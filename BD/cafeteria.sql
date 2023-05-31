-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 29-05-2023 a las 06:07:56
-- Versión del servidor: 8.0.31
-- Versión de PHP: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `cafeteria`
--

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `usp_actualizar`$$
CREATE  PROCEDURE `usp_actualizar` (IN `xnp` INT)   update detalle set id_ped=xnp where id_ped is null$$

DROP PROCEDURE IF EXISTS `usp_ActualizarDetalle`$$
CREATE  PROCEDURE `usp_ActualizarDetalle` (IN `xiddet` INT, IN `xidcafe` INT, IN `xcan` INT)   BEGIN
UPDATE detalle set can_dev = xcan where id_det= xiddet;
set @idcli = (select p.id_cliente from pedidos p inner join detalle d on p.id_ped = d.id_ped where d.id_det=xiddet);
set @can_cafe = (select can_cafe from detalle where id_det= xiddet);
set @tiempo = (SELECT TIMESTAMPDIFF(YEAR, fec_reg, CURDATE()) from clientes where id_cliente=@idcli);
if @tiempo>=4 THEN
DELETE from descuentos where id_cli = @idcli and id_cafe=xidcafe;
set @des = ((xcan/@can_cafe)*3/0.2);
insert into descuentos (id_cli, id_cafe, descuento, estado) values (@idcli, xidcafe, @des,'A');
end if;
END$$

DROP PROCEDURE IF EXISTS `usp_BuscarCliente`$$
CREATE  PROCEDURE `usp_BuscarCliente` (IN `xcli` INT)   select * from clientes where id_cliente=xcli$$

DROP PROCEDURE IF EXISTS `usp_BuscarDescuento`$$
CREATE  PROCEDURE `usp_BuscarDescuento` (IN `xidcli` INT, IN `xidcafe` INT)   select descuento from descuentos where id_cli = xidcli and id_cafe= xidcafe$$

DROP PROCEDURE IF EXISTS `usp_EliminarCafe`$$
CREATE  PROCEDURE `usp_EliminarCafe` (IN `xid` INT)   delete 
from cafes
where id_cafe = xid$$

DROP PROCEDURE IF EXISTS `usp_EliminarCliente`$$
CREATE  PROCEDURE `usp_EliminarCliente` (IN `xid` INT)   DELETE
FROM
clientes WHERE id_cliente = xid$$

DROP PROCEDURE IF EXISTS `usp_EliminarDetalle`$$
CREATE  PROCEDURE `usp_EliminarDetalle` (IN `xid` INT)   delete from detalle
where id_det = xid$$

DROP PROCEDURE IF EXISTS `usp_EliminarFoto`$$
CREATE  PROCEDURE `usp_EliminarFoto` (IN `xid` INT)   DELETE
FROM
fotos where id_foto = xid$$

DROP PROCEDURE IF EXISTS `usp_EliminarPedido`$$
CREATE  PROCEDURE `usp_EliminarPedido` (IN `xid` INT)   BEGIN
delete FROM pedidos where id_ped = xid;
END$$

DROP PROCEDURE IF EXISTS `usp_EliminarRecojo`$$
CREATE  PROCEDURE `usp_EliminarRecojo` (IN `xid` INT)   DELETE
from recojo where id_recojo=xid$$

DROP PROCEDURE IF EXISTS `usp_EliminarUsuario`$$
CREATE  PROCEDURE `usp_EliminarUsuario` (IN `xid` INT)   DELETE
FROM usuarios where id_usuario=xid$$

DROP PROCEDURE IF EXISTS `usp_IngresarCafe`$$
CREATE  PROCEDURE `usp_IngresarCafe` (IN `xnom` VARCHAR(35), IN `xdes` VARCHAR(40), IN `xpre` DECIMAL(7,2), IN `ximg` VARCHAR(45), IN `xest` CHAR(1))   insert into cafes (nom_cafe, des_cafe, pre_cafe, img_cafe, estado )values (xnom, xdes, xpre, ximg, 'A')$$

DROP PROCEDURE IF EXISTS `usp_ingresarCliente`$$
CREATE  PROCEDURE `usp_ingresarCliente` (IN `xtipo` CHAR(1), IN `xnro` VARCHAR(11), IN `xnom` VARCHAR(35), IN `xcorreo` VARCHAR(35), IN `xdir` VARCHAR(35), IN `xdis` INT(1), IN `xusu` VARCHAR(20), IN `xcon` VARCHAR(20), IN `xfec` VARCHAR(12), IN `xest` CHAR(1))   INSERT into clientes (tipo_cliente,nro_doc, nombre, correo, direccion, id_dis, nom_usuario,con_usuario, fec_reg, estado)
values (xtipo, xnro, xnom, xcorreo, xdir, xdis, xusu, xcon, xfec, xest)$$

DROP PROCEDURE IF EXISTS `usp_IngresarDetalle`$$
CREATE  PROCEDURE `usp_IngresarDetalle` (IN `xidcafe` INT, IN `xcan` INT, IN `xdescto` DECIMAL(7,2))   Begin
set @xpre= (select pre_cafe from cafes WHERE id_cafe = xidcafe);

set @ximp = (xcan * @xpre - (xcan * @xpre * xdescto/100));

INSERT into detalle (id_cafe, can_cafe, descto, imp_cafe) values (xidcafe, xcan, xdescto, @ximp);
END$$

DROP PROCEDURE IF EXISTS `usp_IngresarFoto`$$
CREATE  PROCEDURE `usp_IngresarFoto` (IN `xdes` VARCHAR(35), IN `xidcli` INT, IN `ximg` VARCHAR(40), IN `xfec` VARCHAR(12), IN `xest` CHAR(1))   insert into fotos (des_foto, id_cliente, img_foto, fec_foto, estado) values (xdes, xidcli, ximg, xfec, xest )$$

DROP PROCEDURE IF EXISTS `usp_IngresarPedido`$$
CREATE  PROCEDURE `usp_IngresarPedido` (IN `xidcli` INT, IN `xfec` DATE, IN `xtot` DECIMAL(7,2), IN `xest` CHAR(1))   BEGIN
set @total = (select sum(imp_cafe) from detalle where id_ped is null);
INSERT INTO pedidos (id_cliente, fec_ped, tot_ped, estado) values (xidcli, xfec, @total, xest);
select MAX(id_ped) as id from pedidos;
END$$

DROP PROCEDURE IF EXISTS `usp_IngresarRecojo`$$
CREATE  PROCEDURE `usp_IngresarRecojo` (IN `xidped` INT)   BEGIN
set @cafes = (select sum(can_dev) from pedidos p inner join detalle d on p.id_ped=d.id_ped where p.id_ped=xidped);
set @importe = (select sum(can_dev*imp_cafe/can_cafe) from detalle where id_ped=xidped);
insert into recojo (id_ped, fec_recojo, tot_cafes, tot_recojo, estado) values (xidped,CURDATE(),@cafes,@importe ,'A');
update pedidos set estado='R' where id_ped=xidped;
END$$

DROP PROCEDURE IF EXISTS `usp_IngresarUsuario`$$
CREATE  PROCEDURE `usp_IngresarUsuario` (IN `xdni` CHAR(8), IN `xnom` VARCHAR(35), IN `xcorreo` VARCHAR(45), IN `xusu` VARCHAR(20), IN `xcon` VARCHAR(20), IN `xidrol` INT, IN `xfec` DATE)   INSERT INTO usuarios(nro_doc, nombre, correo, nom_usuario, con_usuario, id_rol, fec_reg, estado) values (xdni, xnom, xcorreo, xusu, xcon, xidrol, xfec,'A')$$

DROP PROCEDURE IF EXISTS `usp_ListaCafes`$$
CREATE  PROCEDURE `usp_ListaCafes` ()   select p.id_cafe, p.nom_cafe,p.des_cafe, p.pre_cafe, p.img_cafe, p.estado
from cafes p$$

DROP PROCEDURE IF EXISTS `usp_ListaClientes`$$
CREATE  PROCEDURE `usp_ListaClientes` ()   SELECT c.id_cliente, c.tipo_cliente,c.nro_doc,c.nombre, c.correo, c.direccion, d.nom_dis, c.fec_reg,c.estado
from clientes c inner join distritos d on c.id_dis=d.id_dis$$

DROP PROCEDURE IF EXISTS `usp_ListaDetalles`$$
CREATE  PROCEDURE `usp_ListaDetalles` ()   SELECT d.id_det, p.nom_cafe, d.can_cafe, d.descto, d.imp_cafe
from detalle d inner join cafes p on d.id_cafe=p.id_cafe
WHERE id_ped is null$$

DROP PROCEDURE IF EXISTS `usp_ListaFotos`$$
CREATE  PROCEDURE `usp_ListaFotos` ()   SELECT f.id_foto, f.des_foto, c.nombre, f.fec_foto, f.estado
from fotos f inner join clientes c
on f.id_cliente=c.id_cliente$$

DROP PROCEDURE IF EXISTS `usp_ListaPedidoDetalles`$$
CREATE  PROCEDURE `usp_ListaPedidoDetalles` (IN `xidped` INT)   SELECT d.id_det,p.id_cafe, p.nom_cafe, d.can_cafe, d.descto, d.imp_cafe
from detalle d inner join cafes p on d.id_cafe=p.id_cafe
WHERE id_ped =xidped$$

DROP PROCEDURE IF EXISTS `usp_ListaPedidos`$$
CREATE  PROCEDURE `usp_ListaPedidos` ()   SELECT p.id_ped, p.fec_ped, c.nombre, p.tot_ped, p.estado
FROM pedidos p inner join clientes c on c.id_cliente=p.id_cliente ORDER by p.id_ped DESC$$

DROP PROCEDURE IF EXISTS `usp_ListaPedidosA`$$
CREATE  PROCEDURE `usp_ListaPedidosA` ()   SELECT p.id_ped, p.fec_ped, c.nombre, p.tot_ped, p.estado
FROM pedidos p inner join clientes c on c.id_cliente=p.id_cliente where p.estado='A' order by 1 DESC$$

DROP PROCEDURE IF EXISTS `usp_ListaRecojos`$$
CREATE  PROCEDURE `usp_ListaRecojos` ()   SELECT r.id_recojo, r.fec_recojo, p.id_ped, c.nombre, r.tot_cafes, r.tot_recojo, r.estado
FROM
recojo r inner join pedidos p on r.id_ped=p.id_ped
INNER JOIN clientes c on p.id_cliente=c.id_cliente$$

DROP PROCEDURE IF EXISTS `usp_ListaRoles`$$
CREATE  PROCEDURE `usp_ListaRoles` ()   SELECT id_rol, nom_rol 
FROM rol$$

DROP PROCEDURE IF EXISTS `usp_ListaUsuarios`$$
CREATE  PROCEDURE `usp_ListaUsuarios` ()  NO SQL SELECT u.id_usuario, u.nom_usuario, r.nom_rol, u.nombre, u.estado
FROM usuarios u inner join rol r on u.id_rol=r.id_rol
ORDER by u.nom_usuario$$

DROP PROCEDURE IF EXISTS `usp_ModificaCafe`$$
CREATE  PROCEDURE `usp_ModificaCafe` (IN `xid` INT, IN `xnom` VARCHAR(35), IN `xdes` VARCHAR(45), IN `xpre` DECIMAL(7,2), IN `ximg` VARCHAR(45), IN `xest` CHAR(1))   update cafes set nom_cafe=xnom, des_cafe=xdes, pre_cafe=xpre, img_cafe= ximg, estado=xest 
where id_cafe = xid$$

DROP PROCEDURE IF EXISTS `usp_ModificarUsuario`$$
CREATE  PROCEDURE `usp_ModificarUsuario` (IN `xid` INT, IN `xdni` CHAR(8), IN `xnom` VARCHAR(35), IN `xcorreo` VARCHAR(45), IN `xusu` VARCHAR(20), IN `xcon` VARCHAR(20), IN `xidrol` INT, IN `xfec` DATE, IN `xest` CHAR(1))   update usuarios set nro_doc=xdni, nombre=xnom, correo=xcorreo, nom_usuario= xusu, con_usuario= xcon, id_rol=xidrol, fec_reg=xfec, estado= xest
where id_usuario=xid$$

DROP PROCEDURE IF EXISTS `usp_validarLogin`$$
CREATE  PROCEDURE `usp_validarLogin` (IN `usu` VARCHAR(20), IN `con` VARCHAR(20))  NO SQL SELECT id_usuario, nom_usuario, con_usuario, id_rol
from usuarios
where nom_usuario=usu and con_usuario = con$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cafes`
--

DROP TABLE IF EXISTS `cafes`;
CREATE TABLE IF NOT EXISTS `cafes` (
  `id_cafe` int NOT NULL AUTO_INCREMENT,
  `nom_cafe` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `des_cafe` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `pre_cafe` decimal(7,2) NOT NULL,
  `img_cafe` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `estado` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  PRIMARY KEY (`id_cafe`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `cafes`
--

INSERT INTO `cafes` (`id_cafe`, `nom_cafe`, `des_cafe`, `pre_cafe`, `img_cafe`, `estado`) VALUES
(1, 'Cafe Expresso', 'Cafe negro solo de la mejor de calidad', '36.00', 'expresso.png', 'A'),
(2, 'Cafe Americano', 'Mezcla de agua y cafe de la mejor calidad', '32.00', 'americano.png', 'A'),
(3, 'Cafe Capuchino', 'Leche evaporada, leche normal y cafe', '40.00', 'capuchino.jpg', 'A'),
(4, 'Cafe Latte', 'Leche evaporada, leche normal y cafe', '38.00', 'latte.png', 'A'),
(5, 'Cafe Carajillo', 'Alcohol de su preferencia y cafe negro', '45.00', 'carajillo.jpg', 'A'),
(6, 'Cafe Moka', 'Caramelo, Leche evaporada, leche normal y cafe', '40.00', 'moka.jpg', 'A');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

DROP TABLE IF EXISTS `clientes`;
CREATE TABLE IF NOT EXISTS `clientes` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `tipo_cliente` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `nro_doc` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `nombre` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `correo` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `direccion` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `id_dis` int NOT NULL,
  `nom_usuario` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `con_usuario` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `fec_reg` date NOT NULL,
  `descto` decimal(7,2) NOT NULL,
  `estado` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  PRIMARY KEY (`id_cliente`),
  KEY `id_dis` (`id_dis`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `tipo_cliente`, `nro_doc`, `nombre`, `correo`, `direccion`, `id_dis`, `nom_usuario`, `con_usuario`, `fec_reg`, `descto`, `estado`) VALUES
(1, '1', '12345678901', 'Tienda Jaimitos', 'fabiola@gmail.com', 'Av. Los alamos 780', 1, 'rhuarcaya', '123', '2020-07-17', '0.00', 'A'),
(2, '1', '7889635214', 'Tienda El Chino', 'chino@yahoo.es', 'Av. Sucre 780 - Los Olivos', 1, 'chino', '1234', '2015-07-17', '0.00', 'A'),
(4, '1', '89876545676', 'Tienda Dianas', 'dianas@gmail.com', 'Jr. Loli 890 - Independencia', 1, 'floli', '123', '2010-07-17', '0.00', 'A'),
(5, '1', '09098767905', 'Miguel Angel', 'ma@gmail.com', 'jr arequpia 450', 1, 'mangel', '123', '2020-07-18', '0.00', 'A'),
(8, '2', '3', 'Arturo', 'artudd222@gmail.com', 'Mexico', 1, 'Arthur', '1212', '2023-05-29', '0.00', 'A');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descuentos`
--

DROP TABLE IF EXISTS `descuentos`;
CREATE TABLE IF NOT EXISTS `descuentos` (
  `id_des` int NOT NULL AUTO_INCREMENT,
  `id_cli` int NOT NULL,
  `id_cafe` int NOT NULL,
  `descuento` decimal(7,2) NOT NULL,
  `estado` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  PRIMARY KEY (`id_des`),
  KEY `id_cli` (`id_cli`),
  KEY `id_cafe` (`id_cafe`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `descuentos`
--

INSERT INTO `descuentos` (`id_des`, `id_cli`, `id_cafe`, `descuento`, `estado`) VALUES
(21, 4, 4, '0.52', 'A'),
(22, 2, 3, '1.20', 'A'),
(26, 2, 6, '4.50', 'A'),
(27, 2, 5, '14.55', 'A'),
(28, 4, 6, '3.75', 'A');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle`
--

DROP TABLE IF EXISTS `detalle`;
CREATE TABLE IF NOT EXISTS `detalle` (
  `id_det` int NOT NULL AUTO_INCREMENT,
  `id_ped` int DEFAULT NULL,
  `id_cafe` int NOT NULL,
  `can_cafe` int NOT NULL,
  `descto` decimal(7,2) DEFAULT NULL,
  `can_dev` int DEFAULT NULL,
  `imp_cafe` decimal(7,2) NOT NULL,
  PRIMARY KEY (`id_det`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `detalle`
--

INSERT INTO `detalle` (`id_det`, `id_ped`, `id_cafe`, `can_cafe`, `descto`, `can_dev`, `imp_cafe`) VALUES
(5, 80, 2, 100, '0.00', 5, '70.00'),
(6, 81, 5, 150, '0.00', 50, '150.00'),
(7, 82, 3, 180, '0.00', NULL, '144.00'),
(8, 83, 3, 100, '0.00', 20, '80.00'),
(9, 84, 2, 100, '0.00', 20, '70.00'),
(10, 85, 4, 150, '0.00', 13, '135.00'),
(18, 86, 3, 100, '0.00', 20, '80.00'),
(19, 87, 3, 1, '1.20', NULL, '0.79'),
(20, 88, 5, 100, '0.00', 20, '100.00'),
(21, 89, 5, 100, '3.00', 97, '97.00'),
(22, 89, 6, 10, '0.00', 3, '2.50'),
(23, 90, 6, 100, '0.00', 25, '25.00'),
(24, 91, 2, 100, '0.00', NULL, '70.00'),
(25, 91, 6, 50, '3.75', NULL, '12.03'),
(26, 91, 2, 1, '0.00', NULL, '0.70'),
(27, 92, 2, 100, '0.00', NULL, '70.00'),
(28, 92, 4, 100, '0.00', NULL, '90.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `distritos`
--

DROP TABLE IF EXISTS `distritos`;
CREATE TABLE IF NOT EXISTS `distritos` (
  `id_dis` int NOT NULL AUTO_INCREMENT,
  `nom_dis` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `cod_postal` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  PRIMARY KEY (`id_dis`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `distritos`
--

INSERT INTO `distritos` (`id_dis`, `nom_dis`, `cod_postal`) VALUES
(1, 'Cercado de Lima', '001'),
(2, 'La Victoria', '002'),
(3, 'Jesús María', '003'),
(4, 'Lince', '004'),
(5, 'Pueblo Libre', '006'),
(6, 'Surquillo', '007'),
(7, 'Miraflores', '010'),
(8, 'La Molina', '011');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fotos`
--

DROP TABLE IF EXISTS `fotos`;
CREATE TABLE IF NOT EXISTS `fotos` (
  `id_foto` int NOT NULL AUTO_INCREMENT,
  `des_foto` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `id_cliente` int NOT NULL,
  `img_foto` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `fec_foto` date NOT NULL,
  `estado` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  PRIMARY KEY (`id_foto`),
  KEY `id_cliente` (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `fotos`
--

INSERT INTO `fotos` (`id_foto`, `des_foto`, `id_cliente`, `img_foto`, `fec_foto`, `estado`) VALUES
(1, 'Productos bien ubicados', 1, 'varios-cafes.png', '2022-07-01', 'A'),
(2, 'Falta diseño de soporte', 1, 'aws-academy-educator.png', '2022-07-18', 'A'),
(12, 'Mostrador de la izquierda', 4, 'familia-Vasos.jpg.jpg', '2022-07-20', 'A');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
CREATE TABLE IF NOT EXISTS `pedidos` (
  `id_ped` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `fec_ped` date NOT NULL,
  `tot_ped` decimal(7,2) NOT NULL,
  `estado` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  PRIMARY KEY (`id_ped`),
  KEY `id_cliente` (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`id_ped`, `id_cliente`, `fec_ped`, `tot_ped`, `estado`) VALUES
(81, 5, '2022-07-28', '150.00', 'R'),
(84, 1, '2022-07-28', '70.00', 'R'),
(85, 4, '2022-07-28', '135.00', 'R'),
(92, 1, '2022-07-29', '160.00', 'A');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recojo`
--

DROP TABLE IF EXISTS `recojo`;
CREATE TABLE IF NOT EXISTS `recojo` (
  `id_recojo` int NOT NULL AUTO_INCREMENT,
  `fec_recojo` date NOT NULL,
  `id_ped` int NOT NULL,
  `tot_cafes` int DEFAULT NULL,
  `tot_recojo` decimal(7,2) NOT NULL,
  `estado` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  PRIMARY KEY (`id_recojo`),
  KEY `id_ped` (`id_ped`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `recojo`
--

INSERT INTO `recojo` (`id_recojo`, `fec_recojo`, `id_ped`, `tot_cafes`, `tot_recojo`, `estado`) VALUES
(13, '2022-07-27', 84, 20, '14.00', 'A'),
(14, '2022-07-27', 85, 13, '11.70', 'A');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

DROP TABLE IF EXISTS `rol`;
CREATE TABLE IF NOT EXISTS `rol` (
  `id_rol` int NOT NULL AUTO_INCREMENT,
  `nom_rol` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id_rol`, `nom_rol`) VALUES
(1, 'Administrador'),
(2, 'Supervisor'),
(3, 'Operador'),
(4, 'Subir fotos'),
(5, 'Público');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nro_doc` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `nombre` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `correo` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `nom_usuario` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `con_usuario` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `id_rol` int NOT NULL,
  `fec_reg` date NOT NULL,
  `estado` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  PRIMARY KEY (`id_usuario`),
  KEY `id_rol` (`id_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nro_doc`, `nombre`, `correo`, `nom_usuario`, `con_usuario`, `id_rol`, `fec_reg`, `estado`) VALUES
(2, '98745687', 'Admin', 'Admin@gmail.com', 'admin', 'admin', 1, '2021-06-25', 'A'),
(4, '12345678', 'Fotos', 'fabi888@hotmail.com', 'fotos', 'fotos', 4, '2022-07-21', 'A');

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD CONSTRAINT `clientes_ibfk_1` FOREIGN KEY (`id_dis`) REFERENCES `distritos` (`id_dis`);

--
-- Filtros para la tabla `descuentos`
--
ALTER TABLE `descuentos`
  ADD CONSTRAINT `descuentos_ibfk_1` FOREIGN KEY (`id_cli`) REFERENCES `clientes` (`id_cliente`),
  ADD CONSTRAINT `descuentos_ibfk_2` FOREIGN KEY (`id_cafe`) REFERENCES `cafes` (`id_cafe`);

--
-- Filtros para la tabla `fotos`
--
ALTER TABLE `fotos`
  ADD CONSTRAINT `fotos_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`);

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`);

--
-- Filtros para la tabla `recojo`
--
ALTER TABLE `recojo`
  ADD CONSTRAINT `recojo_ibfk_1` FOREIGN KEY (`id_ped`) REFERENCES `pedidos` (`id_ped`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
