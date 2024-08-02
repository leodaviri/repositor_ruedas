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


-- Ejemplo de uso

SELECT 
    factura_id,
    factura_precio,
    repositor_ruedas.ganancia_neta(factura_precio) AS Ganancia_neta
FROM 
    facturas;
    


DROP FUNCTION IF EXISTS repositor_ruedas.cant_x_cia;

DELIMITER //

CREATE FUNCTION repositor_ruedas.cant_x_cia
(seguro_alias_param VARCHAR(50))
	RETURNS INT
	DETERMINISTIC
	NO SQL
BEGIN
    DECLARE total_cantidad INT;

    -- Calcula la suma de cantidad de ruedas para cada seguro
    SELECT SUM(s.cantidad_ruedas)
    INTO total_cantidad
    FROM siniestros AS s
    JOIN seguros AS e
		ON s.seguro_cia = e.seguro_id
    WHERE e.seguro_alias = seguro_alias_param;

    RETURN total_cantidad;
END //

DELIMITER ;


-- Ejemplo simple de uso (entre paréntesis, cambiar el seguro a consultar)

SELECT repositor_ruedas.cant_x_cia('ALLIANZ') AS Total_ruedas;

-- Ejemplo de uso por período, enlistando todas las compañías

SELECT
    se.seguro_alias,
    SUM(si.cantidad_ruedas) AS Total_ruedas
FROM siniestros AS si
JOIN seguros AS se
	ON si.seguro_cia = se.seguro_id
WHERE
    si.siniestro_fecha BETWEEN '2024-06-01' AND '2024-06-30'
GROUP BY se.seguro_alias
ORDER BY Total_ruedas DESC;



DROP FUNCTION IF EXISTS repositor_ruedas.porcent_licitador;

DELIMITER //

CREATE FUNCTION repositor_ruedas.porcent_licitador()
	
END //

DELIMITER ;