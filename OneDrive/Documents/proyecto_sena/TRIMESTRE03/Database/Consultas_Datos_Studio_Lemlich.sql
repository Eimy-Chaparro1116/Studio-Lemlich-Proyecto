
USE StudioLemlichDB;
-- 1. VERIFICACIÓN DE DATOS DE PRUEBA
SELECT 'ROL' AS Tabla, COUNT(*) AS Total FROM ROL
UNION ALL SELECT 'ARTESANA', COUNT(*) FROM ARTESANA
UNION ALL SELECT 'USUARIO', COUNT(*) FROM USUARIO
UNION ALL SELECT 'CATEGORIA', COUNT(*) FROM CATEGORIA
UNION ALL SELECT 'PRODUCTO', COUNT(*) FROM PRODUCTO
UNION ALL SELECT 'VARIANTE_PRODUCTO', COUNT(*) FROM VARIANTE_PRODUCTO
UNION ALL SELECT 'DIRECCION', COUNT(*) FROM DIRECCION
UNION ALL SELECT 'PEDIDO', COUNT(*) FROM PEDIDO
UNION ALL SELECT 'DETALLE_PEDIDO', COUNT(*) FROM DETALLE_PEDIDO
UNION ALL SELECT 'ORDEN_SERVICIO', COUNT(*) FROM ORDEN_SERVICIO
UNION ALL SELECT 'TIPO_SERVICIO', COUNT(*) FROM TIPO_SERVICIO
UNION ALL SELECT 'PAGO', COUNT(*) FROM PAGO
UNION ALL SELECT 'Favoritos', COUNT(*) FROM Favoritos;


-- ============================================================
-- 2. CONSULTAS CON JOINS
-- ============================================================

-- 2.1 Productos con categoría y artesana
SELECT 
    p.idPRODUCTO,
    p.nombre_producto,
    p.precio_base,
    c.nombre AS categoria,
    a.nombre_completo AS artesana
FROM PRODUCTO p
INNER JOIN CATEGORIA c ON p.CATEGORIA_idCATEGORIA = c.idCATEGORIA
INNER JOIN ARTESANA a ON p.ARTESANA_idARTESANA = a.idARTESANA
ORDER BY p.nombre_producto;


-- 2.2 Variantes de producto con nombre y stock
SELECT 
    p.nombre_producto,
    v.talla,
    v.stock,
    p.precio_base
FROM VARIANTE_PRODUCTO v
INNER JOIN PRODUCTO p ON v.PRODUCTO_idPRODUCTO = p.idPRODUCTO
ORDER BY p.nombre_producto, v.talla;


-- 2.3 Pedidos con cliente (nombre + apellido) y dirección
SELECT 
    pe.idPEDIDO,
    pe.fecha_pedido,
    pe.estado,
    pe.subtotal,
    pe.costo_envio,
    (pe.subtotal + pe.costo_envio) AS total,
    CONCAT(u.nombre, ' ', u.apellido) AS cliente,
    u.email,
    d.calle,
    d.ciudad,
    d.barrio
FROM PEDIDO pe
INNER JOIN USUARIO u ON pe.USUARIO_idUSUARIO = u.idUSUARIO
INNER JOIN DIRECCION d ON pe.DIRECCION_idDIRECCION = d.idDIRECCION
ORDER BY pe.fecha_pedido DESC;


-- 2.4 Detalle completo de pedidos
SELECT 
    pe.idPEDIDO,
    CONCAT(u.nombre, ' ', u.apellido) AS cliente,
    p.nombre_producto,
    v.talla,
    dp.cantidad,
    dp.precio_unitario,
    (dp.cantidad * dp.precio_unitario) AS subtotal_linea
FROM DETALLE_PEDIDO dp
INNER JOIN PEDIDO pe ON dp.PEDIDO_idPEDIDO = pe.idPEDIDO
INNER JOIN USUARIO u ON pe.USUARIO_idUSUARIO = u.idUSUARIO
INNER JOIN VARIANTE_PRODUCTO v ON dp.VARIANTE_PRODUCTO_idVARIANTE_PRODUCTO = v.idVARIANTE_PRODUCTO
INNER JOIN PRODUCTO p ON v.PRODUCTO_idPRODUCTO = p.idPRODUCTO
ORDER BY pe.idPEDIDO;


-- 2.5 Favoritos con nombre del cliente y del producto
SELECT 
    CONCAT(u.nombre, ' ', u.apellido) AS cliente,
    p.nombre_producto,
    p.precio_base,
    f.fecha_agregado
FROM Favoritos f
INNER JOIN USUARIO u ON f.USUARIO_idUSUARIO = u.idUSUARIO
INNER JOIN PRODUCTO p ON f.PRODUCTO_idPRODUCTO = p.idPRODUCTO
ORDER BY u.apellido, f.fecha_agregado;


-- 2.6 Órdenes de servicio con tipo de servicio y cliente
SELECT 
    os.idORDEN_SERVICIO,
    os.descripcion_prenda,
    os.fecha_solicitud,
    os.fecha_entrega_pactada,
    os.estado,
    CONCAT(u.nombre, ' ', u.apellido) AS cliente,
    ts.nombre_servicio,
    ts.precio_base AS precio_servicio
FROM ORDEN_SERVICIO os
INNER JOIN USUARIO u ON os.USUARIO_idUSUARIO = u.idUSUARIO
INNER JOIN TIPO_SERVICIO ts ON os.idORDEN_SERVICIO = ts.ORDEN_SERVICIO_idORDEN_SERVICIO;


-- ============================================================
-- 3. SUBCONSULTAS
-- ============================================================

-- 3.1 Productos con precio superior al promedio
SELECT 
    nombre_producto,
    precio_base
FROM PRODUCTO
WHERE precio_base > (SELECT AVG(precio_base) FROM PRODUCTO)
ORDER BY precio_base DESC;


-- 3.2 Clientes que han realizado más de 1 pedido
SELECT 
    u.idUSUARIO,
    CONCAT(u.nombre, ' ', u.apellido) AS cliente,
    u.email
FROM USUARIO u
WHERE u.idUSUARIO IN (
    SELECT USUARIO_idUSUARIO
    FROM PEDIDO
    GROUP BY USUARIO_idUSUARIO
    HAVING COUNT(*) > 1
);


-- 3.3 Productos que nunca han sido agregados a favoritos
SELECT 
    p.idPRODUCTO,
    p.nombre_producto,
    p.precio_base
FROM PRODUCTO p
WHERE p.idPRODUCTO NOT IN (
    SELECT PRODUCTO_idPRODUCTO FROM Favoritos
);


-- 3.4 Artesanas cuyo stock total de productos supera las 10 unidades
SELECT 
    a.nombre_completo,
    a.biografia_corta
FROM ARTESANA a
WHERE a.idARTESANA IN (
    SELECT p.ARTESANA_idARTESANA
    FROM PRODUCTO p
    INNER JOIN VARIANTE_PRODUCTO v ON p.idPRODUCTO = v.PRODUCTO_idPRODUCTO
    GROUP BY p.ARTESANA_idARTESANA
    HAVING SUM(v.stock) > 10
);


-- ============================================================
-- 4. AGREGACIONES (GROUP BY)
-- ============================================================

-- 4.1 Ventas totales por artesana
SELECT 
    a.nombre_completo AS artesana,
    COUNT(dp.idDETALLE_PEDIDO) AS lineas_vendidas,
    SUM(dp.cantidad) AS unidades_vendidas,
    SUM(dp.cantidad * dp.precio_unitario) AS total_vendido
FROM DETALLE_PEDIDO dp
INNER JOIN VARIANTE_PRODUCTO v ON dp.VARIANTE_PRODUCTO_idVARIANTE_PRODUCTO = v.idVARIANTE_PRODUCTO
INNER JOIN PRODUCTO p ON v.PRODUCTO_idPRODUCTO = p.idPRODUCTO
INNER JOIN ARTESANA a ON p.ARTESANA_idARTESANA = a.idARTESANA
GROUP BY a.idARTESANA, a.nombre_completo
ORDER BY total_vendido DESC;


-- 4.2 Productos más vendidos
SELECT 
    p.nombre_producto,
    SUM(dp.cantidad) AS unidades_vendidas,
    SUM(dp.cantidad * dp.precio_unitario) AS ingresos
FROM DETALLE_PEDIDO dp
INNER JOIN VARIANTE_PRODUCTO v ON dp.VARIANTE_PRODUCTO_idVARIANTE_PRODUCTO = v.idVARIANTE_PRODUCTO
INNER JOIN PRODUCTO p ON v.PRODUCTO_idPRODUCTO = p.idPRODUCTO
GROUP BY p.idPRODUCTO, p.nombre_producto
ORDER BY unidades_vendidas DESC;


-- 4.3 Resumen de pedidos por estado
SELECT 
    estado,
    COUNT(*) AS cantidad_pedidos,
    SUM(subtotal + costo_envio) AS monto_total
FROM PEDIDO
GROUP BY estado
ORDER BY cantidad_pedidos DESC;


-- 4.4 Métodos de pago más utilizados (solo completados)
SELECT 
    metodo_pago,
    COUNT(*) AS transacciones,
    SUM(monto) AS total_cobrado
FROM PAGO
WHERE estado = 'Completado'
GROUP BY metodo_pago
ORDER BY total_cobrado DESC;


-- 4.5 Stock disponible por categoría
SELECT 
    c.nombre AS categoria,
    SUM(v.stock) AS stock_total
FROM CATEGORIA c
INNER JOIN PRODUCTO p ON c.idCATEGORIA = p.CATEGORIA_idCATEGORIA
INNER JOIN VARIANTE_PRODUCTO v ON p.idPRODUCTO = v.PRODUCTO_idPRODUCTO
GROUP BY c.idCATEGORIA, c.nombre
ORDER BY stock_total DESC;


-- ============================================================
-- 5. CONSULTAS MIXTAS (JOIN + SUBCONSULTA + HAVING)
-- ============================================================

-- 5.1 Clientes que han gastado más que el promedio
SELECT 
    CONCAT(u.nombre, ' ', u.apellido) AS cliente,
    SUM(pe.subtotal + pe.costo_envio) AS total_gastado
FROM USUARIO u
INNER JOIN PEDIDO pe ON u.idUSUARIO = pe.USUARIO_idUSUARIO
GROUP BY u.idUSUARIO, u.nombre, u.apellido
HAVING SUM(pe.subtotal + pe.costo_envio) > (
    SELECT AVG(total_cliente)
    FROM (
        SELECT SUM(subtotal + costo_envio) AS total_cliente
        FROM PEDIDO
        GROUP BY USUARIO_idUSUARIO
    ) AS promedios
)
ORDER BY total_gastado DESC;


-- 5.2 Productos que están en favoritos y también han sido comprados
SELECT DISTINCT
    p.nombre_producto,
    p.precio_base,
    a.nombre_completo AS artesana
FROM PRODUCTO p
INNER JOIN Favoritos f ON p.idPRODUCTO = f.PRODUCTO_idPRODUCTO
INNER JOIN ARTESANA a ON p.ARTESANA_idARTESANA = a.idARTESANA
WHERE p.idPRODUCTO IN (
    SELECT v.PRODUCTO_idPRODUCTO
    FROM DETALLE_PEDIDO dp
    INNER JOIN VARIANTE_PRODUCTO v ON dp.VARIANTE_PRODUCTO_idVARIANTE_PRODUCTO = v.idVARIANTE_PRODUCTO
);


-- ============================================================
-- 6. SENTENCIAS DML ADICIONALES (UPDATE / ejemplos prácticos)
-- ============================================================

-- 6.1 Actualizar stock después de una venta
UPDATE VARIANTE_PRODUCTO 
SET stock = stock - 1 
WHERE idVARIANTE_PRODUCTO = 2;


-- 6.2 Cambiar estado de un pedido
UPDATE PEDIDO 
SET estado = 'Enviado' 
WHERE idPEDIDO = 4;


-- 6.3 Desactivar un usuario (soft delete)
UPDATE USUARIO 
SET activo = 'Inactivo' 
WHERE idUSUARIO = 6;


-- 6.4 Actualizar precio de un producto
UPDATE PRODUCTO 
SET precio_base = 185000 
WHERE idPRODUCTO = 1;


-- 6.5 Marcar un pago como completado
UPDATE PAGO 
SET estado = 'Completado' 
WHERE idPAGO = 4;





