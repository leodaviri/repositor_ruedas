USE repositor_ruedas;


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
