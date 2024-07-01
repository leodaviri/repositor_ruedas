-- ESTRUCTURACIÓN DE BASE DE DATOS PARA GRUPO CONCESIONARIO

-- Alumno: Iriarte Leonardo David

-- Comisión: #57190

-- Proofesor: Anderson M. Torres

-- Tutor: Ariel Annone

__________________________________________________________________
-- Creación de bases de datos 

DROP DATABASE IF EXISTS repositor_ruedas;

CREATE DATABASE
	IF NOT EXISTS repositor_ruedas;
	
__________________________________________________________________
-- Creación de tablas

USE repositor_ruedas;

-- Tabla de hechos, resumen de siniestros
CREATE TABLE
	IF NOT EXISTS siniestros(
	siniestro_id INT NOT NULL COMMENT 'numero de siniestro real segun compañia',
	fecha DATETIME NOT NULL,
	siniestro_tipo VARCHAR(50) NOT NULL,
	cantidad_ruedas INT NOT NULL,
	seguro_cia INT NOT NULL,
	poliza_nro INT NOT NULL COMMENT 'numero de poliza real segun compañia',
	licitador INT NOT NULL,
	vehiculo INT NOT NULL,
	observaciones TEXT COMMENT 'para especificaciones puntuales y necesarias',
	PRIMARY KEY (siniestro_id)
	COMMENT 'Tabla de hechos destinada a asignar los casos por siniestros, NO ADMITE NULOS'
);

-- Tablas dimensionales
CREATE TABLE 
	IF NOT EXISTS tipos_siniestros(
	siniestro_tipo_id VARCHAR(50) NOT NULL,
	siniestro_tipo_descripcion VARCHAR(50) NOT NULL DEFAULT 'pendiente descripcion',
	PRIMARY KEY (siniestro_tipo_id)
	COMMENT 'Se especifica el tipo de siniestro, puntualmente posicion de rueda sustraida'
);

CREATE TABLE 
	IF NOT EXISTS seguros(
	seguro_id INT NOT NULL AUTO_INCREMENT, 
	seguro_nombre VARCHAR(50) NOT NULL COMMENT 'razon social',
	seguro_alias VARCHAR(50) UNIQUE NOT NULL COMMENT 'nombre resumido o comercial',
	seguro_ciudad INT NOT NULL,
	seguro_provincia INT NOT NULL,
	seguro_web VARCHAR(50) UNIQUE,
	seguro_telefono INT NOT NULL COMMENT 'requiere siempre un telefono de contacto',
	seguro_mail VARCHAR(50) UNIQUE DEFAULT 'pendiente asignar mail',
	PRIMARY KEY (seguro_id)
	COMMENT 'Información de contacto y ubicacion de las companias de seguro'
);

CREATE TABLE 
	IF NOT EXISTS ciudades(
	ciudad_id INT NOT NULL AUTO_INCREMENT,
	ciudad_nombre VARCHAR(50) NOT NULL,
	PRIMARY KEY (ciudad_id)
	COMMENT 'Ciudad en la que se ubica la casa central'
);

CREATE TABLE 
	IF NOT EXISTS provincias(
	provincia_id INT NOT NULL AUTO_INCREMENT,
	provincia_nombre VARCHAR(50) NOT NULL UNIQUE,
	PRIMARY KEY (provincia_id)
	COMMENT 'Provincia en la que se ubica la casa central'
);

CREATE TABLE 
	IF NOT EXISTS polizas(
	poliza_id INT NOT NULL COMMENT 'numero de poliza real segun compañia',
	poliza_tipo VARCHAR(50) NOT NULL DEFAULT 'falta asignar tipo de poliza', 
	cobertura DECIMAL(10,2) NOT NULL COMMENT 'porcentaje de cobertura',
	asegurado INT NOT NULL,
	PRIMARY KEY (poliza_id)
	COMMENT 'Informacion especifica de polizas segun siniestros'
);

CREATE TABLE 
	IF NOT EXISTS asegurados(
	asegurado_id INT NOT NULL AUTO_INCREMENT,
	asegurado_nombre VARCHAR(50) NOT NULL,
	asegurado_apellido VARCHAR(50) NOT NULL,
	asegurado_telefono INT,
	asegurado_mail VARCHAR(50) UNIQUE DEFAULT 'pendiente asignar mail',
	PRIMARY KEY (asegurado_id)
	COMMENT 'Informacion basica de asegurados'
);

CREATE TABLE 
	IF NOT EXISTS licitadores(
	licitador_id INT NOT NULL AUTO_INCREMENT,
	licitador_nombre VARCHAR(50) NOT NULL UNIQUE,
	licitador_web VARCHAR(50) UNIQUE DEFAULT 'pendiente aseigar web',
	PRIMARY KEY (licitador_id)
	COMMENT 'Datos de utilidad sobre los entes licitadores'
);

CREATE TABLE 
	IF NOT EXISTS vehiculos(
	vehiculo_id INT NOT NULL AUTO_INCREMENT,
	vehiculo_marca INT NOT NULL, 
	vehiculo_modelo INT NOT NULL,
	vehiculo_utilidad INT NOT NULL,
	PRIMARY KEY (vehiculo_id)
	COMMENT 'Conecta con tablas categoricas marca, modelo y utilidad'
);

CREATE TABLE 
	IF NOT EXISTS marcas(
	marca_id INT NOT NULL AUTO_INCREMENT,
	marca_nombre VARCHAR(50) NOT NULL,
	PRIMARY KEY (marca_id)
	COMMENT 'Marca fabricante del veiculo'
);

CREATE TABLE 
	IF NOT EXISTS modelo(
	modelo_id INT NOT NULL AUTO_INCREMENT,
	modelo_descripcion VARCHAR(100) NOT NULL COMMENT 'refiere a modelo, NO anio de fabricacion',
	PRIMARY KEY (modelo_id)
	COMMENT 'Especificaciones de modelo del vehiculo'
);

CREATE TABLE 
	IF NOT EXISTS utilidad(
	utilidad_id INT NOT NULL AUTO_INCREMENT,
	utilidad_descripcion VARCHAR(100) NOT NULL DEFAULT 'pendiente asignar utilidad',
	PRIMARY KEY (utilidad_id)
	COMMENT 'Especificaciones de uso del vehiculo'
);
	
__________________________________________________________________
-- Asignación de conexiones, definición de FK

ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestro_tipo
	FOREIGN KEY (siniestro_tipo) REFERENCES tipos_siniestros(siniestro_tipo_id);

ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestro_seguro
	FOREIGN KEY (seguro_cia) REFERENCES seguros(seguro_id);
	
ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestro_poliza
	FOREIGN KEY (poliza_nro) REFERENCES polizas(poliza_id);
	
ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestro_licitador
	FOREIGN KEY (licitador) REFERENCES licitadores(licitador_id);
	
ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestro_vehiculo
	FOREIGN KEY (vehiculo) REFERENCES vehiculos(vehiculo_id);
	
ALTER TABLE seguros
	ADD CONSTRAINT fk_seguro_ciudad
	FOREIGN KEY (seguro_ciudad) REFERENCES ciudades(ciudad_id);
	
ALTER TABLE seguros
	ADD CONSTRAINT fk_seguro_provincia
	FOREIGN KEY (seguro_provincia) REFERENCES provincias(provincia_id);
	
ALTER TABLE polizas
	ADD CONSTRAINT fk_poliza_asegurado
	FOREIGN KEY (asegurado) REFERENCES asegurados(asegurado_id);
	
ALTER TABLE vehiculos
	ADD CONSTRAINT fk_vehiculo_marca
	FOREIGN KEY (vehiculo_marca) REFERENCES marcas(marca_id);
	
ALTER TABLE vehiculos
	ADD CONSTRAINT fk_vehiculo_modelo
	FOREIGN KEY (vehiculo_modelo) REFERENCES modelo(modelo_id);
	
ALTER TABLE vehiculos
	ADD CONSTRAINT fk_vehiculo_utilidad
	FOREIGN KEY (vehiculo_utilidad) REFERENCES utilidad(utilidad_id);