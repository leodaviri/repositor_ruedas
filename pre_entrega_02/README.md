<center>
<img src="https://github.com/leodaviri/repositor_ruedas/blob/main/imagenes/image.jpg?raw=true" style="width: 100% ; aspect-ratio:12/6">
</center>

# ESTRUCTURA DE BASE DE DATOS PARA GRUPO CONCESIONARIO

**Alumno:** *[Iriarte Leonardo David](https://www.linkedin.com/in/leodaviri/)*

**Comisión:** #57190

**Profesor:** Anderson M. Torres

**Tutor:** Ariel Annone

**Lenguaje utilizado:** [SQL](https://dev.mysql.com/)

___

#### PROBLEMA:

Importante grupo concesionario necesita el desarrollo y estructura de una base de datos que permita optimizar informes sobre las reposiciones de ruedas a compañías de seguros. Requiere el tratado de información relevante sobre los siniestros, más específicamente sobre los vehículos más afectados y la segmentación de cada seguro a fin de poder mantener un inventario adecuado a las circunstancias.

#### DESARROLLO:

Trabajaremos con el objetivo de identificar los grupos de mayor relevancia para el proyecto, los mismos se separan en 5 segmentos:

- **`Siniestros:`** necesitamos una base de datos que permita registrar los casos según siniestros, cantidad de ruedas a reponer, compañías aseguradoras y vehículos involucrados.

- **`Seguros:`** una base de datos de compañías es crucial para éste proyecto. La misma debe contener información precisa y completa de cada seguro y licitador asociado, ya que serán los principales clientes y requerirán diversas provisiones según el target de cada uno.

- **`Pólizas:`** requeriremos almacenar campos puntuales sobre los tipos de pólizas y detalles de coberturas ya que cada siniestro puede diferir su porcentaje dependiendo si es total o parcial. También precisaremos información de contacto de los asegurados.

- **`Vehículos:`** es importante considerar la descripción de marca, modelo y utilidad de cada vehículo, ya que las ruedas de equipamiento original varían según dichos campos y debemos asegurarnos de tener el conocimiento previo a la reposición.

- **`Facturas:`** mediante la facturación podremos mantener los registros de inventarios y cuentas, llevando así el control de stock relacionado directamente a los montos de las ruedas, actualización de precios y cuentas corrientes a las compañías de seguros.

___

### TABLAS:

La elección del formato de entidades se centra en una tabla de hechos desde la cual se comienzan a separar los datos potencialmente categóricos en nuevas tablas con la idea de optimizar el uso y facilitar las consultas. Cada tabla tiene en el nombre de la mayoría de sus atributos una referencia inicial al nombre de la tabla a la que pertenecen, de ésta manera lograremos simplificar las consultas externas.

#### DESCRIPCIÓN DE TABLAS:

A continuación ennumeramos las tablas y agregamos una breve descripción.

1. #### `SINIESTROS`
    - Tabla de hechos, contiene información de cada siniestro, fecha y cantidad de ruedas a reponer, así como referencias FK que conectan al resto de tablas dimensionales.
    - Atributos:
        - siniestro_id (PK)
        - fecha
        - siniestro_tipo (FK)
        - cantidad_ruedas
        - seguro_cia (FK)
        - poliza_nro (FK)
        - licitador (FK)
        - vehiculo(FK)
        - observaciones

2. #### `TIPOS_SINIESTROS`
    - Describe el tipo de siniestro, si fuera rueda de posición, auxilio u otros detalles específicos del tipo de llanta que fuera equipo original.
    - Atributos:
        - siniestro_tipo_id (PK)
        - siniestro_tipo_descripcion

3. #### `SEGUROS`
    - Posee información puntual sobre la compañía de seguro a la que pertenece el caso, datos de contacto y la ubicación matriz, así como también un atributo específico llamado *ALIAS* que simplifica el nombre ya que muchos seguros tienen razones sociales demasiado extensas, las cuales se describen en *NOMBRE*.
    - Atributos:
        - seguro_id (PK)
        - seguro_nombre
        - seguro_alias
        - seguro_ciudad (FK)
        - seguro_provincia (FK)
        - seguro_web
        - seguro_telefono
        - seguro_mail

4. #### `CIUDADES`
    - Detalla ID y nombre de la ciudad donde se ubica la casa matriz o central.
    - Atributos:
        - ciudad_id (PK)
        - ciudad_nombre

5. #### `PROVINCIAS`
    - Detalla ID y nombre de la provincia donde se ubica la casa matriz o central.
    - Atributos:
        - provincia_id (PK)
        - provincia_nombre

6. #### `POLIZAS`
    - Informa datos exclusivos de las pólizas, tipo, porcentaje de cobertura y FK que conecta a tabla de *asegurados*.
    - Atributos:
        - poliza_id (PK)
        - poliza_tipo
        - cobertura
        - asegurado (FK)

7. #### `ASEGURADOS`
    - Describe nombre y datos de contacto del/la titular de póliza.
    - Atributos:
        - asegurado_id (PK)
        - asegurado_nombre
        - asegurado_apellido
        - asegurado_telefono
        - asegurado_mail

8. #### `LICITADORES`
    - Especifica el ente o compañía encargada de las licitaciones de los siniestros.
    - Atributos:
        - licitador_id (PK)
        - licitador_nombre
        - licitador_web

9. #### `VEHICULOS`
    - Contiene información primordial de los vehículos afectados, al ser datos categóricos, dicha tabla es un puente o nexo que conecta a otras 3 que almacenan menor cantidad de información.
    - Atributos:
        - vehiculo_id (PK)
        - vehiculo_marca (FK)
        - vehiculo_modelo (FK)
        - vehiculo_utilidad (FK)

10. #### `MARCAS_VEH`
    - Detalla ID y nombre de la marca fabricante del vehículo.
    - Atributos:
        - marca_id (PK)
        - marca_nombre

11. #### `MODELOS`
    - Detalla ID y descripción del modelo de vehículo.
    - Atributos:
        - modelo_id (PK)
        - modelo_descripcion

12. #### `UTILIDADES`
    - Detalla ID y descripción de la utilidad del vehículo.
    - Atributos:
        - utilidad_id (PK)
        - utilidad_descripcion

13. #### `FACTURAS`
    - Describe los datos de facturación y la numeración, así como también las ruedas entregadas.
    - Atributos:
        - factura_id (PK)
        - factura_tipo
        - factura_fecha
        - factura_pdv
        - factura_numero
        - rueda_item (FK)
        - rueda_precio
        - rueda_cantidad
        - factura_precio

14. #### `FACTURAS_TIPOS`
    - Especifica el tipo de emisión de factura según monto y cuit del cliente.
    - Atributos:
        - factura_tipo_id (PK)
        - factura_tipo_descripción

15. #### `RUEDAS`
    - Muestra una breve descripción de la rueda, llanta, rodado y marca de cubierta.
    - Atributos:
        - rueda_id (PK)
        - rueda_descripcion
        - cubierta_marca
        - rodado_llanta

16. #### `MARCAS_CUB`
    - Describe solamente la marca de la cubierta, ya que las llantas son por defecto equipo original.
    - Atributos:
        - marca_id (PK)
        - marca_descripcion

16. #### `LINK_FACTURAS_RUEDAS`
    - Para evitar una relación de muchos a muchos, se crea una tabla vínculo entre **FACTURAS** y **RUEDAS**.
    - Atributos:
        - id_facturas (PK)
        - id_ruedas (PK)
        - cantidad

#### CONEXIÓN DE TABLAS:

En la imagen de puede ver las estructuras de tablas, la definición de PK y FK, la conexión entre las mismas y los tipos de valores designados en cada campo. Se organiza de manera calculada, la tabla de hechos (*SINIESTROS*) al centro y el resto alrededor, las vinculaciones entre tablas externas se pueden notar fácilmente ya que no se cruza ninguna flecha, todo ello a fin de que sea visualmente prolija y comprensible.

**para una vista ampliada de la imagen se puede hacer click en la misma.*

<center>
<img src="https://github.com/leodaviri/repositor_ruedas/blob/main/imagenes/Tablas-conexiones.jpg?raw=true" style="width: 100% ; aspect-ratio:12/8">
</center>

___
#### DIAGRAMA ENTIDAD RELACIÓN (DER):


El diagrama fue desarrollado en excalidraw, muestra en rombos la relación que conecta las entidades y el tipo de conexión.

Se pude visualizar de forma ampliada clickeando en la imagen o en el siguiente link: [(clik aquí)](https://excalidraw.com/#json=58WAnFDVuz632v2A2sq0F,H6KwFhnDlN64ij9bGPKb0w)

<center>
<img src="https://github.com/leodaviri/repositor_ruedas/blob/main/imagenes/Diagrama%20E-R.jpg?raw=true" style="width: 100% ; aspect-ratio:12/9">
</center>

#### VALIDACIÓN:

Print del DER resultante una vez creada la base de datos en SQL.\
En el mismo se puede ver la conexión a la tabla vínculo que no figura en las imágenes anteriores.

<center>
<img src="https://github.com/leodaviri/repositor_ruedas/blob/main/imagenes/DER%20SQL.jpg?raw=true" style="width: 100% ; aspect-ratio:12/9">
</center>

___
### IMPORTACIÓN DE DATOS:

Para la correcta importación de datos desde archivos planos, es necesario previamente habilitar los permisos en servidor y cliente, así como también la edición del archivo 'my.ini' o 'my.cnf', insertando el comando local_infile=1 debajo de una termnación específica:
```
[mysqld]
local_infile=1
```
Los permisos fueron activados mediante 2 comandos adicionales:
* **SET GLOBAL local_infile = TRUE;** (en el script).
* **local-infile=1** posterior a los datos de inicio en server (consola, cmd).

Posterior a la habilitación, se procede a ejecutar el mismo comando de importación local por cada tabla y en el orden en que fueron creadas las tablas:
```
LOAD DATA LOCAL INFILE 'ruta/al/archivo/nombre_archivo.csv'
INTO TABLE nombre_tabla
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
```
___
### OBJETOS DE LA BASE DE DATOS:

A continuación se detalla una lista con breve descripción de cada objeto creado para la optimización y agilización de la base de datos.

### VISTAS:

1. #### `VIEW_TAXES`
    - Vista para determinar el IVA (21%) e IIBB (3%) mensual según monto y provincia.

    - Columnas:
        - Mes
        - IVA 21%
        - IIBB
        - Provincia
    - Ejemplo de uso:
```
SELECT * FROM repositor_ruedas.view_taxes
    ORDER BY mes ASC;
```
2. #### `VIEW_RUEDAS`
    - Vista para determinar el movimiento de stock según cantidad, rodado de llanta y marca de cubierta.
    
    - Columnas:
        - Cantidad
        - Llanta
        - Marca_cubierta
    - Ejemplo de uso:
```
SELECT * FROM repositor_ruedas.view_ruedas
    ORDER BY Cantidad DESC;
```
3. #### `VIEW_REINCIDENCIAS`
    - Vista para las compañías, ayudará al control de reincidencias por alta siniestralidad.

    - Columnas:
        - Poliza
        - Reincidencias
        - Asegurado
    - Ejemplo de uso:
```
SELECT * FROM repositor_ruedas.view_reincidencias
	ORDER BY reincidencias DESC;
```
4. #### `VIEW_SINIESTROS_VEHICULOS`
    - Vista para control de reposiciones, ayudará a determinar las compras a concecionarias oficiales considerando marca y modelo de vehículos.

    - Columnas:
        - Suma_siniestros
        - Modelo
        - Marca
        - Cant_ruedas
    - Ejemplo de uso:
```
SELECT * FROM repositor_ruedas.view_siniestros_vehiculos;
	ORDER BY cant_ruedas DESC;
```
5. #### `VIEW_CIA_PROM`
    - Vista para llevar control del promedio de ordenes que asigna cada seguro. A fines prácticos, considera solamente el último mes de participación.

    - Columnas:
        - Compania
        - Promedio_orden
        - Ultimo_mes
    Ejemplo de uso:
```
SELECT * FROM repositor_ruedas.view_cia_prom;
```
**(la propia vista ordena de forma ascendente para considerar estrategias alternativas sobre los clientes menos frecuentes)*

___
### TRIGGERS:

1. #### `CHECK_FACTURA_FECHA`

    - Creado sobre tabla 'facturas' para evitar que la fecha de una nueva factura sea anterior a la del siniestro que le corresponde registrado previamente.

    - Ejemplo de uso y mensaje SIGNAL SQLSTATE '45000':
```
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

ERROR 1644 (45000): La fecha de la factura no puede ser anterior a la fecha del siniestro.
```
2. #### `CANT_X_SINIESTRO`

    - Creado sobre tabla 'siniestros' para evitar errores de tipeo, en éste caso, la cantidad de ruedas máxima de ruedas que pueda poseer cualquier vehículo del segmento trabajado, el cual no incluye transportes o taras más granes.

    - Ejemplo de uso y mensaje SIGNAL SQLSTATE '45000':
```
INSERT INTO siniestros
	(siniestro_nro, siniestro_fecha, siniestro_tipo,
    cantidad_ruedas, seguro_cia, poliza_nro, licitador,
    vehiculo)
VALUES
	(2554738, NOW(), 'AUPOAL', 6, '30-50004717-4',
	169601, 2, 11);

ERROR 1644 (45000): La cantidad de ruedas no puede superar las 5 unidades
```
3. #### `ASEGURADO_TEL`

    - Creado sobre tabla 'asegurados' con devolución de mensaje de advertencia o warning en caso que no se haya asignado un número de teléfono de contacto.

    - Ejemplo de uso y mensaje SIGNAL SQLSTATE '01000':
```
INSERT INTO asegurados
	(asegurado_id, asegurado_nombre, asegurado_apellido)
VALUES
	(1260, 'Rosario', 'Pileyra');

Warning Code: 1000
Recuerde registrar un contacto telefónico
```

___
### FUNCIONES:

1. #### `GANANCIA_NETA`

    - Calcula la ganancia neta, restando -21% (iva) y -3% (IIBB) al valor de las facturas. Determina la ganancia con un cálculo simple del precio *0,79 *0,03 y concatena el resultado con un símbolo $.

    - Ejemplo de uso:
```
SELECT 
    factura_id AS Factura,
    factura_precio AS Precio,
    repositor_ruedas.ganancia_neta(factura_precio) AS Ganancia_neta
FROM 
    facturas;
```
2. #### `CANT_X_CIA`

    - Toma como parámetro el alias de las compañías para ejecutar la función, la cual calcula de forma simple el total de ruedas entregadas a cada seguro.

    - Ejemplo de uso (unitario simple y en lista, por período):
```
-- simple
SELECT repositor_ruedas.cant_x_cia('ALLIANZ') AS Total_ruedas;

-- por período
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
```
3. #### `PORCENT_LICITADOR`

    - Determina el índice de participación de cada licitador. Considera el total de los siniestros, cuenta la cantidad de veces que aparece cada ente y transforma el valor a porcentual (cuenta / total * 100), modificando también el resultado a decimal y concatenando un símbolo % al final.

    - Ejemplo de uso:
```
SELECT
    licitador_nombre AS Licitador,
    repositor_ruedas.porcent_licitador(licitador_nombre) AS Participación
FROM
    licitadores
ORDER BY
	Participación DESC;
```

___
### PROCEDIMIENTOS:

1. #### `INGRESO_SINIESTRO`

    - Posibilita el ingreso de nuevos registros en la tabla 'siniestros', determinando validaciones con mensajes SQLSTATE '45000' para 5 de los 11 atributos.
    - Se determinan los campos a completar y finaliza con una query simple que muestra el último registro.
    - La idea es simplificar el proceso y posibilitar un nulo dentro del campo de nro de factura, ya que es FK pero no siempre se factura al mismo momento.
    
    - Ejemplo de uso:
```
CALL ingreso_siniestro(
    2003506792, 			-- siniestro_nro
    '2024-08-02 12:45:00', 	-- siniestro_fecha
    'AUCH',				 	-- siniestro_tipo
    4, 						-- cantidad_ruedas
    '30-50004946-0', 		-- seguro_cia
    167559,					-- poliza_nro
    2, 						-- licitador
    33,						-- vehiculo
    );
```
2. #### `AGREGAR_FACTURA`

    - Optimiza el ingreso de una nueva factura, ya que no sólo permite la inserción en la tabla 'facturas', sino que además considera el nro de siniestro al que corresponde, previamente cargado en su respectiva tabla y actualiza el campo de la tabla 'siniestros', es decir, pasa de estar en FC 'Pendiente' a llevar el nro de FC que estamos asignando.
    - Inicialmente valida que el siniestro exista y que tenga estado 'Pendiente' en FC, caso contrario devuelve un mensaje SQLSTATE '45000' como 'Siniestro inexistente'.
    - Agiliza el proceso ya que el valor en ID (PK) se concatena de forma automática, así como también se automatiza el valor del campo que determina el precio final de la factura.
    - Lo más importante es que además de actualizar el nro de FC en la tabla 'siniestros', actualiza los registros completos en la tabla link que existe entre ambas.
    - Por último, también devuelve una query simple que muestra la carga exitosa del registro.
    
    - Ejemplo de uso:
```
CALL agregar_factura(
    1258,      -- siniestro_id
    'FA',      -- factura_tipo
    3,         -- factura_pdv
    69050,     -- factura_nro
    60,        -- rueda_item
    220000,    -- rueda_precio
    2          -- rueda_cantidad
    );
```

___
### CÓMO CORRER MI CÓDIGO:

En la terminal, colocar los comandos:
- `make` _si te da un error de que no conexion al socket, volver al correr el comando `make`_
- `make clean-db` limpiar la base de datos
- `make test-db` para mirar los datos de cada tabla
- `make backup-db` para realizar un backup de mi base de datos
- `make access-db` para acceder a la base de datos

También está la posibilidad de ver el script con el código completo en el siguiente link: [click aquí](https://github.com/leodaviri/repositor_ruedas/blob/main/pre_entrega_02/Repositor_ruedas_Iriarte_Leonardo(v2).sql)
___
### VERSIONES PREVIAS:

[Pre entrega 01](https://github.com/leodaviri/repositor_ruedas/tree/main/pre_entrega_01)