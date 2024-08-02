USE repositor_ruedas;

-- Habilitamos la importación de archivos local

SET GLOBAL local_infile = TRUE;

-- Chequeamos dicha habilitación

SHOW GLOBAL VARIABLES LIKE 'local_infile';


-- Procedemos a importar datos considerando el orden en que fueron creadas las tablas

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/siniestros.csv'
INTO TABLE siniestros
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(siniestro_id, siniestro_nro, siniestro_fecha, factura_nro,
siniestro_tipo, cantidad_ruedas, seguro_cia, poliza_nro,
licitador, vehiculo, observaciones);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/facturas.csv'
INTO TABLE facturas
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(factura_id, factura_tipo, factura_fecha, factura_pdv, factura_nro
rueda_item, rueda_precio, rueda_cantidad, factura_precio);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/facturas_tipos.csv'
INTO TABLE facturas_tipos
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(factura_tipo_id, factura_tipo_descripcion);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/tipos_siniestros.csv'
INTO TABLE tipos_siniestros
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(siniestro_tipo_id, siniestro_tipo_descripcion);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/seguros.csv'
INTO TABLE seguros
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(seguro_id, seguro_nombre, seguro_alias, seguro_ciudad, seguro_provincia,
seguro_web, seguro_telefono, seguro_mail);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/ciudades.csv'
INTO TABLE ciudades
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ciudad_id, ciudad_nombre);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/provincias.csv'
INTO TABLE provincias
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(provincia_id, provincia_nombre);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/polizas.csv'
INTO TABLE polizas
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(poliza_id, poliza_tipo, cobertura, asegurado);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/asegurados.csv'
INTO TABLE asegurados
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(asegurado_id, asegurado_nombre, asegurado_apellido,
asegurado_telefono, asegurado_mail);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/licitadores.csv'
INTO TABLE licitadores
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(licitador_id, licitador_nombre, licitador_web);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/vehiculos.csv'
INTO TABLE vehiculos
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(vehiculo_id, vehiculo_marca, vehiculo_modelo, vehiculo_utilidad);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/marcas_veh.csv'
INTO TABLE marcas_veh
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(marca_id, marca_nombre);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/modelos.csv'
INTO TABLE modelos
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(modelo_id, modelo_descripcion);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/utilidades.csv'
INTO TABLE utilidades
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(utilidad_id, utilidad_descripcion);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/ruedas.csv'
INTO TABLE ruedas
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(rueda_id, rueda_descripcion, cubierta_marca, rodado_llanta);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/marcas_cub.csv'
INTO TABLE marcas_cub
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(marca_id, marca_descripcion);

LOAD DATA LOCAL INFILE '/repositor_ruedas/data_csv/link_facturas_ruedas.csv'
INTO TABLE link_facturas_ruedas
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_facturas, id_ruedas, cantidad);