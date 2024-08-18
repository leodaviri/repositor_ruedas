USE repositor_ruedas;


-- Crearemos 3 áreas

DROP ROLE IF EXISTS 'SISTEMA', 'ADMIN', 'DEPOSITO', 'CONTACTO';

CREATE ROLE 'SISTEMA', 'ADMIN', 'DEPOSITO', 'CONTACTO';

-- Otorgaremos permisos por área:

-- SISTEMA
-- Todos los permisos
GRANT ALL ON repositor_ruedas.* TO 'SISTEMA';

-- ADMIN
-- DML sobre 4 tablas
GRANT SELECT, INSERT, UPDATE, DELETE ON repositor_ruedas.siniestros TO 'ADMIN';
GRANT SELECT, INSERT, UPDATE, DELETE ON repositor_ruedas.tipos_siniestros TO 'ADMIN';
GRANT SELECT, INSERT, UPDATE, DELETE ON repositor_ruedas.facturas TO 'ADMIN';
GRANT SELECT, INSERT, UPDATE, DELETE ON repositor_ruedas.facturas_tipos TO 'ADMIN';

-- Ejecución en 2 funciones y 2 procedimientos
GRANT EXECUTE ON FUNCTION repositor_ruedas.ganancia_neta TO 'ADMIN';
GRANT EXECUTE ON FUNCTION repositor_ruedas.porcent_licitador TO 'ADMIN';
GRANT EXECUTE ON PROCEDURE repositor_ruedas.ingreso_siniestro TO 'ADMIN';
GRANT EXECUTE ON PROCEDURE repositor_ruedas.agregar_factura TO 'ADMIN';

-- Utilización de 2 vistas
GRANT SELECT ON repositor_ruedas.view_taxes TO 'ADMIN';
GRANT SELECT ON repositor_ruedas.view_cia_prom TO 'ADMIN';
	
-- DEPOSITO
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
	
-- CONTACTO 
-- Visualización sobre 4 tablas
GRANT SELECT ON seguros TO 'CONTACTO';
GRANT SELECT ON licitadores TO 'CONTACTO';
GRANT SELECT ON asegurados TO 'CONTACTO';
GRANT SELECT ON polizas TO 'CONTACTO';

-- Utilización de 1 vista
GRANT SELECT ON repositor_ruedas.view_reincidencias TO 'CONTACTO';


-- Crearemos usuarios

DROP USER IF EXISTS
	'LeoDI'@'%', 'JesiB'@'%',
	'AndreC'@'%', 'FedeZ'@'%', 'HugoQ'@'%',
	'CrisA'@'%', 'ReneB'@'%', 'SantiG'@'%', 'MatiK'@'%',
	'RubenM'@'%', 'LucasN'@'%';
	
	
-- SISTEMA
CREATE USER 'LeoDI'@'%' IDENTIFIED BY 'sys123';
CREATE USER 'JesiB'@'%' IDENTIFIED BY 'sys456';

-- ADMIN
CREATE USER 'AndreC'@'%' IDENTIFIED BY 'adm01';
CREATE USER 'FedeZ'@'%' IDENTIFIED BY 'adm02';
CREATE USER 'HugoQ'@'%' IDENTIFIED BY 'adm03';

-- DEPOSITO
CREATE USER 'CrisA'@'%' IDENTIFIED BY 'dep01';
CREATE USER 'ReneB'@'%' IDENTIFIED BY 'dep02';
CREATE USER 'SantiG'@'%' IDENTIFIED BY 'dep03';
CREATE USER 'MatiK'@'%' IDENTIFIED BY 'dep04';

-- CONTACTO
CREATE USER 'RubenM'@'%' IDENTIFIED BY 'con01';
CREATE USER 'LucasN'@'%' IDENTIFIED BY 'con02';


-- Otorgamos roles

GRANT 'SISTEMA' TO
	'LeoDI'@'%', 'JesiB'@'%';
	
GRANT 'ADMIN' TO
	'AndreC'@'%', 'FedeZ'@'%', 'HugoQ'@'%';
	
GRANT 'DEPOSITO' TO
	'CrisA'@'%', 'ReneB'@'%', 'SantiG'@'%', 'MatiK'@'%';
	
GRANT 'CONTACTO' TO
	'RubenM'@'%', 'LucasN'@'%';
	

-- Activación de roles por defecto

SET DEFAULT ROLE 'SISTEMA' TO 'LeoDI'@'%', 'JesiB'@'%';
SET DEFAULT ROLE 'ADMIN' TO 'AndreC'@'%', 'FedeZ'@'%', 'HugoQ'@'%';
SET DEFAULT ROLE 'DEPOSITO' TO 'CrisA'@'%', 'ReneB'@'%', 'SantiG'@'%', 'MatiK'@'%';
SET DEFAULT ROLE 'CONTACTO' TO 'RubenM'@'%', 'LucasN'@'%';


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