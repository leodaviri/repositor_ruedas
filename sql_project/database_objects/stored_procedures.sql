USE repositor_ruedas;


-- Procedimiento TRANSACCIONAL (TCL) para ingresar nuevo siniestro
-- Corrobora que los datos ingresados en FK sean correctos y no sean nulos

DROP PROCEDURE IF EXISTS repositor_ruedas.ingreso_siniestro;

DELIMITER //
CREATE PROCEDURE repositor_ruedas.ingreso_siniestro (
	IN p_siniestro_nro BIGINT,
  	IN p_siniestro_tipo VARCHAR(50),
  	IN p_cantidad_ruedas INT,
  	IN p_seguro_cia VARCHAR(20),
  	IN p_poliza_nro INT,
  	IN p_licitador INT,
  	IN p_vehiculo INT,
  	IN p_observaciones TEXT)
BEGIN
	-- Inicio de transacción
  	START TRANSACTION;

  	-- Verificar que los parámetros no sean nulos
  	IF p_siniestro_nro IS NULL THEN
   		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe completar el número de siniestro';
  	END IF;

 	-- Crear un savepoint para el número de siniestro
 	SAVEPOINT siniestro_ingresado;
 
	-- Verificar que la compañía de seguro exista
	IF NOT EXISTS (SELECT 1 FROM seguros WHERE seguro_id = p_seguro_cia) THEN
    	ROLLBACK TO siniestro_ingresado;
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Seguro inexistente, corrobore';
  	END IF;

	-- Verificar que la póliza exista
	IF NOT EXISTS (SELECT 1 FROM polizas WHERE poliza_id = p_poliza_nro) THEN
    	ROLLBACK TO siniestro_ingresado;
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Póliza inexistente, corrobore';
  	END IF;

  	-- Verificar que el licitador exista
  	IF NOT EXISTS (SELECT 1 FROM licitadores WHERE licitador_id = p_licitador) THEN
    	ROLLBACK TO siniestro_ingresado;
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Licitador inexistente, corrobore';
 	 END IF;

	-- Verificar que el vehículo exista
  	IF NOT EXISTS (SELECT 1 FROM vehiculos WHERE vehiculo_id = p_vehiculo) THEN
    	ROLLBACK TO siniestro_ingresado;
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Vehículo inexistente, corrobore';
  	END IF;

	-- Insertar el nuevo registro en la tabla siniestros
	INSERT INTO siniestros (
    	siniestro_nro, siniestro_fecha, siniestro_tipo, cantidad_ruedas,
    	seguro_cia, poliza_nro, licitador, vehiculo, observaciones)
	VALUES (
		p_siniestro_nro, CURRENT_TIMESTAMP(), p_siniestro_tipo, p_cantidad_ruedas,
    	p_seguro_cia, p_poliza_nro, p_licitador, p_vehiculo,
    	-- Observaciones puede quedar en nulo
    	IFNULL(p_observaciones, ''));

    -- Confirmamos la transacción correcta
  	COMMIT;
  	
  	-- Mostramos el último registro insertado
  	SELECT * FROM siniestros
  	ORDER BY siniestro_fecha DESC
  	LIMIT 1;
END //
DELIMITER ;

-- Mostramos las advertencias
SHOW WARNINGS;

-- Para que la inserción funcione, hubo que agregar un valor genérico en 'facturas'

INSERT INTO facturas
(factura_id, factura_tipo, factura_pdv, factura_nro,
rueda_item, rueda_precio, rueda_cantidad, factura_precio)
VALUES
('Pendiente', 'FA', 0, 0, 0, 0, 0, 0);



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
    IN p_rueda_precio DECIMAL(10, 2))
BEGIN
    DECLARE v_siniestro_existente INT;
    DECLARE v_factura_id VARCHAR(20);
    DECLARE v_factura_precio DECIMAL(10, 2);
    DECLARE v_rueda_cantidad INT;
	
    -- Inicio de TCL
    START TRANSACTION;
    
    -- Verificamos si el siniestro existe y si el campo factura_nro es 'Pendiente'
    SELECT COUNT(*) INTO v_siniestro_existente
    FROM siniestros
    WHERE siniestro_id = p_siniestro_id
	AND factura_nro = 'Pendiente';

    -- Validamos la existencia de dicho siniestro
    IF v_siniestro_existente = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Siniestro inexistente, por favor corrobore';
    ELSE
		-- Creamos un savepoint posterior a la confirmación
		SAVEPOINT siniestro_confirmado;

        -- Obtenemos la cantidad de ruedas del siniestro
        SELECT cantidad_ruedas INTO v_rueda_cantidad
        FROM siniestros
        WHERE siniestro_id = p_siniestro_id;
        
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
            VALUES (v_factura_id, p_factura_tipo, CURRENT_TIMESTAMP(), p_factura_pdv,
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
    
    -- Devolución de los IDs insertados y/o actualizados
    SELECT
		v_vehiculo_id AS vehiculo_id,
		v_marca_id AS marca_id, 
        v_modelo_id AS modelo_id,
		v_utilidad_id AS utilidad_id;
END //
DELIMITER ;

-- Mostramos las advertencias
SHOW WARNINGS;
