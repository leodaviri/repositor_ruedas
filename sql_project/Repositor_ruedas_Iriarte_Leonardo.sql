-- ESTRUCTURACIÓN DE BASE DE DATOS PARA GRUPO CONCESIONARIO

-- Alumno: Iriarte Leonardo David
-- Comisión: #57190
-- Proofesor: Anderson M. Torres
-- Tutor: Ariel Annone
-- Repositorio GitHub: https://github.com/leodaviri/repositor_ruedas/

-- CREACIÓN DE LA BASE DE DATOS 

DROP DATABASE IF EXISTS repositor_ruedas;

CREATE DATABASE IF NOT EXISTS repositor_ruedas;

-- Creación de tablas

USE repositor_ruedas;

-- Tablas de hechos, resumen de siniestros y facturas
CREATE TABLE
	IF NOT EXISTS siniestros(
	siniestro_id INT NOT NULL AUTO_INCREMENT,
	siniestro_nro BIGINT NOT NULL COMMENT 'número de siniestro real según compañía',
	siniestro_fecha DATETIME NOT NULL,
	factura_nro VARCHAR(10) DEFAULT 'Pendiente',
	siniestro_tipo VARCHAR(50) NOT NULL,
	cantidad_ruedas INT NOT NULL,
	seguro_cia VARCHAR(20) NOT NULL,
	poliza_nro INT NOT NULL COMMENT 'número de póliza real según compañía',
	licitador INT NOT NULL,
	vehiculo INT NOT NULL,
	observaciones TEXT COMMENT 'para especificaciones puntuales y necesarias',
	PRIMARY KEY (siniestro_id))
	COMMENT 'Tabla de hechos destinada a asignar los casos por siniestros, fc puede quedar pendiente'
	;

CREATE TABLE
	IF NOT EXISTS facturas(
	factura_id VARCHAR(20) NOT NULL,
	factura_tipo VARCHAR(10) NOT NULL COMMENT 'tipo de emisión de factura según cuit y monto',
	factura_fecha DATETIME DEFAULT (current_timestamp),
	factura_pdv INT NOT NULL,
	factura_nro INT NOT NULL,
	rueda_item INT NOT NULL,
	rueda_precio DECIMAL(10,2) NOT NULL,
	rueda_cantidad INT NOT NULL DEFAULT 1,
	factura_precio DECIMAL NOT NULL,
	PRIMARY KEY (factura_id))
	COMMENT 'Tabla de hechos que describen datos de facturación y ruedas, NO ADMITE NULOS'
	;

-- Tablas dimensionales
CREATE TABLE 
	IF NOT EXISTS facturas_tipos(
	factura_tipo_id VARCHAR(10) NOT NULL DEFAULT "FA",
	factura_tipo_descripcion VARCHAR(100) NOT NULL,
	PRIMARY KEY (factura_tipo_id))
	COMMENT 'Tipo de factura emitida según cuit y monto'
	;

CREATE TABLE 
	IF NOT EXISTS tipos_siniestros(
	siniestro_tipo_id VARCHAR(50) NOT NULL,
	siniestro_tipo_descripcion VARCHAR(100) NOT NULL DEFAULT 'pendiente descripción',
	PRIMARY KEY (siniestro_tipo_id))
	COMMENT 'Especifica el tipo de siniestro, puntualmente posición de rueda sustraída'
	;

CREATE TABLE 
	IF NOT EXISTS seguros(
	seguro_id VARCHAR(20) NOT NULL COMMENT 'número de CUIT con guiones', 
	seguro_nombre VARCHAR(100) UNIQUE NOT NULL COMMENT 'razón social',
	seguro_alias VARCHAR(50) UNIQUE NOT NULL COMMENT 'nombre resumido o comercial',
	seguro_ciudad INT NOT NULL,
	seguro_provincia INT NOT NULL,
	seguro_web VARCHAR(100) UNIQUE,
	seguro_telefono BIGINT NOT NULL COMMENT 'requiere siempre un télefono de contacto',
	seguro_mail VARCHAR(100) UNIQUE DEFAULT 'pendiente asignar mail',
	PRIMARY KEY (seguro_id))
	COMMENT 'Información de contacto y ubicación de las companías de seguros'
	;

CREATE TABLE 
	IF NOT EXISTS ciudades(
	ciudad_id INT NOT NULL AUTO_INCREMENT,
	ciudad_nombre VARCHAR(50) NOT NULL,
	PRIMARY KEY (ciudad_id))
	COMMENT 'Ciudad en la que se ubica la casa central'
	;

CREATE TABLE 
	IF NOT EXISTS provincias(
	provincia_id INT NOT NULL AUTO_INCREMENT,
	provincia_nombre VARCHAR(50) NOT NULL UNIQUE,
	PRIMARY KEY (provincia_id))
	COMMENT 'Provincia en la que se ubica la casa central'
	;

CREATE TABLE 
	IF NOT EXISTS polizas(
	poliza_id INT NOT NULL COMMENT 'número de póliza real según compañía',
	poliza_tipo VARCHAR(50) NOT NULL DEFAULT 'falta asignar tipo de póliza', 
	cobertura VARCHAR(5) NOT NULL DEFAULT '100%' COMMENT 'porcentaje de cobertura',
	asegurado INT NOT NULL,
	PRIMARY KEY (poliza_id))
	COMMENT 'Información específica de pólizas según siniestros'
	;

CREATE TABLE 
	IF NOT EXISTS asegurados(
	asegurado_id INT NOT NULL AUTO_INCREMENT,
	asegurado_nombre VARCHAR(50) NOT NULL,
	asegurado_apellido VARCHAR(50) NOT NULL,
	asegurado_telefono BIGINT,
	asegurado_mail VARCHAR(100) DEFAULT 'pendiente agendar mail',
	PRIMARY KEY (asegurado_id))
	COMMENT 'Información básica de asegurados'
	;

CREATE TABLE 
	IF NOT EXISTS licitadores(
	licitador_id INT NOT NULL AUTO_INCREMENT,
	licitador_nombre VARCHAR(50) NOT NULL UNIQUE,
	licitador_web VARCHAR(100) DEFAULT 'pendiente asigar web',
	PRIMARY KEY (licitador_id))
	COMMENT 'Datos de utilidad sobre los entes licitadores'
	;

CREATE TABLE 
	IF NOT EXISTS vehiculos(
	vehiculo_id INT NOT NULL AUTO_INCREMENT,
	vehiculo_marca INT NOT NULL, 
	vehiculo_modelo INT NOT NULL,
	vehiculo_utilidad INT NOT NULL,
	PRIMARY KEY (vehiculo_id))
	COMMENT 'Conecta con las tablas categóricas marca, modelo y utilidad'
	;

CREATE TABLE 
	IF NOT EXISTS marcas_veh(
	marca_id INT NOT NULL AUTO_INCREMENT,
	marca_nombre VARCHAR(50) DEFAULT 'Pendiente asignar marca';
	PRIMARY KEY (marca_id))
	COMMENT 'Marca fabricante del vehículo'
	;

CREATE TABLE 
	IF NOT EXISTS modelos(
	modelo_id INT NOT NULL AUTO_INCREMENT,
	modelo_descripcion VARCHAR(100) DEFAULT 'Pendiente asignar descripcion' COMMENT 'refiere a modelo, NO año de fabricación';
	PRIMARY KEY (modelo_id))
	COMMENT 'Especificaciones de modelo del vehículo'
	;

CREATE TABLE 
	IF NOT EXISTS utilidades(
	utilidad_id INT NOT NULL AUTO_INCREMENT,
	utilidad_descripcion VARCHAR(100) NOT NULL DEFAULT 'pendiente asignar utilidad',
	PRIMARY KEY (utilidad_id))
	COMMENT 'Especificaciones de uso del vehículo'
	;

CREATE TABLE 
	IF NOT EXISTS ruedas(
	rueda_id INT NOT NULL AUTO_INCREMENT,
	rueda_descripcion VARCHAR(50) NOT NULL DEFAULT 'pendiente asignar descripcion',
	cubierta_marca INT NOT NULL,
	rodado_llanta INT NOT NULL,
	PRIMARY KEY (rueda_id))
	COMMENT 'Características básicas de la rueda a reponer'
	;

CREATE TABLE 
	IF NOT EXISTS marcas_cub(
	marca_id INT NOT NULL,
	marca_descripcion VARCHAR(50) NOT NULL,
	PRIMARY KEY (marca_id))
	COMMENT 'Marca fabricante de la cubierta'
	;


-- Asignación de conexiones, definición de FK

ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestro_tipo
	FOREIGN KEY (siniestro_tipo) REFERENCES tipos_siniestros(siniestro_tipo_id);

ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestros_facturas
	FOREIGN KEY (factura_nro) REFERENCES facturas(factura_id);

ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestros_seguros
	FOREIGN KEY (seguro_cia) REFERENCES seguros(seguro_id);
	
ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestros_polizas
	FOREIGN KEY (poliza_nro) REFERENCES polizas(poliza_id);
	
ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestros_licitadores
	FOREIGN KEY (licitador) REFERENCES licitadores(licitador_id);
	
ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestros_vehiculos
	FOREIGN KEY (vehiculo) REFERENCES vehiculos(vehiculo_id);
	
ALTER TABLE seguros
	ADD CONSTRAINT fk_seguros_ciudades
	FOREIGN KEY (seguro_ciudad) REFERENCES ciudades(ciudad_id);
	
ALTER TABLE seguros
	ADD CONSTRAINT fk_seguros_provincias
	FOREIGN KEY (seguro_provincia) REFERENCES provincias(provincia_id);
	
ALTER TABLE polizas
	ADD CONSTRAINT fk_polizas_asegurados
	FOREIGN KEY (asegurado) REFERENCES asegurados(asegurado_id);
	
ALTER TABLE vehiculos
	ADD CONSTRAINT fk_vehiculos_marcas_veh
	FOREIGN KEY (vehiculo_marca) REFERENCES marcas_veh(marca_id);
	
ALTER TABLE vehiculos
	ADD CONSTRAINT fk_vehiculos_modelos
	FOREIGN KEY (vehiculo_modelo) REFERENCES modelos(modelo_id);
	
ALTER TABLE vehiculos
	ADD CONSTRAINT fk_vehiculo_utilidades
	FOREIGN KEY (vehiculo_utilidad) REFERENCES utilidades(utilidad_id);
	
ALTER TABLE facturas
	ADD CONSTRAINT fk_facturas_tipos
	FOREIGN KEY (factura_tipo) REFERENCES facturas_tipos(factura_tipo_id);
	
ALTER TABLE ruedas
	ADD CONSTRAINT fk_ruedas_marcas
	FOREIGN KEY (cubierta_marca) REFERENCES marcas_cub(marca_id);
	

-- Creación de tabla vínculo entre facturas y ruedas para evitar relación de muchos a muchos
-- Asignamos que en caso de eliminar y/o modificar registros, sea modificación en cascada

CREATE TABLE 
	IF NOT EXISTS link_facturas_ruedas(
	id_facturas VARCHAR(20) NOT NULL,
	id_ruedas INT NOT NULL, 
	cantidad INT NOT NULL DEFAULT 1,
	PRIMARY KEY (id_facturas, id_ruedas))
	COMMENT 'Tabla vínculo entre facturas y ruedas'
	;

ALTER TABLE link_facturas_ruedas
	ADD CONSTRAINT fk_facturas_ruedas
	FOREIGN KEY (id_facturas) REFERENCES facturas(factura_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;
	
ALTER TABLE link_facturas_ruedas
	ADD CONSTRAINT fk_ruedas_facturas
	FOREIGN KEY (id_ruedas) REFERENCES ruedas(rueda_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;


-- Creación de tabla log para guardar registros DML y usuarios

CREATE TABLE
	IF NOT EXISTS log (
    id_log INT NOT NULL AUTO_INCREMENT,
    tabla VARCHAR(100) NOT NULL COMMENT 'Nombre de la tabla afectada por el DML',
    id_pk VARCHAR(100) NOT NULL COMMENT 'PK del registro alterado',
    usuario VARCHAR(100) NOT NULL COMMENT 'Nombre del usuario que intervino',
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha actual',
    operacion VARCHAR(10) NOT NULL COMMENT 'Tipo de operación DML'
    PRIMARY KEY (id_log))
    COMMENT 'Tabla log que guarda las modificaciones y usuarios responsables'
	;


-- CORROBORACIÓN OPCIONAL
-- Se puede chequear cada una de las tablas creadas con el comando EXPLAIN o DESCRIBE

DESCRIBE asegurados;
DESCRIBE ciudades;
DESCRIBE facturas;
DESCRIBE facturas_tipos;
DESCRIBE licitadores;
DESCRIBE link_facturas_ruedas;
DESCRIBE marcas_cub;
DESCRIBE marcas_veh;
DESCRIBE modelos;
DESCRIBE polizas;
DESCRIBE provincias;
DESCRIBE ruedas;
DESCRIBE seguros;
DESCRIBE siniestros;
DESCRIBE tipos_siniestros;
DESCRIBE utilidades;
DESCRIBE vehiculos;
DESCRIBE log;
	

-- IMPORTACIÓNDE DATOS

-- Habilitamos la importación de archivos local

SET GLOBAL local_infile = TRUE;

-- Desactivamos temporalmente la verificación de claves foráneas durante la importación

SET foreign_key_checks = 0;

-- Procedemos a importar datos
-- Se considera el orden correcto de constrains respecto a las tablas de hechos
-- Se setean en las mismas, las fechas y nulos 

LOAD DATA LOCAL INFILE '/sql_project/data_csv/facturas_tipos.csv'
INTO TABLE facturas_tipos
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(factura_tipo_id, factura_tipo_descripcion);

LOAD DATA LOCAL INFILE '/sql_project/data_csv/facturas.csv'
INTO TABLE facturas
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(factura_id, factura_tipo, @factura_fecha, factura_pdv, factura_nro,
rueda_item, rueda_precio, rueda_cantidad, factura_precio)
SET factura_fecha = STR_TO_DATE(@factura_fecha, '%Y-%m-%d');

LOAD DATA LOCAL INFILE '/sql_project/data_csv/siniestros.csv'
INTO TABLE siniestros
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(siniestro_id, siniestro_nro, @siniestro_fecha, factura_nro,
siniestro_tipo, cantidad_ruedas, seguro_cia, poliza_nro,
licitador, vehiculo, @observaciones)
SET siniestro_fecha = STR_TO_DATE(@siniestro_fecha, '%Y-%m-%d'),
    observaciones = NULLIF(@observaciones, '');

LOAD DATA LOCAL INFILE '/sql_project/data_csv/tipos_siniestros.csv'
INTO TABLE tipos_siniestros
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(siniestro_tipo_id, siniestro_tipo_descripcion);

LOAD DATA LOCAL INFILE '/sql_project/data_csv/seguros.csv'
INTO TABLE seguros
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(seguro_id, seguro_nombre, seguro_alias, seguro_ciudad, seguro_provincia,
seguro_web, seguro_telefono, seguro_mail);

LOAD DATA LOCAL INFILE '/sql_project/data_csv/ciudades.csv'
INTO TABLE ciudades
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ciudad_id, ciudad_nombre);

LOAD DATA LOCAL INFILE '/sql_project/data_csv/provincias.csv'
INTO TABLE provincias
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(provincia_id, provincia_nombre);

LOAD DATA LOCAL INFILE '/sql_project/data_csv/polizas.csv'
INTO TABLE polizas
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(poliza_id, poliza_tipo, cobertura, asegurado);

LOAD DATA LOCAL INFILE '/sql_project/data_csv/asegurados.csv'
INTO TABLE asegurados
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(asegurado_id, asegurado_nombre, asegurado_apellido,
asegurado_telefono, asegurado_mail);

LOAD DATA LOCAL INFILE '/sql_project/data_csv/licitadores.csv'
INTO TABLE licitadores
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(licitador_id, licitador_nombre, licitador_web);

LOAD DATA LOCAL INFILE '/sql_project/data_csv/vehiculos.csv'
INTO TABLE vehiculos
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(vehiculo_id, vehiculo_marca, vehiculo_modelo, vehiculo_utilidad);

LOAD DATA LOCAL INFILE '/sql_project/data_csv/marcas_veh.csv'
INTO TABLE marcas_veh
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(marca_id, marca_nombre);

LOAD DATA LOCAL INFILE '/sql_project/data_csv/modelos.csv'
INTO TABLE modelos
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(modelo_id, modelo_descripcion);

LOAD DATA LOCAL INFILE '/sql_project/data_csv/utilidades.csv'
INTO TABLE utilidades
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(utilidad_id, utilidad_descripcion);

LOAD DATA LOCAL INFILE '/sql_project/data_csv/ruedas.csv'
INTO TABLE ruedas
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(rueda_id, rueda_descripcion, cubierta_marca, rodado_llanta);

LOAD DATA LOCAL INFILE '/sql_project/data_csv/marcas_cub.csv'
INTO TABLE marcas_cub
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(marca_id, marca_descripcion);

LOAD DATA LOCAL INFILE '/sql_project/data_csv/link_facturas_ruedas.csv'
INTO TABLE link_facturas_ruedas
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_facturas, id_ruedas, cantidad);

-- Activamos nuevamente la verificación de claves foráneas

SET foreign_key_checks = 1;


-- CREACIÓN DE VISTAS

-- Desactivamos el modo ONLY_FULL_GROUP_BY para evitar inconvenientes
-- (probablemente haya que ejecutar la query en terminal)

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));


-- Vista para determinar el IVA e IIBB mensual según monto y provincia

CREATE OR REPLACE VIEW 
	repositor_ruedas.view_taxes
AS 
SELECT 
    DATE_FORMAT(f.factura_fecha, '%M') AS Mes,
    SUM(f.factura_precio * 0.21) AS IVA_21,
    SUM(f.factura_precio * 0.03) AS IIBB,
    p.provincia_nombre AS Provincia
FROM facturas AS f
JOIN siniestros AS s
	ON f.factura_id = s.factura_nro
JOIN seguros AS se
	ON s.seguro_cia = se.seguro_id
JOIN provincias AS p
	ON se.seguro_provincia = p.provincia_id
GROUP BY 
    Mes, Provincia
ORDER BY 
    IVA_21 DESC
    LIMIT 10;


-- Vista para determinar el movimiento de stock según cantidad, rodado de llanta y marca de cubierta

CREATE OR REPLACE VIEW
	repositor_ruedas.view_ruedas
AS
SELECT 
    SUM(f.rueda_cantidad) AS Cantidad,
    r.rodado_llanta AS Llanta,
    m.marca_descripcion AS Marca_cubierta
FROM facturas AS f
JOIN ruedas AS r
	ON f.rueda_item = r.rueda_id
JOIN marcas_cub AS m
	ON r.cubierta_marca = m.marca_id
GROUP BY 
    Llanta, Marca_cubierta
ORDER BY 
    Cantidad DESC;


-- Vista para las compañías, ayudará al control de reincidencias por alta siniestralidad

CREATE OR REPLACE VIEW
repositor_ruedas.view_reincidencias
AS
SELECT 
    s.poliza_nro AS Poliza,
    COUNT(*) AS Reincidencias,
    CONCAT(a.asegurado_nombre, ' ', a.asegurado_apellido) AS Asegurado
FROM siniestros AS s
JOIN polizas AS p
	ON s.poliza_nro = p.poliza_id
JOIN asegurados AS a
	ON p.asegurado = a.asegurado_id
GROUP BY 
    Poliza, Asegurado
HAVING 
    COUNT(*) >= 2
ORDER BY 
    Reincidencias DESC;


-- Vista para control de reposiciones, ayudará a determinar las compras a concecionarias oficiales
   
CREATE OR REPLACE VIEW
	repositor_ruedas.view_siniestros_vehiculos
AS
SELECT 
    COUNT(s.siniestro_id) AS Suma_siniestros,
    mo.modelo_descripcion AS Modelo,
    mv.marca_nombre AS Marca,
    SUM(s.cantidad_ruedas) AS Cant_ruedas
FROM siniestros AS s
JOIN vehiculos AS v
	ON s.vehiculo = v.vehiculo_id
JOIN modelos AS mo
	ON v.vehiculo_modelo = mo.modelo_id
JOIN marcas_veh AS mv
	ON v.vehiculo_marca = mv.marca_id
GROUP BY 
    Modelo, Marca
ORDER BY 
    Suma_siniestros DESC;


-- Vista para llevar control del promedio de ordenes que asigna cada seguro
-- se ordena de forma ascendente para considerar estrategias alternativas sobre los clientes menos frecuentes
-- a fines prácticos, considera solamente el último mes de participación
   
CREATE OR REPLACE VIEW
	repositor_ruedas.view_cia_prom
AS
SELECT
	sg.seguro_alias AS Compania,
    AVG(f.factura_precio) AS Promedio_orden,
    DATE_FORMAT(MAX(f.factura_fecha), '%M') AS Ultimo_mes
FROM seguros AS sg
JOIN siniestros AS s
	ON sg.seguro_id = s.seguro_cia
JOIN facturas AS f
	ON s.factura_nro = f.factura_id
GROUP BY 
    Compania
ORDER BY 
    Promedio_orden ASC;
   
   
-- Vista para consultar las descripciones de vehículos registrados
-- Implica joins en las 4 tablas de vehículos involucradas
    
CREATE OR REPLACE VIEW 
	repositor_ruedas.view_vehiculos
AS
SELECT 
    mv.marca_nombre AS Marca,
    m.modelo_descripcion AS Modelo,
    u.utilidad_descripcion AS Utilidad
FROM vehiculos AS v
JOIN marcas_veh AS mv
	ON v.vehiculo_marca = mv.marca_id
JOIN modelos AS m
	ON v.vehiculo_modelo = m.modelo_id
JOIN utilidades AS u
	ON v.vehiculo_utilidad = u.utilidad_id
ORDER BY 
Marca, Modelo, Utilidad;
    
   
-- CREACIÓN DE TRIGGERS
   
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
    WHERE factura_nro = NEW.factura_id
    ORDER BY siniestro_fecha DESC
    LIMIT 1;

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

-- Ejemplo de uso

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


-- Trigger para registrar acciones DML en tabla 'log' y usuarios responsables
-- Se crean en total 3 triggers para abarcar todas las acciones

DROP TRIGGER IF EXISTS repositor_ruedas.siniestros_insert_log;
DROP TRIGGER IF EXISTS repositor_ruedas.siniestros_update_log;
DROP TRIGGER IF EXISTS repositor_ruedas.siniestros_delete_log;

DELIMITER //
-- Trigger para INSERT
CREATE TRIGGER repositor_ruedas.siniestros_insert_log
AFTER INSERT ON siniestros
FOR EACH ROW
BEGIN
    INSERT INTO log (tabla, id_pk, usuario, operacion)
    VALUES ('siniestros', NEW.siniestro_id, USER(), 'INSERT');
END//
-- Trigger para UPDATE
CREATE TRIGGER repositor_ruedas.siniestros_update_log
AFTER UPDATE ON siniestros
FOR EACH ROW
BEGIN
    INSERT INTO log (tabla, id_pk, usuario, operacion)
    VALUES ('siniestros', NEW.siniestro_id, USER(), 'UPDATE');
END//
-- Trigger para DELETE
CREATE TRIGGER repositor_ruedas.siniestros_delete_log
AFTER DELETE ON siniestros
FOR EACH ROW
BEGIN
    INSERT INTO log (tabla, id_pk, usuario, operacion)
    VALUES ('siniestros', OLD.siniestro_id, USER(), 'DELETE');
END//
DELIMITER ;

-- Ejemplo de uso
-- Primero insertamos un dato

CALL ingreso_siniestro(
    2331984, 		-- siniestro_nro
    NULL, 			-- siniestro_fecha (CURRENT_TIMESTAMP)
    'AUCH',			-- siniestro_tipo
    3, 				-- cantidad_ruedas
    '30-50001770-4',-- seguro_cia
    8902726,		-- poliza_nro
    1, 				-- licitador
    18,				-- vehiculo
    NULL			-- observaciones
    );

-- Ahora modificamos
   
UPDATE siniestros
SET cantidad_ruedas = 2
WHERE siniestro_id = 1262;

-- Por último, eliminamos el registro

DELETE FROM siniestros
WHERE siniestro_id = 1262;

-- Corroboramos la tabla log

SELECT * FROM log;


-- CREACIÓN DE FUNCIONES

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
    factura_id AS Factura,
    factura_precio AS Precio,
    repositor_ruedas.ganancia_neta(factura_precio) AS Ganancia_neta
FROM 
    facturas;
    

   
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


-- Ejemplo de uso, lista de licitadores y su participación porcentual 
SELECT
    licitador_nombre AS Licitador,
    repositor_ruedas.porcent_licitador(licitador_nombre) AS Participación
FROM
    licitadores
ORDER BY
	Participación DESC;
    
   
-- CREACIÓN DE PROCEDIMIENTOS

-- Procedimiento TRANSACCIONAL (TCL) para ingresar nuevo siniestro
-- Corrobora que los datos ingresados en FK sean correctos y no sean nulos

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

	-- Si la fecha no se proporciona, usar la fecha actual
  	IF p_siniestro_fecha IS NULL THEN
    	SET p_siniestro_fecha = CURRENT_TIMESTAMP();
  	END IF;

	-- Insertar el nuevo registro en la tabla siniestros
	INSERT INTO siniestros (
    	siniestro_nro, siniestro_fecha, siniestro_tipo, cantidad_ruedas,
    	seguro_cia, poliza_nro, licitador, vehiculo, observaciones)
	VALUES (
		p_siniestro_nro, p_siniestro_fecha, p_siniestro_tipo, p_cantidad_ruedas,
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

-- Llamamos al procedimiento

CALL ingreso_siniestro(
    2003506792, 		-- siniestro_nro
    NULL,		 		-- siniestro_fecha (por defecto, fecha actual)
    'AUCH',				-- siniestro_tipo
    4, 					-- cantidad_ruedas
    '30-50004946-0', 	-- seguro_cia
    167559,				-- poliza_nro
    2, 					-- licitador
    33,					-- vehiculo
    NULL				-- observaciones
    );



-- Procedimiento TRANSACCIONAL (TCL) para ingresar una nueva factura
-- Dicho registro además actualizará campos en 'siniestros' y 'link_facturas_ruedas'

DROP PROCEDURE IF EXISTS repositor_ruedas.agregar_factura;

DELIMITER //
CREATE PROCEDURE repositor_ruedas.agregar_factura(
    IN p_siniestro_id INT,
    IN p_factura_tipo VARCHAR(10),
    IN p_factura_fecha DATETIME,
    IN p_factura_pdv INT,
    IN p_factura_nro INT,
    IN p_rueda_item INT,
    IN p_rueda_precio DECIMAL(10, 2),
    IN p_rueda_cantidad INT)
BEGIN
    DECLARE v_siniestro_existente INT;
    DECLARE v_factura_id VARCHAR(20);
    DECLARE v_factura_precio DECIMAL(10, 2);
    DECLARE v_factura_fecha DATETIME;
	
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

            -- Si la fecha proporcionada es NULL, usamos la fecha actual
            SET v_factura_fecha = IFNULL(p_factura_fecha, CURRENT_TIMESTAMP());

            -- Determinamos campos para insertar nuevo registro
            INSERT INTO facturas (factura_id, factura_tipo, factura_fecha, factura_pdv,
                factura_nro, rueda_item, rueda_precio, rueda_cantidad, factura_precio)
            VALUES (v_factura_id, p_factura_tipo, v_factura_fecha, p_factura_pdv,
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


-- Llamamos al procedimiento
-- (quizás sea necesario desactivar temporalmente SQL_SAFE_UPDATES)

SET SQL_SAFE_UPDATES = 0;

CALL agregar_factura(
    1256,      -- siniestro_id
    'FA',      -- factura_tipo
    NULL,      -- factura_fecha (default CURRENT)
    3,         -- factura_pdv
    69050,     -- factura_nro
    60,        -- rueda_item
    220000,    -- rueda_precio
    2          -- rueda_cantidad
    );

SET SQL_SAFE_UPDATES = 1;

-- Finalmente corroboramos las tablas relacionadas

SELECT * FROM facturas
ORDER BY factura_fecha DESC
LIMIT 10;

SELECT * FROM siniestros
ORDER BY siniestro_fecha DESC
LIMIT 10;

SELECT * FROM link_facturas_ruedas
WHERE id_facturas = 'FA-3-69050';



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

-- Ejemplo de uso

CALL agregar_vehiculo(
'Audi',			-- Marca
'A6',			-- Modelo
'Particular'	-- Utilidad
);

-- Verificación

SELECT * FROM vista_vehiculos;



-- CREACIÓN DE ROLES Y ASIGNACIÓN DE USUARIOS

-- Crearemos 4 roles que representan las áreas encargadas

DROP ROLE IF EXISTS 'SISTEMA', 'ADMIN', 'DEPOSITO', 'CONTACTO';
CREATE ROLE 'SISTEMA', 'ADMIN', 'DEPOSITO', 'CONTACTO';

-- Otorgaremos permisos

-- ROL SISTEMA
-- Todos los permisos
GRANT ALL PRIVILEGES ON repositor_ruedas.* TO 'SISTEMA';

-- ROL ADMIN
-- DML sobre 4 tablas
GRANT SELECT, INSERT, UPDATE ON repositor_ruedas.siniestros TO 'ADMIN';
GRANT SELECT, INSERT, UPDATE ON repositor_ruedas.tipos_siniestros TO 'ADMIN';
GRANT SELECT, INSERT, UPDATE ON repositor_ruedas.facturas TO 'ADMIN';
GRANT SELECT, INSERT, UPDATE ON repositor_ruedas.facturas_tipos TO 'ADMIN';

-- Ejecución en 2 funciones y 2 procedimientos
GRANT EXECUTE ON FUNCTION repositor_ruedas.ganancia_neta TO 'ADMIN';
GRANT EXECUTE ON FUNCTION repositor_ruedas.porcent_licitador TO 'ADMIN';
GRANT EXECUTE ON PROCEDURE repositor_ruedas.ingreso_siniestro TO 'ADMIN';
GRANT EXECUTE ON PROCEDURE repositor_ruedas.agregar_factura TO 'ADMIN';

-- Utilización de 2 vistas
GRANT SELECT ON repositor_ruedas.view_taxes TO 'ADMIN';
GRANT SELECT ON repositor_ruedas.view_cia_prom TO 'ADMIN';
	
-- ROL DEPOSITO
-- DML sobre 6 tablas
GRANT SELECT, INSERT, UPDATE, DELETE ON ruedas TO 'DEPOSITO';
GRANT SELECT, INSERT, UPDATE, DELETE ON marcas_cub TO 'DEPOSITO';
GRANT SELECT, INSERT, UPDATE, DELETE ON vehiculos TO 'DEPOSITO';
GRANT SELECT, INSERT, UPDATE, DELETE ON marcas_veh TO 'DEPOSITO';
GRANT SELECT, INSERT, UPDATE, DELETE ON modelos TO 'DEPOSITO';
GRANT SELECT, INSERT, UPDATE, DELETE ON utilidades TO 'DEPOSITO';

-- Ejecución de 1 función y 1 procedimiento
GRANT EXECUTE ON FUNCTION repositor_ruedas.cant_x_cia TO 'DEPOSITO';
GRANT EXECUTE ON PROCEDURE repositor_ruedas.agregar_vehiculo TO 'DEPOSITO';

-- Utilización de 3 vistas
GRANT SELECT ON repositor_ruedas.view_ruedas TO 'DEPOSITO';
GRANT SELECT ON repositor_ruedas.view_siniestros_vehiculos TO 'DEPOSITO';
GRANT SELECT ON repositor_ruedas.view_vehiculos TO 'DEPOSITO';
	
-- ROL CONTACTO 
-- Visualización sobre 4 tablas
GRANT SELECT ON seguros TO 'CONTACTO';
GRANT SELECT ON licitadores TO 'CONTACTO';
GRANT SELECT ON asegurados TO 'CONTACTO';
GRANT SELECT ON polizas TO 'CONTACTO';

-- Utilización de 1 vista
GRANT SELECT ON repositor_ruedas.view_reincidencias TO 'CONTACTO';


-- Crearemos los usuarios
	
-- SISTEMA
DROP USER IF EXISTS
	'LeoDI'@'%',
	'JesiB'@'%';

CREATE USER 'LeoDI'@'%' IDENTIFIED BY 'sys123'
	FAILED_LOGIN_ATTEMPTS 3
	PASSWORD_LOCK_TIME 2
	PASSWORD EXPIRE INTERVAL 180 DAY;
CREATE USER 'JesiB'@'%' IDENTIFIED BY 'sys456'
	FAILED_LOGIN_ATTEMPTS 3
	PASSWORD_LOCK_TIME 2
	PASSWORD EXPIRE INTERVAL 180 DAY;

-- ADMIN
DROP USER IF EXISTS
	'AndreC'@'localhost',
	'FedeZ'@'localhost',
	'HugoQ'@'localhost';

CREATE USER 'AndreC'@'localhost' IDENTIFIED BY 'adm01'
	FAILED_LOGIN_ATTEMPTS 3
	PASSWORD_LOCK_TIME 5
	PASSWORD EXPIRE INTERVAL 90 DAY;
CREATE USER 'FedeZ'@'localhost' IDENTIFIED BY 'adm02'
	FAILED_LOGIN_ATTEMPTS 3
	PASSWORD_LOCK_TIME 5
	PASSWORD EXPIRE INTERVAL 90 DAY;
CREATE USER 'HugoQ'@'localhost' IDENTIFIED BY 'adm03'
	FAILED_LOGIN_ATTEMPTS 3
	PASSWORD_LOCK_TIME 2
	PASSWORD EXPIRE INTERVAL 90 DAY;

-- DEPOSITO
DROP USER IF EXISTS
	'CrisA'@'localhost', 'ReneB'@'localhost',
	'SantiG'@'localhost', 'MatiK'@'localhost';
	
CREATE USER 'CrisA'@'localhost' IDENTIFIED BY 'dep01'
	FAILED_LOGIN_ATTEMPTS 3
	PASSWORD_LOCK_TIME 5
	PASSWORD EXPIRE INTERVAL 90 DAY;
CREATE USER 'ReneB'@'localhost' IDENTIFIED BY 'dep02'
	FAILED_LOGIN_ATTEMPTS 3
	PASSWORD_LOCK_TIME 5
	PASSWORD EXPIRE INTERVAL 90 DAY;
CREATE USER 'SantiG'@'localhost' IDENTIFIED BY 'dep03'
	FAILED_LOGIN_ATTEMPTS 3
	PASSWORD_LOCK_TIME 5
	PASSWORD EXPIRE INTERVAL 90 DAY;
CREATE USER 'MatiK'@'localhost' IDENTIFIED BY 'dep04'
	FAILED_LOGIN_ATTEMPTS 3
	PASSWORD_LOCK_TIME 5
	PASSWORD EXPIRE INTERVAL 90 DAY;

-- CONTACTO
DROP USER IF EXISTS
	'RubenM'@'localhost', 'LucasN'@'localhost';

CREATE USER 'RubenM'@'localhost' IDENTIFIED BY 'con01'
	FAILED_LOGIN_ATTEMPTS 3
	PASSWORD_LOCK_TIME 5
	PASSWORD EXPIRE INTERVAL 90 DAY;
CREATE USER 'LucasN'@'localhost' IDENTIFIED BY 'con02'
	FAILED_LOGIN_ATTEMPTS 3
	PASSWORD_LOCK_TIME 5
	PASSWORD EXPIRE INTERVAL 90 DAY;


-- Otorgamos roles

GRANT 'SISTEMA' TO
	'LeoDI'@'%', 'JesiB'@'%';
	
GRANT 'ADMIN' TO
	'AndreC'@'localhost', 'FedeZ'@'localhost',
	'HugoQ'@'localhost';
	
GRANT 'DEPOSITO' TO
	'CrisA'@'localhost', 'ReneB'@'localhost',
	'SantiG'@'localhost', 'MatiK'@'localhost';
	
GRANT 'CONTACTO' TO
	'RubenM'@'localhost', 'LucasN'@'localhost';
	

-- Activación de roles por defecto

SET DEFAULT ROLE 'SISTEMA'
	TO 'LeoDI'@'%',
		'JesiB'@'%';
	
SET DEFAULT ROLE 'ADMIN'
	TO 'AndreC'@'localhost',
		'FedeZ'@'localhost',
		'HugoQ'@'localhost';
	
SET DEFAULT ROLE 'DEPOSITO'
	TO 'CrisA'@'localhost',
		'ReneB'@'localhost',
		'SantiG'@'localhost',
		'MatiK'@'localhost';
	
SET DEFAULT ROLE 'CONTACTO'
	TO 'RubenM'@'localhost',
		'LucasN'@'localhost';

-- Actualizamos los privilegios

FLUSH PRIVILEGES;


-- Corroboramos los roles asignados en cada usuario

SHOW GRANTS FOR 'LeoDI'@'%';
SHOW GRANTS FOR 'JesiB'@'%';
SHOW GRANTS FOR 'AndreC'@'%';
SHOW GRANTS FOR 'FedeZ'@'%';
SHOW GRANTS FOR 'HugoQ'@'%';
SHOW GRANTS FOR 'CrisA'@'%';
SHOW GRANTS FOR 'ReneB'@'%';
SHOW GRANTS FOR 'SantiG'@'%';
SHOW GRANTS FOR 'MatiK'@'%';
SHOW GRANTS FOR 'RubenM'@'%';
SHOW GRANTS FOR 'LucasN'@'%';



-- CHEQUEO DE OBJETOS

-- Verificación de tablas y comentarios

SELECT 
    TABLE_NAME AS Tabla, 
    TABLE_COMMENT AS Comentario
FROM 
    INFORMATION_SCHEMA.TABLES
WHERE 
    TABLE_SCHEMA = 'repositor_ruedas';


-- Verificación de datos importados
   
SELECT 
    TABLE_NAME AS Tabla, 
    TABLE_ROWS AS Cantidad_filas
FROM 
    information_schema.tables
WHERE 
    TABLE_SCHEMA = 'repositor_ruedas'
ORDER BY 
    TABLE_ROWS DESC;
    
   
-- Verificación de conexiones entre tablas
   
SELECT 
    TABLE_NAME AS Tabla, 
    COLUMN_NAME AS Columna, 
    CONSTRAINT_NAME AS Restriccion, 
    REFERENCED_TABLE_NAME AS Referencia_tabla, 
    REFERENCED_COLUMN_NAME AS Referencia_columna
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
    REFERENCED_TABLE_SCHEMA = 'repositor_ruedas';   
   
   
-- Verificación de vistas
   
SELECT 
    TABLE_NAME AS Vista,
    TABLE_TYPE AS Tipo
FROM 
    INFORMATION_SCHEMA.TABLES
WHERE 
    TABLE_SCHEMA = 'repositor_ruedas' 
    AND TABLE_TYPE = 'VIEW'
ORDER BY 
    TABLE_NAME;
    
   
-- Verificación de funciones
   
SELECT 
    ROUTINE_NAME AS Funcion,
    DATA_TYPE AS Retorno
FROM 
    INFORMATION_SCHEMA.ROUTINES
WHERE 
    ROUTINE_SCHEMA = 'repositor_ruedas' 
    AND ROUTINE_TYPE = 'FUNCTION'
ORDER BY 
    ROUTINE_NAME;
    
   
-- Verificación de procedimientos

SELECT 
    ROUTINE_NAME AS Procedimiento,
    ROUTINE_TYPE AS Tipo
FROM 
    INFORMATION_SCHEMA.ROUTINES
WHERE 
    ROUTINE_SCHEMA = 'repositor_ruedas' 
    AND ROUTINE_TYPE = 'PROCEDURE'
ORDER BY 
    ROUTINE_NAME;
    
   
-- Verificación de trigers

SELECT 
    TRIGGER_NAME AS Nombre_trigger,
    EVENT_MANIPULATION AS Evento,
    EVENT_OBJECT_TABLE AS Tabla,
    ACTION_TIMING AS Momento
FROM 
    INFORMATION_SCHEMA.TRIGGERS
WHERE 
    TRIGGER_SCHEMA = 'repositor_ruedas'
ORDER BY 
    EVENT_OBJECT_TABLE, 
    ACTION_TIMING, 
    EVENT_MANIPULATION;
    
   
-- Verificación de roles y usuarios

SELECT
    FROM_USER AS Roles,
    TO_USER AS Usuarios,
    CASE 
        WHEN FROM_USER = 'SISTEMA' THEN 'Desde cualquier host'
        ELSE 'Dispositivo local'
    END AS Conexion,
    CASE 
        WHEN FROM_USER = 'SISTEMA' THEN 'Acceso total al sistema'
        WHEN FROM_USER = 'ADMIN' THEN 'Permisos de administrador'
        WHEN FROM_USER = 'DEPOSITO' THEN 'Control de depósito'
        ELSE 'Consultas a info de contacto'
    END AS Comentario
FROM mysql.role_edges
ORDER BY Roles ASC;
