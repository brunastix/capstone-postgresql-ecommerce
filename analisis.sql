-- Proyecto Capstone: Analisis de ventas de un e-commerce
-- Ejecutar despues de estructura.sql dentro de capstone_project.

-- 0. CONTROL DE CALIDAD
-- Medimos los faltantes antes del analisis para demostrar que la limpieza
-- responde a problemas reales del dataset y no altera silenciosamente el origen.
SELECT
    (SELECT COUNT(*) FROM pedidos WHERE fecha_pedido IS NULL)
        AS fechas_faltantes,
    (SELECT COUNT(*) FROM detalle_pedido WHERE precio_unitario IS NULL)
        AS precios_faltantes,
    (SELECT COUNT(*) FROM detalle_pedido WHERE descuento_porcentaje IS NULL)
        AS descuentos_faltantes;

-- La vista ventas_limpias usa COALESCE con estas reglas:
-- 1) fecha_pedido faltante -> fecha_carga;
-- 2) precio_unitario faltante -> precio_lista del producto;
-- 3) descuento faltante -> 0.

-- 1. TOP 5 CLIENTES POR GASTO TOTAL
-- Identificamos a los clientes de mayor valor para priorizar acciones de
-- fidelizacion. Solo contamos pedidos completados porque representan ingresos.
SELECT
    c.cliente_id,
    c.nombre,
    c.ciudad,
    ROUND(SUM(v.total_linea), 2) AS gasto_total,
    COUNT(DISTINCT v.pedido_id) AS pedidos_completados
FROM clientes AS c
JOIN ventas_limpias AS v
    ON v.cliente_id = c.cliente_id
WHERE v.estado = 'Completado'
GROUP BY c.cliente_id, c.nombre, c.ciudad
ORDER BY gasto_total DESC
LIMIT 5;

-- 2. VENTAS TOTALES POR MES
-- La evolucion mensual permite detectar picos de facturacion y meses que
-- necesitan nuevas acciones comerciales.
SELECT
    DATE_TRUNC('month', fecha_pedido)::DATE AS mes,
    ROUND(SUM(total_linea), 2) AS ventas_totales,
    COUNT(DISTINCT pedido_id) AS cantidad_pedidos
FROM ventas_limpias
WHERE estado = 'Completado'
GROUP BY DATE_TRUNC('month', fecha_pedido)::DATE
ORDER BY mes;

-- 3. TRES PRODUCTOS MENOS VENDIDOS
-- Incluimos tambien productos con cero ventas para evitar ocultar articulos
-- sin rotacion, que son los que mas necesitan una decision de inventario.
SELECT
    p.producto_id,
    p.nombre AS producto,
    COALESCE(SUM(v.cantidad), 0) AS unidades_vendidas,
    ROUND(COALESCE(SUM(v.total_linea), 0), 2) AS facturacion
FROM productos AS p
LEFT JOIN ventas_limpias AS v
    ON v.producto_id = p.producto_id
    AND v.estado = 'Completado'
GROUP BY p.producto_id, p.nombre
ORDER BY unidades_vendidas ASC, facturacion ASC
LIMIT 3;

-- 4. RANKING DE PEDIDOS DENTRO DE CADA CATEGORIA
-- El ranking compara cada pedido con otros de su misma categoria. RANK conserva
-- empates y permite localizar las compras de mayor valor por linea de negocio.
WITH total_por_pedido_categoria AS (
    SELECT
        categoria,
        pedido_id,
        ROUND(SUM(total_linea), 2) AS total_pedido_categoria
    FROM ventas_limpias
    WHERE estado = 'Completado'
    GROUP BY categoria, pedido_id
)
SELECT
    categoria,
    pedido_id,
    total_pedido_categoria,
    RANK() OVER (
        PARTITION BY categoria
        ORDER BY total_pedido_categoria DESC
    ) AS posicion_en_categoria
FROM total_por_pedido_categoria
ORDER BY categoria, posicion_en_categoria, pedido_id;

-- 5. SEGMENTACION DE CLIENTES (PREGUNTA ADICIONAL)
-- Traducimos el gasto acumulado a segmentos accionables. CASE permite que el
-- equipo comercial diferencie clientes VIP, frecuentes y ocasionales.
WITH gasto_por_cliente AS (
    SELECT
        c.cliente_id,
        c.nombre,
        ROUND(SUM(v.total_linea), 2) AS gasto_total
    FROM clientes AS c
    JOIN ventas_limpias AS v
        ON v.cliente_id = c.cliente_id
    WHERE v.estado = 'Completado'
    GROUP BY c.cliente_id, c.nombre
)
SELECT
    cliente_id,
    nombre,
    gasto_total,
    CASE
        WHEN gasto_total >= 1000000 THEN 'VIP'
        WHEN gasto_total >= 300000 THEN 'Frecuente'
        ELSE 'Ocasional'
    END AS segmento
FROM gasto_por_cliente
ORDER BY gasto_total DESC;

