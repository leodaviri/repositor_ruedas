USE repositor_ruedas;

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
