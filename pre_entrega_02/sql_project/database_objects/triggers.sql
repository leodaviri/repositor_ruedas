USE repositor_ruedas;


-- Trigger para evitar que la fecha de factura sea anterior a la del siniestro registrado

DROP TRIGGER IF EXISTS repositor_ruedas.check_factura_fecha;

DELIMITER //
CREATE TRIGGER repositor_ruedas.check_factura_fecha
BEFORE INSERT ON facturas
FOR EACH ROW
BEGIN
    DECLARE siniestro_fecha DATETIME;

    -- Obtener la fecha del siniestro correspondiente
    SELECT siniestro_fecha INTO siniestro_fecha
    FROM siniestros
    WHERE siniestro_nro = NEW.siniestro_nro;
    
    -- Verificar que la fecha de la factura no sea anterior a la fecha del siniestro
    IF NEW.factura_fecha < siniestro_fecha THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de la factura no puede ser anterior a la fecha del siniestro.';
    END IF;
END //
DELIMITER ;

-- Ejemplo de uso con el procedimiento correspondiente para ingresar una factura

CALL agregar_factura(
    1259,				  	-- nro factura
    '2024-07-10 00:00:00'	-- VALOR ERRÓNEO
    'FA',				  	-- tipo FC
    3,					  	-- punto de venta
    69055,					-- FC nro
    51,						-- rueda item
    1880000,				-- precio
    1						-- cantidad
);

-- ERROR 1644 (45000): La fecha de la factura no puede ser anterior a la fecha del siniestro.



-- Trigger para evitar errores de tipeo, en éste caso, la cantidad de ruedas máxima de todo vehículo

DROP TRIGGER IF EXISTS repositor_ruedas.cant_x_siniestro;

DELIMITER //
CREATE TRIGGER repositor_ruedas.cant_x_siniestro
AFTER INSERT ON siniestros
FOR EACH ROW
BEGIN
    -- Verificamos que la cantidad no supere 5
    IF NEW.cantidad_ruedas > 5 THEN
        -- Devuelve el mensaje de error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad de ruedas no puede superar las 5 unidades';
    END IF;
END //
DELIMITER ;



INSERT INTO siniestros
	(siniestro_nro, siniestro_fecha, siniestro_tipo,
    cantidad_ruedas, seguro_cia, poliza_nro, licitador,
    vehiculo)
VALUES
	(2554738, NOW(), 'AUPOAL', 6, '30-50004717-4',
	169601, 2, 11);

-- ERROR 1644 (45000): La cantidad de ruedas no puede superar las 5 unidades
	


-- Trigger con devolución de mensaje de advertencia sobre teléfono de asegurado

DROP TRIGGER IF EXISTS repositor_ruedas.asegurado_tel;

DELIMITER //
CREATE TRIGGER repositor_ruedas.asegurado_tel
AFTER INSERT ON asegurados
FOR EACH ROW
BEGIN
    -- Verifica si el campo asegurado_telefono está vacío
    IF NEW.asegurado_telefono IS NULL OR NEW.asegurado_telefono = '' THEN
        -- Lanza una advertencia con el mensaje especificado
        SIGNAL SQLSTATE '01000'
        SET MESSAGE_TEXT = 'Recuerde registrar un contacto telefónico';
    END IF;
END //
DELIMITER ;

-- Ejemplo de uso

INSERT INTO asegurados
	(asegurado_id, asegurado_nombre, asegurado_apellido)
VALUES
	(1260, 'Rosario', 'Pileyra');

-- Warning Code: 1000
-- Recuerde registrar un contacto telefónico