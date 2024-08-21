USE repositor_ruedas;


-- Trigger para verificar conexión segura a cada portal proveedor de cada compañía

DROP TRIGGER IF EXISTS repositor_ruedas.validacion_web;

DELIMITER //
CREATE TRIGGER repositor_ruedas.validacion_web
BEFORE INSERT
ON seguros
FOR EACH ROW
BEGIN
    -- Verificar si la columna seguro_web o licitador_web comienza con 'https://'
    IF NEW.seguro_web IS NOT NULL
	AND NEW.seguro_web NOT LIKE 'https://%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Corroborar falta de ''https://'', web podría no ser segura';
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
-- No requiere 'delimiters' por su estructura y su correcta ejecución en bash

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
