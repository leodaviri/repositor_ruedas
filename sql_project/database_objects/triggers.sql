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
    WHERE factura_nro = 'Pendiente'
    AND siniestro_id = (
        SELECT siniestro_id 
        FROM siniestros 
        WHERE factura_nro = 'Pendiente' 
        ORDER BY siniestro_fecha DESC 
        LIMIT 1);
    
    -- Verificar que la fecha de la factura no sea anterior a la fecha del siniestro
    IF NEW.factura_fecha < siniestro_fecha THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de la factura no puede ser anterior a la fecha del siniestro.';
    END IF;
END //
DELIMITER ;


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


-- Trigger con devolución de mensaje de advertencia sobre teléfono de asegurado

DROP TRIGGER IF EXISTS repositor_ruedas.asegurado_tel;

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
END;


-- Trigger para registrar acciones DML en tabla 'log' y usuarios responsables
-- Se crean en total 3 triggers para abarcar todas las acciones

DROP TRIGGER IF EXISTS repositor_ruedas.siniestros_insert_log;
DROP TRIGGER IF EXISTS repositor_ruedas.siniestros_update_log;
DROP TRIGGER IF EXISTS repositor_ruedas.siniestros_delete_log;

-- Trigger para INSERT

CREATE TRIGGER repositor_ruedas.siniestros_insert_log
AFTER INSERT ON siniestros
FOR EACH ROW
BEGIN
    INSERT INTO log (tabla, id_pk, usuario, operacion)
    VALUES ('siniestros', NEW.siniestro_id, USER(), 'INSERT');
END;

-- Trigger para UPDATE

CREATE TRIGGER repositor_ruedas.siniestros_update_log
AFTER UPDATE ON siniestros
FOR EACH ROW
BEGIN
    INSERT INTO log (tabla, id_pk, usuario, operacion)
    VALUES ('siniestros', NEW.siniestro_id, USER(), 'UPDATE');
END;

-- Trigger para DELETE

CREATE TRIGGER repositor_ruedas.siniestros_delete_log
AFTER DELETE ON siniestros
FOR EACH ROW
BEGIN
    INSERT INTO log (tabla, id_pk, usuario, operacion)
    VALUES ('siniestros', OLD.siniestro_id, USER(), 'DELETE');
END;