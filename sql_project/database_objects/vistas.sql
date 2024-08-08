USE repositor_ruedas;

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