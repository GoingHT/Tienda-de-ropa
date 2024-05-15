CREATE DATABASE IF NOT EXISTS tienda_de_ropa;
USE tienda_de_ropa;

DROP TABLE IF EXISTS `clientes`;
CREATE TABLE `clientes` (
  `id_clientes` int NOT NULL,
  `nombre` varchar(30) DEFAULT NULL,
  `apellido` varchar(30) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `correo` varchar(150) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_clientes`)
);

INSERT INTO `clientes` VALUES (1,'Juan','Pérez','Calle Falsa 123','juan.perez@example.com','+34 123 456 789'),(2,'Ana','García','Avenida Siempre Viva 456','ana.garcia@example.com','+34 987 654 321'),(3,'Carlos','Rodríguez','Plaza Central 789','carlos.rodriguez@example.com','+34 555 555 555'),(4,'María','López','Río Grande 101','maria.lopez@example.com','+34 666 666 666'),(5,'Pedro','Martínez','Montaña Alta 202','pedro.martinez@example.com\'','+34 777 777 777');

DROP TABLE IF EXISTS `pedidos`;
CREATE TABLE `pedidos` (
  `id_pedidos` int NOT NULL,
  `id_cliente` varchar(45) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `total` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_pedidos`)
);

INSERT INTO `pedidos` VALUES (1,'1','2024-05-05','NO ENTREGADO','100'),(2,'1','2024-04-10','ENTREGADO','200'),(3,'3','2024-05-19','ENTREGADO','300'),(4,'5','2024-03-25','ENTREGADO','400'),(5,'5','2024-05-11','NO ENTREGADO','500'),(6,'2','2024-03-02','ENTREGADO','600'),(7,'2','2023-12-10','NO ENTREGADO','700'),(8,'3','2023-10-23','NO ENTREGADO','800'),(9,'4','2024-01-01','ENTREGADO','1000'),(10,'4','2024-02-16','ENTREGADO','1272'),(11,'4','2024-04-28','NO ENTREGADO','276');

DROP TABLE IF EXISTS `productos`;
CREATE TABLE `productos` (
  `id_productos` int NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `precio` varchar(30) DEFAULT NULL,
  `categoria` varchar(30) DEFAULT NULL,
  `stock` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_productos`)
);

INSERT INTO `productos` VALUES (1,'Camiseta Casual','Camiseta de algodón suave y ligera, perfecta para el día a día.','42.87177620000002','Camisetas','50'),(2,'Pantalones Chinos','Pantalones chinos de mezclilla con cremalleras, ideales para el trabajo o el fin de semana.','45','Pantalones','30'),(3,'Vestido de Verano','Vestido de verano corto con volantes, disponible en varios colores.','35','Vestidos','40'),(4,'Zapatillas Deportivas','Zapatillas deportivas de tela con soporte en talón, cómodas para caminar o correr.','25','Calzado','60'),(5,'Abrigo Ligero','Abrigo ligero de punto, ideal para protegerse del frío sin sentirse abrumado.','55','Abrigos','70');

DROP TABLE IF EXISTS `ventas`;
CREATE TABLE `ventas` (
  `id_ventas` int NOT NULL,
  `id_pedido` int DEFAULT NULL,
  `id_producto` int DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  `precio_de_venta` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_ventas`)
);

INSERT INTO `ventas` VALUES (1,1,1,2,20.00),(2,2,2,1,45.00),(3,3,3,3,35.00),(4,4,4,1,25.00),(5,5,5,2,55.00);

SELECT c.nombre, c.apellido, c.direccion, c.correo
FROM clientes AS c
JOIN pedidos AS p ON c.id_clientes = p.id_cliente
WHERE p.fecha >= CURDATE() - INTERVAL 30 DAY;

SELECT p.nombre, SUM(v.cantidad * v.precio_de_venta) AS Total_Vendido
FROM productos AS p
JOIN ventas AS v ON p.id_productos = v.id_producto
WHERE v.id_pedido IN (
    SELECT id_pedidos FROM pedidos WHERE fecha >= CURDATE() - INTERVAL 1 MONTH
)
GROUP BY p.nombre
ORDER BY Total_Vendido DESC;

SELECT c.nombre, COUNT(p.id_pedidos) AS Numero_Pedidos
FROM clientes AS c
JOIN pedidos AS p ON c.id_clientes = p.id_cliente
WHERE p.fecha >= CURDATE() - INTERVAL 1 YEAR
GROUP BY c.nombre
ORDER BY Numero_Pedidos DESC;

UPDATE productos
SET precio = precio * 0.10
WHERE categoria = 'Camisetas';

DELETE FROM pedidos
WHERE id_pedidos NOT IN (
    SELECT DISTINCT id_pedido FROM ventas
);

CREATE OR REPLACE VIEW vista_clientes_pedidos AS SELECT clientes.nombre, clientes.apellido, pedidos.fecha, pedidos.total FROM clientes INNER JOIN pedidos ON clientes.id_clientes = pedidos.id_cliente;
SELECT * FROM vista_clientes_pedidos
