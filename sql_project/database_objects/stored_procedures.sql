USE repositor_ruedas;


-- Procedimiento para ingresar nuevo siniestro

DROP PROCEDURE IF EXISTS repositor_ruedas.ingreso_siniestro;

DELIMITER //
CREATE PROCEDURE repositor_ruedas.ingreso_siniestro (
    IN p_siniestro_nro BIGINT,
    IN p_siniestro_fecha DATETIME,
    IN p_siniestro_tipo VARCHAR(50),
    IN p_cantidad_ruedas INT,
    IN p_seguro_cia VARCHAR(20),
    IN p_poliza_nro INT,
    IN p_licitador INT,
    IN p_vehiculo INT,
    IN p_observaciones TEXT)    
BEGIN
    -- Determinamos validaciones con mensajes de errores
    IF p_siniestro_nro IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Debe completar nro de siniestro';
    END IF;

    IF p_seguro_cia IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Debe asignar una companía de seguro';
    END IF;

    IF p_poliza_nro IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Debe completar el nro de póliza';
    END IF;

    IF p_licitador IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Debe asignar un ente licitador';
    END IF;

    IF p_vehiculo IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Debe indicar un vehículo';
    END IF;

    -- Si la fecha no se proporciona, usamos la fecha actual
    IF p_siniestro_fecha IS NULL THEN
	SET p_siniestro_fecha = CURRENT_TIMESTAMP();
    END IF;

    -- Determinamos campos para insertar nuevo registro
    INSERT INTO siniestros (
        siniestro_nro, siniestro_fecha, siniestro_tipo, cantidad_ruedas,
        seguro_cia, poliza_nro, licitador, vehiculo, observaciones)
        VALUES (
        p_siniestro_nro, p_siniestro_fecha, p_siniestro_tipo, p_cantidad_ruedas,
        p_seguro_cia, p_poliza_nro, p_licitador, p_vehiculo,
    -- Observaciones puede quedar en nulo
        IFNULL(p_observaciones, '')
       	);
     
    -- Mostramos el último registro insertado
    SELECT * FROM siniestros
    ORDER BY siniestro_fecha DESC
    LIMIT 1;
END //
DELIMITER ;

-- Mostramos las advertencias
SHOW WARNINGS;

-- Procedimiento TRANSACCIONAL (TCL) para ingresar una nueva factura
-- Dicho registro además actualizará campos en 'siniestros' y 'link_facturas_ruedas'

DROP PROCEDURE IF EXISTS repositor_ruedas.agregar_factura;

DELIMITER //
CREATE PROCEDURE repositor_ruedas.agregar_factura(
    IN p_siniestro_id INT,
    IN p_factura_tipo VARCHAR(10),
    IN p_factura_pdv INT,
    IN p_factura_nro INT,
    IN p_rueda_item INT,
    IN p_rueda_precio DECIMAL(10, 2),
    IN p_rueda_cantidad INT)
BEGIN
    DECLARE v_siniestro_existente INT;
    DECLARE v_factura_id VARCHAR(20);
    DECLARE v_factura_precio DECIMAL(10, 2);
	
    -- Inicio de TCL
    START TRANSACTION;
    
    -- Verificamos si el siniestro existe y si el campo factura_nro es 'Pendiente'
    SELECT COUNT(*) INTO v_siniestro_existente
    FROM siniestros
    WHERE siniestro_id = p_siniestro_id AND factura_nro = 'Pendiente';

    -- Validamos la existencia de dicho siniestro
    IF v_siniestro_existente = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Siniestro inexistente, por favor corrobore';
    ELSE
		-- Creamos un savepoint posterior a la confirmación
		SAVEPOINT siniestro_confirmado;
        
        -- Construimos el ID de la factura
        SET v_factura_id = CONCAT(p_factura_tipo, '-', p_factura_pdv, '-', p_factura_nro);

        -- Determinamos validaciones con mensajes de errores
        IF p_factura_tipo IS NULL OR p_factura_tipo = '' THEN
			
            -- Revertimos la transacción hasta la confirmación del siniestro
			ROLLBACK TO SAVEPOINT siniestro_confirmado;
            
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe asignar tipo de factura';
        ELSEIF p_factura_pdv IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe indicar punto de venta';
        ELSEIF p_factura_nro IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe asignar nro de factura';
        ELSEIF p_rueda_item IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe indicar item de rueda';
        ELSEIF p_rueda_precio IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe asignar precio a la rueda';
        ELSE
            -- Automatizamos el precio final de la factura
            SET v_factura_precio = p_rueda_precio * p_rueda_cantidad;

            -- Determinamos campos para insertar nuevo registro
            INSERT INTO facturas (factura_id, factura_tipo, factura_fecha, factura_pdv,
                factura_nro, rueda_item, rueda_precio, rueda_cantidad, factura_precio)
            VALUES (v_factura_id, p_factura_tipo, CURRENT_TIMESTAMP, p_factura_pdv,
                p_factura_nro, p_rueda_item, p_rueda_precio, p_rueda_cantidad, v_factura_precio);

            -- Actualizamos el campo factura_nro en la tabla siniestros
            UPDATE siniestros
            SET factura_nro = v_factura_id
            WHERE siniestro_id = p_siniestro_id;

            -- Insertamos datos en la tabla link_facturas_ruedas
            INSERT INTO link_facturas_ruedas (
                id_facturas, id_ruedas, cantidad)
            VALUES (v_factura_id, p_rueda_item, p_rueda_cantidad);

            -- Confirmamos la transacción correcta
            COMMIT;

            -- Mostramos el último registro insertado
            SELECT * FROM facturas
            ORDER BY factura_fecha DESC
            LIMIT 1;
        END IF;
    END IF;
END //
DELIMITER ;

-- Mostramos las advertencias
SHOW WARNINGS;


-- Procedimiento para ingresar un nuevo vehículo
-- Implica la actualización de 4 tablas
-- Si ya existe una marca/modelo/utilidad con ese nombre, se actualiza el registro existente
-- y se obtiene el ID del campo actualizado utilizando LAST_INSERT_ID(marca_id/modelo_id/utilidad_id)

DROP PROCEDURE IF EXISTS agregar_vehiculo;

DELIMITER //
CREATE PROCEDURE agregar_vehiculo(
    IN p_marca_nombre VARCHAR(50),
    IN p_modelo_descripcion VARCHAR(100),
    IN p_utilidad_descripcion VARCHAR(100)
)
BEGIN
    DECLARE v_marca_id INT;
    DECLARE v_modelo_id INT;
    DECLARE v_utilidad_id INT;
    DECLARE v_vehiculo_id INT;
    
    -- Insertar u obtener marca_id
    INSERT INTO marcas_veh (marca_nombre)
    VALUES (p_marca_nombre)
    ON DUPLICATE KEY UPDATE marca_id = LAST_INSERT_ID(marca_id);
    SET v_marca_id = LAST_INSERT_ID();
    
    -- Insertar u obtener modelo_id
    INSERT INTO modelos (modelo_descripcion)
    VALUES (p_modelo_descripcion)
    ON DUPLICATE KEY UPDATE modelo_id = LAST_INSERT_ID(modelo_id);
    SET v_modelo_id = LAST_INSERT_ID();
    
    -- Insertar u obtener utilidad_id
    INSERT INTO utilidades (utilidad_descripcion)
    VALUES (p_utilidad_descripcion)
    ON DUPLICATE KEY UPDATE utilidad_id = LAST_INSERT_ID(utilidad_id);
    SET v_utilidad_id = LAST_INSERT_ID();
    
    -- Insertar en la tabla vehiculos
    INSERT INTO vehiculos (vehiculo_marca, vehiculo_modelo, vehiculo_utilidad)
    VALUES (v_marca_id, v_modelo_id, v_utilidad_id);
    SET v_vehiculo_id = LAST_INSERT_ID();
    
    -- Devolución de los IDs insertados y/oo actualizados
    SELECT
		v_vehiculo_id AS vehiculo_id,
		v_marca_id AS marca_id, 
        v_modelo_id AS modelo_id,
		v_utilidad_id AS utilidad_id;
END //
DELIMITER ;

-- Mostramos las advertencias
SHOW WARNINGS;
