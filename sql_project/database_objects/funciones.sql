USE repositor_ruedas;


-- Función que calcula la ganancia neta, restando -21% (iva) y -3% (IIBB)

DROP FUNCTION IF EXISTS repositor_ruedas.ganancia_neta;

DELIMITER //
CREATE FUNCTION repositor_ruedas.ganancia_neta
(precio DECIMAL(10,2))
	RETURNS VARCHAR(20)
	DETERMINISTIC
	NO SQL
BEGIN
    DECLARE ganancia DECIMAL(10,2);
    DECLARE resultado VARCHAR(20);
    
    -- Calcular la ganancia
    SET ganancia = precio * 0.79 * 0.03;
    
    -- Convertir el resultado a un formato con coma decimal
    SET resultado = REPLACE(FORMAT(ganancia, 2), '.', ',');
    
    -- Añadir el signo peso al principio
    SET resultado = CONCAT('$', resultado);
    
    RETURN resultado;
END //
DELIMITER ;
    
   
-- Función que calcula la suma de cantidad de ruedas entregadas a cada seguro

DROP FUNCTION IF EXISTS repositor_ruedas.cant_x_cia;

DELIMITER //
CREATE FUNCTION repositor_ruedas.cant_x_cia
(seguro_alias_param VARCHAR(50))
	RETURNS INT
	DETERMINISTIC
	NO SQL
BEGIN
    DECLARE total_cantidad INT;

   	-- Cálculo de cantidad por cada seguro
    SELECT SUM(s.cantidad_ruedas)
    INTO total_cantidad
    FROM siniestros AS s
    JOIN seguros AS e
		ON s.seguro_cia = e.seguro_id
    WHERE e.seguro_alias = seguro_alias_param;

    RETURN total_cantidad;
END //
DELIMITER ;


-- Función que muestra de manera porcentual la participación de los licitadores

DROP FUNCTION IF EXISTS repositor_ruedas.porcent_licitador;

DELIMITER //
CREATE FUNCTION repositor_ruedas.porcent_licitador
(licitador_nombre VARCHAR(50))
RETURNS VARCHAR(10)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_siniestros INT;
    DECLARE licitador_count INT;
    DECLARE porcentaje DECIMAL(5,2);
    DECLARE RESULT VARCHAR(10);

    -- Cuenta el total de siniestros
    SELECT COUNT(*)
    INTO total_siniestros
    FROM siniestros;

    -- Cuenta la cantidad de veces que aparece un licitador determinado
    SELECT COUNT(*)
    INTO licitador_count
    FROM siniestros sin
    JOIN licitadores lic ON sin.licitador = lic.licitador_id
    WHERE lic.licitador_nombre = licitador_nombre;

    -- Calcular el porcentaje
    SET porcentaje = (licitador_count / total_siniestros) * 100;

    -- Cambia el valor del resultado, 2 decimales y agrega símbolo %
    SET RESULT = CONCAT(FORMAT(porcentaje, 2), '%');

    RETURN RESULT;
END //
DELIMITER ;