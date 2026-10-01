# Proyecto Capstone - Analisis de ventas de un e-commerce

## Contexto

Este proyecto simula el trabajo de un analista de datos para un e-commerce
argentino. El negocio necesita entender quienes son sus clientes de mayor
valor, como evolucionan las ventas, que productos tienen menor rotacion y
cuales son los pedidos mas importantes dentro de cada categoria.

El objetivo es transformar datos transaccionales en informacion util para
decisiones de fidelizacion, inventario y estrategia comercial mediante
PostgreSQL.

## Modelo de datos

La base contiene cinco tablas relacionadas:

- `clientes`: datos de cada comprador.
- `categorias`: clasificacion de los productos.
- `productos`: catalogo y precio de lista.
- `pedidos`: fecha, cliente y estado de cada compra.
- `detalle_pedido`: productos, cantidades, precios y descuentos de cada pedido.

Relaciones principales:

- Un cliente puede realizar muchos pedidos.
- Un pedido puede incluir muchos productos.
- Un producto puede aparecer en muchos pedidos.
- Una categoria puede contener muchos productos.

La tabla `detalle_pedido` resuelve la relacion de muchos a muchos entre pedidos
y productos.

## Limpieza de datos

El dataset incluye faltantes intencionales para simular problemas reales. La
vista `ventas_limpias` conserva las tablas originales y aplica criterios
consistentes antes del analisis:

- Si falta `fecha_pedido`, se utiliza `fecha_carga`.
- Si falta `precio_unitario`, se recupera `precio_lista` del producto.
- Si falta el descuento, se interpreta como `0`.

Las columnas monetarias usan `NUMERIC` y las fechas usan `DATE`. El archivo
`analisis.sql` comienza con un control que cuenta los nulos originales.

## Preguntas de negocio

El analisis responde cinco preguntas:

1. Quienes son los cinco clientes con mayor gasto total.
2. Como evolucionan las ventas totales por mes.
3. Cuales son los tres productos menos vendidos.
4. Que posicion ocupa cada pedido dentro de su categoria mediante `RANK()`.
5. Como se segmentan los clientes segun su gasto mediante `CASE`.

## Hallazgos principales

- Los 28 pedidos completados generan una facturacion total de `$7.854.400`.
  Tecnologia aporta `$4.531.400`, aproximadamente el 57,7 % del total, por lo
  que el negocio depende especialmente de esta categoria.
- Ana Torres (`$2.258.500`), Lucas Gomez (`$1.393.900`) y Franco Ruiz
  (`$1.104.000`) son los tres clientes de mayor valor. Juntos concentran el
  60,56 % de la facturacion, lo que justifica una estrategia de fidelizacion.
- Julio es el mes de mayor facturacion, con `$1.473.000`. Agosto registra solo
  `$141.250`, pero contiene datos hasta el dia 3; por eso no debe compararse como
  si fuera un mes completo.
- Mancuernas ajustables, Monitor 24 pulgadas y Notebook 14 pulgadas empatan
  como los productos de menor rotacion, con 4 unidades cada uno. Sin embargo,
  la notebook genera `$3.267.000`: una baja cantidad de unidades no implica
  necesariamente baja importancia economica.
- La segmentacion identifica 3 clientes VIP, 4 frecuentes y 5 ocasionales. Los
  pedidos cancelados y pendientes se excluyen para no confundir operaciones
  iniciadas con ingresos efectivamente concretados.

## Archivos

- `estructura.sql`: crea tablas y relaciones, carga el dataset y genera la vista
  limpia.
- `analisis.sql`: contiene las cinco consultas comentadas.
- `README.md`: explica el problema, el modelo, la limpieza y las conclusiones.

## Como ejecutar el proyecto

1. Abrir pgAdmin 4 y conectarse al servidor PostgreSQL.
2. Crear una base de datos llamada `capstone_project`.
3. Abrir **Query Tool** sobre esa base.
4. Ejecutar todo el archivo `estructura.sql`.
5. Confirmar que aparecen las cinco tablas y la vista `ventas_limpias`.
6. Ejecutar `analisis.sql` consulta por consulta para revisar sus resultados.

El script de estructura puede volver a ejecutarse: al inicio elimina solamente
los objetos de este proyecto y los crea nuevamente en el orden correcto.

## Tecnologias y conceptos aplicados

- PostgreSQL y pgAdmin 4
- DDL: `CREATE TABLE`, claves primarias y claves foraneas
- DML: `INSERT`
- Limpieza: `COALESCE`
- Analisis: `JOIN`, `GROUP BY`, `SUM`, `COUNT`, `DATE_TRUNC`
- SQL avanzado: CTE, `RANK()` y `CASE`
