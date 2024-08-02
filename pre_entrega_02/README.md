<center>
<img src="https://github.com/leodaviri/repositor_ruedas/blob/main/imagenes/image.jpg?raw=true" style="width: 100% ; aspect-ratio:12/6">
</center>

# ESTRUCTURA DE BASE DE DATOS PARA GRUPO CONCESIONARIO

**Alumno:** *[Iriarte Leonardo David](https://www.linkedin.com/in/leodaviri/)*

**Comisión:** #57190

**Profesor:** Anderson M. Torres

**Tutor**: Ariel Annone

**Lenguaje utilizado**: [SQL](https://dev.mysql.com/)

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
### COMO CORRER MI CÓDIGO:
 ```bash
    make
 ```
