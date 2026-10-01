-- Proyecto Capstone: Analisis de ventas de un e-commerce
-- Autor: Bruno Vera
-- Motor: PostgreSQL
-- Ejecutar este archivo dentro de la base de datos capstone_project.

-- El orden de borrado permite volver a ejecutar el script sin conflictos.
DROP VIEW IF EXISTS ventas_limpias;
DROP TABLE IF EXISTS detalle_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
    cliente_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE,
    ciudad VARCHAR(80) NOT NULL,
    fecha_registro DATE NOT NULL
);

CREATE TABLE categorias (
    categoria_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE productos (
    producto_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    categoria_id INTEGER NOT NULL REFERENCES categorias(categoria_id),
    nombre VARCHAR(100) NOT NULL,
    precio_lista NUMERIC(12, 2) NOT NULL CHECK (precio_lista > 0),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE pedidos (
    pedido_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(cliente_id),
    fecha_pedido DATE,
    fecha_carga DATE NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Completado', 'Pendiente', 'Cancelado'))
);

CREATE TABLE detalle_pedido (
    detalle_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pedido_id INTEGER NOT NULL REFERENCES pedidos(pedido_id),
    producto_id INTEGER NOT NULL REFERENCES productos(producto_id),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(12, 2) CHECK (precio_unitario > 0),
    descuento_porcentaje NUMERIC(5, 2)
        CHECK (descuento_porcentaje BETWEEN 0 AND 100),
    UNIQUE (pedido_id, producto_id)
);

INSERT INTO clientes (nombre, email, ciudad, fecha_registro) VALUES
('Ana Torres', 'ana.torres@email.com', 'Buenos Aires', '2025-11-10'),
('Lucas Gomez', 'lucas.gomez@email.com', 'Cordoba', '2025-11-18'),
('Sofia Martinez', 'sofia.martinez@email.com', 'Rosario', '2025-12-03'),
('Mateo Rodriguez', 'mateo.rodriguez@email.com', 'Mendoza', '2025-12-15'),
('Valentina Lopez', 'valentina.lopez@email.com', 'La Plata', '2026-01-05'),
('Tomas Fernandez', 'tomas.fernandez@email.com', 'Mar del Plata', '2026-01-13'),
('Camila Diaz', 'camila.diaz@email.com', 'Salta', '2026-02-02'),
('Joaquin Perez', 'joaquin.perez@email.com', 'Neuquen', '2026-02-11'),
('Martina Sanchez', 'martina.sanchez@email.com', 'Tucuman', '2026-03-01'),
('Franco Ruiz', 'franco.ruiz@email.com', 'Santa Fe', '2026-03-14'),
('Julieta Castro', 'julieta.castro@email.com', 'Buenos Aires', '2026-04-08'),
('Benjamin Romero', 'benjamin.romero@email.com', 'Cordoba', '2026-04-22');

INSERT INTO categorias (nombre) VALUES
('Tecnologia'),
('Hogar'),
('Fitness'),
('Accesorios');

INSERT INTO productos (categoria_id, nombre, precio_lista, activo) VALUES
(1, 'Notebook 14 pulgadas', 850000.00, TRUE),
(1, 'Monitor 24 pulgadas', 220000.00, TRUE),
(1, 'Teclado mecanico', 70000.00, TRUE),
(2, 'Freidora de aire', 160000.00, TRUE),
(2, 'Lampara de escritorio', 45000.00, TRUE),
(2, 'Termo de acero', 35000.00, TRUE),
(3, 'Mancuernas ajustables', 90000.00, TRUE),
(3, 'Colchoneta de yoga', 30000.00, TRUE),
(3, 'Bandas elasticas', 18000.00, TRUE),
(4, 'Mouse inalambrico', 28000.00, TRUE),
(4, 'Mochila urbana', 75000.00, TRUE),
(4, 'Auriculares bluetooth', 110000.00, TRUE);

-- fecha_carga conserva una referencia valida cuando la fecha original falta.
INSERT INTO pedidos (cliente_id, fecha_pedido, fecha_carga, estado) VALUES
(1,  '2026-01-05', '2026-01-05', 'Completado'),
(2,  '2026-01-12', '2026-01-12', 'Completado'),
(3,  '2026-01-20', '2026-01-20', 'Completado'),
(1,  '2026-02-03', '2026-02-03', 'Completado'),
(4,  '2026-02-10', '2026-02-10', 'Completado'),
(5,  '2026-02-18', '2026-02-18', 'Completado'),
(6,  '2026-02-25', '2026-02-25', 'Cancelado'),
(2,  '2026-03-02', '2026-03-02', 'Completado'),
(7,  '2026-03-07', '2026-03-07', 'Completado'),
(8,  '2026-03-15', '2026-03-15', 'Completado'),
(3,  '2026-03-21', '2026-03-21', 'Completado'),
(9,  '2026-03-30', '2026-03-30', 'Completado'),
(10, '2026-04-04', '2026-04-04', 'Completado'),
(1,  '2026-04-12', '2026-04-12', 'Completado'),
(11, '2026-04-20', '2026-04-20', 'Pendiente'),
(4,  '2026-04-27', '2026-04-27', 'Completado'),
(12, '2026-05-03', '2026-05-03', 'Completado'),
(5,  '2026-05-09', '2026-05-09', 'Completado'),
(6,  '2026-05-16', '2026-05-16', 'Completado'),
(2,  '2026-05-24', '2026-05-24', 'Completado'),
(7,  '2026-06-02', '2026-06-02', 'Completado'),
(8,  '2026-06-08', '2026-06-08', 'Completado'),
(9,  '2026-06-15', '2026-06-15', 'Completado'),
(10, '2026-06-22', '2026-06-22', 'Completado'),
(11, '2026-07-01', '2026-07-01', 'Completado'),
(12, '2026-07-07', '2026-07-07', 'Completado'),
(1,  '2026-07-15', '2026-07-15', 'Completado'),
(3,  '2026-07-22', '2026-07-22', 'Completado'),
(4,  NULL,         '2026-07-28', 'Completado'),
(5,  '2026-08-03', '2026-08-03', 'Completado');

-- Los NULL de precio y descuento son intencionales para demostrar limpieza.
-- Si falta precio_unitario se recupera el precio de lista del producto.
INSERT INTO detalle_pedido
    (pedido_id, producto_id, cantidad, precio_unitario, descuento_porcentaje)
VALUES
(1,  1, 1, 850000.00, 5.00),
(1, 10, 1,  28000.00, NULL),
(2,  2, 1, 220000.00, NULL),
(2,  3, 1,  70000.00, 10.00),
(3,  4, 1, 160000.00, NULL),
(3,  6, 2,  35000.00, NULL),
(4, 12, 2, 110000.00, 5.00),
(4, 11, 1,  75000.00, NULL),
(5,  7, 1,  90000.00, NULL),
(5,  8, 2,  30000.00, NULL),
(6,  5, 2,  45000.00, NULL),
(6,  6, 1,  35000.00, 5.00),
(7,  1, 1, 850000.00, NULL),
(8,  2, 1, 220000.00, 8.00),
(8, 10, 2,  28000.00, NULL),
(9,  9, 3,  18000.00, NULL),
(9,  8, 1,  30000.00, NULL),
(10, 4, 1, 160000.00, 10.00),
(10, 5, 1,  45000.00, NULL),
(11, 3, 2,  70000.00, NULL),
(11,12, 1, 110000.00, NULL),
(12,11, 1,  75000.00, NULL),
(12,10, 1,  28000.00, NULL),
(13, 1, 1, 825000.00, NULL),
(14, 4, 1, 160000.00, NULL),
(14, 6, 2,  35000.00, NULL),
(15, 7, 1,  90000.00, NULL),
(15, 9, 2,  18000.00, NULL),
(16, 2, 1, 220000.00, NULL),
(16,12, 1, 110000.00, 5.00),
(17, 8, 2,  30000.00, NULL),
(17, 9, 1,  18000.00, NULL),
(18, 4, 1, 160000.00, NULL),
(18,10, 1,  28000.00, NULL),
(19, 3, 1,  70000.00, NULL),
(19,11, 1,  75000.00, NULL),
(20, 1, 1, NULL,      3.00),
(20,10, 1,  28000.00, NULL),
(21, 7, 2,  90000.00, 10.00),
(21, 8, 1,  30000.00, NULL),
(22, 5, 3,  45000.00, NULL),
(22, 6, 1,  35000.00, NULL),
(23,12, 1, 110000.00, NULL),
(23,10, 2,  28000.00, NULL),
(24, 2, 1, 220000.00, 5.00),
(24, 3, 1,  70000.00, NULL),
(25,11, 1,  75000.00, NULL),
(25, 9, 2,  18000.00, NULL),
(26, 4, 1, 160000.00, NULL),
(26, 8, 2,  30000.00, NULL),
(27, 1, 1, 810000.00, NULL),
(27,12, 1, 110000.00, 10.00),
(28, 7, 1,  90000.00, NULL),
(28,10, 1,  28000.00, NULL),
(29, 5, 1, NULL,      NULL),
(29, 6, 2,  35000.00, NULL),
(30, 3, 1,  70000.00, NULL),
(30,11, 1,  75000.00, 5.00);

-- La vista mantiene intactos los datos originales y centraliza el criterio de
-- limpieza para que todas las consultas calculen ventas de la misma manera.
CREATE VIEW ventas_limpias AS
SELECT
    pe.pedido_id,
    pe.cliente_id,
    cl.nombre AS nombre_cliente,
    cl.ciudad,
    COALESCE(pe.fecha_pedido, pe.fecha_carga) AS fecha_pedido,
    pe.estado,
    pr.producto_id,
    pr.nombre AS producto,
    ca.nombre AS categoria,
    dp.cantidad,
    COALESCE(dp.precio_unitario, pr.precio_lista) AS precio_unitario,
    COALESCE(dp.descuento_porcentaje, 0) AS descuento_porcentaje,
    ROUND(
        dp.cantidad
        * COALESCE(dp.precio_unitario, pr.precio_lista)
        * (1 - COALESCE(dp.descuento_porcentaje, 0) / 100),
        2
    ) AS total_linea
FROM pedidos AS pe
JOIN clientes AS cl
    ON cl.cliente_id = pe.cliente_id
JOIN detalle_pedido AS dp
    ON dp.pedido_id = pe.pedido_id
JOIN productos AS pr
    ON pr.producto_id = dp.producto_id
JOIN categorias AS ca
    ON ca.categoria_id = pr.categoria_id;

-- Estos indices ayudan a las columnas utilizadas con frecuencia en JOIN.
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX idx_detalle_pedido ON detalle_pedido(pedido_id);
CREATE INDEX idx_detalle_producto ON detalle_pedido(producto_id);

