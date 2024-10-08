USE repositor_ruedas;

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