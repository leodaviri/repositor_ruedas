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
	FOREIGN KEY (siniestro_tipo)
	REFERENCES tipos_siniestros(siniestro_tipo_id)
    ON UPDATE CASCADE;

ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestros_facturas
	FOREIGN KEY (factura_nro)
	REFERENCES facturas(factura_id)
    ON UPDATE CASCADE;

ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestros_seguros
	FOREIGN KEY (seguro_cia)
	REFERENCES seguros(seguro_id)
    ON UPDATE CASCADE;
	
ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestros_polizas
	FOREIGN KEY (poliza_nro)
	REFERENCES polizas(poliza_id)
    ON UPDATE CASCADE;
	
ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestros_licitadores
	FOREIGN KEY (licitador)
	REFERENCES licitadores(licitador_id)
    ON UPDATE CASCADE;
	
ALTER TABLE siniestros
	ADD CONSTRAINT fk_siniestros_vehiculos
	FOREIGN KEY (vehiculo)
	REFERENCES vehiculos(vehiculo_id)
    ON UPDATE CASCADE;
	
ALTER TABLE seguros
	ADD CONSTRAINT fk_seguros_ciudades
	FOREIGN KEY (seguro_ciudad)
	REFERENCES ciudades(ciudad_id)
    ON UPDATE CASCADE;
	
ALTER TABLE seguros
	ADD CONSTRAINT fk_seguros_provincias
	FOREIGN KEY (seguro_provincia)
	REFERENCES provincias(provincia_id)
    ON UPDATE CASCADE;
	
ALTER TABLE polizas
	ADD CONSTRAINT fk_polizas_asegurados
	FOREIGN KEY (asegurado)
	REFERENCES asegurados(asegurado_id)
    ON UPDATE CASCADE;
	
ALTER TABLE vehiculos
	ADD CONSTRAINT fk_vehiculos_marcas_veh
	FOREIGN KEY (vehiculo_marca)
	REFERENCES marcas_veh(marca_id)
    ON UPDATE CASCADE;
	
ALTER TABLE vehiculos
	ADD CONSTRAINT fk_vehiculos_modelos
	FOREIGN KEY (vehiculo_modelo)
	REFERENCES modelos(modelo_id)
    ON UPDATE CASCADE;
	
ALTER TABLE vehiculos
	ADD CONSTRAINT fk_vehiculo_utilidades
	FOREIGN KEY (vehiculo_utilidad)
	REFERENCES utilidades(utilidad_id)
    ON UPDATE CASCADE;
	
ALTER TABLE facturas
	ADD CONSTRAINT fk_facturas_tipos
	FOREIGN KEY (factura_tipo)
	REFERENCES facturas_tipos(factura_tipo_id)
    ON UPDATE CASCADE;
	
ALTER TABLE ruedas
	ADD CONSTRAINT fk_ruedas_marcas
	FOREIGN KEY (cubierta_marca)
	REFERENCES marcas_cub(marca_id)
    ON UPDATE CASCADE;
	

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
