-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: roundhouse.proxy.rlwy.net    Database: railway
-- ------------------------------------------------------
-- Server version	8.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Auditoria`
--

DROP TABLE IF EXISTS `Auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Auditoria` (
  `IdAuditoria` int NOT NULL AUTO_INCREMENT,
  `IdUsuario` int NOT NULL,
  `Fecha` datetime NOT NULL,
  `Tabla` varchar(45) NOT NULL,
  `Campo` varchar(45) NOT NULL,
  `Identificador` int NOT NULL,
  `ValorAnterior` varchar(45) NOT NULL,
  `ValorActual` varchar(45) NOT NULL,
  `Tipo` varchar(45) NOT NULL,
  `Pendiente` bit(1) NOT NULL,
  PRIMARY KEY (`IdAuditoria`),
  KEY `fk_Auditoria_Usuario1_idx` (`IdUsuario`),
  CONSTRAINT `fk_Auditoria_Usuario1` FOREIGN KEY (`IdUsuario`) REFERENCES `Usuario` (`IdUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Auditoria`
--

LOCK TABLES `Auditoria` WRITE;
/*!40000 ALTER TABLE `Auditoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `Auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AumentoPorProducto`
--

DROP TABLE IF EXISTS `AumentoPorProducto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AumentoPorProducto` (
  `IdAumentoPorProducto` int NOT NULL AUTO_INCREMENT,
  `IdProducto` int NOT NULL,
  `IdTipoAumento` int DEFAULT NULL,
  `PorcentajeExtra` decimal(18,2) DEFAULT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdAumentoPorProducto`),
  KEY `fk_AumentoPorProducto_Producto1_idx` (`IdProducto`),
  KEY `fk_AumentoPorProducto_TipoAumento1_idx` (`IdTipoAumento`),
  CONSTRAINT `fk_AumentoPorProducto_Producto1` FOREIGN KEY (`IdProducto`) REFERENCES `Producto` (`IdProducto`),
  CONSTRAINT `fk_AumentoPorProducto_TipoAumento1` FOREIGN KEY (`IdTipoAumento`) REFERENCES `TipoAumento` (`IdTipoAumento`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AumentoPorProducto`
--

LOCK TABLES `AumentoPorProducto` WRITE;
/*!40000 ALTER TABLE `AumentoPorProducto` DISABLE KEYS */;
INSERT INTO `AumentoPorProducto` VALUES (1,40,1,NULL,NULL),(2,40,2,NULL,NULL),(3,40,NULL,10.00,NULL);
/*!40000 ALTER TABLE `AumentoPorProducto` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `T_GeneradorPreciosAumento` AFTER INSERT ON `AumentoPorProducto` FOR EACH ROW BEGIN
    DECLARE precio_costo DECIMAL(18,2);
    DECLARE porcentaje_total DECIMAL(5,2);
    DECLARE precio_final DECIMAL(18,2);
  -- Actualizar GeneradorPrecios si el producto no está deshabilitado
  IF (SELECT FechaBaja FROM Producto WHERE IdProducto = NEW.IdProducto) IS NULL THEN
    -- Obtener PrecioCosto desde la tabla Producto
    SELECT PrecioCosto INTO precio_costo
    FROM Producto
    WHERE IdProducto = NEW.IdProducto;

    -- Calcular PorcentajeTotal sumando todos los porcentajes de los registros en AumentoPorProducto que coincidan con el mismo IdProducto,
    -- incluyendo el PorcentajeExtra
    SELECT IFNULL(SUM(TA.Porcentaje), 0) + IFNULL(SUM(AP.PorcentajeExtra), 0) INTO porcentaje_total
    FROM AumentoPorProducto AP
    LEFT JOIN TipoAumento TA ON AP.IdTipoAumento = TA.IdTipoAumento
    WHERE AP.IdProducto = NEW.IdProducto;

    -- Calcular PrecioFinal
    SET precio_final = precio_costo * (1 + porcentaje_total / 100);

    -- Insertar el nuevo registro en GeneradorPrecios
    INSERT INTO GeneradorPrecios (IdProducto, PrecioCosto, PorcentajeTotal, PrecioFinal, Fecha)
    VALUES (NEW.IdProducto, CAST(precio_costo AS CHAR), CAST(porcentaje_total AS CHAR), precio_final, NOW());
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `T_GeneradorPreciosAumentoUpd` AFTER UPDATE ON `AumentoPorProducto` FOR EACH ROW BEGIN
    DECLARE precio_costo DECIMAL(18,2);
    DECLARE porcentaje_total DECIMAL(5,2);
    DECLARE precio_final DECIMAL(18,2);
	IF NEW.FechaBaja IS NULL AND OLD.FechaBaja IS NULL THEN
		-- Obtener PrecioCosto desde la tabla Producto
		SELECT PrecioCosto INTO precio_costo
		FROM Producto
		WHERE IdProducto = NEW.IdProducto;

		-- Calcular PorcentajeTotal sumando todos los porcentajes de los registros en AumentoPorProducto que coincidan con el mismo IdProducto,
		-- incluyendo el PorcentajeExtra
		SELECT IFNULL(SUM(TA.Porcentaje), 0) + IFNULL(SUM(AP.PorcentajeExtra), 0) INTO porcentaje_total
		FROM AumentoPorProducto AP
		LEFT JOIN TipoAumento TA ON AP.IdTipoAumento = TA.IdTipoAumento
		WHERE AP.IdProducto = NEW.IdProducto;

		-- Calcular PrecioFinal
		SET precio_final = precio_costo * (1 + porcentaje_total / 100);

		-- Insertar el nuevo registro en GeneradorPrecios
		INSERT INTO GeneradorPrecios (IdProducto, PrecioCosto, PorcentajeTotal, PrecioFinal, Fecha)
		VALUES (NEW.IdProducto, CAST(precio_costo AS CHAR), CAST(porcentaje_total AS CHAR), precio_final, NOW());
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `DetalleFactura`
--

DROP TABLE IF EXISTS `DetalleFactura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DetalleFactura` (
  `IdDetalleFactura` int NOT NULL AUTO_INCREMENT,
  `IdFacturas` int NOT NULL,
  `IdTipoFormaDePago` int NOT NULL,
  `SubTotal` decimal(18,2) NOT NULL,
  `Total` decimal(18,2) NOT NULL,
  `DescVenta` decimal(18,2) NOT NULL,
  `Pago` decimal(18,2) NOT NULL,
  `Vuelto` decimal(18,2) NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdDetalleFactura`),
  KEY `fk_DetalleFactura_Facturas1_idx` (`IdFacturas`) /*!80000 INVISIBLE */,
  KEY `fk_DetalleFactura_TipoFormaDePago1_idx` (`IdTipoFormaDePago`),
  CONSTRAINT `fk_DetalleFactura_Facturas1` FOREIGN KEY (`IdFacturas`) REFERENCES `Factura` (`IdFactura`),
  CONSTRAINT `fk_DetalleFactura_TipoFormaDePago1` FOREIGN KEY (`IdTipoFormaDePago`) REFERENCES `TipoFormaDePago` (`IdTipoFormaDePago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DetalleFactura`
--

LOCK TABLES `DetalleFactura` WRITE;
/*!40000 ALTER TABLE `DetalleFactura` DISABLE KEYS */;
/*!40000 ALTER TABLE `DetalleFactura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Domicilio`
--

DROP TABLE IF EXISTS `Domicilio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Domicilio` (
  `IdDomicilio` int NOT NULL AUTO_INCREMENT,
  `IdTipoDomicilio` int NOT NULL,
  `Calle` varchar(45) NOT NULL,
  `Nro` varchar(45) DEFAULT NULL,
  `Piso` varchar(45) DEFAULT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdDomicilio`),
  KEY `fk_Domicilio_TipoDomicilio1_idx` (`IdTipoDomicilio`),
  CONSTRAINT `fk_Domicilio_TipoDomicilio1` FOREIGN KEY (`IdTipoDomicilio`) REFERENCES `TipoDomicilio` (`IdTipoDomicilio`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Domicilio`
--

LOCK TABLES `Domicilio` WRITE;
/*!40000 ALTER TABLE `Domicilio` DISABLE KEYS */;
INSERT INTO `Domicilio` VALUES (1,2,'Avenida Gutnisky','4774','0',NULL),(2,1,'Eva Peron','1200','0','2024-05-22 19:30:51'),(3,1,'Avenida Nestor Kirchner','4221333333','0',NULL),(4,1,'Avenida Gutnisky','4774','0',NULL),(5,1,'Calle San Martín','123','1',NULL),(6,2,'Calle Belgrano','456','2',NULL),(8,2,'Calle España','101','4',NULL),(11,1,'Calle Alberdi','415','7',NULL),(12,2,'Calle Saavedra','161','8',NULL),(13,1,'Calle 9 de Julio','718','9',NULL),(14,2,'Calle 25 de Mayo','192','10',NULL),(15,1,'Calle Sarmiento','202','11',NULL),(16,2,'Calle Mitre','232','12',NULL),(17,1,'Calle Urquiza','242','13',NULL),(18,2,'Calle Güemes','252','14',NULL),(19,1,'Calle Lavalle','262','15',NULL),(20,2,'Calle Bolívar','272','16',NULL),(21,1,'Calle Tucumán','282','17',NULL),(22,2,'Calle Salta','292','18',NULL),(23,1,'Calle Córdoba','303','19',NULL),(24,2,'Calle Entre Ríos','313','20',NULL),(25,1,'Calle Corrientes','323','21',NULL),(26,2,'Calle Catamarca','333','22',NULL),(27,1,'Calle Mendoza','343','23',NULL),(28,2,'Calle San Juan','353','24',NULL),(29,1,'Calle Jujuy','363','25',NULL),(30,2,'Calle La Rioja','373','26',NULL),(31,1,'Calle Santiago del Estero','383','27',NULL),(32,2,'Calle Chaco','393','28',NULL),(33,1,'Calle Formosa','404','29',NULL),(34,2,'Calle Misiones','414','30',NULL),(35,1,'Calle Neuquén','424','31',NULL),(36,2,'Calle Río Negro','434','32',NULL),(37,1,'Calle Chubut','444','33',NULL),(38,2,'Calle Santa Cruz','454','34',NULL),(39,1,'Calle Tierra del Fuego','464','35',NULL),(40,2,'Calle Buenos Aires','474','36',NULL),(41,1,'Calle La Pampa','484','37',NULL),(42,2,'Calle San Luis','494','38',NULL),(43,1,'Calle Santa Fe','505','39',NULL),(44,2,'Calle Córdoba','515','40',NULL),(45,1,'Calle Mendoza','525','41',NULL),(46,2,'Calle San Juan','535','42',NULL),(47,1,'Calle Jujuy','545','43','2024-06-11 15:02:33'),(48,2,'Calle La Rioja','555','44',NULL),(49,1,'Calle Santiago del Estero','565','45',NULL),(50,2,'Calle Chaco','575','46',NULL),(51,1,'Calle Formosa','585','47',NULL),(52,2,'Calle Misiones','595','48',NULL),(53,1,'Calle Neuquén','606','49',NULL);
/*!40000 ALTER TABLE `Domicilio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Factura`
--

DROP TABLE IF EXISTS `Factura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Factura` (
  `IdFactura` int NOT NULL AUTO_INCREMENT,
  `IdTipoDestinatarioFactura` int NOT NULL,
  `IdTipoFactura` int NOT NULL,
  `IdFormaDePago` int NOT NULL,
  `FechaEmision` datetime NOT NULL,
  PRIMARY KEY (`IdFactura`),
  KEY `fk_Facturas_TipoFactura1_idx` (`IdTipoFactura`),
  KEY `fk_Facturas_TipoDestinatarioFactura1_idx` (`IdTipoDestinatarioFactura`),
  KEY `fk_Facturas_FormaDePago1_idx` (`IdFormaDePago`),
  CONSTRAINT `fk_Facturas_FormaDePago1` FOREIGN KEY (`IdFormaDePago`) REFERENCES `TipoFormaDePago` (`IdTipoFormaDePago`),
  CONSTRAINT `fk_Facturas_TipoDestinatarioFactura1` FOREIGN KEY (`IdTipoDestinatarioFactura`) REFERENCES `TipoDestinatarioFactura` (`IdTipoDestinatarioFactura`),
  CONSTRAINT `fk_Facturas_TipoFactura1` FOREIGN KEY (`IdTipoFactura`) REFERENCES `TipoFactura` (`IdTipoFactura`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Factura`
--

LOCK TABLES `Factura` WRITE;
/*!40000 ALTER TABLE `Factura` DISABLE KEYS */;
/*!40000 ALTER TABLE `Factura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GastosProtocolares`
--

DROP TABLE IF EXISTS `GastosProtocolares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GastosProtocolares` (
  `IdGastosProtocolares` int NOT NULL AUTO_INCREMENT,
  `IdUsuarioCarga` int NOT NULL,
  `IdSucursal` int NOT NULL,
  `Descripcion` varchar(45) NOT NULL,
  `Monto` decimal(18,2) NOT NULL,
  PRIMARY KEY (`IdGastosProtocolares`),
  KEY `fk_GastosProtocolares_Usuario1_idx` (`IdUsuarioCarga`),
  KEY `fk_GastosProtocolares_Sucursal1_idx` (`IdSucursal`),
  CONSTRAINT `fk_GastosProtocolares_Sucursal1` FOREIGN KEY (`IdSucursal`) REFERENCES `Sucursal` (`IdSucursal`),
  CONSTRAINT `fk_GastosProtocolares_Usuario1` FOREIGN KEY (`IdUsuarioCarga`) REFERENCES `Usuario` (`IdUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GastosProtocolares`
--

LOCK TABLES `GastosProtocolares` WRITE;
/*!40000 ALTER TABLE `GastosProtocolares` DISABLE KEYS */;
/*!40000 ALTER TABLE `GastosProtocolares` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GeneradorPrecios`
--

DROP TABLE IF EXISTS `GeneradorPrecios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GeneradorPrecios` (
  `IdGeneradorPrecios` int NOT NULL AUTO_INCREMENT,
  `IdProducto` int NOT NULL,
  `PrecioCosto` decimal(18,2) NOT NULL,
  `PorcentajeTotal` varchar(45) NOT NULL,
  `PrecioFinal` decimal(18,2) NOT NULL,
  `Fecha` datetime NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdGeneradorPrecios`),
  KEY `fk_GeneradorPrecios_AumentoPorProducto1_idx` (`IdProducto`),
  CONSTRAINT `fk_GeneradorPrecios_AumentoPorProducto1` FOREIGN KEY (`IdProducto`) REFERENCES `Producto` (`IdProducto`)
) ENGINE=InnoDB AUTO_INCREMENT=312 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GeneradorPrecios`
--

LOCK TABLES `GeneradorPrecios` WRITE;
/*!40000 ALTER TABLE `GeneradorPrecios` DISABLE KEYS */;
INSERT INTO `GeneradorPrecios` VALUES (201,41,24446.40,'0.00',24446.40,'2024-06-11 18:33:30',NULL),(202,46,491.40,'21.00',594.59,'2024-06-11 18:33:30',NULL),(203,6,2007.72,'0.00',2007.72,'2024-06-11 18:33:30',NULL),(253,46,648.65,'36.00',882.16,'2024-06-11 19:36:54',NULL),(254,46,648.65,'36.00',882.16,'2024-06-11 19:36:54',NULL),(255,48,100.00,'0.00',100.00,'2024-06-11 23:58:02',NULL),(256,46,648.65,'39.00',901.62,'2024-06-12 20:40:13',NULL),(257,46,648.65,'29.00',836.76,'2024-06-12 20:40:13',NULL),(258,46,648.65,'44.00',934.06,'2024-06-12 20:40:40',NULL),(259,41,24446.40,'21.00',29580.14,'2024-06-12 20:41:53',NULL),(260,41,24446.40,'24.00',30313.54,'2024-06-12 20:41:53',NULL),(261,41,24446.40,'34.00',32758.18,'2024-06-12 20:41:53',NULL),(262,10,220.00,'30.00',286.00,'2024-06-12 21:02:19',NULL),(263,46,713.52,'44.00',1027.47,'2024-06-12 21:10:26',NULL),(264,40,605.83,'21.00',733.05,'2024-06-12 21:28:52',NULL),(265,40,605.83,'24.00',751.23,'2024-06-12 21:28:52',NULL),(266,40,605.83,'36.00',823.93,'2024-06-12 21:28:52',NULL),(267,46,784.87,'44.00',1130.21,'2024-06-12 22:44:37',NULL),(268,48,110.00,'0.00',110.00,'2024-06-12 22:44:37',NULL),(269,48,110.00,'21.00',133.10,'2024-06-12 22:48:56',NULL),(270,48,110.00,'24.00',136.40,'2024-06-12 22:48:56',NULL),(271,46,784.87,'21.00',949.69,'2024-06-12 22:56:15',NULL),(272,46,784.87,'0.00',784.87,'2024-06-12 22:57:01',NULL),(273,49,200.00,'0.00',200.00,'2024-06-12 23:29:27',NULL),(274,49,300.00,'0.00',300.00,'2024-06-12 23:30:06',NULL),(275,49,300.00,'21.00',363.00,'2024-06-12 23:30:30',NULL),(276,49,300.00,'26.00',378.00,'2024-06-12 23:30:30',NULL),(277,49,300.00,'36.00',408.00,'2024-06-12 23:30:30',NULL),(278,48,121.00,'24.00',150.04,'2024-06-12 23:33:41',NULL),(279,46,863.36,'0.00',863.36,'2024-06-12 23:33:41',NULL),(280,49,330.00,'36.00',448.80,'2024-06-12 23:34:07',NULL),(281,46,949.70,'0.00',949.70,'2024-06-13 14:17:40',NULL),(282,46,1139.64,'0.00',1139.64,'2024-06-13 14:30:23',NULL),(283,46,1151.04,'0.00',1151.04,'2024-06-13 15:11:53',NULL),(284,40,666.41,'36.00',906.32,'2024-06-13 15:12:20',NULL),(285,48,133.10,'24.00',165.04,'2024-06-13 15:12:20',NULL),(286,42,880.00,'0.00',880.00,'2024-06-13 17:22:42',NULL),(287,48,266.20,'24.00',330.09,'2024-06-13 17:25:37',NULL),(288,40,1332.82,'36.00',1812.64,'2024-06-13 17:25:37',NULL),(289,40,1332.82,'26.00',1679.35,'2024-06-13 17:31:26',NULL),(290,40,1332.82,'21.00',1612.71,'2024-06-13 17:38:26',NULL),(291,40,1332.82,'24.00',1652.70,'2024-06-13 17:38:26',NULL),(292,40,1332.82,'34.00',1785.98,'2024-06-13 17:38:26',NULL),(293,48,532.40,'0.00',532.40,'2024-06-13 17:40:21',NULL),(294,42,1760.00,'0.00',1760.00,'2024-06-13 17:40:21',NULL),(297,4,585.00,'0.00',585.00,'2024-06-13 17:55:24',NULL),(298,10,220.00,'0.00',220.00,'2024-06-13 18:03:20',NULL),(299,21,100.50,'0.00',100.50,'2024-06-13 18:03:21',NULL),(300,22,150.75,'0.00',150.75,'2024-06-13 18:03:22',NULL),(301,23,200.00,'0.00',200.00,'2024-06-13 18:03:22',NULL),(306,47,220.00,'0.00',220.00,'2024-06-13 18:07:55',NULL),(310,24,250.25,'0.00',250.25,'2024-06-13 18:11:33',NULL),(311,25,300.50,'0.00',300.50,'2024-06-13 18:11:34',NULL);
/*!40000 ALTER TABLE `GeneradorPrecios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Localidad`
--

DROP TABLE IF EXISTS `Localidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Localidad` (
  `IdLocalidad` int NOT NULL AUTO_INCREMENT,
  `IdProvincia` int NOT NULL,
  `Detalle` varchar(45) NOT NULL,
  PRIMARY KEY (`IdLocalidad`),
  KEY `fk_Localidad_Provincia1_idx` (`IdProvincia`),
  CONSTRAINT `fk_Localidad_Provincia1` FOREIGN KEY (`IdProvincia`) REFERENCES `Provincia` (`IdProvincia`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Localidad`
--

LOCK TABLES `Localidad` WRITE;
/*!40000 ALTER TABLE `Localidad` DISABLE KEYS */;
INSERT INTO `Localidad` VALUES (1,1,'La Plata'),(2,1,'Mar del Plata'),(3,2,'Buenos Aires'),(4,2,'Palermo'),(5,3,'San Fernando del Valle de Catamarca'),(6,3,'Valle Viejo'),(7,4,'Resistencia'),(8,4,'Barranqueras'),(9,5,'Comodoro Rivadavia'),(10,5,'Trelew'),(11,6,'Córdoba'),(12,6,'Villa Carlos Paz'),(13,7,'Corrientes'),(14,7,'Goya'),(15,8,'Paraná'),(16,8,'Concordia'),(17,9,'Formosa'),(18,9,'Clorinda'),(19,10,'San Salvador de Jujuy'),(20,10,'Palpalá'),(21,11,'Santa Rosa'),(22,11,'General Pico'),(23,12,'La Rioja'),(24,12,'Chilecito'),(25,13,'Mendoza'),(26,13,'San Rafael'),(27,14,'Posadas'),(28,14,'Puerto Iguazú'),(29,15,'Neuquén'),(30,15,'Cutral Có'),(31,16,'Viedma'),(32,16,'Bariloche'),(33,17,'Salta'),(34,17,'San Ramón de la Nueva Orán'),(35,18,'San Juan'),(36,18,'Rivadavia'),(37,19,'San Luis'),(38,19,'Villa Mercedes'),(39,20,'Río Gallegos'),(40,20,'Caleta Olivia'),(41,21,'Santa Fe'),(42,21,'Rosario'),(43,22,'Santiago del Estero'),(44,22,'La Banda'),(45,23,'Ushuaia'),(46,23,'Río Grande'),(47,24,'San Miguel de Tucumán'),(48,24,'Yerba Buena');
/*!40000 ALTER TABLE `Localidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PedidoProveedor`
--

DROP TABLE IF EXISTS `PedidoProveedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PedidoProveedor` (
  `IdPedidoProveedor` int NOT NULL AUTO_INCREMENT,
  `IdPersona` int NOT NULL,
  `IdProducto` int NOT NULL,
  `Fecha` datetime NOT NULL,
  PRIMARY KEY (`IdPedidoProveedor`),
  KEY `fk_PedidoProveedor_Persona1_idx` (`IdPersona`),
  KEY `fk_PedidoProveedor_Producto1_idx` (`IdProducto`),
  CONSTRAINT `fk_PedidoProveedor_Persona1` FOREIGN KEY (`IdPersona`) REFERENCES `Persona` (`IdPersona`),
  CONSTRAINT `fk_PedidoProveedor_Producto1` FOREIGN KEY (`IdProducto`) REFERENCES `Producto` (`IdProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PedidoProveedor`
--

LOCK TABLES `PedidoProveedor` WRITE;
/*!40000 ALTER TABLE `PedidoProveedor` DISABLE KEYS */;
/*!40000 ALTER TABLE `PedidoProveedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PedidosSucursal`
--

DROP TABLE IF EXISTS `PedidosSucursal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PedidosSucursal` (
  `IdPedidosSucursal` int NOT NULL AUTO_INCREMENT,
  `IdUsuario` int NOT NULL,
  `IdSucursal` int NOT NULL,
  `Fecha` datetime NOT NULL,
  `CantBulto` int NOT NULL,
  `Estado` varchar(55) NOT NULL,
  `FechaEnvio` datetime NOT NULL,
  `FechaEntrega` datetime NOT NULL,
  PRIMARY KEY (`IdPedidosSucursal`),
  KEY `fk_PedidosSucursales_Usuario1_idx` (`IdUsuario`),
  KEY `fk_PedidosSucursales_Sucursal1_idx` (`IdSucursal`),
  CONSTRAINT `fk_PedidosSucursales_Sucursal1` FOREIGN KEY (`IdSucursal`) REFERENCES `Sucursal` (`IdSucursal`),
  CONSTRAINT `fk_PedidosSucursales_Usuario1` FOREIGN KEY (`IdUsuario`) REFERENCES `Usuario` (`IdUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PedidosSucursal`
--

LOCK TABLES `PedidosSucursal` WRITE;
/*!40000 ALTER TABLE `PedidosSucursal` DISABLE KEYS */;
/*!40000 ALTER TABLE `PedidosSucursal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Persona`
--

DROP TABLE IF EXISTS `Persona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Persona` (
  `IdPersona` int NOT NULL AUTO_INCREMENT,
  `IdTipoPersonaSistema` int NOT NULL,
  `IdTipoPersona` int NOT NULL,
  `IdDomicilio` int NOT NULL,
  `IdLocalidad` int NOT NULL,
  `IdTipoDocumentacion` int NOT NULL,
  `Documentacion` varchar(45) NOT NULL,
  `Nombre` varchar(45) DEFAULT NULL,
  `Apellido` varchar(45) DEFAULT NULL,
  `Mail` varchar(45) NOT NULL,
  `RazonSocial` varchar(45) DEFAULT NULL,
  `FechaNacimiento` date DEFAULT NULL,
  `Telefono` varchar(45) DEFAULT NULL,
  `FechaAlta` datetime NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  `IdUsuarioCarga` int NOT NULL,
  PRIMARY KEY (`IdPersona`),
  KEY `fk_Persona_TipoPersona1_idx` (`IdTipoPersona`),
  KEY `fk_Persona_TipoDocumentacion1_idx` (`IdTipoDocumentacion`),
  KEY `fk_Persona_Domicilio1_idx` (`IdDomicilio`),
  KEY `fk_Persona_TipoPersonaSistema1_idx` (`IdTipoPersonaSistema`),
  KEY `fk_Persona_Localidad1_idx` (`IdLocalidad`),
  KEY `fk_Persona_IdUsuarioCarga` (`IdUsuarioCarga`),
  CONSTRAINT `fk_Persona_Domicilio1` FOREIGN KEY (`IdDomicilio`) REFERENCES `Domicilio` (`IdDomicilio`),
  CONSTRAINT `fk_Persona_IdUsuarioCarga` FOREIGN KEY (`IdUsuarioCarga`) REFERENCES `Usuario` (`IdUsuario`),
  CONSTRAINT `fk_Persona_Localidad1` FOREIGN KEY (`IdLocalidad`) REFERENCES `Localidad` (`IdLocalidad`),
  CONSTRAINT `fk_Persona_TipoDocumentacion1` FOREIGN KEY (`IdTipoDocumentacion`) REFERENCES `TipoDocumentacion` (`IdTipoDocumentacion`),
  CONSTRAINT `fk_Persona_TipoPersona1` FOREIGN KEY (`IdTipoPersona`) REFERENCES `TipoPersona` (`IdTipoPersona`),
  CONSTRAINT `fk_Persona_TipoPersonaSistema1` FOREIGN KEY (`IdTipoPersonaSistema`) REFERENCES `TipoPersonaSistema` (`IdTipoPersonaSistema`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Persona`
--

LOCK TABLES `Persona` WRITE;
/*!40000 ALTER TABLE `Persona` DISABLE KEYS */;
INSERT INTO `Persona` VALUES (1,1,1,1,3,1,'44343826','Lautaro','Britez','lautibritez@gmail.com','Lautaro Britez S.A.','1990-01-01','123456789','2024-05-09 21:52:14',NULL,1),(2,1,1,1,3,1,'43806722','Ezequiel','Ferreyra','eze@gmail.com','Ezequiel S.R.L','2001-01-01','3704475135','2024-05-10 12:20:00',NULL,1),(3,1,1,1,3,1,'44343434','Samuel','Torales','samu@gmail.com','Samuel S.A.','2002-01-01','3704336265','2024-05-15 14:14:14',NULL,1),(4,1,1,1,3,1,'42890780','Ezequiel','Ferreyra','ezef8137@gmail.com','Ezequiel S.A.','2001-01-01','3704561476','2024-05-21 23:42:00',NULL,1),(5,1,1,1,3,1,'30123456','Juan','Pérez','juan.perez@mail.com','Juan Pérez S.A.','1980-05-15','3704123456','2024-05-22 22:04:35',NULL,24),(6,1,1,3,3,1,'32456789','María','González','maria.gonzalez@mail.com','María González S.R.L.','1985-11-23','3704234567','2024-05-22 22:04:35',NULL,1),(7,1,1,3,1,1,'33876543','Carlos','Rodríguez','carlos.rodriguez@mail.com','Carlos Rodríguez y Asociados','1990-02-10','3704345678','2024-05-22 22:04:35',NULL,1),(8,1,1,3,1,1,'30129876','Laura','Martínez','laura.martinez@mail.com','Laura Martínez S.A.','1978-08-30','3704456789','2024-05-22 22:04:35',NULL,24),(9,1,1,4,1,1,'32765432','Federico','García','federico.garcia@mail.com','Federico García S.R.L.','1982-12-05','3704567890','2024-05-22 22:04:35',NULL,1),(10,1,1,4,1,1,'31324567','Ana','López','ana.lopez@mail.com','Ana López S.A.','1987-04-20','3704678901','2024-05-22 22:04:35',NULL,1),(11,1,1,4,3,1,'34876543','José','Sánchez','jose.sanchez@mail.com','José Sánchez S.R.L.','1975-09-15','3704789012','2024-05-31 14:01:56',NULL,1),(12,1,1,4,3,1,'30129876','Marta','Fernández','marta.fernandez@mail.com','Marta Fernández S.A.','1980-06-25','3704890123','2024-05-31 14:02:02',NULL,1),(13,3,2,4,1,1,'32876543','Diego','Ramírez','diego.ramirez@mail.com','Diego Ramírez S.R.L.','1985-11-30','3704901234','2024-05-31 14:06:19',NULL,24),(14,3,1,4,1,1,'30234567','Lucía','Torres','lucia.torres@mail.com','Lucía Torres S.A.','1990-03-10','3704012345','2024-05-31 14:13:57',NULL,1),(15,2,2,1,1,1,'30765432','Gustavo','Gómez','gustavo.gomez@mail.com','Gustavo Gómez S.R.L.','1978-07-15','3704123456','2024-05-31 14:13:57',NULL,1),(16,1,1,1,1,1,'30123456','Valeria','Díaz','valeria.diaz@mail.com','Valeria Díaz S.A.','1982-11-20','3704234567','2024-05-31 14:13:57',NULL,1),(17,1,1,1,1,1,'33876543','Gabriel','Silva','gabriel.silva@mail.com','Gabriel Silva S.R.L.','1983-04-25','3704345678','2024-05-31 14:13:57',NULL,1),(18,1,1,1,1,1,'31234567','Natalia','Rojas','natalia.rojas@mail.com','Natalia Rojas S.A.','1988-01-19','3704456789','2024-05-31 14:13:57',NULL,1),(19,3,1,20,1,1,'32765432','Pablo','Méndez','pablo.mendez@mail.com','Pablo Méndez S.R.L.','1991-12-01','3704567890','2024-05-31 19:07:47',NULL,1),(20,3,2,21,1,2,'30129876','Verónica','Ortiz','veronica.ortiz@mail.com','Verónica Ortiz S.A.','1979-05-20','3704678901','2024-05-31 19:11:41',NULL,1),(21,3,2,22,1,2,'30123456','Fernando','Cruz','fernando.cruz@mail.com','Fernando Cruz S.R.L.','1986-03-17','3704789012','2024-05-31 19:12:21',NULL,1),(22,3,1,23,1,2,'34876543','Paula','Castro','paula.castro@mail.com','Paula Castro S.A.','1992-06-05','3704890123','2024-05-31 19:14:14',NULL,1),(23,1,1,24,1,1,'30129876','Sergio','Reyes','sergio.reyes@mail.com','Sergio Reyes S.R.L.','1984-09-09','3704901234','2024-06-03 16:13:59',NULL,1),(24,2,1,25,1,1,'32765432','Cecilia','Morales','cecilia.morales@mail.com','Cecilia Morales S.A.','1989-02-14','3704012345','2024-06-03 16:15:42',NULL,1),(25,3,1,26,1,1,'31234567','Martín','Romero','martin.romero@mail.com','Martín Romero S.R.L.','1981-11-25','3704123456','2024-06-03 16:28:26',NULL,1),(26,3,1,27,1,2,'30123456','Romina','Herrera','romina.herrera@mail.com','Romina Herrera S.A.','1987-10-10','3704234567','2024-06-03 19:09:23',NULL,24),(27,3,2,28,1,1,'33876543','Ricardo','Medina','ricardo.medina@mail.com','Ricardo Medina S.R.L.','1976-12-20','3704345678','2024-06-03 19:12:50',NULL,24),(28,3,1,29,17,2,'31234567','Silvana','Ibarra','silvana.ibarra@mail.com','Silvana Ibarra S.A.','1985-08-18','3704456789','2024-06-03 19:24:00','2024-06-03 00:00:00',1),(29,2,2,30,17,1,'33876543','Roberto','Rivera','roberto.rivera@mail.com','Roberto Rivera S.R.L.','1977-03-27','3704567890','2024-06-03 20:32:32','2024-06-12 00:17:59',24),(30,2,2,31,17,1,'30765432','Claudia','Ortiz','claudia.ortiz@mail.com','Claudia Ortiz S.A.','1990-10-30','3704678901','2024-06-03 20:36:33',NULL,1),(31,1,2,32,17,1,'32456789','Jorge','Flores','jorge.flores@mail.com','Jorge Flores S.R.L.','1978-12-19','3704789012','2024-06-03 20:55:31',NULL,1),(32,1,2,33,17,1,'30129876','Andrea','Chávez','andrea.chavez@mail.com','Andrea Chávez S.A.','1981-07-08','3704890123','2024-06-03 21:01:12',NULL,24),(33,3,2,34,11,2,'32765432','Daniel','Ramos','daniel.ramos@mail.com','Daniel Ramos S.R.L.','1989-04-22','3704901234','2024-06-03 22:36:12',NULL,1),(34,3,2,35,1,1,'30123456','Patricia','Peña','patricia.pena@mail.com','Patricia Peña S.A.','1979-11-13','3704012345','2024-06-03 22:40:40',NULL,24),(35,1,1,36,17,1,'33876543','Mario','Vega','mario.vega@mail.com','Mario Vega S.R.L.','1983-08-28','3704123456','2024-06-03 23:25:48',NULL,24),(36,3,2,37,41,1,'30765432','Liliana','Maldonado','liliana.maldonado@mail.com','Liliana Maldonado S.A.','1980-06-15','3704234567','2024-06-03 23:54:32',NULL,1),(37,3,1,38,17,2,'31234567','Hernán','Campos','hernan.campos@mail.com','Hernán Campos S.R.L.','1990-05-10','3704345678','2024-06-04 00:24:24',NULL,1),(38,1,1,1,17,1,'30129876','Alicia','Guzmán','alicia.guzman@mail.com','Alicia Guzmán S.A.','1984-07-22','3704456789','2024-06-05 17:02:24',NULL,24),(39,2,1,43,17,2,'30123456','Agustín','Vargas','agustin.vargas@mail.com','Agustín Vargas S.R.L.','1992-09-16','3704567890','2024-06-05 17:03:51',NULL,5),(40,2,1,44,7,3,'32765432','Monica','Mendoza','monica.mendoza@mail.com','Mónica Mendoza S.A.','1981-04-11','3704678901','2024-06-05 19:00:36',NULL,5),(41,2,1,45,1,3,'30129876','Ignacio','Aguilar','ignacio.aguilar@mail.com','Ignacio Aguilar S.R.L.','1985-02-23','3704789012','2024-06-05 19:03:01',NULL,24),(42,1,2,46,17,1,'33876543','Elena','Salazar','elena.salazar@mail.com','Elena Salazar S.A.','1987-12-03','3704890123','2024-06-10 17:09:13',NULL,5),(43,1,2,48,17,1,'32456789','Rodrigo','Montoya','rodrigo.montoya@mail.com','Rodrigo Montoya S.R.L.','1989-05-17','3704901234','2024-06-11 16:07:50','2024-06-12 00:13:32',24),(48,1,2,53,17,1,'30765432','Graciela','Suárez','graciela.suarez@mail.com','Graciela Suárez S.A.','1983-10-27','3704456789','2024-06-12 22:31:48',NULL,1);
/*!40000 ALTER TABLE `Persona` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Producto`
--

DROP TABLE IF EXISTS `Producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Producto` (
  `IdProducto` int NOT NULL AUTO_INCREMENT,
  `IdTipoMedida` int NOT NULL,
  `IdTipoCategoria` int NOT NULL,
  `IdTipoProducto` int NOT NULL,
  `Codigo` varchar(255) NOT NULL,
  `Nombre` varchar(45) NOT NULL,
  `Marca` varchar(45) NOT NULL,
  `PrecioCosto` decimal(18,2) NOT NULL,
  `Tamano` decimal(18,2) NOT NULL,
  `CantMinima` int NOT NULL,
  `CantMaxima` int NOT NULL,
  `IdUsuarioCarga` int NOT NULL,
  `FechaAlta` datetime NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  `IdPersona` int DEFAULT NULL,
  PRIMARY KEY (`IdProducto`),
  KEY `fk_Producto_TipoCategoria1_idx` (`IdTipoCategoria`),
  KEY `fk_Productos_TipoProducto1_idx` (`IdTipoProducto`),
  KEY `fk_Productos_TipoMedida1_idx` (`IdTipoMedida`),
  KEY `fk_Producto_Usuario1_idx` (`IdUsuarioCarga`),
  KEY `FK_Producto_Persona` (`IdPersona`),
  CONSTRAINT `FK_Producto_Persona` FOREIGN KEY (`IdPersona`) REFERENCES `Persona` (`IdPersona`),
  CONSTRAINT `fk_Producto_TipoCategoria1` FOREIGN KEY (`IdTipoCategoria`) REFERENCES `TipoCategoria` (`IdTipoCategoria`),
  CONSTRAINT `fk_Producto_Usuario1` FOREIGN KEY (`IdUsuarioCarga`) REFERENCES `Usuario` (`IdUsuario`),
  CONSTRAINT `fk_Productos_TipoMedida1` FOREIGN KEY (`IdTipoMedida`) REFERENCES `TipoMedida` (`IdTipoMedida`),
  CONSTRAINT `fk_Productos_TipoProducto1` FOREIGN KEY (`IdTipoProducto`) REFERENCES `TipoProducto` (`IdTipoProducto`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Producto`
--

LOCK TABLES `Producto` WRITE;
/*!40000 ALTER TABLE `Producto` DISABLE KEYS */;
INSERT INTO `Producto` VALUES (1,5,3,3,'22222222','Jabón','Rexona',130.00,11.00,111,111,1,'2024-05-09 22:07:08','2024-06-13 17:10:38',1),(3,1,1,1,'12345678910','Jabón Blanco',' Rexona',260.00,5.00,100,200,1,'2024-05-15 17:41:08','2024-06-06 00:16:17',1),(4,1,1,1,'666666667','Jabón en Polvo','Zorro',585.00,6.60,6,600,1,'2024-05-28 16:05:13',NULL,1),(5,1,1,1,'20202020','Lavandina','Ayudin',390.00,2.50,10,20,6,'2024-05-29 16:42:02',NULL,NULL),(6,3,1,1,'1222323333','Desodorante','Poet',2007.72,2.00,20,1000,24,'2024-05-30 15:22:43','2024-06-13 17:13:31',1),(7,3,17,1,'12223233335','Desodorante','Nivea',200.00,1.00,100,1000,1,'2024-05-30 16:28:27','2024-06-13 17:15:27',1),(8,1,2,1,'10000000','Jabón Eco','Rexona',110.00,100.00,50,100,1,'2024-05-30 17:49:25','2024-06-05 02:10:24',1),(9,1,1,1,'10000001','Detergente','Ayudín',165.00,100.00,50,100,1,'2024-05-30 17:49:25','2024-06-05 02:10:24',1),(10,1,1,1,'22322132123231','Insecticida','Manchester',220.00,12.00,2,5,1,'2024-06-05 19:34:45',NULL,NULL),(21,1,1,1,'COD001','Cloro liquido','Ayudin',100.50,1.00,5,20,1,'2024-06-06 00:48:58',NULL,NULL),(22,2,2,2,'COD002','Cloro en Polvo','Ayudin',150.75,2.50,10,30,1,'2024-06-06 00:48:58',NULL,NULL),(23,3,3,3,'COD003','Jabón Líquido','Rexona',200.00,1.50,15,40,1,'2024-06-06 00:48:58',NULL,NULL),(24,4,1,7,'COD004','Quitamanchas','Ayudín',250.25,2.00,20,50,1,'2024-06-06 00:48:58',NULL,NULL),(25,5,2,7,'COD005','Vela','Veli',300.50,3.00,25,60,1,'2024-06-06 00:48:58',NULL,NULL),(40,3,1,10,'COD011','Sahumerio','Aromanza',1332.82,1.00,50,110,1,'2024-06-07 09:48:00',NULL,36),(41,3,1,1,'1222323333A','Desodorante','Ariel',24446.40,2.00,11,1111,5,'2024-06-07 17:04:35','2024-06-13 17:23:02',40),(42,2,1,1,'D33345674','Detergente','Ariel',1760.00,500.00,50,300,5,'2024-06-07 17:15:31',NULL,41),(46,1,1,1,'adasda312322','Suavizante','Ariel',1151.04,10.00,10,20,1,'2024-06-07 17:15:31',NULL,36),(47,1,1,1,'adasda3123222','Desengrasante','Mr. Músculo',220.00,10.00,10,20,1,'2024-06-07 17:15:31',NULL,NULL),(48,2,7,2,'11111111','Lustrador Piso','Cif',532.40,200.00,200,300,1,'2024-06-11 23:58:02',NULL,24),(49,2,1,1,'11223344','lavandina','Mr. Músculo',330.00,500.00,200,300,1,'2024-06-12 23:29:27','2024-06-13 17:19:23',41);
/*!40000 ALTER TABLE `Producto` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `T_GeneradorPreciosProdInsert` AFTER INSERT ON `Producto` FOR EACH ROW BEGIN
  DECLARE porcentaje_total DECIMAL(5,2) DEFAULT 0;
  DECLARE precio_final DECIMAL(18,2);
  DECLARE record_count INT;

  IF (SELECT FechaBaja FROM Producto WHERE IdProducto = NEW.IdProducto) IS NULL THEN
    SELECT IFNULL(SUM(TA.Porcentaje), 0) + IFNULL(SUM(AP.PorcentajeExtra), 0) INTO porcentaje_total
    FROM AumentoPorProducto AP
    LEFT JOIN TipoAumento TA ON AP.IdTipoAumento = TA.IdTipoAumento
    WHERE AP.IdProducto = NEW.IdProducto;

    -- Calcular PrecioFinal
    SET precio_final = NEW.PrecioCosto * (1 + porcentaje_total / 100);

    -- Verificar si el registro ya existe en GeneradorPrecios
    SELECT COUNT(*) INTO record_count
    FROM GeneradorPrecios
    WHERE IdProducto = NEW.IdProducto AND PrecioCosto = NEW.PrecioCosto AND PorcentajeTotal = porcentaje_total;

    IF record_count = 0 THEN
      -- Insertar un nuevo registro en GeneradorPrecios
      INSERT INTO GeneradorPrecios (IdProducto, PrecioCosto, PorcentajeTotal, PrecioFinal, Fecha)
      VALUES (NEW.IdProducto, NEW.PrecioCosto, porcentaje_total, precio_final, NOW());
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `T_GeneradorPreciosProd` AFTER UPDATE ON `Producto` FOR EACH ROW BEGIN
  DECLARE porcentaje_total DECIMAL(5,2);
  DECLARE precio_final DECIMAL(18,2);
  DECLARE record_count INT;

  IF NEW.FechaBaja IS NULL AND OLD.FechaBaja IS NULL THEN
    -- Calcular el porcentaje total
    SELECT IFNULL(SUM(TA.Porcentaje), 0) + IFNULL(SUM(AP.PorcentajeExtra), 0) INTO porcentaje_total
    FROM AumentoPorProducto AP
    LEFT JOIN TipoAumento TA ON AP.IdTipoAumento = TA.IdTipoAumento
    WHERE AP.IdProducto = NEW.IdProducto;

    -- Calcular el precio final
    SET precio_final = NEW.PrecioCosto * (1 + porcentaje_total / 100);

    -- Verificar si el registro ya existe en GeneradorPrecios
    SELECT COUNT(*) INTO record_count
    FROM GeneradorPrecios
    WHERE IdProducto = NEW.IdProducto AND PrecioCosto = NEW.PrecioCosto AND PorcentajeTotal = porcentaje_total;

    IF record_count = 0 THEN
      -- Insertar un nuevo registro en GeneradorPrecios
      INSERT INTO GeneradorPrecios (IdProducto, PrecioCosto, PorcentajeTotal, PrecioFinal, Fecha)
      VALUES (NEW.IdProducto, NEW.PrecioCosto, porcentaje_total, precio_final, NOW());
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ProductoPorPedido`
--

DROP TABLE IF EXISTS `ProductoPorPedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProductoPorPedido` (
  `IdProductoPorPedido` int NOT NULL AUTO_INCREMENT,
  `IdPedidoSucursal` int NOT NULL,
  `IdProductos` int NOT NULL,
  `FechaBaja` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`IdProductoPorPedido`),
  KEY `fk_ProductosPorPedido_PedidosSucursales1_idx` (`IdPedidoSucursal`),
  KEY `fk_ProductosPorPedido_Productos1_idx` (`IdProductos`),
  CONSTRAINT `fk_ProductosPorPedido_PedidosSucursales1` FOREIGN KEY (`IdPedidoSucursal`) REFERENCES `PedidosSucursal` (`IdPedidosSucursal`),
  CONSTRAINT `fk_ProductosPorPedido_Productos1` FOREIGN KEY (`IdProductos`) REFERENCES `Producto` (`IdProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductoPorPedido`
--

LOCK TABLES `ProductoPorPedido` WRITE;
/*!40000 ALTER TABLE `ProductoPorPedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `ProductoPorPedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Provincia`
--

DROP TABLE IF EXISTS `Provincia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Provincia` (
  `IdProvincia` int NOT NULL AUTO_INCREMENT,
  `Detalle` varchar(45) NOT NULL,
  PRIMARY KEY (`IdProvincia`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Provincia`
--

LOCK TABLES `Provincia` WRITE;
/*!40000 ALTER TABLE `Provincia` DISABLE KEYS */;
INSERT INTO `Provincia` VALUES (1,'BUENOS AIRES'),(2,'CAPITAL FEDERAL'),(3,'CATAMARCA'),(4,'CHACO'),(5,'CHUBUT'),(6,'CORDOBA'),(7,'CORRIENTES'),(8,'ENTRE RIOS'),(9,'FORMOSA'),(10,'JUJUY'),(11,'LA PAMPA'),(12,'LA RIOJA'),(13,'MENDOZA'),(14,'MISIONES'),(15,'NEUQUEN'),(16,'RIO NEGRO'),(17,'SALTA'),(18,'SAN JUAN'),(19,'SAN LUIS'),(20,'SANTA CRUZ'),(21,'SANTA FE'),(22,'SANTIAGO DEL ESTERO'),(23,'TIERRA DEL FUEGO'),(24,'TUCUMAN');
/*!40000 ALTER TABLE `Provincia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RolModulo`
--

DROP TABLE IF EXISTS `RolModulo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RolModulo` (
  `IdRolModulo` int NOT NULL AUTO_INCREMENT,
  `IdTipoRol` int NOT NULL,
  `IdTipoModulo` int NOT NULL,
  `IdTipoPermiso` int NOT NULL,
  `FechaBaja` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`IdRolModulo`),
  KEY `fk_RolModulo_RolTipo1_idx` (`IdTipoRol`),
  KEY `fk_RolModulo_TipoModulo1_idx` (`IdTipoModulo`),
  KEY `fk_RolModulo_TipoPermiso1_idx` (`IdTipoPermiso`),
  CONSTRAINT `fk_RolModulo_RolTipo1` FOREIGN KEY (`IdTipoRol`) REFERENCES `TipoRol` (`IdTipoRol`),
  CONSTRAINT `fk_RolModulo_TipoModulo1` FOREIGN KEY (`IdTipoModulo`) REFERENCES `TipoModulo` (`IdTipoModulo`),
  CONSTRAINT `fk_RolModulo_TipoPermiso1` FOREIGN KEY (`IdTipoPermiso`) REFERENCES `TipoPermiso` (`IdTipoPermiso`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RolModulo`
--

LOCK TABLES `RolModulo` WRITE;
/*!40000 ALTER TABLE `RolModulo` DISABLE KEYS */;
INSERT INTO `RolModulo` VALUES (2,1,2,1,NULL),(3,1,3,1,NULL),(4,1,4,1,NULL),(5,1,5,1,NULL),(6,1,6,1,NULL),(7,1,7,1,NULL),(8,1,8,1,NULL),(9,1,9,1,NULL),(10,1,10,1,NULL),(11,1,11,1,NULL),(12,1,12,1,NULL),(13,1,13,1,NULL),(14,1,14,1,NULL),(15,1,15,1,NULL),(16,1,16,1,NULL),(17,1,17,1,NULL),(18,1,18,1,NULL),(19,1,19,1,NULL),(20,1,20,1,NULL),(35,1,21,1,NULL),(36,1,22,1,NULL),(37,1,23,1,NULL),(38,1,24,1,NULL),(39,1,25,1,NULL),(40,1,26,1,NULL),(41,1,27,1,NULL),(42,1,28,1,NULL),(43,1,29,1,NULL),(44,1,30,1,NULL),(45,1,31,1,NULL),(46,1,32,1,NULL),(47,1,33,1,NULL),(48,1,34,1,NULL),(49,1,35,1,NULL),(50,1,36,1,NULL),(53,2,7,2,'2024-06-12 01:45:02'),(54,3,7,3,NULL),(55,1,1,1,NULL),(56,2,8,1,NULL),(57,2,9,3,NULL),(58,4,7,4,NULL),(59,4,2,1,'2024-06-12 12:46:19'),(60,11,15,1,NULL),(61,11,18,1,NULL),(62,2,3,1,'2024-06-11 23:44:49'),(63,12,10,4,NULL),(64,1,36,4,NULL);
/*!40000 ALTER TABLE `RolModulo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SistemaAPIs`
--

DROP TABLE IF EXISTS `SistemaAPIs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SistemaAPIs` (
  `IdSistemaAPIs` int NOT NULL AUTO_INCREMENT,
  `Detalle` varchar(45) NOT NULL,
  `Method` varchar(45) NOT NULL,
  `Path` varchar(45) NOT NULL,
  `IdUsuarioCarga` int NOT NULL,
  `FechaAlta` datetime NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdSistemaAPIs`),
  KEY `fk_SistemaAPIs_Usuario1_idx` (`IdUsuarioCarga`),
  CONSTRAINT `fk_SistemaAPIs_Usuario1` FOREIGN KEY (`IdUsuarioCarga`) REFERENCES `Usuario` (`IdUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SistemaAPIs`
--

LOCK TABLES `SistemaAPIs` WRITE;
/*!40000 ALTER TABLE `SistemaAPIs` DISABLE KEYS */;
INSERT INTO `SistemaAPIs` VALUES (1,'Login','POST','auth',1,'2024-05-09 21:52:14',NULL),(2,'Obtener Menu','GET','utils/menu',1,'2024-05-09 21:52:15',NULL),(3,'Obtener SubMenu','GET','utils/menu/submenu',1,'2024-05-09 21:52:15',NULL),(4,'Obtener Icono SubMenu','GET','utils/submenu/image',1,'2024-05-09 21:52:15',NULL),(5,'Usuario - Agregar Usuario ','POST','seguridad/usuarios',1,'2024-06-05 21:52:15',NULL),(6,'Usuario - Modificar Usuario','PUT','seguridad/usuarios',1,'2024-06-05 21:52:15',NULL),(7,'Usuario - Inhabilitar Usuario','DELETE','seguridad/usuarios',1,'2024-06-05 21:52:15',NULL),(8,'Usuario - Agregar Rol','POST','seguridad/usuarios/rol',1,'2024-06-05 21:52:15',NULL),(9,'Usuario - Modificar Sucursal','PUT','seguridad/usuarios/sucursal',1,'2024-06-05 21:52:15',NULL),(10,'Usuario - Obtener Usuarios','GET','seguridad/usuarios',1,'2024-06-06 21:52:15',NULL),(11,'Usuario - Inhabilitar Rol','DELETE','seguridad/usuarios/rol',1,'2024-06-06 12:21:50',NULL),(12,'Tipo Rol - Listar','GET','seguridad/tiporoles',1,'2024-06-06 12:26:26',NULL),(13,'Tipo Rol - Agregar','POST','seguridad/tiporoles',1,'2024-06-06 12:26:26',NULL),(14,'Tipo Rol - Modificar','PUT','seguridad/tiporoles',1,'2024-06-06 12:26:26',NULL),(15,'Tipo Rol - Inhabilitar','DELETE','seguridad/tiporoles',1,'2024-06-06 12:26:26',NULL),(16,'Rol Modulo - Listar','GET','seguridad/rolmodulos',1,'2024-06-06 12:30:29',NULL),(17,'Rol Modulo - Agregar','POST','seguridad/rolmodulos',1,'2024-06-06 12:30:29',NULL),(18,'Rol Modulo - Modificar','PUT','seguridad/rolmodulos',1,'2024-06-06 12:30:30',NULL),(19,'Rol Modulo - Habilitar','PUT','seguridad/rolmodulos/habilitar',1,'2024-06-06 12:30:30',NULL),(20,'Rol Modulo - Inhabilitar','DELETE','seguridad/rolmodulos',1,'2024-06-06 12:30:30',NULL),(21,'Tipo Persona - Listar','GET','parametria/tipopersona',1,'2024-06-06 12:34:49',NULL),(22,'Tipo Documentacion - Listar','GET','parametria/tipodocumentacion',1,'2024-06-06 12:34:50',NULL),(23,'Tipo Medida - Listar','GET','parametria/tipomedida',1,'2024-06-06 12:34:50',NULL),(24,'Tipo Domicilio - Listar','GET','parametria/tipodomicilio',1,'2024-06-06 12:34:50',NULL),(25,'Tipo Factura - Listar','GET','parametria/tipofactura',1,'2024-06-06 12:34:50',NULL),(26,'Tipo Permiso - Listar','GET','parametria/tipopermiso',1,'2024-06-06 12:34:51',NULL),(27,'Tipo Modulo - Listar','GET','parametria/tipomodulo',1,'2024-06-06 12:34:51',NULL),(28,'Tipo Producto - Listar','GET','parametria/tipoproducto',1,'2024-06-06 12:39:33',NULL),(29,'Tipo Producto - Agregar','POST','parametria/tipoproducto',1,'2024-06-06 12:39:34',NULL),(30,'Tipo Producto - Editar','PUT','parametria/tipoproducto',1,'2024-06-06 12:39:34',NULL),(31,'Tipo Producto - Inhabilitar','DELETE','parametria/tipoproducto',1,'2024-06-06 12:39:34',NULL),(32,'Tipo Categoria - Listar','GET','parametria/tipocategoria',1,'2024-06-06 13:25:08',NULL),(33,'Tipo Categoria - Agregar','POST','parametria/tipocategoria',1,'2024-06-06 13:25:08',NULL),(34,'Tipo Categoria - Editar','PUT','parametria/tipocategoria',1,'2024-06-06 13:25:08',NULL),(35,'Tipo Categoria - Inhabilitar','DELETE','parametria/tipocategoria',1,'2024-06-06 13:25:09',NULL),(36,'Tipo Impuesto - Listar','GET','parametria/tipoimpuesto',1,'2024-06-06 13:26:16',NULL),(37,'Tipo Impuesto - Agregar','POST','parametria/tipoimpuesto',1,'2024-06-06 13:26:17',NULL),(38,'Tipo Impuesto - Editar','PUT','parametria/tipoimpuesto',1,'2024-06-06 13:26:17',NULL),(39,'Tipo Impuesto - Inhabilitar','DELETE','parametria/tipoimpuesto',1,'2024-06-06 13:26:17',NULL),(40,'Tipo Forma de Pago - Listar','GET','parametria/tipoformadepago',1,'2024-06-06 13:27:30',NULL),(41,'Tipo Forma de Pago - Agregar','POST','parametria/tipoformadepago',1,'2024-06-06 13:27:30',NULL),(42,'Tipo Forma de Pago - Editar','PUT','parametria/tipoformadepago',1,'2024-06-06 13:27:31',NULL),(43,'Tipo Forma de Pago - Inhabilitar','DELETE','parametria/tipoformadepago',1,'2024-06-06 13:27:31',NULL),(44,'Sucursales - Listar','GET','parametria/sucursales',1,'2024-06-06 13:28:13',NULL),(45,'Sucursales - Agregar','POST','parametria/sucursales',1,'2024-06-06 13:28:13',NULL),(46,'Sucursales - Editar','PUT','parametria/sucursales',1,'2024-06-06 13:28:13',NULL),(47,'Sucursales - Inhabilitar','DELETE','parametria/sucursales',1,'2024-06-06 13:28:13',NULL),(48,'Inventario - Listar','GET','recursos/inventario',1,'2024-06-06 13:29:43',NULL),(49,'Inventario - Agregar','POST','recursos/inventario',1,'2024-06-06 13:29:43',NULL),(50,'Inventario - Editar','PUT','recursos/inventario',1,'2024-06-06 13:29:44',NULL),(51,'Inventario - Inhabilitar','DELETE','recursos/inventario',1,'2024-06-06 13:29:44',NULL),(52,'Personal - Listar','GET','recursos/personal',1,'2024-06-06 13:30:23',NULL),(53,'Personal - Agregar','POST','recursos/personal',1,'2024-06-06 13:30:23',NULL),(54,'Personal - Editar','PUT','recursos/personal',1,'2024-06-06 13:30:24',NULL),(55,'Personal - Inhabilitar','DELETE','recursos/personal',1,'2024-06-06 13:30:24',NULL),(56,'Proveedores - Listar','GET','recursos/proveedores',1,'2024-06-06 13:31:07',NULL),(57,'Proveedores - Agregar','POST','recursos/proveedores',1,'2024-06-06 13:31:07',NULL),(58,'Proveedores - Editar','PUT','recursos/proveedores',1,'2024-06-06 13:31:07',NULL),(59,'Proveedores - Inhabilitar','DELETE','recursos/proveedores',1,'2024-06-06 13:31:07',NULL),(60,'Clientes - Listar','GET','recursos/clientes',1,'2024-06-06 13:31:23',NULL),(61,'Clientes - Agregar','POST','recursos/clientes',1,'2024-06-06 13:31:24',NULL),(62,'Clientes - Editar','PUT','recursos/clientes',1,'2024-06-06 13:31:24',NULL),(63,'Clientes - Inhabilitar','DELETE','recursos/clientes',1,'2024-06-06 13:31:24',NULL),(64,'Usuario - Listar Usuario Rol','GET','seguridad/usuarios/rol',1,'2024-06-06 13:38:30',NULL),(65,'Tipo Persona Sistema','GET','parametria/tipopersonasistema',1,'2024-06-06 13:45:33',NULL),(66,'Tipo Destinatario Factura','GET','parametria/tipodestinatariofactura',1,'2024-06-06 13:45:54',NULL),(67,'Tipo Producto - Habilitar','PUT','parametria/tipoproducto/habilitar',1,'2024-06-06 13:47:43',NULL),(73,'Lista Personas','GET','lista/personas',1,'2024-06-06 14:07:33',NULL),(74,'Lista Localidad','GET','lista/localidad',1,'2024-06-06 14:07:34',NULL),(75,'Lista Provincia','GET','lista/provincia',1,'2024-06-06 14:07:34',NULL),(76,'Proveedores - Habilitar','PUT','recursos/proveedores/habilitar',1,'2024-06-06 18:20:04',NULL),(77,'Clientes - Habilitar','PUT','recursos/clientes/habilitar',1,'2024-06-06 18:22:25',NULL),(78,'Personal - Habilitar','PUT','recursos/personal/habilitar',1,'2024-06-06 18:22:25',NULL),(79,'Inventario - Habilitar','PUT','recursos/inventario/habilitar',1,'2024-06-06 18:22:25',NULL),(80,'Sucursales - Habilitar','PUT','parametria/sucursales/habilitar',1,'2024-06-06 18:22:25',NULL),(81,'Tipo Forma de Pago - Habilitar','PUT','parametria/tipoformadepago/habilitar',1,'2024-06-06 18:22:25',NULL),(82,'Tipo Impuesto - Habilitar','PUT','parametria/tipoimpuesto/habilitar',1,'2024-06-06 18:22:25',NULL),(83,'Inventario - Agregar Stock','POST','recursos/inventario/stock',1,'2024-06-06 18:22:25',NULL),(84,'Tipo Rol - Habilitar','PUT','seguridad/tiporoles/habilitar',1,'2024-06-06 18:22:25',NULL),(85,'Inventario - Tipos Aumentos','GET','recursos/inventario/tipoaumento',1,'2024-06-06 18:22:25',NULL),(86,'Inventario - Aumento por Producto','GET','recursos/inventario/aumentoporproducto',1,'2024-06-06 18:22:25',NULL),(87,'Inventario - Agregar Aumento','POST','recursos/inventario/agregaraumento',1,'2024-06-06 18:22:25',NULL),(88,'Tipo Categoria - Habilitar','PUT','parametria/tipocategoria/habilitar',1,'2024-06-06 18:22:25',NULL),(89,'Inventario - Aumento En Masa','PUT','recursos/inventario/aumentoEnMasa',1,'2024-06-06 18:22:25',NULL),(90,'Lista Localidad por Provincia','GET','listas/localidadesporprov',1,'2024-06-06 18:22:25',NULL);
/*!40000 ALTER TABLE `SistemaAPIs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SistemaModuloAPIs`
--

DROP TABLE IF EXISTS `SistemaModuloAPIs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SistemaModuloAPIs` (
  `IdSistemaModuloAPIs` int NOT NULL AUTO_INCREMENT,
  `IdTipoModulo` int NOT NULL,
  `IdSistemasAPIs` int NOT NULL,
  `IdUsuarioCarga` int NOT NULL,
  `FechaAlta` datetime NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdSistemaModuloAPIs`),
  KEY `fk_SistemaModuloAPIs_TipoModulo1_idx` (`IdTipoModulo`),
  KEY `fk_SistemaModuloAPIs_SistemaAPIs1_idx` (`IdSistemasAPIs`),
  KEY `fk_SistemaModuloAPIs_Usuario1_idx` (`IdUsuarioCarga`),
  CONSTRAINT `fk_SistemaModuloAPIs_SistemaAPIs1` FOREIGN KEY (`IdSistemasAPIs`) REFERENCES `SistemaAPIs` (`IdSistemaAPIs`),
  CONSTRAINT `fk_SistemaModuloAPIs_TipoModulo1` FOREIGN KEY (`IdTipoModulo`) REFERENCES `TipoModulo` (`IdTipoModulo`),
  CONSTRAINT `fk_SistemaModuloAPIs_Usuario1` FOREIGN KEY (`IdUsuarioCarga`) REFERENCES `Usuario` (`IdUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SistemaModuloAPIs`
--

LOCK TABLES `SistemaModuloAPIs` WRITE;
/*!40000 ALTER TABLE `SistemaModuloAPIs` DISABLE KEYS */;
INSERT INTO `SistemaModuloAPIs` VALUES (1,1,4,1,'2024-05-09 21:52:24',NULL),(2,2,1,1,'2024-06-06 07:25:24',NULL),(3,3,2,1,'2024-06-06 07:25:24',NULL),(4,4,3,1,'2024-06-06 07:25:24',NULL),(5,7,5,1,'2024-06-06 07:25:24',NULL),(6,7,6,1,'2024-06-06 07:25:24',NULL),(7,7,7,1,'2024-06-06 07:25:24',NULL),(8,7,8,1,'2024-06-06 07:25:24',NULL),(9,7,9,1,'2024-06-06 07:25:24',NULL),(10,7,10,1,'2024-06-06 07:25:24',NULL),(11,7,11,1,'2024-06-06 07:25:24',NULL),(12,8,12,1,'2024-06-06 07:25:24',NULL),(13,8,13,1,'2024-06-06 07:25:24',NULL),(14,8,14,1,'2024-06-06 07:25:24',NULL),(15,8,15,1,'2024-06-06 07:25:24',NULL),(16,9,16,1,'2024-06-06 07:25:24',NULL),(17,9,17,1,'2024-06-06 07:25:24',NULL),(18,9,18,1,'2024-06-06 07:25:24',NULL),(19,9,19,1,'2024-06-06 07:25:24',NULL),(20,9,20,1,'2024-06-06 07:25:24',NULL),(21,11,21,1,'2024-06-06 17:59:13',NULL),(22,12,22,1,'2024-06-06 17:59:14',NULL),(23,15,23,1,'2024-06-06 17:59:14',NULL),(24,16,24,1,'2024-06-06 17:59:14',NULL),(25,18,25,1,'2024-06-06 17:59:15',NULL),(26,35,26,1,'2024-06-06 17:59:15',NULL),(27,36,27,1,'2024-06-06 17:59:15',NULL),(28,13,28,1,'2024-06-06 17:59:15',NULL),(29,13,29,1,'2024-06-06 17:59:16',NULL),(30,13,30,1,'2024-06-06 18:00:52',NULL),(31,13,31,1,'2024-06-06 18:00:52',NULL),(32,14,32,1,'2024-06-06 18:00:52',NULL),(33,14,33,1,'2024-06-06 18:00:53',NULL),(34,14,34,1,'2024-06-06 18:00:53',NULL),(35,14,35,1,'2024-06-06 18:00:53',NULL),(36,17,36,1,'2024-06-06 18:00:53',NULL),(37,17,37,1,'2024-06-06 18:00:54',NULL),(38,17,38,1,'2024-06-06 18:00:54',NULL),(39,17,39,1,'2024-06-06 18:00:54',NULL),(40,20,40,1,'2024-06-06 18:01:18',NULL),(41,20,41,1,'2024-06-06 18:01:18',NULL),(42,20,42,1,'2024-06-06 18:01:18',NULL),(43,20,43,1,'2024-06-06 18:04:15',NULL),(44,34,44,1,'2024-06-06 18:04:15',NULL),(45,34,45,1,'2024-06-06 18:04:15',NULL),(46,34,46,1,'2024-06-06 18:04:16',NULL),(47,34,47,1,'2024-06-06 18:05:53',NULL),(48,29,48,1,'2024-06-06 18:05:53',NULL),(49,29,49,1,'2024-06-06 18:05:53',NULL),(50,29,50,1,'2024-06-06 18:05:53',NULL),(51,29,51,1,'2024-06-06 18:06:50',NULL),(52,22,52,1,'2024-06-06 18:06:50',NULL),(53,22,53,1,'2024-06-06 18:06:50',NULL),(54,22,54,1,'2024-06-06 18:06:50',NULL),(55,22,55,1,'2024-06-06 18:07:46',NULL),(56,23,56,1,'2024-06-06 18:07:46',NULL),(57,23,57,1,'2024-06-06 18:07:47',NULL),(58,23,58,1,'2024-06-06 18:07:47',NULL),(59,23,59,1,'2024-06-06 18:10:05',NULL),(60,28,60,1,'2024-06-06 18:10:05',NULL),(61,28,61,1,'2024-06-06 18:10:05',NULL),(62,28,62,1,'2024-06-06 18:10:05',NULL),(63,28,63,1,'2024-06-06 18:10:05',NULL),(64,7,64,1,'2024-06-06 18:10:05',NULL),(65,3,65,1,'2024-06-06 18:10:05',NULL),(66,19,66,1,'2024-06-06 18:10:05',NULL),(67,13,67,1,'2024-06-06 18:10:05',NULL),(68,23,76,1,'2024-06-06 18:10:05',NULL),(69,28,77,1,'2024-06-06 18:10:05',NULL),(70,22,78,1,'2024-06-06 18:10:05',NULL),(71,1,1,1,'2024-06-06 18:10:05',NULL),(72,21,83,1,'2024-06-06 18:10:05',NULL),(73,8,84,1,'2024-06-06 18:10:05',NULL),(74,21,85,1,'2024-06-06 18:10:05',NULL),(75,21,86,1,'2024-06-06 18:10:05',NULL),(76,21,87,1,'2024-06-06 18:10:05',NULL),(77,14,88,1,'2024-06-06 18:10:05',NULL),(78,20,81,1,'2024-06-06 18:10:05',NULL),(79,34,80,1,'2024-06-06 18:10:05',NULL),(80,21,89,1,'2024-06-06 18:10:05',NULL),(81,21,79,1,'2024-06-06 18:10:05',NULL);
/*!40000 ALTER TABLE `SistemaModuloAPIs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `StockSucursal`
--

DROP TABLE IF EXISTS `StockSucursal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `StockSucursal` (
  `IdStockSucursal` int NOT NULL AUTO_INCREMENT,
  `IdProducto` int NOT NULL,
  `IdSucursal` int NOT NULL,
  `Cantidad` decimal(18,2) NOT NULL,
  `IdUsuarioUltMod` int NOT NULL,
  `FechaAlta` datetime NOT NULL,
  `FechaUltMod` datetime DEFAULT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdStockSucursal`),
  KEY `fk_StockSucursales_Producto1_idx` (`IdProducto`),
  KEY `fk_StockSucursales_Sucursal1_idx` (`IdSucursal`),
  KEY `fk_StockSucursales_Usuario1_idx` (`IdUsuarioUltMod`),
  CONSTRAINT `fk_StockSucursales_Producto1` FOREIGN KEY (`IdProducto`) REFERENCES `Producto` (`IdProducto`),
  CONSTRAINT `fk_StockSucursales_Sucursal1` FOREIGN KEY (`IdSucursal`) REFERENCES `Sucursal` (`IdSucursal`),
  CONSTRAINT `fk_StockSucursales_Usuario1` FOREIGN KEY (`IdUsuarioUltMod`) REFERENCES `Usuario` (`IdUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StockSucursal`
--

LOCK TABLES `StockSucursal` WRITE;
/*!40000 ALTER TABLE `StockSucursal` DISABLE KEYS */;
INSERT INTO `StockSucursal` VALUES (1,1,1,10.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(2,3,1,15.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(3,4,1,20.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39','2024-05-09 21:52:39'),(4,5,1,25.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(5,6,1,30.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(6,3,2,35.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(7,4,2,40.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(8,5,2,45.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39','2024-05-09 21:52:39'),(9,6,2,50.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(10,7,2,55.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(26,7,3,10.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(27,8,3,10.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(28,9,3,20.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(29,10,3,20.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(30,21,3,10.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(31,22,3,10.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(32,23,3,20.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(33,24,3,20.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(38,22,4,30.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(39,23,4,20.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(40,24,4,20.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(41,25,4,20.00,1,'2024-05-09 21:52:39','2024-05-09 21:52:39',NULL),(42,1,3,20.00,7,'2024-06-10 19:34:22','2024-06-10 19:34:22',NULL),(43,4,3,20.00,7,'2024-06-10 19:36:14','2024-06-10 19:36:14',NULL),(44,4,3,20.00,7,'2024-06-10 19:36:18','2024-06-10 19:36:18',NULL),(45,47,1,200.00,1,'2024-06-10 19:36:18','2024-06-10 19:36:18',NULL),(46,4,3,20.00,3,'2024-06-10 19:55:05','2024-06-10 19:55:05',NULL),(47,4,3,20.00,3,'2024-06-10 19:55:14','2024-06-10 19:55:14',NULL),(48,4,3,20.00,3,'2024-06-10 20:05:51','2024-06-10 20:05:51',NULL),(49,4,3,20.00,3,'2024-06-10 20:24:59','2024-06-10 20:24:59',NULL),(50,4,3,30.00,3,'2024-06-10 20:26:00','2024-06-10 20:26:00',NULL),(51,4,3,30.00,3,'2024-06-10 20:27:44','2024-06-10 20:27:44',NULL),(52,41,3,5.00,5,'2024-06-10 23:06:40','2024-06-10 23:06:40',NULL),(53,41,3,50.00,5,'2024-06-10 23:09:15','2024-06-10 23:09:15',NULL),(54,41,3,6.00,5,'2024-06-10 23:09:56','2024-06-10 23:09:56',NULL),(55,46,3,2.00,5,'2024-06-10 23:25:37','2024-06-10 23:25:37',NULL),(56,46,3,15.00,1,'2024-06-12 22:47:13','2024-06-12 22:47:13',NULL),(57,49,3,20.00,1,'2024-06-12 23:31:22','2024-06-12 23:31:22',NULL),(58,40,3,50.00,1,'2024-06-13 17:27:22','2024-06-13 17:27:22',NULL),(59,40,3,35.00,1,'2024-06-13 17:39:16','2024-06-13 17:39:16',NULL);
/*!40000 ALTER TABLE `StockSucursal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Sucursal`
--

DROP TABLE IF EXISTS `Sucursal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sucursal` (
  `IdSucursal` int NOT NULL AUTO_INCREMENT,
  `IdDomicilio` int NOT NULL,
  `Descripcion` varchar(45) NOT NULL,
  `IdUsuarioCarga` int NOT NULL,
  `FechaAlta` datetime NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdSucursal`),
  KEY `fk_Sucursal_Usuario1_idx` (`IdUsuarioCarga`),
  KEY `fk_Sucursal_Domicilio1_idx` (`IdDomicilio`),
  CONSTRAINT `fk_Sucursal_Domicilio1` FOREIGN KEY (`IdDomicilio`) REFERENCES `Domicilio` (`IdDomicilio`),
  CONSTRAINT `fk_Sucursal_Usuario1` FOREIGN KEY (`IdUsuarioCarga`) REFERENCES `Usuario` (`IdUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sucursal`
--

LOCK TABLES `Sucursal` WRITE;
/*!40000 ALTER TABLE `Sucursal` DISABLE KEYS */;
INSERT INTO `Sucursal` VALUES (1,1,'Sucursal Eva Peron',6,'2024-05-09 21:52:39',NULL),(2,3,'Sucursal Kirchner',1,'2024-05-09 21:52:39',NULL),(3,4,'Sucursal Galpon',1,'2024-05-09 21:52:40',NULL),(4,5,'Sucursal Centro',1,'2024-05-10 19:40:53',NULL),(5,6,'Sucursal c5',1,'2024-05-10 19:41:27',NULL),(6,8,'Sucursal Incone',1,'2024-05-21 17:05:27',NULL),(7,11,'Sucursal San Martin',24,'2024-05-21 21:54:31',NULL),(8,12,'Sucursal Pilar',1,'2024-05-21 22:04:32','2024-05-09 21:52:39'),(9,13,'Sucursal Fontana',1,'2024-05-21 22:04:43','2024-05-09 21:52:39'),(10,14,'Sucursal Independencia',1,'2024-05-21 22:04:52','2024-05-09 21:52:39'),(11,15,'Sucursal Resguardo',1,'2024-05-21 22:05:03','2024-05-09 21:52:39'),(12,16,'Sucursal Vial',1,'2024-05-21 22:05:16','2024-05-09 21:52:39'),(13,17,'RapiPago',6,'2024-05-22 19:30:04','2024-05-09 21:52:39'),(14,47,'NUEVA',24,'2024-06-11 15:02:12','2024-06-11 15:02:33');
/*!40000 ALTER TABLE `Sucursal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoAumento`
--

DROP TABLE IF EXISTS `TipoAumento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoAumento` (
  `IdTipoAumento` int NOT NULL AUTO_INCREMENT,
  `Detalle` varchar(45) NOT NULL,
  `Porcentaje` decimal(18,2) NOT NULL,
  `FechaBaja` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`IdTipoAumento`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoAumento`
--

LOCK TABLES `TipoAumento` WRITE;
/*!40000 ALTER TABLE `TipoAumento` DISABLE KEYS */;
INSERT INTO `TipoAumento` VALUES (1,'IVA',21.00,NULL),(2,'RENTAS',3.00,NULL),(3,'TRANSPORTE',5.00,NULL),(4,'Ganancias Prod Sueltos',40.00,NULL),(5,'Ganancias Prod Limpieza',40.00,NULL),(6,'Ganancias Prod Automovil',13.00,NULL),(7,'Ganancias Prod Pileta',35.00,NULL),(8,'Ganancias Prod Aromas',35.00,NULL),(9,'Impuestos Generales',20.00,NULL);
/*!40000 ALTER TABLE `TipoAumento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoCategoria`
--

DROP TABLE IF EXISTS `TipoCategoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoCategoria` (
  `IdTipoCategoria` int NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(255) NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdTipoCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoCategoria`
--

LOCK TABLES `TipoCategoria` WRITE;
/*!40000 ALTER TABLE `TipoCategoria` DISABLE KEYS */;
INSERT INTO `TipoCategoria` VALUES (1,'Limpieza',NULL),(2,'Automovil',NULL),(3,'Pileta',NULL),(7,'Sahumerios',NULL),(8,'Bazar',NULL),(17,'Suelto',NULL);
/*!40000 ALTER TABLE `TipoCategoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoDestinatarioFactura`
--

DROP TABLE IF EXISTS `TipoDestinatarioFactura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoDestinatarioFactura` (
  `IdTipoDestinatarioFactura` int NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(45) NOT NULL,
  PRIMARY KEY (`IdTipoDestinatarioFactura`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoDestinatarioFactura`
--

LOCK TABLES `TipoDestinatarioFactura` WRITE;
/*!40000 ALTER TABLE `TipoDestinatarioFactura` DISABLE KEYS */;
INSERT INTO `TipoDestinatarioFactura` VALUES (1,'Cliente'),(2,'Proveedor');
/*!40000 ALTER TABLE `TipoDestinatarioFactura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoDocumentacion`
--

DROP TABLE IF EXISTS `TipoDocumentacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoDocumentacion` (
  `IdTipoDocumentacion` int NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`IdTipoDocumentacion`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoDocumentacion`
--

LOCK TABLES `TipoDocumentacion` WRITE;
/*!40000 ALTER TABLE `TipoDocumentacion` DISABLE KEYS */;
INSERT INTO `TipoDocumentacion` VALUES (1,'Dni'),(2,'Cuil'),(3,'Cuit'),(4,'Pasaporte');
/*!40000 ALTER TABLE `TipoDocumentacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoDomicilio`
--

DROP TABLE IF EXISTS `TipoDomicilio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoDomicilio` (
  `IdTipoDomicilio` int NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(45) NOT NULL,
  PRIMARY KEY (`IdTipoDomicilio`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoDomicilio`
--

LOCK TABLES `TipoDomicilio` WRITE;
/*!40000 ALTER TABLE `TipoDomicilio` DISABLE KEYS */;
INSERT INTO `TipoDomicilio` VALUES (1,'Legal'),(2,'Real'),(3,'Juridico'),(4,'Fiscal');
/*!40000 ALTER TABLE `TipoDomicilio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoFactura`
--

DROP TABLE IF EXISTS `TipoFactura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoFactura` (
  `IdTipoFactura` int NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(45) NOT NULL,
  PRIMARY KEY (`IdTipoFactura`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoFactura`
--

LOCK TABLES `TipoFactura` WRITE;
/*!40000 ALTER TABLE `TipoFactura` DISABLE KEYS */;
INSERT INTO `TipoFactura` VALUES (1,'Factura A'),(2,'Factura B'),(3,'Factura C'),(4,'Factura E'),(5,'Ticket'),(6,'Remito'),(7,'Nota de Crédito'),(8,'Recibo');
/*!40000 ALTER TABLE `TipoFactura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoFormaDePago`
--

DROP TABLE IF EXISTS `TipoFormaDePago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoFormaDePago` (
  `IdTipoFormaDePago` int NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(45) NOT NULL,
  `FechaBaja` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`IdTipoFormaDePago`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoFormaDePago`
--

LOCK TABLES `TipoFormaDePago` WRITE;
/*!40000 ALTER TABLE `TipoFormaDePago` DISABLE KEYS */;
INSERT INTO `TipoFormaDePago` VALUES (1,'Efectivo',NULL),(2,'Tarjeta Bancarizada Debito',NULL),(3,'Tarjeta Bancarizada Credito',NULL),(4,'Tarjeta Billetera Virtual Debito',NULL),(5,'Tarjeta Billetera Virtual Credito',NULL),(6,'QR Billtera Virtual',NULL),(7,'Transferencia',NULL),(10,'RapiPago',NULL);
/*!40000 ALTER TABLE `TipoFormaDePago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoMedida`
--

DROP TABLE IF EXISTS `TipoMedida`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoMedida` (
  `IdTipoMedida` int NOT NULL AUTO_INCREMENT,
  `Detalle` varchar(45) NOT NULL,
  `Abreviatura` varchar(45) NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdTipoMedida`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoMedida`
--

LOCK TABLES `TipoMedida` WRITE;
/*!40000 ALTER TABLE `TipoMedida` DISABLE KEYS */;
INSERT INTO `TipoMedida` VALUES (1,'Centímetros cúbicos','cm3',NULL),(2,'Mililitros','mls',NULL),(3,'Litros','lts',NULL),(4,'Kilogramos','kgs',NULL),(5,'Gramos','grs',NULL),(6,'Miligramos','mgs',NULL),(7,'Unidad','un',NULL);
/*!40000 ALTER TABLE `TipoMedida` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoModulo`
--

DROP TABLE IF EXISTS `TipoModulo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoModulo` (
  `IdTipoModulo` int NOT NULL AUTO_INCREMENT,
  `IdPadre` varchar(10) NOT NULL,
  `Orden` varchar(45) NOT NULL,
  `Detalle` varchar(45) NOT NULL,
  `PathRout` varchar(45) NOT NULL,
  `TipoMenu` int NOT NULL,
  `TipoIcono` varchar(45) NOT NULL,
  `Icono` mediumblob NOT NULL,
  `FechaAlta` datetime NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdTipoModulo`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoModulo`
--

LOCK TABLES `TipoModulo` WRITE;
/*!40000 ALTER TABLE `TipoModulo` DISABLE KEYS */;
INSERT INTO `TipoModulo` VALUES (32,'6','06.03','Enviar Inventario','/gestion/enviarinventario',3,'data:image/jpeg;base64,',_binary 'iVBORw0KGgoAAAANSUhEUgAAAgAAAAIACAYAAAD0eNT6AAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAIABJREFUeJzs3XeYVEX28PHv7Th5yDlnJEkQBSSI5JxzRkUQUNc1re7qurqv/tYEmMOaVqIECYJgFswoYkByBgEJM8OEjvf94w4yM9D39p3b05PO53nm2YWurilh6KpbVeccEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghjCmFPQBRLLmBq4HKhT0QIfIpCOwDtgFqIY9FCCGKhWvRPjhV+ZKvEvD1FVAbIUoh2QEQZtQAfgLKFPZAhIig74FrAF9hD0SIaLIV9gBEsfI3ZPIXJU8bYGhhD0KIaJMFgDCjeWEPQIgCIj/botSRBYAww1nYAxCigLgKewBCRJssAIQQQohSSBYAQgghRCnkKOwBiJLj+vZtKJecZNxQKb7BJ+9+vBmvL/Rl8ZY1qmK3Ga+rbTYlaiE4Z9Iz2XfqdMjXa1SuSIeWzcLrrJj+3f22/yA/7d5X2MMQokiRBYCImEdm38DVzZsaN0xMBIe94AdUACpc2ZXTKaEXAOOuaU282/g4uVJiArYoTaaf797P/A82h3z96uZNWfrYA8YduZwQHx/BkUXPowte5t4nnyvsYQhRpMgRgBBCCFEKyQJACCGEKIVkASCEEEKUQrIAEEIIIUohWQAIIYQQpZAsAIQQQohSSBYAQgghRCkkCwAhhBCiFJIFgBBCCFEKyQJACCGEKIVkASCEEEKUQrIAEEIIIUohWQAIIYQQpZAsAIQQQohSSBYAQgghRCkkCwAhhBCiFJIFgBBCCFEKyQJACCGEKIVkASCEEEKUQo7CHoAQIjRfIECWz48vGCQQDKIANpuC2+4gxunEblMKe4hCiGJKFgBCFEH+QIA0jxeP33/pi0Hw+gOkeTzEOV0kuF3YZCEghDBJFgBCFCGqqpLm8ZDp86Gqxu0zfF6y/D7iXS7i3C5kGSCECJcsAIQoIrJ8PlKzPATDmflzCOZYNCTFxOBy2AtohEKIkkQWAEIUMl8gSGpWFr5AwFI//mCQMxkZxDgdJLrd2G1yx1cIEZosAIQoJAFV5XyW9uQeSVk+Px6/nziXiwSXO6J9CyFKDlkACFEI0j1eMnzesM7580NVte+R5fNb3lkQQpRMsgAQohCke71R+T6BYBCvXxYAQohLySGhEEIIUQrJAkAIIYQoheQIQIgi5GTqeT7asYe9p07jtNtpUaMK3RrXJ9blLOyhCSFKGFkACFEEeP0BPvh1N5t+2YU/GPzz9w+fOccnv+2jb4vGdGlcD5siqX6EEJEhCwAhCpEKbDt0lJVbf+ZsRuZl22R4vSzf+hPf7D/MiHYtqFexfHQHKYQokWQBIEQhOXI2hWXfbmffqdNhtT985hxPb/ycK2tVZ2jb5pSNiy3gEQohSjJZAAgRZRleL+9t38nnu/aZTvurAj8cOsovx37n+qYN6dWsEQ673OUVQpgnCwAhoiSoqny59yBrt/3KeY+1PABef4D1P/3GdweOMLxtc5pVrxKhUQohSgtZAAgRBbtP/ME7323n2LnUiPZ7Ku08L3zyFY2rVGREu5ZUSU6MaP9CiJJLFgBCFKBzGVms2fYL3+w/XKDfZ+fvp3j0vY+5tmFdBrZqitsp/7SFEPrkU0KIAuALaGF9H/y6O1+peMsnJ5GWkYHX5w/7PYFgkE937uXHw8cY0roZberUQIIGhRChyO0hISLs56O/88jaD3lv+2+mJ3+H3c5Nwwawc9Vb/PLO6wzo3MH09z+XkcnrW77jiQ2fcvD0WdPvF0KUDrIDIEQEvfjpV+w/dSZf772+fRvm3TmHZvXrANouwJp5/2bt5q+4/fFn2XPoiKn+Dp4+y5Pvf0at8mXyNR4hRMkmOwBCRFB+Jv8alSvyxkP38sELT/w5+f/J7WbAgN78+uFKnv7HnSQlxJvqO6iqHPhDdgGEEJeSBYAQhSTW7ebuKWPZsfwNJg3olftFpxOSEyEuFhQFp8PBrVPH8duHq5g4tD9KYaQENpeyQAhRxMkCQIhCMKBzB3555zUenXsTCTkz+tlskBCvfdnsl7yvaqUKvPnkw3y96i2uvrJFFEecPTYhRIkh/6KFMMPik3fjOjVZ/8xjrJn3b+pWr5qzY4iN1Z76ncaV/65q2Ywvlr/OG0/8i0rly1kaU9jsly5IhBDFl1wCFNGXkX6ZiTTPr21K7i1nBVDyrFcvNxlf0q2ifdlsuf83ysokJnDP1HHcPn4krrwx+i4XxMaYfsK22WxMGjaAgdd34cGnX+C5t5biD5gPOQybQxYAQpQksgAQ0RcIGrcpSDY7OB3ahOZwmJt4Ta4dFEVhQr+ePH77TCqVy3Mb327Xzvgd1v4Zlk1OYt4DdzFzwihue+g/vP/ZF5b6uyynU3YAhChh5AhAlD7BAHg8kJ4BKamQdh58vrAuuTns4U/WHVo249v/vcCb/7o39+Sv2LSJPzHR8uSfU5P6ddjwxrMseeYxalYNvzaAw3BiV7QdCiFEiSILACH8fjifDqmp4PWitxJoWKeWYXdVK5TnzX/dy5bXFtC2aaPcL8a4ITkB3G7TuwnhGtW/F799uJL7Z99IjNtl2L5R7Zr6DeJj5elfiBJIFgBCXBAMarsCqee1RcFlzJo4KuTbXU4Hd00ew86VbzKxf6/coXoOByQlahf98t5lKABxsTH8645Z/LJxOUN6XRe6XYybKYP6hHhV0aIRXMaLCBERClATSCrsgYjSQRYAQuQVCGjHAplZl2wGjB3Uh7/PufGSOPy+na7mp6Wv8ditM0iMj7v4gt0O8XGQmFAoT9H1atVg5YtPsvGt52naoG6u15Li41n86D+olysaAW0acrnCjkgQlpUH7gH2A4eAc8CXwJWFOShR8sklQCFCycrSdgLi47WohGwP/WUWE4cN4P3PvsDvD9ClfRvaXNFYa6uq2pfNZv6CYQHqee01/LThHTZ+/iW/7N5L+TLJDO7ZlXKJCeAPaGNGAXv2uAsj0VDp0wKYC4wHciSDQAGuATYDVwO/RH9oojSQBYAQevx+SEvVnuBzJOZpWKfWpfcBivhWud1uo2+3TvTt1inPC/IxEEV2YCDaxB/6bEYTD/wbGFzQgxKlU9F4PBGiKAuqkJquHQ0IkT9JwK3AbmAlxpP/BQOBRoathMgHWfoXvupAc6AxUAmIQ1v5nyP3CbQHyMjz3hQgZ1C9F0jP0yYVyDlz+YDzedqkATlvvfmzfy+nvO8pXdQgpKVD0uVT9AoRQhO0p/1JaP+uzVKAWcBtkRyUECALgMLSAe3crxfQsJDHEjH959xDcp5qdUkJ8dhznIM7HY7cue+BxLg4HDmyzDkddhJi87SJj8sVr+6w23NftgMS4mIpm5hI5fJlqVyuLE3q1gojxt0ENQhpGZCUIGfkQo8N6IP2xN8T6wGfU4G/c+miXAhLZAEQPQ5gNNpt3+aFPJYCcTolldMpqYU9jD8lxMXSoWUzurZtxbg+1+fJvZ9PwYAWHZBnESMEkAhMAeYQ2YV9Una/CyLYpxByByBKugDfA/+jhE7+RdH5jEw2ffUd9z/7Kg0Gj6fXrDtZ9fFmVNViXVuPB7y+yAxSlAQNgKeBI8B8CmZXbzbyeS0iTH6gCpYb7YPhE7SQH1FIgkGVTV99x9A7/k6X6bfy3a87rXWYkZkdOidKKQVte38NsBNtu78gE/g0QjtWECJiZAFQcCoBn6F9MMiBcRGyedtPXD1pJrc//iy+EBn/DKlBbSdAFH1BVcvyGBnxwM3Az8BGYAAWPkcddjsjenRl/TOPkZTnTstlzM3v9xHicmQBUDBqA1uA9oU9EHF5waDK0wvf4bqbbufYqdP56yTToy0ERNHk92s7NakpkQjhrAP8BzgMPA9cYaWzcsmJ3DV5DHvXLGTZ/z1In47tmTq4r9HbeqFFFQgREbIAiLzKwCa0c0FRxG3Z9jNXT5rJvqPH8/FuFbK8ER+TsMjr1VI5p53XdmmsndR0A1YAe4C/AmWtdNa8QV1evP8ODq9fxmO3zqBWlUraCzYbs6eMxaafOVJBu2AoRERIFEBkudHOBE1dAqpcPoaubStTtWIs1SvFkpzg4myqV1ue2UFVIMvrJysr91PMuRRvrmNojzdIRmbuLe3U8z4CgYuNfP4g5zNyt0lL9+P3X3yS9QdU0tJzX3I7n+HH5y+ZT7tHTpzi+hl/4dNX5l38QA5Xlker8CdhgYVLVbWJP8sTie3+GLQw3TlAK6ud2WwKAzp3YO7Y4XS/qvWlRaJi3OB00iA5if7XdWbNh5/qdTcJuA8tT4gQlsgCILIeB64Kp6HTYWPqkHpMHliPa1pWwJYj1zxOUONVLWloERUMqqSk5V4kZGT68XgufviqqrZIySkzK0BWZu6FzNkUHzkf07I8ATLztElJ8xEMXmzj9QXJSPfnul2RmubjbIqXg8fS+eHXs2R5wt/2PXDsd3rN+ivfvvXCJfkF9GVPPG63ifeIiAkGtF0YrzcSlzJroCXduRGoYLWz5IR4pg3ux+wxQ/MUXFLA7dK+8uSpmDt1rNECIAGYBjxpdXxCyGNL5HQFPiaMP9NB3Wrwn7+0plHtPJeGFVDjVO35Q1ji8Qb55MsT/HfRXlZtOBL27sWkAb1446F7zX0zm02rnCf/nKJEBZ9fe9oP8xLno68t5N4FL+s1OQZUBCyXP2xcpyZzxgxj8oDeuZNe2W1avQh36B0jVVVp3nsEv+7ep/ct9qFFBUhuamFJEX7GLFYcwDq0D5CQbDaFR+ZcyTP3XkWFMpc+MarxMvlHisOu0KBOIiMH1GLUwFrsP3Se3fuNE6n9uGsvjWrVpEXDeuF/M1XVtnILodxvqXJhmz89AzxeU1v9m7f9xIfffK/XJBELn4eKotCnY3sW3D2Xp+64hfbNm+K6UErZ4dASR8XGgVO/0qKiKDjsdtZ+9LnetyuLllfEYiyrKO3kEmBkjAOa6jWw2RQWPtqJe6c3u/y/f5dM/gWlcf0k1r7ZjXn/aofLafwjf+fTz5ORZTLETy4DFpxgULvNn5Kq/W/kQvosS4yL45ZRQ/htxZusf+Yx+nRsr53xK2hP+8mJWiVJpzPsDaKJQwdQNtkwpYCEBArLZAFgnYKW3lfXI3NaMbp37ZCvq2aOnUW+zJnaiBWvdjFcBBw7dZpnl6w017nfJ9UCI0rVtvfPp2sTv8dj6Yw/5XzeGlnW1K9RjSfvmMXhDUt55p5baVS7hvaCzQaxMZCUDPFx+SocFRcbww2jhxo1644kFxMWyaGlddcCuvt1g7rV4N15XUM3cICaLFnlomXJ6oOMnbVFt0355CQOrFt8SeEiXW4XxMlKzpIL2/weDwSsPen7/H7e+eBT5i1cztc/77A8NEVR6H5Va+aOHc6AztfkDtm7cJvfEf6Tvp6DR49Tv+sAAvp/Bi8DN1n/bqK0kkNL6/4GtAv1otNh4915XSmfrHNL3K1G4OqRCFfzxmX4/WQmW7efCdkm0+OheqUKtG9mIu9KMKgtAiQk0LxAdmbF9Azw+Sw97Z88c46n3l7GhPse4fU173P05B+WhhYX42bqoL688dC9/HXSaBrXqZkdyqdo2/zxcRATo90BidBffZmkRH7csZsde/brNbsCeAHIjMx3FaWNfFJZtw+oG+rFmaMa8tx9+gkB5fJf9KWm+WjQaTV/nAl91t+4Tk12LH8jd9y2kbhYCQk0w3/hNr/PasIefvhtN/MXr2DRhg/xRKBYU+2qlZk1agg3DOlPueTEHK8o2jZ/AS/2Pv16K93G3GDU7B7gsQIbhCjRZAFgTW3ggF6DL97sTYdW+iHFapwKUl026h5/YQd3PfyDbpsLF7vCZrNBUpL8y9Kjoj3lZ2ZpcfwW+AMBVn28mfmLVvD5D9sjMrwubVoyd+xwhlx3LfZQmfnKJIFS8Feoruw3mh937NJrchioB+SzqIUozeQSoDUt9V6sXimOa1oa5xNRgjJbFIYZExqQnKh/9jJ/0QpznQaD2uQmLhUMapN+Siqkp1ua/FPOpzNv4XIaDBrPyLsetDz5u11ORvbsxpdvPMunr8xj+PVdQk/+oIUhRsHcKWONmtQEDG8MCnE5sgCwprHei9e2rhjeDqHMF4UiMcHJ5JH68f4bvviGnQcOm+tYqgTmlvM2f1aWpQJKP+/Zz00PP0G1XsO57fFnOHj8RESG+Ny9t7P0sQe4pkWYNX6yLNcYCMu4wf2oWM6w/ICEBIp8kQWANeX1XqxVNT68XgLIBl4hmT2tUe40zHmoqsozpkMC/RISiApeH6SmaUV5LOyKBINBPvh6KwNv/RstR0/n5RVrzedpMPDqqnXm3nAhWqGAxbhd3DRuuFGza9G5iCxEKLIAsEY3W0f1SuEf7CsZcgxQGBrUSaRf92q6bd5Y8775OPLSugsQVLWn/HPZ2/wWFkIp59N56u1lNBw8gZ4z/8raz79EtZ7v/7K++PEXvvvVZGK9CC9CQpk5fiROh2HZltnRGIsoWWQBYI3up5vXZ2Kr0wdkyiKgMMyZpnuSQ1pGBq+tXm+uU4/P0lZ3seMPaCF8KSnaOb+FiXrngcPMfnQeNfqM5C9PPJfPUs0XJca46dmskf6ZPvm57xEIuxaBFdWrVGJ43+uNmo0BTJayFKWdLACs0Y2/PXkmy1RnSgaQYWU4Ij96dK7CFY2Sdds8s3glQVMpaFVtEVCiqdrWflqa9mVhS1xVVdZv+Zq+s++m6fDJPLt0FeczrIW31ypfhokd2/LQkN4MuvIKWteqrtt+ycaP+P106NwQlxWlnZ65U8YZNXEDM6IwFFGCyALAGt1HkyMnzM/mSqaCkqqAX3YDokVRYPbURrpt9h45xrrNX5nruKQeA6hBbZs/JU273OfP/zZ/WnoGzyxZSZNhk+g35x42fPGNpW1+u81Gm9rV+UuvLtzZpxvt69bEYdc+5no1b6j7Xq/PzwvvrDb3DX2+qNQm6NCmJVe1bGbU7GbAVeCDESWGzDLWDARCfmJULOvm94+G614y02UDnKDaASX7Q/GSrpSLr/35Wwq5rihf7tsrl/l9o1+XYBmZfmpdtYoz50I/xfa4ui2bnn/cXMfxcVq2uJLAH9Ce8r3Wb8DvO3qcl5av4eWVazmTYlyl0Uisy0n7urW4vmkDysZfvHujKBDrdBLvcmG32bhvxXp2nQidGbBSuTIcfG8JMWb+zmJitMRABex/q9Yx8fb7jZqNBxYW+GBEiVCKPuILRHXgiF6Dr/7Xm6tbGOcCKBZCLSTyyruvFM77FPXS37SpoCq5fq39UgG7qhVhjuBP8F0P/8DjL+jnjP9xyau0NFMq2OHQqsEVZz5fdrY+6+fdm7f9xPxFK1jx4WcEIvDkXCkpgc4N69KxQR1cjouZze02G3EuF3FOR65Mjpt3H2DeB7qlO3jzX/cysX+v8AehKJCcVOApoL0+H7U79eX3U6f1mm1FIgJEmKQWgDVpwCS0+tyXpapaMaASS73MVzCMr0DeL+XS3/MrWnjkhS+fguJTUHygeBSULAUlSMQWAg3rJvHM67t0768Fg0EGdukYfqfBILicWobA4kTNkZvf47W0zZ2R5eG11RuY/I//x2OvL+LXfQcsbfPbFIWWNasxun0rhrZpTp0K5f684Od2OEiKcZMUE4PLbr8kjXP1skl8+NsesnyhFzOHT5zipmEDTA7Kpi32CpDdbic9I5NPvvpOr1k1YANwtEAHI0oE2QGwbgE6ITgOu8IvKwfQqLZhfW+RXwqoCWpETj+H3/A5KzeETvwTF+Pm8PpleXLDG7hQMKY4CAS0CT8C2/wHj5/guaWreGXVuohs88e5nHSoX5sujetRLsefpw2FWLeTOKfT8KY/wPKtP7H4m226bba89gwdWxmeuV9kt0OSiZ+JfPr91GnqXNsPj/6Fy4VoRwFC6JIdAOtSgWmhXgyqsP9IOmP71pEicQVI8SpaRUWLP9GVK8bwxrLQFdh8/gDlyyTR6crm4XcaCGoFgorsD4AKPj9kZGohfBaTGH32/XbuePI5Zv37KTZv+4lMi2lzqyQn0r9VUyZ2aEuz6lWIdeVO32xTFMrExWEL88+3Rtlk1v+0k6DOLkR6ZiYjeuiU8M5LVbUdAHvB7vQkxMexa/9Btv+2W69ZY+C/aDuUQoRUVD+RihMF+BFoodfon7Na8o8Zuk2EVQqoZVTLsS1X9nyP7TvOhXy9dtXK7F2zMKynzT/FxmiXxYqSC9nssjyWb7Jneb0s2vAh8xetYNvOPZaHpigKzapVpmvjejSuWsnwgyo5NpZYZ/hb8M9+/AWf/LY35OtOh4N9axZSo3LFsPvE6YSEMLN/WvDdT79y1SDDB/x/Af8o8MGIYk12ACLjPAYFOT7bepJ6NRJo1cgwr7ewQFEVy0cBTqeNNZtCH6GmnE+nZcP6XFGvdvidBoIQ46JIrLmDAcj0QEaGdsHPwnn8sVOneez1RUy4/98s2vCh+Tj6EG7qeg39WjahQmJ8WH9iqhok1sTN/YqJ8Wz6NfRTdDAYJDbGxfXt24TdJ8EguJ0FXiWwWuWKbNr8FYf16yA0RTueLO05qYUOWQBExi/AYKBKqAaqCqs+PkymJ0D39lXM1ZgX4QuiLQAsfAY3a1yGl9/eQ3pG6Itiv58+w9RBfU30qmrnxPbC+ienamF8GZnal8Vt/q07dnHP/Je44aH/8MnWbWRkmUt6ZcTttNOiRtWw2wdUFbfDEdauTFBVSY6N5ZdjJ/hDJ8Xzjv2HmDNmaDhpeC9SFG0noIAlxMXyzvoP9JrEA3vQdieFuCxZAESGCuwAJmPwiLflh1Ns2XaKKxuXo3L5IrYlXEIoCtp9gHxy2BXOnvOy+ZtTIdscPH6CId2upUqFcuF3HMy+CxBtXq92m9/iVr/X52fx+x9xw0P/4cEXXmf77r0msyOG7/eU81zbsG6u0D5jKjGXmXxVFTwBP2lZHlKzskj3eMnwenHa7fxwKPROT0aWh3o1qtG6iX4CoVz8QYgp+PsejevV4bVlq0nVr1FRC3ipQAciijVZAETOQSAZ6GDUcP/R87y8fA+7D6URF2OnVtV47HbZEYiYgAIxWNptb1w/iQWv7dSdL70+P4O7dQq/U1XVng6jFRKoqlpBniyPpW3+E6fP8uT/ljH+vod5c91Gjp0KnUgnHPGxMQzq2pEd+w+GbBNUVeJcTupX0i24mYs/GCTO5cy1u+YPBDiXmUWG13tJ3oFKSQl8ve+QbkjgweO/c/OIQWGPAYhOSKDNRpbHw0dffKPXrCrwIXCoQAcjii2ZdSLLBXxCGIuAnMomuWjXrDw1K8dRq2o8MS47NhskJ+Q+04yNsRPjsl/y3pxi3HZi3bnbJCc4c2UjdDltxMfm/oBKjHfiKEGLEDUeiLEWxzZm5maWrgn92RnjcnFo/RIqli0TfqcuJ8QX/EUxVLT8/Ba2+rfu2MX8RctZsvFjPF7rdQ3qVq/KLaOGMH1IP8okJtBm3E38oHObvWxcLA8O6RX27X6AeLeLxOxdFl8gwJmMDN21zwe/7ubdH37R7fPjl56iW7srwx6D9o83kYL+eP3j7DlqdexDpn5VwneAkQU6EFFslZxP/KKjIvAF0KCwB2KFw66QGJ97OzUhzoHTcfHp1WZTSE7I3SYuxoHbdbGNoiiUSczdJsZlJzYm9yKlTKIr166p22knLsZB7WrxDOhSnYQ4k09UDlCTrS0Atnx7is5DN+m2efiW6dw3fYK5jpOTCn4XICM7gY9J/kCAFR99zvxFy9my7eeIDOW6q1ozZ8xQBnXtlOuM/vV1m5j693/rvnda56sMi/jkZFMUKibEE1BVzqRn6Ib6AWR4vfx95ft4deoZDL2uMyueeCjsMQCQkAAmohLya/rd/+S/S1fpNfED9ZFdAHEZsgAoGDWBTWjxuMKiimXdLH+yC53bmKt2qiaplu4CAFzVbwNbt4e+2V69UgX2r11k7qJYQYcEBgNaoR4T/jiXwssr1vLcsnc5ciL03YdwxbrdjO/XgzljhuVJnaxoE2NMDFmBALU69uHUmbMh+6lfsTy39eps6nsnxcSQ6fPhC3P3Y/HX29iy50DI1+02G3tWv02daiHv+F7K6dAWAQXsxx27uLLfaKNmjwH3FPhgRLEjdwAKRiqwFO0ooFYhj6XYy8gK8O4nR5g2pMElRxd6FFXRiqRaEOO2s2pD6HIPaekZXFGvDs0b1A2/00AA3DEFt/zOCD+Zz/bd+7jv2VeY9uD/8f6X35Kabq0edc3Klbh32jj+98h9jO51HZXLZ4e92hTtvzk+TrsIabPhcNhJPZ/OZ998H7K/sxmZtKhRhWQTxXY8fr/hk39O5RPi2Lw7dPInVVVxOhz0usZEiv1gUMsAmd9CYGGqUrE8n369lQNHjuk1uxASaL2YgyhRilmC8mLlJNAdeBwtOE1YcCbFy1Nv6RfquYQX7UKgBaMH1aZyRf3JZ/6iFeY6vZCAp6AYFO0JBIOs/PhzrrvpdlqNns6rq94j02Lp4k5XNmfJYw+wb+1C7pk6jvLJ2amvHXbtzkNysrbzkefoY+aEkYa7J5/sDJ2wJxKqlkmiURX9hD+vrnqP9EyToY7e6JSDnjtlrFGT8oDJcypRGsgCoGD5gDvRdgJCP+aIsLy8fA+ZHnOX2hSL4elul40ZE/XDwL7c/gvf/vKbuY71L27ln6qGDPU7l3aex99cQoNB4xl2xz/45Dv9fPhG3C4nkwb04ru3X2Tzfxcwqmc3HHY7oGhPv0kJkJioXXwMoVrliozo10P3+3x/4ChpBfXnla1r4/q6r59NTeOtdRvNdZq+5ITxAAAgAElEQVTlxXJBhTAM6tGNOjWqGTWbU+ADEcWOHAFEx1HgZWA7UA+tjLAwKSMrQN3qCbRpaiL2PoB2DGAxJPCZ/+4iEAz9YZ7p8TKsu4mzalXVzokjfRlQVbUqfjns2H+Qfzz/GlMeeJR1m7/iXNp5S9+iaoXy3DlpDP97+D4m9O9JtYrZoXqKTYuBj48Htyvs/7bqVSrz6pKVIV8Pqipup4OGlQuurHalxHi+3X+EDJ1oh/1HjzNr5GBzSbzsjgJP/mSzKfgDATZ9/pVes8rA50Dosw5R6sgOQPSowAqgPdASeBT4gWg8IpQg8xeafNJWAa+1Y4CqlWIZNVD/KsfSTR+bT4Nrcdv9snJMTu9t/pret9xJsxFTeeGd1ea3sPNo37wJ/3v4Pg6sW8w/bpp08XzfYdfO9sskZm/zm/vzvqZ1C9q30i+utHn3gUvi+MNx3uPlbEam4Z0ARVHo0riebptf9x3kg6+3mhtAIDrH7tNHDSE+Ltao2dxojEUUHxIFUPjKAFegRQxUAMqiLcwcQN76ovHkznRvQ0s+lFMcua++KdnfI6dYtFQ5ecdRLH4ePn61B93aVQ7/DfbsIkEWfPvjaa7u/75umwdmTObBGVPC71QBkiIfEpj++0mG/+V+3v/yW8t9OR0ORvToytyxw7imxRV5XnRqT/wRSHrz9qr3mHD7fbptJndqS7s6NcPq7+jZFJZ9u519p06jooUHJsfFUD4+jnIJcZSPj6dcfBzl4mMplxBH2bhYvIEAf1/5Ph6dxEADOndgzTz90MVcolQgCGDm/Y/wwtvv6DUJAI2AfVEZkCjyisUHvigUbrTFRE4fACGro7z+z3uoVaVSric1n9/P+YzMXO3SfH786sU2fn+AtBwpTf/13H9Jz8z9npyGdq/Jiqe6hPdfkS0SIYGdBm/ky62hs+BVLl+Wg+uW4NY5875ETIz21BxBs+79F88vNnkxMY+KZctw07ABzBo15OIWP2g7DC6XNvFHcOHi9fmoc20/jp8M/edbu3xZ/trHuETvidQ0nnz/M93t/LwURSE5Vgsf1FsA2GwKO1e+RYOaYZ7iRXEB8OvufTTvPQJVf7fjSeCOqAxIFHkFn6lCFFee7K+cdK+uN6lbi6ubNzXuOTFR2zYOYf/xE7y4MPSTzOpPjnDgWDp1qoX/wapkgmpxATBnWmPdBcCJ02dZuuljJvbvFX6nHm9Ec8dneby8vmpdvt/fuklD5owZytg+1xOTs7qe3a6N0+kqkMcGl9PJzeNH8sBTz4dsc/D0WQ78cYY6OvUXfIEAr23+ztTkD1qo37mM0IvOC4JBlQWLVzDvzjDv1BVwGGBOVzSsR49OV7Nps+5dgGnAA2gVTEUpJ3cARJEzZ/IY3YtWgaDKs4t3muvUp1gOCRzevybVq+TdFMnNfEhgMKIhgSdPnzFKDXsJh93OiB5d+fSVeXy/8CWmDuqbe/K32SApUXvyL8D5bMa44bgNSvp+slN/93rV979w9GxKJId1iddXbyAt3HwJjoKvDJjT3KmGIYFlgElRGIooBmQBIIqcZo3qc33H9rptXl25l/RMcxesrIYEOh02bp6kHxL43a87+eJH/dzyl8hHyt5QKlcoF85lMADKJSdy1+Qx7F2zkGX/9yBd2rS8fMNgEHS2xSOlcoXyjB6gv3uy7dAxUkJcZtx++Dif7yr44+3U9Aze1i/Fm02JSjrgnPp1u5YGtQ3vScxBjn8FsgAQRZTRk8zZVC9vrTUZ0eTBcszFTeMbEOPWD+uav2i5uU4DAcPkPeFyu1yM7NfTsN1DM6dyeP0yHrt1BrWqhJFiuSAiFi5j7pRxuq8HgkE+33Xp3/vZjEze/uqHqIXUfPztD8aNYlwFXhY4L5vNxuzJY4yaNQFMnFOJkkoWAKJI6n9dZ8MnmfkLd5qrcqsCWdY+kCuWdzN2SG3dNis++tx8Pv0IJroJIzMcmR4vcTEm8iT7fBAo+ISWbVs0pZNB5b0tuw/kyvMfVFXe2PwdGQWZXTEPw5BEu71g6z3omDpyMInGFSclJFDIAkAUTTabjVsm6Rc52bEvhU1fHTfVrxKBXYA50/RrPPn8fp5/511znfp8WhGfCGjdrAmdrwoZrAHAyyvWmk//W0RS2573ePj+4NE/f73+p9/Ye+p0QQ8rl+56f752OyQmRP3p/4KkhHimjBho1KwPWkigKMVkASCKrHCeZOa/bfIyYAAtQbMFVzYrS5er9bfNX1qejwk2gncBbp2qv5X+x7kUFq7/0FynHi/mtlzyZ1jv66lRRT/Pwye/afUBdp/4g40/7zLus3tnflzyKquffoR5d87hLxNGMqx7Z9o2bUSFMnlTaehr06Qh04f0u/yLbnehTv4XzJkyFpt+mKYNmB2l4YgiSsIARZGVnJjAlBEDWfDG4pBt1m85xu5DaTSslTdnUmhKFqj6l80NzZnemM++Phny9QsTbMiJ4nKyvNq2cQQmj8E9u1GrWhUOHfs9ZJv5i5abG9+FIkZuiyUWDTgcdmZNHMXf/rMgZJsjZ1P48fAx3vluu2GWv9pVK/PKP+6kbFJintLE2WJjOB8McvDIcfYfOcrBI8c5cOQYB48ey/7f45w8fZbyZZIZ0/d6Hr7lBtxuV/ZiSAG7TYv3dzkLPO1vuBrWqUWfrh157+PNes2mAPejVS8VpZDcBBVmfAlcE+rFr958LiJ5AHLatf8gTXsMI6hz5jp3XGPm3W2iVCvZmQEtfFb7/SoNr13NwSPpIdu0alSfbYtfMddxXGzEJtj/e/F17n50nm6bj196im4GZ+652OyQHP5iK7/+OHuOWh376IY02hTFcPJ32O18+so8OrZqdvkGTkd2op78fBSq+XxfdLz/2Rf0mXyLUbPbAP0fElFiyRGAKNIa1a1Nn64dddu89u4+Us6b29dXMq19cDscCjMNQgJ/3LXXfMW9rAhcUsh245hhhiGBpvMWBANRCQmsULYM4wb31R9KGMcR/7x5aujJX1EgLo78T+JFd/IH6NW5A00b1DVqditSFK7UkgWAKPKMLoWlpft4Y7XJ+O8IVGq9cXwD4uP0T9HMT7BB8EXmMmDZ5CTGD9bf4l/96Rb2HTV3kRKPxYQKYbpt2nhzlffy6NbuSu7WCyeNj4t8NcYiRFEUZk8yDAmsC5g4BxIlScn96RclRjhPMgsW7SSoU673EiqXJjo2qWyyiwnD6ui2Wf3pFvYX4gQ7d8pYg6yKQZ5fZjZiwR+VkMDmjRrQ9eq2+XpvxbJlePuR+7GHmuDdbu3cvoSbMmIQ5YwvOUpIYCklCwBR5IXzJLPnUBrrtxwz16/FYwDQQgL1HlIDwSDPFeIE26xRfbp3vEq3zSsr111SsMlQEQkJvBxFUfjvg3flLmKUk90OcYUTox9tcbExTB05yKhZD6BFFIYjihhZAIhiIZwnGdMhgUEMyhsZu6JRMt07VdFt88rKdaSHSF8bUgQnWKPseufSzvPWuo3mOs2KTkjgoB7dqFerhqn3/HXSaAZ07hDiVQUSrJz7Fz9zJo/Fbjf8qDe8LShKHlkAiGIhLjaGKSP0n2Q2fnmcn3afM9WvYjEzIMCcafr5VPI1wXq8WqGgCBjQvTP1a+tPok8vfMeojGweakTzFoRit9uYOWFk2O3bXdGYh2dND90gPk6LZChFalevysDrDcsoTwRCbJmIkkoWAKLYmDvF+Enm+aXGSWFy8WG5SuCAHtVpVE8/NG7+ohXmJlg1chOszWbjlon6WRV3HTzCpq+2muvYG4GblGG4YfRQEuL0qzACJMTF8vYj9+MKVYDH7dZi9UuhMI5S4tBKBYtSRBYAotioXb0qA7p30W3zxur9nEkxN3EqJo+/87LZFGZM1A8J3LH/IB98bXKC9XgjNr/eMGYoSQkGWRUX56OIURRCAsskJTJxWH/Ddi/edweNQu102O0QWzrO/S/nug5X0bKJ/s8oWmZASQ5XisgCQBQrRk8yGVl+Xnt3r7lOPap2H8CCaWPqk5ig/3SZr5BAv8W8xdkS4+OZOGyAbpv1W75m96Ej5jqOUpXAOZP1U9tOH9KPcX2vv/yLNjskxhd6et7CNsd4F6AWYHhjUJQcsgAQxUr3ju1p3qiBbptnF+8iYCYkEMVylcDkRCeTR+qHKr635Sv2HD6q2+YSETxnnzN5jG5IYDCo8sySleY69fkjVsRIT9MGdZk1YdRlX2vVqD7z7woRyeZyQVICKPJRN35wP8qXlZBAcZH8qxDFzly95C7A/qPnWfOJuSdZJQIPsrdMaaT7kJm/CdanbbVHQON6dejdJdTteM3rqzeQmp5hruPM6OwCPP2PO/n7nBv/LBDlsNsZ1ac7m158MndpY0XRJv7EBO3SXyl/8r8gNsbNjWOGGTXrCrSKwnBEESALAFHshPMkM39h9EMCG9dPok+3arptXnt3PWlmJ1idfPhmGYUEpqZn8PrqDeY69fkiFrGgx2638dBfZnFm26fs/mQ1p7d9ypLnn6BinVpQJgmSk6BMsvYVHwcOOc7Oa9bEUTiMCxbJLkApIQsAUezExcZww2j9J5mPvz3BjzvPmupXMTkvX86c6Y11X09Nz+D1NWYnWC+YOtIIrU/XjjSpX0e3zYLFK3SLL10ighEL4XA47DSoXTP3pUbFpqX1lad9XTWrVmFo7+5GzcYD+vWYRYkgCwBRLM2ZPAanwRPeM4tNhgQGFPBbm0B6d61KkwZJum3mLzI7wRKxxECKonDLJP2QwD2Hj7J+yzfmOo5gxIIoWEZHaIAbuCEKQxGFTBYAoliqXqUSg3t2023z1tp9nDxjLgOf1ZBARdHuAujZc/goG7741lzHEXzCnjJiEMmJCbptTIcERjBiQRSsa9u15qqWISokXjQLKJ1JE0oRWQCIYsvoScbjDfLqSpMhgV4shwROHlmP5ESjkMB8TLC+yEywCXFxTBs1RLfNxi+/4+c9+811HMG7CqJgGe0CAdWA4VEYiihEsgAQxVbnq9rQrsUVum2eXbwLn9/cjG41IiAh3sG0MfV122z86jt27D9oruOIXgY0zqpouoiR3x+xiAVRsMYM7E2VUMWSLpoTjbGIwiMLAFGsGT3JHD2ZwcqPDpvrNCL1ARpjt4fuR1XzERIYwQm2To1q9L+us26bN9Zs4ExKmrmOZRegWHC7XNw01vABvyPQPgrDEYVEFgCiWBs7qA+VK+g/yeSrSqDFeaxOzXj6X19dt83rqwt3gjUKCczI8vDa6vXmOvVGJyRQWHfz+JG4nIbH/LOjMRZROGQBIIo17UlGPyRwy7ZTfPvLaVP9RqNKYGFPsNd3am+YH37B4hUEzEQsRKlKoLCuaqUKjOzf06jZaEC/3rUotmQBIIq9mRNGGT7JPLPIZEigH61SoAXXX1uFlk3L6LYp7AnW6Ajl4PETrPn0C3OdejxITGDxcPu0CUZNXMDNURiKKASyABDFXtVKFRjRr4dum8UbDvD7H+Zi/CKxCzDLICSwsCfYiUMHGGdVXGy2iJEK3oKvEiisa9uiKde0bmHUbCZQeksplmCyABAlwu3T9Z9kvL4gLy3fY65TH5ZDAicOr0v5sm7dNoU5wcbGuJk+aqhum4+//YEfd5mtsGgu/4IoPEZ3QYBKwMgoDEVEmSwARInQrsUVXH2l/pPMC0t34/WZy8CnWJzHYmPs3DBWPyTw429/YPvufeY6juAEe8uk0Yb54c1HLAS0qAVR5I3o14MaVQwz/94WjbGI6JIFgCgx5hrUOz/+RybLNh4y12mWYnm3febkhjgc+scJC8zuAkRwgq1VrQqDe3XTbfPWuo2cPHPOXMdyGbBYcDoczBhvGBLYBi0sUJQgsgAQJcbI/j2pXqWSbpun/rfDXKcq4LV2F6BW9XiG9K6p2+bt9z7gdEqquY4jOMEabQN7vD5eXbXOXKdeX8SKGImCNWPcCGLcLqNmUiWwhJEFgCgxnA4HM8aN0G2z9dczfLX9D1P9Wq0PAMYhgZkeDy+vWGuuU69XSxEcAV3at6F1sya6bZ5fthq/qUREavaFRVF0aX9HFR0OxhhXCRwG1NB53Q50Rrsv0DZCAxQFSBYAokSZMW44bpf+k8z8hSYTAwWwHBLY+epKtG5eVrfNc0vfNTnBEuFdAP0jlMMnTrLio8/NderxSERgURQIQGYWnEuDjEwIBJg7Rj+fBlpxoJmX+f1ywN3APuAzYCnwHfAR2gVCUUTJAkCUKJXKl2PMwN66bd7ZdIhjp8yGBFoZlWbOtMa6rx8+cZKVhTjBjhnYh4rl9BcpposYqSr45C5AkeH3w/l0SE2DrKxcSaVaN2lI59YtjXq4CYjN/v/NgZeAw8CjQK08ba8DlgHW42lFgZAFgChxjJ5kff4gzy81mRjIq1gOCRwzuDYVyxuEBC4yeRkwghNsjNtleISyZdvPbN1h8s9O6gMUMlW7j5GaBmnndatKzjXIqglUAB4HPgR+Am4E4nTadwF6mRuviBZZAIgSp03zplzbrrVumxeX7SbLY2673WpioBi3nRkT9FPvbt72E9/9avKIIoIT7MwJxvnhTe8CBCQksFAEVe0pPyUV0tPDKiQ1tHtn6lavatRsFmB4YSAHuTxYRMkCQJRIc6fq7wKcOuth0foD5jrNIiIhgS6n/j870zH3EZxgq1WuyPC+1+u2Wfz+R/x++oy5jmUXIHr8AUjPgJQU7ZzfRCSG3WZjxvCBkR5RX0D/hqkoFLIAECXS0F7dqVlVv4bJgkUmn7RVwGNtF6BqpViG99cPCVz8/kfmY+6jWCXQ6/Pz0nKTEQs+X8QiFsTlqNqfcVqa9uXN/7HQ9CH9cDkdERwbCnBLJDsUkSELAFEiORx2Zk0cpdvmh9/O8tnWk6b6VbKs37gzugzo8fp4cflqc51GcIK9pnUL2rdqrtvmhXdW4/WZ3HWQkMDI+3ObP0273Oc3GUWSw/mMTF5asZZuN95m/u/W2GRAv+iEiDpZAIgSa8a44cTF6tcwMR8SqFgOCbymTQXaX1let83zywp3gjXOqniaZZs+Mdepx6tdWhTWXbLNn//F376jx7ln/kvU7j+aGQ8/wS97D0RunBclAlMLomORf7IAECVW2eQkxg3qq9vm3Y8Pc+h4uql+lUzrUU1zpuvvAhz/4zTvfPCpuU4jOMGO7N+TqpUq6LaZvzg/IYEWV0+l2oVt/vOWt/lVVeXDb75n8O330XDweB57fRFnUtIsjc6ongQwG5lzihT5yxAl2m3TxqMooSdsf0Dl2SUmw9p8aMmBLBg1sBbVq+hFT8GT/1tqrtMITrAup5Obx+sXgPvm59/46qdfzXUslwHNU4N5tvnzvz3v8fp4c+1GWo2+gR4338HqT78gaCFds82mMKBzBzY9/zjz75pj1Lw+0D/f30xEnCwARInWrFF9ul3TTrfNy8v3kJ5p7kPVamIgp8PGjeMb6LbZumMXX/9ssnZBhEMCjfLDm85bICGB4QsEtCx9KamWt/mPnTrNgy++TvXeI5j8j//HT3tMVp/MIyk+jrljh7F39ULWzPs3Pa5uy+SBfSiXnGT0VgkJLEJkASBKPKPz7LOpXt5ed8Bcp54IVAmc1JAYt/62aWHG3FcsV5ZR/fVzuLzzwaccOXHKXMeyC6AjxzZ/aprlTI9bd+xi0t//H7X7jeafL75hvuBUHg1r1eDpv87m2MblzLtzDnWqZUfa2GzElU1m2qghRl30APTrdouokQWAKPEG9ehKvVp6NUxg/sLfzB2fRyAksGJ5N6MG5s2emtuyTYU7wd42bbzu6z6/nxeXrzHXqc8XVlKaUkXNLpwUoW3+ZZs+ocPkW2g3fgZvrdtovsZEDjabQo+r27L66UfYufJNbh03nPgLl2sdDkiIh+QkiIlh9uQx2O2G04qEBBYRsgAQJZ7NZmPWBP2QwF/2pvDRN7+b6jcSVQJvvUE/P4rP7+cls1UCIzjBtm7WhE7trtRt8+LyNWSZvZBm4QJbiRLMsc2fkWlpm//302d48MXXqdl3FKPu/qf5+xl5JMbFcdOwAfy87DU2Pf84A7t0zL5Po4DbDUmJkJgAOTJH1q5elUE9uhl1PRHQD4MRUSELAFEqTB89hIQ4/Ut3pkMCg4DFeax187J0uqqibpsX3lldqBOs0RHKqbPnWLThQ3OderyU3jKB6sWiPCkXtvnz/2dxYZu/Vl9tm//UWZNJpPKoX6Maj869iUPrl/Di/XfQtG5t7QW7HWJjoEwSxMVqv74Mo58XtNoB0ywNUkSELABEqVAmKZFJwwfotln72VH2Hj5vqt9oVAk8dfYcizd8ZK7TCE6ww3pfb5hVMV9FjCJYyrhYyLnNb1CUx4jX52fZpk/oNHX2n9v8Pot3Pzpd2Zyljz3AzlVvcfeUsZRJTNBeuLDNn5gIMTGgE1UD0O2adrRq2sjo280GIppuUJgnCwBRatw6dRw2W+gf+WBQ5dklJncBfIrlkMBhfWtSs5rB7sTiwptgHQ47MyfohwRu27mHz77fbq7jrFKyCxAMRmyb/+SZczz2+iLqDxrHqLv/yRc//mJpaAlxsX9u82/+7wJG9uyG3WbTkve6XLm3+U1ceZkz2XAXoBYwKP8jF5EgCwBRajSqW5ue116j2+aVFXtJTTf3ZGa1SqDDoXDzJP0qgT/8tpvPfyi8CTacrIoLzC5SggGIfMrZIiLnNn+q5W3+H37bzYyHn6BO/zHcM/8l8xdD86hbvSqPzr2Jg+u0bf5m9etoL9hs2jZ/UjLEx4Xc5jcyYWg/KpUvZ9RMQgILmSwARKlidD6Zlu7jrTX7zXXqwfI8O2NCQ+Ji9XdETW+zR3CCLVcm2TCr4sqPPmf/0ePmOi5pxwAXtvlTz1ve5g8Gg6z57At6zvwrbcbdxEsr1pJpMd3zhW3+Xdnb/OWSE7UXHHaIj4ck7TY/NmuLWrfLxfTRhiGBXQH9G6aiQMkCQJQqfbt1onG9Orpt5r39m7nsaCpaqWALypVxMW5Ibd02Kz/6nAPHzEUqRHKCvXXaON2sioFgMH8hgcESEBIYCGrJei5s81uIwkg5n868hcupO2Asg267jw++3mppaG6Xk4n9e/Hjklf/3ObX0vYqObb5E8FlbpvfyOxJY3A6DI/5DdMHioIjCwBRqiiKYlglcPehNDZ+ae5JVolAYqC5NzTWvV8VCAZ54Z38VAmMzATbvFEDw6yKL61YS3qmydVQcU4MdGGbPy1VS9drYZt/54HD3PqfBVTrNZzbHn+GQ7+bq1SZV9UK5XlgxmSObFjGm/+6l5YN62kv2JSLt/ktbPMbqVa5IkN7dzdqNh6oXCADEIZkASBKnakjB5F84YZzCOarBGK5SmDzxmXo1kH/s7CwJ1jjrIppvL3+A3OdenzFq0qgCnh9uW/z53P4Obf5mw6fzPxFK8iw+PfVtmkj3njoXg6+t5gHZ0yhQpnsKrwXtvmTk8O6zR8JYYQEuoEbCnwg4rIkDENEX5q1qmNWJQJTBvZm3sLQaXY3bDnGb/tTaVLXMLf5n5QsBdVlbSKbM60xH39xIuTrZ1PTWLj+A24cph/SmIvHG7GjgEFtW1GvelX26Zz1z1+0nBuH9tc9LshN1fIWuN0RGWOBCQa1cXo8YKGADkBqegavvbuepxe+Y/5Y5zJcTgeDu13LXyaM5JoWV+R4RQGnA2LcWjhflHVqdyVXtWzGt9t1oxVmAf+H5SW0MEt2AESpNHv0UGw6F51UlUKpEjioV3Xq1dLfnZi3aDlqIT0x22w2Zhnke/9l7wE++vYHcx17InCTsqDkvM2fmWVp8t996EiubX6rk3/l8mW5e8pY9q1ZxNLHHsgx+Wdv8ycnaTH8hTD5XzB78hijJtWA4VEYishDFgCiVGpQszr9OumHBL7+7l5Szkc3JNBmU5g5WT8k8Je9B/j4u22Wvo8V04f0IyEuVreN+SJGwSIWEqhq2/yp1pP2BINBPvh6KwNv/RuNh05i/qIV5o9x8mjbtBEv3n8HB9Yt5tG5N1G9UoVLx+90Wr7NHwljBvamSkXDzL8SElgIZAEgSq25Y4fpvn4+w89/V+4112mWqqUItmD62PokxBuFBJqcYCOoTGICEw2qBK79/Ev2HjlmruOicBkwqGqX+c6lQnq6pdv8aekZvLRiLc1HTqPnzL+y9vMvLe3cOB0ORvbsxub/LuC7t1/kpmEDiHHplGu2GDIYKS6nkxnjRhg16wC0j8JwRA6yABClVo+r23JFPf3Qu2eX7DQXEohiuUpgmSQXE4fX1W2z9rMvdc/hC9qcMUN1z/i1rIqrzHXq9xdelUB/ANIzICVF2+a3MFFf2Oav3nskMx5+gh37D0ZkiI/cMp2ljz1Apyubh/cGrw9Ui6vRCJkxbgSuHEWDQpCQwCiTBYAotRRFYc4Y/V2AvYfPs/azo+b6jUB9gFtvaGIYEvjskpXWv1E+Na1bm57XtNVt88rKdaSmZ5jrOKpPraq2tZ+Wpn1ZLKC0edtPjLr7nzQdpt3mT8sw+d9u4OWV6wiaSSOsZh9jFAFVK1VglMGuETAK0C86ISJKFgCiVJs0oPfFbGgh5KtKoMV5rFG9RHp2qarbJl8TbATNHaN/bystI4O31m0012k0nlrVYPY2f5p2uc+f/12HLK+XN9dupMWoaXSeNpdlmz4hYCHXv57dh46w8avvTA7QU2TuVt42bbxRExdwcxSGIrLJAkCUanExbqYN7qfb5qNvfueXvSmm+o1GlcDU9Az+t26T9W+UT307tadhrRq6bRYsXmHu3Lsgn1r9/otFeTKzLC009h89zl+fep6qPYcz+R//j5/3mEwfnUe820WPKxridkY6HXTQ0gXGSGrboikd2rQ0ajYDLTeAiAJZAIhSb/booVoFtBBUFeYv/M1cp34FLF5q79e9Go3r6+cheHrhO+a2hSPIZrMxe/RQ3TY7Dxzm/S+/NddxJJ9aVbK3+ZJr/0EAACAASURBVLNz83us9X1hm7/RkIk88dZSzqWZKx+dV6WkBIa3bcFDQ3ozuHUzrjG4k7Lhi2/47cAhc9+kiFwGBJg7ZZxRkypoRwEiCmQBIEq92lUrM6hrJ902b63Zz+lz5j5IrYYEKgqGIYG7Dx1hk8Vc8VZMHdSH5IR43TaF8tSqZt/mT03N3ubP/2rM4/Xx5tqNtBo9/c9tfr+Fy4qKotC4SkVmdLuG+wf2oFuT+rgcWjrens0a6l6uVNVidrkyjxF9e1CjimHm39uiMRYR0dIPRcpk4G9AQ0ruf6OIssdua81dU68wbpiDWg5Q8v/ImZrmo1b7VaSmFY1t3PxQFIUdy9+gcZ2a4b/J4dDq0JsVCGhZD71ey+mFD584yXNL3+XlFWs5nZJqqS+AWJeTDvVr06VRPconxP35+zYU3C4HCS4XdpuN//feR3x/MPTF08S4OA5vWGq48MrF7YK4OON2UfDIM69w/xPPGjXrBHwRheGUagVTBaJwPQA8DZRHJn8RQbsPpjF7bGPdDIKXUsEw+ik0t9vO7yez+PqH0/nvpIjod+3V4TcOBrXqdDpHMxepWhKhjEztbN/i0+7mbT/x16deYOYjT/HZ99stl+CtnJRI/1ZNmdihDc2rVyHOpf1A2G02ElwuysTFEON0Yst+8k+KcfPZrtB3Crw+H5XLl82T8tdAIAgxrqjk/zfStEFdFryxyGgXJQF4J0pDKrUK/6chshoAO5AaB6KAvPNEZ4b3qBX+G2yglrX2JLrnQBpNuqw1mY+gaCmQp1Y1u4ZAlkdbMFjg8fpY/P5HLFi8gq07TKaAvgxFUbiiaiW6NqlPk6qVcn3QOh124p0uYkJc+FOB2xev5ujZ0BdP69eoxq5Vb2ELa4GULTZWqwlQBEy760FeW/auXhMfUA84Ep0RlU4lbQdgGKCfqFwIC34/ncXUwfXDf4MK2BVLS9JyZdx8u+00u/cXbhElKyL61BoMQKYHMjKyK/Hlf2F0/I/TPP7mEibc/whvv/cBx/+wttPidjq4tmEdJnVsS9fG9amYGP/n5B/rdJIcF0uCy4XDHnriVgCbougeA5xNTaPdFY1pXNvEsUowWGQWALWrV+XFhboP+HYgC/goOiMqnUraDsDtwJOFPQhRsn27sA/tmhnmNr/IAWqytaf3jZ8ep8/4jy31UdjqVKvCntVv60ZcXCI2Ritdi6rF62d5IhLWtnXHLl5avoY3124ky2ICIIAKCfF0bFiHTg3q/LnFD9o2f5zTSazr4hZ/ODx+Pze/uYLzOscPPa5uy6bnHzc30Pg40EsfHEVdR0/ns2++12vyB1ALyIzOiEqfkrYD0AHoXdiDECWb368y+Dr9+PdcgmgpTizE3NSvk8iK9w5z8o8IJBgoJOfSztO2aWNzlwED2Vv7GRmWt/p9fj8rPvyM2x5/hnvmv8TWHbss3eYHqFexPEPbNmdU+1Y0qFQep137SHU67CS5Y0iKicHlsJsojaxx2GykZmax68SpkG32HT3O8Ou7ULlc2fA7VlXtaKUISEpIYKl+oqg4YB9gsrSkCJcsAIQwacf+FG4c3pCEuPD39RUUbRFg0XsfmiywU8ScOnuOSQPM/BNVtTA2C9v8p86e45klK5lw3795ddV7lmsoOO122tWpweRO7ejZrBFVk5NyTfBuh4NycXE47DZLd+6qlUlm/U+/6aYtCAZVBnTpEH6npi5XFqzG9erw1sp1nEvVPdqqD7wQpSGVOoX/UyBEMePxBnl5+R5zb/JiuUrg5JF1KVemaDy95deH33zP9t37ovK9tu3cw4yHn6B2vzHcM/8lDp84aam/5NgY+rZowr+G9mZix7ZULXP5JE3egD8iyZkqJsbTro7+TtNb6zaaD1EsClUXAbvdxs3jDasENge6RGE4pVKpugNw+/iRPHnHLONeYtzajdli6Ja//YvndBKvjLqqFZ0b6VeaAy0UKS6KZ4VjXnxbN4e695tNOB1hPHGXLROR8Vw1aDzf/fRryNerV4pj//rBOB1mzrNVVIuh2Hc9/AOPv7Aj5OuKovDT0v/SrH6d8DvNb8z9ZRw4cowG3QYSCIT+u7xp2ABevP+OiHy/vPyBAKs+3sz8RSv4/IftEelTASZf247WtaqHfY4f73KRGIELdz8f/Z1/rtZP9/x/t87gzsljTPSqQHISmApnLRhnzqVQs2MfMjJ1j7ZWAPqFJ0S+yA6AEJcxd6p+ytKjJzN4Z5PZlKyK5RS3t0xphN2unylu/qLl5jqNYKa4OjWqMahHN902b63bFJHEOjmlnE9n3sLlNBg0npF3PRixyR+0vzJVVU1d4svw+VAjkM+4efUq1Cmvf8b/zJKVJu8yqOAtGrsA5cokM2FIf6NmgwHjpxZhmiwAhLiM0QN6UaWi/k3/wqgSWLtGPIN6Gm0L52OCjeC28NwpY3Vfz/R4eHXVexH5XrsOHuHW/yygeu8R3Pb4Mxw8fiIi/eb10Y69ptqrqkqWz2IxiGx9WjTRff3Q7ydZ/anJpHlZXopKmcBbp44zuiRpB2ZGaTiliiwAhLgMl9PJjHH655Nfbf+Db342FzdutT4AwJzpjXRfz9cE6/VBhBINdbumHa2a6o/xuaWr8n0DPxgM8u4nW+hx8x00HjqR+YtWkK6/hWyomsFi7/CZcxz444ypPtMjVNWwc8O6hscJpnd91GDBVV006YqG9eje8SqjZjcAJrJIiXDIAkCIEGZNHIXb4B7EArO7AAEsVwns1qEyra7Q3xZ+tpC3hedM1t8FOHj8BO9+ssVUn6npGby0Yi3NRkxlyF/u50P9GHJDLqeDkT27seW1Z9i2+BViDP6uP9lp7vKiPxDAY6EI0QUuh50eV+gXhfp064/mMxgWryqBZYGJURhKqSILACFCqFS+HCP79dRts+T9gxw9mWGqXyXT+i7A7Kn6T9iHfj9peoLVJoTI7AJMGNSLSgbx6eE+te45fJR75r9E7X6jmfHwE+bL4eZRuXxZ7p4ylr2rF7L0sQfo2KoZFcuWYXTv7rrv23boGOcyzOWkyTTxlB1UVTJ9PtI8HlKyskjNyiLd4yXL5+f6pg0NEyg9t9RslcCA9lUEDOjemfq1DXNrzKHkXVwvVLIAEELH7dPH677u8+cjJNCHthNgwYThdalUIUa3jelt4aBqfVtYVSE9A3eWlxuG9tNt+tn320M+taqqygdfb2XgrX+j0ZCJPPb6Is6lnbc0tDZNGvLi/Xewf+0iHp17EzUqV9ResNshLpZbb5qs+/5AMMjm3QdMfc8sv183ukXrV+VcZhan0s6TkqlN+pleHxlebTFwLjMTFZVWNavq9vP2+g84cfqsqfHhKRqJpWw2G7dMHG3U7AqgRxSGU2rIAkAIHW2aN6VDm5a6bZ5fupssj4kZXQXFY+1Bxu2yMX2Mfk2Cz77fzne/mjyisHIZMBiEtDStQA9wy6ihhqGbeWvbn8/I5KUVa2k+cio9Z/6VtZ9/iWohCZDdZmNA5w5sev5xti58iZuGDSDWnX2e7nRq4Y9JieB207p5E65t11q3vy27D+AzeXchQ2dRleXz80f6ebJ8PsO9l66N6+m+7vH6eGXVOlNjw+vT7gMUATeMGUqScbGoudEYS2khCwAhDBidT548k8XSjQfNdZqF9ZDAqY0M8xA8t1S34tqlAvncFlaB9PSLqXvRLtYN695Z920LN2hPrfuOHte2+ftr2/y/7jP555lHmcQE5o4dxr61i1gz79/0uLqt9oKigNutxcEnxGs5EHKYO1X/7sJ5j0e3SM/lZPp8l01k6A0ESMnMCjvJYb2K5altEBL43NJV+MzeO8iyXgshEhLj45k0bKBRs/6A/vmXCJssAIQwMLzv9VSvUkm3jemQQBUtL4AF1SrHMrSv/rnpog0fcursOXMd52dbOCvrsguHuWP187d4vD663DCXhoPH89jriziTYq3iYatG9Xn1gbs4vmk58+6cQ60Lf282bZuf5CTtf0Ocpw/t1Z2aVavofo9PfjMXEhhUVbLyFDDyB4OczcgwnSugSyP9XYBjp06z/MPPTPWJx1NUIgKZPXm0UUigAoSRzU2EQxYAQhhwOhzMHD9St83WX8+wZVvowi2Xo0TgEvacaY11X8/y/n/2zju8iir945+56ZXeewsoolgAEUXpvdfQq3SwrL/ddV3doqurrisBRFQWFCHU0IsgRRFBiiIgvfcO6bl1fn9MAolkztzJXELK+TyPz7reM2cOBO55z3ve7/t1MGPJSnOTOpzmTHdUVbei/JnH6tKgrljHfvTMeTwWJIg2m3Inzf9L7OcM69LubkW/v7920i+ipfmNmvP7+/sxdmBv4Zjzt+I5cdWc/DMpk+OgqqqmTv6ZebJqBSJDjGo/9DuBZouq3rm2edDUrl6Vts8/YzRsGJB9H2aJKWQAIJF4waj+PQk2cFGLmWsyC+BCKwi0QJMGpWjwmFjDPn3Rchxmm9KY2RCcTqFZz4S+3cy920siw0KZGN2dEyvm3UnzK4pyN80fGand8QcEGE+WiVH9ehBqsMluOWIuC+D2eO5IAhPtDtN1BBn42Ww0qVlVOGb7vt/YeeCwuYnzlyQwAhBXbEq8QgYAEokXlCxWlOjO7YRj4jae5fwVk5JAHzQGGmcgCbx47QZxm0ymhdNMpIUNagbKFC+OzYd95x+uXoVP//IKlzbEMfm1CVQtn56yt9kgJPhumt8vZ19vxYpE0s/gZ73v3CVuJZuTBKY4HNhdLlIsnrafrVXVUBI4Zb7JLIDbrbWEzgO0adqY2tWrGg0bj9y/LCN/AyUSL3llxADh5y63yicLTDZjcQBua5tj3y5VKFtKfGKdPM9spzgTaeFsrgvsDieLNmzh6UFjaTPuNUspftDS/C0bPcmKj9/hwKJZjOrRidCM7ngB/hAerm38wcGGaX5veGlYf+FdtEdV2XrUXGMgu8vNbYsdCwEiQ4J5vHIF4ZgF6zdz4ep1cxPb88Y1gKIoTDA2N4oC2ubCcgo0MgCQSLzkkaiaNG34hHDMjMXHSEkzd5JSLO4JgQE2Xhwo7hS3Y/9B82lhbyWBmfbJyzdu8rcZs6nUrje9//h3fjqg71zoDRGhobzYvSMHFs1iw/QP6dT0mfSNOaOaP0Lb/AO8cIo0Qd2oGrzw9FPCMduOn8ZhUjFhRdKYmeYPiSWgTpeLz5euMjep05FnigEH9+xEEWOHSikJtIgMACQSE0wycAm8Ge8gdq1JCZsdzSjIAqMG1CQwQPzXOWa+2cZAXqaFFRs34hMY8tZ7VG7Xh7/P+NK88uB3RFWpSMz/TeDCN4uY8carPFStivaBn02z6i6aUc3vZ+k9IoxMjVIcTnafPpfj+W+npLLht6PM/2kvK375jR+OneLgxStcjk80rBGoVLwoVUsWF46ZsXgldjONnVR85gpplfDQUIb17mo0rDUgrjCVCPFt2CyRFHC6tGpGlQrlOHPhku6YmHmHGd5NfELLggo4FAjO+fGrXOkQeneqzNdxp3XHLNqwhQ9eGk25kuKiwSzY7fdo5X9PqttD8xdfZt8xcynx36MoCq2ffoqJ0T1o+0wDbJnvuf39ITgo/aSfO91gO7V4nmqVKnDqnL7uf8uRkzSuWdX0ig5evMLMrTuFGYSI4CCKh4VSIjyUYmGhlAgLpXhYCMXDwygRFsoLtaszW2BQdPnGTRZu2MzADq29X5jHg2a+9+AZP6gPk2fNw6OvSFHQ2gOPy71VFSxkBkAiMYGfn41xg8QtS/cdvc2W3eZsaa1eAwBMGC6WBDqcLj5dvMLcpF5IAuesWmdp8w8PDWFs7y4cXDKbddPep/2zjdI3fwUCA7VOfXeq+XOvFbyfn3F72ku3Ezh22Zz882pCEv/busvw+iAxzc6ZG7f4+cwFNh48xsJdv/Lplh38a9VGXl2wkoW7fjV8l2lJYF65AwCqV65IR4NGUsAgoGguLKdAIgMAicQkw3t3NZSJmZYEurEsCWzwWAkaP1lSOGbGEpNpYTAsDtvxy35z86VTvUI5/vPKWM6tXci0P71EnaqV734YHAxFIyAsVOvV/4AY3qcrYaEhwjHfmXAJdLk9zPphl09cAkUthjPYffAIP/76m/eTPsDf6+zwQhIYjtYXQJIDZAAgkZikeNEiDOzWUThmxZbznL6YbGpexZyqLFuMGgNduXGLBes3m5vUbhfq/J0meww0b/A4yz56m2PLv+aVAb0omm2xlwrKg/96KhoZwaDu4p/1gQuXuZ7k3c962S+/cf5WvC+W5jVem0IpSo6lk/eL5s804JGomkbDxpNX7i3yGXnrpy3Jl7g9KinpNqaJdjvJdk3v7KOC5zzJhMF9hTIxt0dl2nyTWQCnYlkS2KNDJSqUDRWOMe0SaCAJbPN8Y8MpQoKCGNm9I/sWzmTjjI/o8kKTrHf8v8fuJK+koycMjvZCEnjKcJ795y/zvckGQr4gbtNWrt/2IugIzN0rFm9QFIUJQwwlgdUAcZQmyRYZAEhyjMPt5mZyCteSkkhItzFNtjtItNu5lZLKtaQkkvOIttjX1I2qQYtnGgrHzFx6guTU3JUEBvjbGD1ILAncc+go2/YeMDex4OfYq30rSpcQV6Q/8VAtPnvjVerVFPeyv4PqsW5N7CMeqlmNVs8+LRyz/cQZYVr/dkoqc3f8/EBCGqfLxfZ9BtcAChAkvtZ6UAzo2oHiRYsYDZOSwBwgAwCJaTwerZf5zeQUHALZkEdVSbTbuZaUdI8ZSkHAyDnuVoKDr1YanwyzYMfywffF/jUJDhJnRE1nAdxu0En1BwUGMqqf2PRn294D7DlksklSHgoejSSBqQ4nP508m+1nHlXly227H2gwbDO6TgkJzXPp/wxCQ4IZ0cewnXRzoF4uLKdAkTd/4pI8S7LDyfWkZFJNbOhuj8rt9IDBacZkJo/Todlz1KgiduObEnvE3FWIClhsD1yqRBDRXasIx8Rt2sr5K+aq10X94kf370WAgVzQdNDhcuWZ9rTtXmhCrcxFitnw/ZFT2cZu6/Yf4bgX5kEtGz1J40frmpNpekF4aAhN6j+iPyAkBAx8Lh404wb1wd+4QFFmAUwiAwCJV9hdLq4lJZOYloYnh0dU7cogmYS0nDmh5TVsNhvjB4nvJw+djGfDDv2eAdmh+CALYFQM6HK7+WTRcnOTOp3gzj6AK1+mFL06tBI+vmD9Zq7cuGXund52I7zP2Gw2JhhkAa4kJHLoYlb55/Gr1/nmgHEtSLdmz7Fh+of8OHsqF9cvJnXHNxyO+4pvpn3AjDde5fUxQ+nXuR1NnnyM8qVLGVnm3kFRFD58eUz2hZY2m+aUmNFSOQ9TuXxZurR+wWhYf8C30VMBRzYCkghxeVQS01Kxm2x5qoeqavKlNKeLsKAgwgLNObXlNYb26sKbH00nMVm/Cjxm7hFaNy7n/aQZkkALh7L6dYvRtFFpvv/pqu6Yz+NW8deRAwkJMrEBOOzaiTEbJg6JZt7ytbqP2h1OZixZyZsvDvL+fc70PgQG5je5wZCenXjjw6kkCCr+vztykofLlwEgye7gy2278RhEu5XLluaLN1/L8t+CAwOpXbUStatW0iSRv5Od2h0Ozl68zJkLlzh9/iJnzl/izIWLnDp3gdPnL5Kckkq9qBq8NrQfHZ97GtwqKCpgA38/radCYO41VfIFE4f0Y8najaIhIcBI4L3cWVH+RwYAkmxRVe0LLNnuQL0PpUseVSUxLY00p5OIfHAC0aNIRDiDe3Ri6lfzdces+eECR04nULuq9xbmShqoFrOyE4bXFgYA12/HM2/tRoZ3be/9pGkOXcOdRvXr0ah+PX7aq98XYNrCpfxxSDRBZgI/u37QkZtEhIUxtFcXJs+apzvm0MUrXElIpHRkBLE7fuF2iriq09/Pj3n/+ivFi0ToDPDXfr9/R1BgILWqVja8lihING34BE/Ve5jd+w+Kho0H/oPlrhqFgwcfVkvyJIl2O0l2+33Z/DPjTFcS5GcmDo0WStpUFfMugU5FywRYoGubilSrLDZU+XjeYpMGNWJJoFGx3NWbt1n07RYT70MrBswjd0bjB/cV/6yB74+eYsvhE+w7b3z189aowfr384qiNULKP4f0+87Ygb2NhlQADE0EJBoyAJBILFKramXaNBVr4WcvP0lCsrlDiZJq7Zvfz09h1ABxE5UDx0/x3R7jlrJZSNMvUujZviXlSou7EZr2qldV7SogD1CzSiXav/CscMyOE2dY8Ytx973mDR7n9WH99QeEheaJq4+8RHTndpQqXsxomCwG9BL5p0si8QFGLUsTkp3MXm6yX74Dy8WAI/vXJCzUqDrf5Ibs8YAz+/REYEAAYwaIT2k7Dxw21qX/njxSDAjG8k+Hy43LQO1SqlhR5rz9F/1sQnBQuveBJDPBQYGM6tfTaNizgNjLWQLIAECSA64mJLH+t6Os+vUQv567aFjkVBho07QxdWpUFY6ZGnsEj8fE75WK1hfAAsWKBNK/W1XhmBXfbeP0xcvmJrbr322P6teDoEBxAYPpoMPtpTVxLtCySSMeruVlQ6NsUBSF2X//E+VL6RSs+/vdU/QnucuYAcaSU7RaAIkBMgCQeE2Kw8Hi3ft5Z9VGVu49yDcHjvDF9zt5e+VGfrtozv2uoKEoiqEk8NjZRNZuu2huXovXAAATh9fOrmbvDm6Ph2kLl5mb1OnSlQSWLlGcvp3aCB9fsvF7830I8kgWQFEUJgwWZwFEvDKgF+2fbaQ3u5b6lxf/upQvU4qe7VsaDesLlMmF5eRrZAAgMcSjqmw7fpp/rPiW746cuOfEfy0xiU83b2fGlh1em6IURIb26mLYstS0S6AH7SrAAg9HFaF5k7LCMV8sXU1Sikk3Iof+hjxpqPhKxOlyMWPJSnPvczq1TEAeYFD3jt60p72HJx+K4l/jR+oPCAsBm/S1McILl8Ag4MVcWEq+RgYAEiHHrlzn32s2M/+nvYatTA9cuMzbKzeyePd+7CYd4goCoSHBDOnZWThm/fZL7D9229S8isXOgAAThkUJP7+dmMSc1evNTZqmX53/eN06PPvU48LHZyxZSZpAUZAtZsffJ0JDghnWq4upZ8JDQ5j3r78SGKCTvg4KAoOrE4nG04/Xo+Fjgu6GGmOw1E2j4CMDAEm23E5JZc6Pe4j59gcu3k7w+jm3x8N3R07wz5XfsvPkuTzi55Z7TBjcFz+DnurTF5qVBGLZJbBjywrUqHIfJIGCoNCoWO7ardvErhM2drmXPCYJNPpZZ2b66y8Tpdc62s8m7/1NYiQ5BcoBhhWDhRkZAEiy4HS72XDwGG+v3MjOU+dyPE98ahpztu8hZsNWLuSy//mDpGrF8nRs3lQ45ssVp7gZb+4kq5jMzv8em01h7BBxFuDomfNs2LHH3MR2u65SoVvr5lQuL756+O/Xi829T1XzjEtglQrl6NzyBa/GDuvSjgHt9VolKxAWlm1zJYk+vTu2pkLZ0kbDXsmNteRXZAAgucOBC5d5Z9VGVvzym9Da1AzHr97g32u3MOfHPSQJzGQKEkYFYilpLmYtN+kLb1e1egALjIiuQWSEWFoWM9+kYY/HA67sN2R/fz9DSeD+4yf5/ud95t4pUCDkNl6cQqlVuSIf/0FQlB4aAsZGN5LfEeDvz4vRYhdK4ElAr+Ky0CMDAAmXbicwZeM2ZmzZwY0k33flU1WVnafO8fbKjWw9dqrAywabP9OAR6LEDXimzT+K24wkEMWyS2BEeACDelYTjlm77SeOnT1vbmJBYDeyb3dCDFo9m7cm1g86cpsXnn6Kxx7Sz6wEBway6P2/EREWqjMgOM878eVlvJGcIhsD6SIDgEJMisPJ4t37eW/NZo5eNinJygHJdgcLd/7KB2u3cMILe9T8iqIohvffpy4ksXKLuY1W8UECZdyQKGGm2eNRmbpgqblJnS7d6vwSxYrQv4vYa2D5lm2cuWRSRpqWN4oBAf712gRdd76PXh3LY1E17v1AUbSTv7z3t0SZkiXo07G10bBeQPlcWE6+QwYAhRBVVfnx+Gn+qSPrMyI0OIh/jBnKt5/+h/q1xSfd7Dh/K57JG7Yye9tubpuVnuUT+ndpbywJnJcDSaDdWhagdo1I2r4g/i6cvWIdCWb9GSwUA7rcbj4x3Ycg3SUwD9C+2bN88d6bFMlkuRscFMh/XhnLmN8rBRRFO/FHRmhV/xLLeCEJDABG58JS8h0yAChknL15mw/WfUfsT3tzdCffq9ULHIr7ir+OHESLhk+we+4Mpr/+MiWKeO90B1rd2J7T5/nnym9Z/9tRk9XneZ/QkGBG9u0uHLN51xX2HTUrCbSyKo0Jw2sLP09ITmH2inXmJnXYQedKo17tWjRr3ED4+BfLVpNittFPWt6pBRjWuyvntq9j7exprJoZw8WfNvDKhJHaRh8WBuFh2r8XjYRQ2ePflzxZ7yGaPFXfaNgotN4AkkzIP4WFjB0nznDuprlNB6BO1cqsm/Y+C//9FpUzVd76+fkxemBvjn23golDovE3WczkcLlZufdggawLGDuwt+Hvx5RYk1kAF+CylgVo83w56tQUB2xT5sfhMXPCVhE2BjIqlrsZn8jXazZ4/z4AuzPPSAJBswtu+/wzdGj+HMUyAmI/PwgM0Pr6+/khO/zdH7woxiwN5Lx9YwFFBgASIUUjwvn4D+PZv+h/tPn9KS4wACIjITiYYkWKMPmt/2P/N4tp/ZzYGa+wULl8Wbq2biYcM2fVSa7eNHeStSoJVBStFkDE8XMXWLttp7mJ7Q5dSWDnls9TvbKOBj6dyT62JpYUHrq3aUGlcmLJKbIY8B5kACDJFptNYWCH1hxZOodJ/XpkPcn6+UFEuJbatGU90dSpUZVvvvqEFV98TJUK5XJ51XnvdGV0/213eJi51KQk0IFlSeDgXtUpkouSQJvNxlgDSeDBk2fYtOsXc+8U6IENcgAAIABJREFUWBNLCg+a5LSX0bDHgedyYTn5BhkAFDQU6z/SBnXrsG3WVL76558pXbxo1rlDQyAiAgzcuDq1eJ6DG+J4a9IognNL5mSiK1tu8VyDJ3iq3sPCMdPmH8XpMrejW1UEhIf5M6xvNtXpmVi/fTf7j5u0MBbc4w/v05XwUB05XDqmJYEej6ZCkBR6RvXrQaixqkJmATKR974xJdaw0E2sXMkSfPmPP/PTV5/w9O83raAgKJJeuezlK0JDgvnbS6M5unk5A7t1yPG6vEavx/oDZtygPsLPL1xNYekmk10XfeIPUBs/P/E80xetMDepS18SWDQygkE9OgofX7V1OyfOm3NMzCsugZIHS/GiRYju3NZoWDeg6v1fTf5ABgAFDZv5jSHA35+J0d05vPQrBnVsnVXT7O+vbfyhITkOLiqVK8tXH73NxrkzqJudJtpXBIhT2g+K6M5tKVNSx/s9nRy5BFrc96pWCqNDiwrCMV+uXMfN+ERzEwvUJZOG9sMmqID3eFSmLTApCRQEHZLCxUvD+uv2ZEjHDykJvIMMAAo57Z9txG+LZzH5tQlEZu5WZrNp0qWIcJ/ZkzZ/piE/r4rlg9dfJjI8zNSzBn+ptc3f4FriQREUGGgoCdy29xp7Dt40NW9uuASmpNmZtWKtuUntTlCzv9KIqlaFVs8+LXz8f8vXmLcmLiRtpiViHomqyfONnjQaNgIIyYXl5HlkAFDAMDppZlCrckVWTX6X1THvUStzdbaC1p40MuK+nKgDAwL4w8hBHNm0nME9Ohlv7EDJokXEcjqbDfRareYRxgzoRYBBgGK6MZALzSnQAs2blOWR2kWFY6YuWIrbVNMdA5dAA8lWfFIyX676xsT70AyCdIIOSeHCC0lgCWBALiwlzyMDgAJG19bNhJtqeGgI7018kf0L/0eH5353EgsM1GR9IcH33ZmsbKkSzP7wH/y45EvDIrluzQWFuzablqXI405q5cuUomf7lsIxC745zZUbJiWBFrMAigLjDbIApy9eZuV3P5qb2O5Arzq/7fPPUKtqZeHjU+bHmZME5iGXQMmDpXPLF6ha0bDz74TcWEtep6BZUDUG2uh++Ghd2jwj7kgGaKnkPHqfbESZkiWw2Wxs3r4ry39XFIX+7Vuy4r//ol2ThvfK+sLDIDgo1zfSiuXKMKJPNyqXL8eOX/aTnJo19VunamXm/esNQrMzlAkK0tadT7qqVShbhpmCPvtut0pEWADPP1XG+0k9aP3NLPzYHqoVyadzjpGapn+PfuXmLYZ0Miywuouqgp9/ti53iqKAorB2yzbdx2/cTqBRvYeyZqeMcHtMFalKCiY2m4Lb7WH91u2iYWWArcCp3FlV3kQGANmRjwMAgOcbPUmj+vVIc9iJDA+nZZNGfPr3PzKxf08iMrT7Nn+tkU9IiPbPA9xEFUXhiUfqMLJvdyLDw1BVlSoVyjG8d1e+ePt1ikVGpK/Zpm0qQYEQHqplLPL4yT8zFcuVYe2WbVy4clV3zJFTCUzoZ1ydnxlFQet2nkMCAmzcvO1g2y59Q6jTFy/TvXlTypQo5v3Eqke33/3Dtaox7asF2AWn9hvxCQxo38rE+1Qt4JDWuoWeh2pWY+pXC3CKJaJFgfm5tKQ8SUH7myIDgHRqVa1M7w6tGdG3G11bN6Ni+XLarykoUPtSDgrU/n8eOj0HBwXxXMMnGNyjE0N6dub5Rk8SFBqibfRBQdo/gYHazycfbfyZCQ0OJu6bTbqfJ6W4qFO1CI9Gie/ls+BWIBhLJ9+o6hFMnX1U6K/jcrvp/Pwz3k/qUSHQP9s/Y0GBgVy5foOf9u7XffzE+Yv0adOMkgamSllQVWmvKyEkOIjzl6+we99B0bAo4GvgVu6sKu+Rd779JZJCQO+OramQyUshO/779SFzk6qAw1pAVLlCGF1ai9Ptc1av56pZHwmBbe+EwdFCSaCqSkmgJOd4IQm0AeNyaTl5EhkASCS5SIC/Py9G9xCO2XPwJjv2XTc1r1V/ADB2CbQ7nMxcttrcpA6Hrm1vjSoVaf/Cs8LHZ69cR3xSsrl3SkmgBO8kp2iSQHNWpgUIGQBIJLnMmAG9DNsjm5YEurEsCWzaqDRPPVpcOGbawmU4XSZb74okgQZeCUkpqfxv+RqT75OSQImGF5LASAqxJFAGABJJLlOqeDH6dNQtVQFg8YaznL+SYmpexZyCMFvGDBZLAi9cvc7SzT+Ym9Ru1/XrafXs09SrXUv4eExsXA76EEhJoATaN3uW2tWrGg17iUK6FxbKX7RE8qCZNLSf8HOny8OMxcfMTepQLLsE9utWlTKlxIYqpg17VBWc+lmAsQPFLoGnL15m9dYd5t4prwEkaAojoz9fQC3AhNyk4CADAInkAfB43To8+9TjwjEzFh0jzW6uoM1qY6CgQBsj+9UUjtm29wC7fjtsbmKBYc+g7h0pblDpnyOXQId+0CEpPAzt1ZkiEeFGwwqlS6AMACSSB4TR/fe1W3Zi1542N2kauul2bxk9qBaBAeKvhqmChkbZ4nZrFfrZEBoSzLBeXYSPb9z5M/uOmbQmFtQeSAoPEWFhDO7RyWhYO6BOLiwnTyEDAInkAdGtdXMqlSsrHGO6GFAF7NayAOXLhNCjQyXhmPnfbOLyDXPmRaINefzgvvj5ib+OppkNOqQkUJLOhCFiySlaF42xubScPIMMACSSB4S/v5/h/eTeI7f4fo9+58DsUNIspgCACcPEkkCH08VnS1aZm1QgCaxSoRydW74gfHzO6g3ciE8w907B1YOk8FCzSiXavdDEaNgQwETXqfyPDAAkkgfIqH49CA0xKLozLQlULEsCn36iJA3ri50lP128Aoe41eq9CIrzjCRbqXY7M5eZlAQ6nFpHQkmhxwtJYAQwNBeWkmeQAYBE8gApViSSfp3bCccs23SOUxeSTM2rpFpvlWzUGOjS9Rss2rDF3KR2p6YKyIYXnn6Kxx4SyxCnLViKy1RaXwWHzAJIoPVzjQ0lp2jFgAWtRb4uMgCQSB4wk4b1E7YsdXtUPl1kUhLoRGsOZIHenSpToWyocMx/5y4yN6nqAad+emLCYPEp7ezlqywXuAhmS5q+NbGkcDFmQC+jIdWA9rmwlDyBDAAkkgfMI1E1eaHRk8Ixny85TnKquXS71cZAAf42RvYXSwL3HDrKjv1Cw5V7SdU/kQ/o1p7SJcTdCM33IfBoVwGSQs/gHp0MJacUIkmgDAAkkjyA0f3krQQHc1efNjepXbF88B01oCZBgeKviZjYOHOTevQlgUGBgYzo2034+Pc/72PvkePm3ikbA0nQJKdDe3U2GtYCqJsLy3ngyABAIskD1De4+waYPPew3vV59vhAElimVDB9OlcRjln87Xecv3LN3MSC6vxxA/sQ4O8vfNx00OFya/9ICj0TBkcbSU4VYEIuLeeBIgMAiSSfcPBkPJt2Xjb1jC9cAieNEPdHcbpczFiy0tykTqeuRr98mVJ0b9tC+Pi8dd9y5YZJG3e7D8wSJPmeKhXK0anF80bDBgJiGUwBQAYAEkk+wrQk0ANYbIj3+CPFaNKglHDMjCUrSTPbelcw3uhKxO5w8vlSs30IpEugRMMLSWAoMCwXlvJAkQGARJKPWPX9BU6cMykJ9MHB16gx0LVbt4ldt9HcpHb96vxnnnyMBo+Kr2GnL1qegz4Esj2wBJo1bmAoOQXGA+K7qHyODAAkknyEx6MybYHJLIBTsSwJ7N6uEpXKiyWBpu/lVbFt7wSDU9rFazdYsvE7c+9M07cmlhQuxg/uazSkMmBYMZifkQGARJLP+CLuBAnJ5mRtVl0C/f0VRg8SN1HZe+Q43/+8z9zEgmLAPh1bU7aU+Bo2R0GHdAmUAAO7dTCUnFLAJYEyAJBI8hmJyU7mrDxl7iE7PpAE1iI0xKg636xtrxtc2QczgQEBjOrXU/j4jv0H2XnApDWxlARK0CSnw/t0NRr2PFA/F5bzQJABgESSD5k89zAeMz3uVTSrYAsULxpIv65iSeCyzT9w6sIlcxOn6Z/Ixw7sTVBgoPDxmPkmgw6BNbGkcOGN5JQCLAmUAYBEkg85djaR9dvNbbSKDxoDTRxRG0HXYtweD58uXmFuUqdTywRkQ+kSxenVvpXw8YXrt3Dh6nVz75RZAAlQoWxpurVpbjSsP1AmF5aT68gAQCLJp5h3CcSyS+AjtYvyQmPxd+HnS1eTnGoy3SDIArw8vL/wUafLZV4S6HTqWhNLChdeSAKDgBG5sJRcRwYAEkk+Zd22ixw+lWDqGavFgGAsCbyVkMjctd+am9Tu0HUJfOKRh2j8xKPCx6cvWm6uD4GKlARKAGjyVH1DySkwFgjIheXkKjIAkEjyKaoK0xYcNfeQD1wCO7euQPXK4cIxk+ctRjXbt1jYGKif8OmrN2+zcP0WE+9DuwYwtUZJQcULSWB5oEcuLCVXkQGARJKPmb38BPFJuSsJtNkUxgwWSwIPnjzDpl2/mJs4TV+q0LNdSyqWFV89TJ632Nz7pCRQkk7fTm0MJacUwGJAGQBIJPmYpBQX/1t6wtxDaarWItgCw6NrEB7ma0mgB3Q6+/n7+zG6v1gS+PPhY2zbe8DcO+U1gARNcvpitOEB/xmgYS4sJ9eQAYBEks+JmXcYtxlJIIpll8CikYEM7FFNOGbV1u2cOH/R3MSCYsBR/XsSHGQgCTQbdLjdukGHpHAxun8vAgMMr/nH58ZacgsZAEgk+ZzTF5NZ/f0FU8/4wh9g0og6Qkmg1rZ4mblJXfougSWLFSW6czvh43GbtnLuylVz75SSQAlQrnQJehm4UAJ9gLK5sJxcQQYAEkkBIEcugRb3vajqEbRqWk445oulq0lITjE3sWBDfmXEAOGjLreb6Yty0IfALSWBhRbVA2lpcDuRl/t2MxodCIzOhVXlCjIAkEgKABt/usy+o7dNPZMbLoGJKSnMWb3e3KQC295HomrStOETwsdnLFlBisBjIPt3yixAocPlgpRUiE+A1DRQPTz5UBRP13vY6MkxQHAurPC+IwMAiSQfEB4agp9N/NfVtEugSwGL19/tmpWjVrUI4Zgp8+PMSQJVVQsCdDCSBN6MTzRvTZym34dAUpBQtYxPYpL2j/1ed8iJ0d2NJikN9LpPC8xVZAAgkeQDShYtQufnmwjHzFl5ihu3zZ1kfSEJHDdU7Kt+5PQ5vtm+y9zEAtverq2bUa1SBeHjH/u4D4Ekn6Oq2mYfnwhJyUIviJ4tn6dimVJGM77k0/U9IGQAIJHkE4xOJql2NzPNSgLtgGotCBjauzpFIsTV06Ztez0e7aSWDX5+NkNJ4IHjp/huz6/m3inoQyDJp3jcd9P8KaletX8O8PdnVI9ORsOeQJMF5mtkACCR5BNeeKo+j0XVEI6ZtuAoLrfJTSzV2qYXER7A4F7VhWPW/biTw6fPmptYUAw4sm93wkJDhI/nLOiw2CZRkgfIlOaPT8xRx8dRPToRbOBCCUzM8RLzCDIAkEjyERP6irMAZy8ls3zzOVNzKhZ7AgCMGxqFzaY/j6qqTJ2/1NykLpeuJLBYkUgGdO0gfHzFd9s4ffGyuXfafVAZKXkwmEjzGxEZFkbDR+oYDesOVMzxS/IAMgCQSPIR/dq1oGTRIsIxOZMEWgsCalWLoF0zsSTwy1XfEJ+UbG5iQRZgwuC+KIJGBG6Ph2kLTfYhcLqkJDC/4fGYTvPrcfnGTd76dBZVOvTh+5/3GQ0PAAbn+GV5ABkASCT5iJCgIEZ27ygc8/2eq+w9csvUvLkhCUxKSeV/y9eYm9SuLwmsG1WDFs+IO7POXLbGvDWxlATmA1TthJ+UrG38Fo2ddv12mAFvvEOV9n34x2dfceWG139/6uf4pXkAGQBIJPmMsb26EOBv0Id/rllJIJYlga2aluOhWpHCMdMWLMNj6oSmakGADhOHir3cbyUkmu9DICWBeZeMNH9ConbHr1Mo6g1Ol4v532yi8eBxNBw4hrlrvsVhvi20uUg7jyEDAIkkn1GxTCm6NXtWOCZ23Wmu3cpdSaCiwPih4izAifMXWbV1h7mJBdcAHZo9R40q4mvYmFiTfQhQpUlQXsPt0Zr1ZKT5LVzTXLt1m3dmfk3VDn2J/vM/2bH/oJWVLbTy8INGBgASST5kooFzWZrdzWeLj5mb1IFll8BBPatRrIiPDXs8Hl2Nvs1mY/wgsZf7oVNn2LBjj7l3ZtMgRvIAyEjzJyZo7XotZGb2HjnOsL+9T+V2fXhj2kwuXrthdXX/Ab61OsmDRAYAEkk+pEn9R3jqYfFpe/rCYzhdJnZ01XotQFioP8OjxVLFTbt+4cDxU+YmFpzIh/bqQkRYmPDxmPk5CDpcOU8vS6yQTZo/h/u+2+NhycbveX7EJB6PHsmsFWtJs97w6XugI/AHqxM9aGQAIJHkU4wkgReuprB4g1ntvWL55DtuSBR+fmJJ4JT5JjX6AklgkYhwBhs0blnzw08cOW1OHildAnMZT3qa/3Ziepo/5z0Z4pOSmTxvCTU796fna295U9FvhANYBDQGngdWW50wLyADAIkkn9K3TXPKliguHPMgXAKrVAyjcyvxvfyc1Ru4EZ9gbmKBwc/EodHYBF4JqqryyaKcSAJlY6D7TuZq/rQ0XdWHNxw9c55JH0yhQpuevPThVPN9IO7lMvBvoBrQGzBZwJK3kQGARJJPCQzwZ1RP8cl3x77r7Dxg7q7TajEgwIThYn+AVLudmctMSgIdTvBkn56oVbUybZo2Fj4+a/m6HPQhkMWA94d0wycfVPN7PB6+/WkPnSa9Tp3ug4iJjTMv/byXPWga/8rAn4CLVifMi8gAQCLJx4zu2ZnAAANJ4LzD5iZ1Y1kS+ELjMjz6UFHhmGkLluIydcJWhRp9I5fAxJQUvlz5jYn3ob1PJ+iQ5ACPqp3ybydAcrLlNP9/5y4iqutAWo35A6u2bjep9rgHBzAXaAQ8BXwFPIhCkEA0r4G+wP8B7wHvA28C49CcCGv64kUyAJBI8jFlSxSnd6tmwjGL1p/l0vVUU/Mq5oZni1FjoLOXr7J8yzZzk6Y50CtSaNO0MbWrVxU+PnXBUnN9CFRkYyBf4HJDcgrEx2v3/BY26iOnzzH+vclUatubV/7zCSfOWz6cXwH+AVQFBgA7rU6YA4oCo4G1wE20DEQs2vXDH4HXgL8DU9Gkh8fQ1h2HdjURlJOXygBAIsnnGLkEOpwePl1oUhLoVLRMgAX6datKyeLi7yXTkkDVo6WOs0FRFCYMFksCj509z9ptJr/f7Q4pCcwRGaY8ido/FqrvVVVl3Y87aTf+jzzUYzDTFi4jMSXF6gIz0vxVgLeAS1YnzAEZmYZLwHSgLSCWtNylNNANWIB2RfERYOhjnBkZAEgk+ZwGdevQ+NG6wjGfLjpGmt3Ejq5aNwkKCfZjZD9xpvL7n/ex+6DJQkVBdf7gnp0oEhEufDxHkkALd9SFDtWjpfnvmPLkPJJMSknls7hV1Os9jHbj/8i6H3daTfN7gFVAK+5uvrmd4rEBnYANwC5gIBBscc7iwMvASeBv3s4nAwCJpABglAW4ejONhevPmJs0DeuSwKFRBPiLv2Y+Wbjc3KQut+6mEh4ayrDeXYWPr9++Owd9COQ1gCEu911TntQ0S6Y8Jy9c4k8xn1GlQx9Gvf0ffjtx2urq4oEYoDra5vsgGvgUASYBp4AVQMv78I5wtGzGz4D4VIAMACSSAkGPFk2pULqkcIxpSaCKZZfA8mVC6NZOLAmMXbeRa7dum5tYYNs7flAfoSQQ4JNFZoMOKQnUxenUKvkTEy11UFRVlY07f6bLy3+hVpf+/Ht2LDfjE62ubh8wEiiHtvmajIJ9wmPAF2iSwo/RlAX3m4eAH4GeokEyAJBICgAB/v6M6dVFOGbPwZts23vN1LyKDw6+RsWAaQ4HM5asNDepQ98lsHrlinRs/pzw8S9XrjO/ucgswF3upPkT0tP8OZeN2B1Ovlq1nsf6jKDl6FdZ8d2PeKwpLzxoJ/zOaG59XwA+KGs1ReY0/y/AcKyn+c0SiVYw+KLeABkASCQFhFE9OhEcZNCHPycugRavv5s0KEWDx0oIx0xftNy8E5tAo28kCUxJszNrxVqT79MPOgoNbt+l+S9dv8HfZsymQpueDH7zXfYfP2l1dQloaf6aaHf8K8n98s1ItEzDCe6m+a031sg5Clpx4YDsPhQLiCUSSb6hZNEiRLdtwazl+htb3MaznL+SQsUyoV7Pq6QpqAHWvkfHDY1iyEvbdT+/eO0GSzZ+R3TbFt5PmmaHoOBsv16bP9OAR6JqcuDocd3Hpy1cxkv9e+JncF1wl3SXwODcPsg9aFStK2Ka3dJJP4Pvf97HlPlxLNv8g8k+ELocAqagFfSZ7PTkMx4GJqAV9Hlbxa+Lzabw9KMlqVU5goplQokMCyA51cXlG6n8dOAGB47dxu32+u+kDZiFVnuQRXcrAwCJpAAxsV9PYQDgcqt8suAo/5pY3/tJHYBbAb+cBwF9Olfhj+/8wpVr+nf3MbFx5gIAVdWkZdlkPRRFYcKQvox6/W3dx09duMTK736kq4G1chbsDggO4sEe6nKJjN/fNLulkz5o1zyx6zYyZf5SfjlsUpKaPR40zXwMWpr9QQg1bUB7YCI+Ouk3qleSYV1r0KVZRcqUyBRo+oMaDASqoMC1G3bmLj3FJ7OPcfy0V1dZ/mhNjuoDdwpu5BWARFKAqF+7Jk0bPiEc8/mS46SakQRi3SUwKNDGqAFiSeCO/QfZecBk10KBP8CArh0oXrSI8PEYs6ZEHg84rJ+C8zSeTGn+lFRLm//Fazd4Y9pMKrfrw7C/ve+LzT8jzV8HzZFvPQ8uzX8E7ZqhFRY2/8AAG/3aV2XH123Y8XUbXuxZU9v8FSBIRY1UUYuoEKTeeUupEkG8NKIOBzZ34D9vPUFYqFdn+SrAJ5n/gwwAJJIChtH99/XbduatOW1uUjvamcsCowbWIjBA/JVjXqPv1k1Lh4YEM9LAMXHzrl/Yd8zk3bNAgZB/UTOZ8mRU8+d8X92x/yD9Xn+bqh368s7Mr82rPO7lONqmWyn9f32SRjBJLWAycB6tmt9SO97SxYP564v1OL2uK3PfbUKjeukqHhsQAmpRFTUcCNCfIzDAxssj67B9ZWuiqkd489q+aK2O77xKIpEUILq2bka1ShWEYz7++rC573cVcFjLcJYrHUKvjmIF1ML1W7hw9bq5iQXV+WMH9sbfz0/4uHlrYje4C0gWQFW13z8fmPI4nC4WbdjCs8Mm0HjwOGLXbcRpvWZgG1qr2zpoJ3+TFpI+4Vm0avpDaOl+r3ZaPR6vU4wZf23E6XVd+ce4RylXMkT7wA/U8PSNP1Q1tTs/UrsoW5e2pm6UOOOFlkO4cy8mAwCJpIDh52djdH+h/JcDx2/z3Z4rpua1eg0AMGG4WBLodLn4LM6kJNDp1E1TVy5flq6txV4Jc9d8mwNr4nzuEujxaOn92+lpfnfO0ztXbtziH599RdUOfen9x7+zbe8Bq6tLBj5FK6x7FliE5cbUpgkDxgAHga1oBjziSFKAv59Cr9aV2Tq7NT8vaM+LPWsSEuSnbceBaGn+olnT/GYpVSKIdfOaUaqEoS1AS7TfVxkASCQFkRF9uhEaIq5WNy0JdGNZEtiwfgmefkLcsGjGkpXYdfr9Z4uKWBI4NFr4eKrdzmem+xA4LBfGPRDupPkT0jMnOU/z7zl0lMFvvkuVDn1469NZXLpuznY6G06jmd5URNt8D1mdMAdUAz5ES/N/gtZQJ8eUKBrEn4bV5eSariz84DmefTy9Vb8NCNbu9tUIVZjmN0OFsqH87yOxLXY6wzOWIZFIChjFixZhQNcOwjErtpzn9EVzqilfuARONMgCXLlxiwXrN5ubVHBn/VyDJ3i8bh3h49MXrTAvSRMEHXkKH6b5XW43C9PT/E/1H8VXq9abC9ayZwvQHe1O/UMyVannIs3QnPWOAa+iufPlmHq1ivLZm404t74b706qT6Wy6bJbPxU1TDvtq2FYyCno06FFeTq1El8BonUIDJYBgERSQJk4JBpF0c8nuj0q0+abzAI4FU0SaIEeHSpRoay4D4F5l0BV6DY3cYg4C3DuylXiNm0198687hLodmvNejKq+S1o7q/fjue9WfOo1jGaPr5J86cCM9Ha5DYDlpL7af4QYATwK7AJzVkvx1uyzabQtXklNn7egn2LOzCyR3qaHyBQO+mrRdH6Ad5nFenfXn3UaEg48IwMACSSAkrdqBo0f6aBcMzMpSdITjVXqGW1FiDA38boQbWEY/YcOmp+kxGcyPt2akup4sWEj+fImtiZB7MAGWn+xEStXa+Fav59x04y8p8fUrldH/485XPOXzHXSjobzgOvo/XDH4HWqz+3qQi8C5wDPgcMd0sRRSMCeXXQQxxf1Zml/21K84ZltQ8UIAjUoqBGAOImnT7l8UeK8XAtw4LAZjIAkEgKMJOGiiWBtxIcfLXSrDMelk++L/avSXCQ+LBlekN2u7WOddkQHBTIqH7iwshtew+w59BRc+/MK9cAKpo/QnymNH8Of0Zuj4elm7fSfNQrPNZnOF8sXU2qdR+EHUAftDv2dwGTUg+f0ARYgNYR70+AuD+1AXWqRTLt9QacW9+ND199gmoV0m2o/bib5g9XLTXQskL3tpWMhtSTAYBEUoDp0Ow5alQRu/FNiT1iXhKYZi2HWapEENFdqwjHxG3aav7EKdioxgzoRYC/uGGK6aDD5fJJe9wc40k35UmIh+RkrS9CDrmdmMR/5iykVpcBdH/1TTbv+sWHC2UsmpQut3+zgoBBwG7gBzRJYY474NpsCu2fK8+66c05uLQTY/tEEZ7RhCcALc1fRNXS/A94d236VBmjIXVkACCRFGBsNhvjBvYRjjl0Mp4NOy6ZmlfxQRbAyCXQ5Xabt+11OnWWGenUAAAgAElEQVQlbeXLlKJne7EF+/xvNnH5xk1z73wQWQCXG5JTMpny5PyHcezseSZ9MIWKbXvxh/9O59QFc38W8ihlgD+imfJ8CTxpZbKIsABe7FmT/Us6sHpqM9o8Uw5FQUvzB6en+SNVLc2fR7pEVylp6PdRSgYAEkkBZ1jvrkSEif1JHoQksH7dYjRtVFo45vO4VebTzw798UZdEh1OF58tWWXyfbklCVS1NH9Cona/Lyh6NMLj8bB66w7ajHuN2t0GERMbR3Jqgehw2BD4GjgLvAcYlsOLqFk5go//70nOb+jGjL824uHq6ffqfqCGqqjFtKr+B5Xm18WhUNE4ACgiAwCJpIBTJCKcwT06Cces3XaRY2e9MhW5Q240Brp+O555azeamzTNoVv49vTj9Wj42CPCxz9dvCIH1sSW78j18ahamv92gpbmt1DNn5CcQkxsHHW6D6bjpD+zfvtuVAtFggH+/kS3bUHlsuJA7j4TgNbidjvwE9AfCyV3igItny7LyikvcGR5Jyb1r0NkWMCdN91J84eQZ077WXCDkgROl+HP1SUDAImkEDB+cB+hJNDjUZkamxNJoLV1dWldkcoVDLITZu/lsSYJvHT9Bos2bDH3SrvTUrV9ttxJ88draX4L8x8/d4FJH0yhUtteTPpgCsfOnre0tNLFi/LGiIGcXj2fef96gxIGpkv3iVLAX9AaCMUCT1uZLCzEn1E9a3EgriMbZrSgY9MK2GwKoHXoU4uqeS7Nfw9uUBIVUOHqTcMIPVUGABJJIaB29aq0ff4Z4ZjZy0+SkGwur6+kWvsm9PdXGDtYLAncd+wkW3bvNTexoFVvrw6tKFda3I3QtCmR6tHS85ZRtTqGxCTLaX5VVdmwYzcdJ/2Z2t0GEhMbR0JyiqXVPV6nFrP+9kfOrlnIP8cOo3wpS4X0OV4G8D+0NP/bQHkrk1UpF8b7Lz/OufXd+PSvDe+m+W0ZaX6tR//9aNrjM1RQUkCJvxuUn71k2OTrggwAJJJCgtH9d0Kyk9nLTTrjObBcDDiiX01CQ8SF2ZPNZgE8+pLAwIAARvfvJXx854HD7Nh/0Nw7BdbEhqjp1fy3EzUNvwVlQXJqGp8uXkHdnkNpPfY1Vm/dgcdCkaC/nx89Wz7P9zMn8/O8zxjSuS1BgekpcX9/CBdncHyEH9AD+A74GRiKVmufY55/qjRLPmrKiTVdeG3IwxSLTL818Ac1XLvfJ4QHXs0vxANKsoJyS4FUJcvfRS8Ke0/mWA4hkUjyF22aNqZOjaocPnFad8yU2COM7xuVnvr0AhWtL4CFr+LiRQMZ0L0qn809rjtm5Xc/cvLCJapXKOf9xPY0CAjP9qMxA3rx7iczSRNU8MfExvF0vYe9f1+GNbGB1DALLpeWOXDYLQdSF6/d4LO4lUydv9S8uVE2FAkPY3CnNrwyoDdVymWSlCkKBAZCcBDY7vvuWAQYAryM5mdviaBAG71bV+HVQQ/xWO3fNYYKBDVEtSASzEWcoKQpWiGuzp+btT9cNJplT16ObSQSiQ9RFIXxg/oKxxw/m8jabYZfHFnntXgNADB+WBSCEgXcHg+fLFxmblKnS1cSWKp4MXp3aC18fPG333HxmkmDG2+KAVUypfmT0n0MzL0mM1t276X7q29SuV1v/j7jS8ub/yM1q/HZG69ycf0SJr824e7mb7NBaAgUidT+9/5u/nWBGcBF4GMsbv4VSofyzoTHOL+hO1+988zdzd+GJuMrlm7Kk5c3//RgW7mtoCQowuzb9l+vs++ooaXCNhkASCSFiME9O1EkIvtTcQamJYEetC8jCzxSuyjNm5QVjpm5bA1JKSbdiASSwJeG9Rc+6nS5mJ6jPgQ6lZF3THkSLKf57Q4nX61aT/2+I2j24sss3bwVtwUpos2m0LLRk6z4+B32LZjJyO4dCQ1Ot5UNCICIMG3jDwoiS6SmYqlO4ffLQLOqXQnsB14EDLVsIp58uDhfvt2YU2u78PqIRyhZNP3XlCnNr4ap+SbNryR5V3j712m/Gg25DWzNy79siUTiY8JDQxnWu6twzIYdlzh0Mt7UvIrFzoAAE4ZFCT+/nZjEnNXrzU0qkAQ+XrcOTZ6qL3x8xpKVpJnZ4LKzJna7NTOeDFMeCxv1+SvXeH3qF1Rs24vBb77Lr0dP5Hgu0NL8rwzoxbHlc9kw/UM6NX0mXS2iaJt9ZIR2x+//O7/aDGlifLymVLBGEbQU/1FgA9ARC3X2gQE2Bnasxq55bdkd245BnaoT4G/TZgzUGvaoRVStR2BexqlV9Cu3FUjD6yzR8s3n2fjTZcNhgD0vJzwkEsl9YOKQaGJmz8Otkx5XVa0W4JO/NPR+UieaS6CFhigdW1agRpVwTpxJ0h3z8bzFjO7ZWShpzIqqbcjB2X/bTxwSzTaBwuDardvMX7eJIZ3bevk+tBNxSLB2wk+z+6RV8J5DR5k8bwnzv9mE0wfz1axUgRHdOjCqRyeKZs4I+dm0+/3fn/QzcLm1LIZvTv010QyBRmHRfhegTIlghnSpzvi+talYJlPiwMbd+/38cOS1p1+r5UBie+xsIkP+ut2boTMgb994SCSS+0DViuXp0Ow5Vnz7ne6Yr1ae4l8T61M0wvt+Kkpqulwqh9hsCmOHRPHq33/WHXP0zHk27NhD68ZPeT+x3Z6+od37Ufc2LahUriznLumfmGLmx5kLAFRVO+1b7AtgdzhZsH4zMbFLzJsUZYOiKLR9piETo7vTpnGDrEGUv78WJPkHZPP7pGr1FGlpWgBgcRlAG2BS+v9aTh09VbcEk/rXpnfrKgQGZNrh/UENzuO6/Qw8QBoodkX79xxw8VoqXSd9x+1Ew+DsB7SmSfkiHpJIJD7GSBKYnOriiziT6WW7muMvrwxGRNcgMiJAOMa0Rt/jAVf2Gn1/fz/GDBBLAn85fIytv5h0rbWw+V+5cYt/z46lRud+DH7zXcubf3hoCC9278iBRbNYM+U92j7TUNv8FbTTfpEIiAjX7vozb5QZ0sT4DGmipc0/HO1Ofz+wFmiLhW3Zz6bQsWkFNsxowa55bRnQodrdzf/3af68vPm7tK59ym1FO/Xn8O/Pr0du0XjgNxz07uruLxn/IjMAEkkhpPkzDXgkqiYHjupL76bNP8LLA+vg560kEEULAkJyvq6I8AAG9qjGtNn6m97abT9x7Ox5alUWuxxmwW7XNrhsGBndnX9O+YxUgY4/JjaO5x63ZBtvyK7fDjM5dgmLNmwx34o4G2pULM/4vt0Y2rkdRTJr9W02CAqEwCDI7mfrcmspfh9IEzPxLRba82ZQsmgQL/asxdg+tahQOlOaX0Hr1hdM3m7Yk4EjPc1v8cecnOriwy8P8f6sg6SkeTVZLPB9xv+RGQCJpBCiKAoThoglgacvJrNyi7mWsb4oBhw/VCwJ9HhUpi5Yam5Sp0u3Or9ksaL069JO+PiyzT9w9vJVc+/0alku5n+zicaDx9Fw4BjmrvnW0uavKHer+Y8um8NL/Xre3fwzmvZERkJw8L2bf+YOhBalidlgafN/rHYxZv79ac6t78Y7Ex67u/n7aVX8WjU/eXvzV7ViPuWWorXrtbD5JyY7mRJ7hKhOK/jb9H3ebv4XgAmZ/4MMACSSQsqArh0obtDDPWZeDiSBdmtBQO0akbR9QdzddfaKdebb2gqa/hhdibjcbvN9CARcu3Wbd2Z+TdUOfYn+8z/Ndx38HaHBQYzq0Yn9C/93p5rfZrMB6U17Io3S/Nalib7Gz6bQvUUltsxsxd6F7RnWtQbBQek7fIYpT1G0JlR5Ps2voNzU5HxWrslOnEvi5Q/2ULHVUia+t5uL17yWxTrQTJKyNLaQVwASSSElNCSYEX268f6M2bpjNu+6wr6jt3k0yvsibSUNVIsSqwnDa7N2s35DooTkFGavWMfE6O7eT+qwZ3/yBR6tU4tmjRuwefsu3cc/X7qKN18cfFcfnwP2HjlOTGwcses2mpMX6lClXBnG9e7K8K4dKF4k4u4HtnQZn141v9utBUQ+SPOfuXSFmz7oPJhBschARnSvybi+UVQpl+nqIkPGF6Lm7ZN+Bo5M3fosoKqw8afLxMw7zOqtF3PS1llFU1vcU/UrAwCJpBAzblAfPvpiDi6BxeyU2CN8/lYj7yd1AS4F/HO+s7R5vhx1akZy+Lj+xjJlfhzj+3RNP+l6gcrdICAbJg6JFgYAN+MT+XrNBl7s3tG796Xj8XhY/cMOYmLj+PanPaae1ePJh6KYGN2Dfu1a4O+XaTf094OgYAjMrt4ho5rft9LE2HUbhX9+vCWqSiRj+9RiRPeahGX2hrClb/p5vaAP7jTFslLQl0Ga3c3C9Wf48MtD7D9m2NVPDzcwFpiT3YcyAJBICjGVy5elS+sXWLJ2o+6YuatP8e6k+ne7qHmBkgpqhPE43ecVGDckiglv7NYdc/zcBdZu20mH50y4wNod2gaZzUbSqcXzVKtUgVPnLug+PmV+HCO7dfCqD8HN+ES+WLaaaQuW+qR+IDgwkH7tWjChb3fq166Z6RMFAvy1wMY/m6Oxmm6PnGa31IQIIM3hYN7ajUyZH8feI/oFpN5isym0f7Y8k/rXoUWjslmTFQHpMr4A8v7G70o/7fvAHOvMpWSmzT/KF3HHuZVgKUuUhOajoCubkQGARFLImTiknzAASLW7+XzJcf48vK73kzrQTkAWqowG96rOG//+lfhE/RxqzPwl5gKADElgNooAPz8b4wb24Q//+kj38QPHT7Fp1y+0aPiE7pjfTpwmJnYJX6/ZQIoVh8B0KpQuydheXRnZvQOlimW6ilHSq/mDA7V//z0et9YJ0aHfDdFbLly9zvRFy/ksbhXXbuX4NHqHyLAAhnatwfi+UdSsnClSLKRpfoDvdl8lZt5hlm8+j9uCe2M6+4E+wCHRIBkASCSFnKYNn+DxunX45bfDumOmLzzKa0Mext/P+6OYYgfVgiQwPMyfYX1r8N/P9de1YcceDp06w0PVTHjFpOlLAof36cpbH08nWeA5EBO75J4AwOPxsGrrDmJil7Bp1y+oFjdcgMaP1mVidHd6tGhKQGaHQX9/LcUfmF1zI1WT8aXZtap+i2zf9xsxsXEs2fi9TzoQRlWJZHx0FEM6VyciLNPPID+l+TNMedJy1q0vM2l2N/PWniZm3hF+PXLLF6tLAt4GPsKLsEQGABKJhIlDohn62lu6n5+7nELcxrP0bm1mo1UgxNpGOHZIFJNnHtEtfFJVlSnzl/LJn1/yflJXuiTQ794jZtHICAZ178j0rxfpPr5q6/Y71sTxScn8b/kapi1Yxonz5lwUsyMwwJ/erZoxMbo7DerWufuBgtalLzgoe7vhjDS/3a7rgOgtDqeLhRs2ExMbxy5BUOgtigKtG5djYr86tG1SLqvVdH5K87u1AlfsiuU0/4WrKXyy4BifLznGtVvWs0RAPDAd+A9w3duHZAAgkUjo26kt//fux1y7qX8KiZl7xFwA4AHsWDJdqVElnI4tK7BivX4/gq9WfcM744ZTLNJE0UGaHcKyN5qbMDiaT+cu1j3Fezwqb02fRZHwML5c9Y15h8JsKFOiGKN7dmZ0z86ULVH87gdKuowvOCh7+12PR/u12K1fPl+5cYtPF6/g08UruHzjpqW5AMJD/RnUqToTomtTp1pkpk+0k74aQv5I8zsz3e9bZPuv15k89zBxG8/hdFmsEtQ4CkwBvgQSzT4sAwCJREJwUCCj+vXk7amf647Ztvcau367QYO6JbyeV0lTUIOsbUwThkUJA4Dk1DRmLlvDHwb18X5ShxNCPdnenT9Usxqtnn2a9Vv1TVW+XrPB+3cJeKJOLUb17MzADq0ICcoUKfn5pXfrC9Qx5XH5LM3/8+FjzFi8gjmrN5Bqt34arVYhnFE9azGyR02KF8nU/8eG9mchhLx/2vegbfw5NOXJjMPpYfnm83w89zA/7r3mk+UB24DJQBwWVigDAIlEAsCYAb14f8ZsHIJNZWrsUb58u7H3k7rQbiLF7f2FtHi2LI8+VJR9h/SLz6YuWMrLA3rh560k8I5LoL4kUBQAWMFmU2jf5Gkm9etBy0ZPZv0wwJs0v0O3q6G33A9pYpP6pZjUvw7dWlTKWiuSn0x5fJjmv3ozjVnLTjJ1/hHOX7FsmQza/f48IAb4zRcTygBAIpEAUL5MKXq0a0HsinW6Y+avO82/X6pP2ZLeV/cpaQpqgPVagNF/3Kn7+ZlLV1jx3Ta6NXvO+0nv2ATfuyu1b/YstatX5cjJ0+YXq0PRiHAGdWzNqwP7ULls6bsfGKX53W4tY2G3W67mj09KZvaKdXz09UKfSBODAm30bl2FPwx++HfNolQIVLTCvvywy/gwzf/zoZvMWHyMOStPkWq33h8BOAl8BnwOWL+byUR++NFIJJJcYuKQfsIAwOH08NmS47w5qp73kzqxLAkc2KMaf3nvV24ICqZiYuPMBQAeDzhc2TbNURSFsQN7M+nv7+dkuVmoXbUSY3p2YWT3jlm7COZimv/I6XN8smgZXyxd7RNpYrmSIbzYsybjo2tn7Q+hqBCkaPf7Nt+aCfgclbsyPosCB49HZfXWi8TMO8y3O/StpU2SkeZfiuUVZo8MACQSyR2efrweDR97hJ2/HtAd8+nCY/xpWN2s3usi1PT2wNnX3HlFSLAfw6Nr8P4n+j3zt+zey69HT/BYVA3vJ7an6XTNg6G9OvPmR58Qn5hkdrlZ0vwtGj6RtXHQA0jzb9z5s0+kiU8+XJyJ/WoT3a4qAf6Zfv4Zaf4g8LWLkM/xpN/t27G81NuJDr5ccZKP5hzm7KVkX6zODiwEPgRMelCbRwYAEokkCxOHRDPg5b/ofn7peiqL1p+lf4eq3k+aIQm0cAc8dnAtPvrsEC6X/rf2lPlxfPHma95P6nKD2wV+934VRoSFMbhHJ2Jmx3o9XWRYKEM6t+Xl/r2oWr7s3Q8U5a4Fr5+gmt8HTXsSklOYtXwtH89bzOmL1k+jgQE2ujSryCsDH+LpR0v+7sP0an4LbZ9zDWempj0Wl3v4VALTFx7li7gT3jrxGXEJLc0/FRMyPqvIAEAikWShV4dWvPbuf7l0Vf97KGbeYXMBgAo4FLCgCKhcIYwurSuyZM053THz1m7kvYkvUtLA5TALaQ4Iy/6rcMKQaKZ/vciwCc7D1aswoW93BnZoTVhIpsJCm5/WqU+U5rc7wOmwvCkdOnWGmNg45qxeT3JqmrXJ0NL8Y/rUYlTPWpQunvnXxN1uffnBT9bum2p+t0dl+ebzTJl3hC27r/hmbbAVrahvGfcpzS9CBgASiSQLgQEBjO7fi7f+O113zM4DN9ix7/q9J0IBSqpvXAJFAUCq3c7ncav487D+3k/qcGrZiWxcAmtWqcTr44bz98kz7vksI80/Mbo7LRs9eW+aPygIAvy4J+2RYUrkozT/2m07mRy7hG9/2uOTNH+jeiWZ2K82PVtVznrNk5+q+T1AWvqJ3+Jvya0EB1/EHeeTBUc5fdFnaf5YtI3/F19MmFNkACCRSO5hVL8e/GvaTOwCy9qYeUdMBQC4sSwJbNqoNI8/UoxfDug3LPpk0XJeG9w3q0ueEFWrsA/JXhL4t5dGU6FsaT76Yg5HT52lTMni9G7bgvG9u1KzfDnteUXRUvv+ARAUoJ38f4/Ho236Pqjmz7BDnjI/juMC8yJvCQyw0bNVZSb2q02jetmk+TO69eV1XOkyPof1jf/gyXimzDvCnFWnSE71yeH8Ilq3vs8A6xIMHyADAIlEcg9lSpagT8fWfBW3SnfM4g1n+fDVJyhfyowkEFSLG8n4obUZ/uoO3c/PX7lG3Kat9G71gveT2h0Qot+IfmTf7ozs2x1VVb1yAsyCy61t+oJgyluOnT3P1AVLmb1iHQnJ1rXlpYsHM6pnLUb3rpX156gAQWp6Nb/l19x/fJTm93hU1vxwkZh5R/h2xyWrcVoGP6FV8y/GJ7ZBvkMGABKJJFteGtZfGAA4XR6mLzzKP8c95v2kDgU81u6O+3Wryuvv7eXKNf177pjYJeYCANWjXQUEBgqHeb/5q+BMl/H5wETnh737iYmNI27j97gtWvoCPF6nGKN7RTGwUzVCgjJlK/wyVfPn9TS/qkCqimJXtJS/BRKTncSuPcPHcw9z6GS8L1bnAJajbfzbfDHh/UAGABKJJFser1uHJk/VZ9vuvbpjZiw6xl9GPEJwkPdN3ZU0BTU050eroEAbI/vV5O3J+lLFbXsPsOu3w1kNdYxIsxsGAIao6Wn+NIf27xZIczhYuH4LH3w1nwPHT1lbF+k1C8+WZ1L/OrR8umzWDwMy3e/ndTLS/HawGqWcOJfE53HH+GzxcW4l+KALkJbanwVMA/SLVfIIMgCQSCS6TBwSLQwArt2yE7v2NEO7mtDep2G5H/zoQbV4/5ODOJz6m+zUBUv58h9/9n5St1s7rWenzzfC5dIyCA675bvni9du8FncSqbMj+NmvGl/l3soEh7A4M7VeWXQQ1QpF3b3AxsQqKIGkz9MeRxaISku66mJH365Rsy8w8R9ew63jtOkSX4BPgXmANbdoXIJGQBIJBJdurdpQaVyZTl3SV9PHjPviLkAQEXrtR6c8y/e8mVC6NGhErHLzuiOmf/NJv49aVRWdz0j7A4TAcD9SfMv3bQVl0V1AEDtqpGM6a2Z8oQGZ/o15ac0v4f0jd96mj/N7mbh+jO8P+sgv53wSZrfA6xBS/N/64sJcxsZAEgkEl38/f0YM6AXr38wRXfM3iO3+H7PVZo+WVp3zO9R0tJPnhaYMKy2MABwOF18tmQVb744yPtJHQ5NDSAyFcro1pdm1yr7LWB3OFmwfjP/mbOAfcdOWpoLtDR/84ZlmNivDh2bVsjaeiDfpfnTe/NbPKCfupDEjMXH+HzJcW7G+yTNH49mv/sRoP8HMB8gA4DscDi1yl2JJLfwQeMWQNucknyiVb7DqC7t+P/27js+rqtM+PjvTpNGo1EvtiTLli1LJr2SYJPYqYRA4EMKpMHLCyTsC0sCC+xStrLL+wLvLmAHQ0gjS7ATpztOnIQ4dnqc4iROsT2Wi2Sra1RmNJKm3rt/jItka+7c0dzRqDzfz0d/JPfM1dFYmvPc55zznP+47U6GgzqL7tZ6UgoAiCkQSW9r2blnlPHx00p5873ehG1WP/gY//DV68hJUO53XIEh/QAgGkl7UOrw9vLHRzawet3jeAfSfxotcNm59tPz+d6NH2NJXcHRCwpHq/VZp3i1Po2x1frSdDjN/9jzB4nGTPnZPcS38d0JmHK8X7ZJADAeVU07shciJSakkIF4AGDC4TGjleQ5ue6yC7n78Y0J2zy++SD72wLUVecbvq8ZWwK/8/VGvvyd1xJe7+4b4OFNL3LD5Rcbv2kslnaBnkS27dzNyrWP8MCzm5NWFzSivtbN317bwNe/UE9+3qiPc8uhSn3TIc2vcXQbX5ofu6FwjHXPtvBff97J+7sTHx+dAhXYTLxoz5NM+YMOUiMBgBAiqe9efzX3rH86YaW5mKpx+0NN/PK7pxu/aViBmJbWArQvXlHLj37+Hm2diR/IfrPmodQCAJOFI1HWv/AKv1nzMK+/n/4x7ooCF50zRz/Nb2fqD/yxQ4O+CWn+Du8If3yoidUP7MY7kP5ph4AfeIB4mt9jxg2nIgkAhBBJnVRfx/IzT+UFnR0Bdx46JtjlNP6xogRBcyVvl4jdYuGmL9XzrysTH5y2bedutn6wg3NPPmHi32gCunr7uXdDvFpfm865Cka5XXau+/R8br1hCScsPOasg8NFe6bLan6T0vzbdvSxcs0uHnimhUjUlKxtE/EtfHcDqR8DOc1IACCEMOSW667UDQD6/WHWPNXMzVfXG79p6NApgakUBlLjr1PCQBS+9YUGfnH7RwRDidP2q+5/dNICgG07d3PHIxv485N/JWhC9b+FNfncfNVibr66nuKCUSv4puNq/mD61frCEZX1W1r59X072fq+KQfnacDzzNA0vx4JAIQQhnxu+TIWVs9lX1tHwjYr1+zipqvqxz34blyHTwlMtiVQAyIKSojjjnMtL87hi5fO588bEq+if3jTi/zq1m9SU1lusGOpiakqG1/Zyqr7H2XTG9tMueey08q59YYlXHnxPKyjDyqaVml+BSWoxQO9NIfVrt4g967fx233e2jrNmUN3iDxQ3lWAjvMuOF0IwGAEMIQq8XC/7nm8/zwt7cnbLNjn4/Nb3Zy0TlzErY5ljKC/pZAA3Xev3vjEt0AIBKN8sdHNvDv3/qa4X4Z0dM/wD3rn2b1usc52JX++S65OVauuaSWH371BE5eXDTqSvxJf9qk+SOjtvGlGaVs29HHHY808ecN+3WzPCnYS3wl/x1A4lOlZgEJAIQQhn3jC5/h3+74bwLDiYudrVrrSSkAOJweHrM/XePoca4GpnZPX1LMstPKefW9noRt/vjIBn76jRvJTbfcL/CeZw9/eGg9f9n4HMPB9BedVZU7uemqer5zXSOlRaPOTLaAlqNBLlP/UB6No9X6YukN+pGoyuObW7njkSY2bU1chCpFrxJ/2n+UtCciZgYJAIQQhhW58/nyZy7lDw+tT9jmyZfa2HswwKJ5KW4JPDwuh0EZTn2u+JYbGnUDgJ7+Ae5/5nn+9+c+ndqND1FVladMTvOfeUIJt1zfyPWX12Gzjho0baPm96c69VCGJkTaaf7uviB/enwfq9d5OKizsyMFQeAh4FdA4sMjZikJAIQQKfnu9Vdz+8NPJNwSqKoaq9d5+PUPzjR+04gCYS1+yEtkYk+PV15Uy7w5eboDx6r7H005APAFhrj3iWf47dqHaW5P/2k0x2Hhi5fO5/tf+RinNhaPveg4tH9/Onwyjy7ak+bA/+6ufm5/aDf3bdjPiDlp/nbiaf7bgMSVoma5w39pFuArwKVAZlbJTI5aoCHRxUt0+AUAABxfSURBVIb5NZzakMIKZSEmydDICBtfeSPhdZczl8s/ee4k9kjfxle2MqRTvbAw307rc1eOLU4zCf7f3R/xk1WJdyoAXHH+UnJzjE0DhMJhNr2xzZQ0f3VFHt/60mJuumox5cVj0/xHBv5pk+ZPfzV/NKbx+OaDrFrr4eV30l8/MUoQeB3z0vxRoI14JuFZk+45JSjEk0wbgQuz3BchxAzyux+fzbevTRiPZ4R3IET1xY/qnhI42T5xall8Nf9F87DbRo3w0ynNHzv0tG9Cmr93IMRdj+7l9w/u5kCHuWWrJ8F/Aj/MdifMogA/B36S7Y4IIWaWxgUF7Hz8CuNbAlM0NBLlrY96efXdHj7cM4Cn2c/ulkGGRkwqq5wGhz2e5r/1hkbOOrF0/EY5oOVP8S3nJqb5P9wzwKq1Hv7ypGlp/mzQiGfKp+Xpf8dSiKc2qrLdESHEzPP07y/gsmXmfbxs9/TzxIutPPliG+/s7DPrkBfTzClz8s2r6/mbaxYzp8yZ/AX2Q0HAVEv9G9h6aYSqamx4sY1Vaz1sftO01fzZtga4MdudMIMNmJvtTgghZqZVaz1pBwD72wLc8/he/vLkfprbp2bK+KwTS7nl+ka+9Kn5OOwpjOYRUPwKmju9MxFMYeJqfl8gwt2P7WH1A7vZ1zrjKurOmAdmG1O/lpQQYpp65tV2PM1+GhcUJG88iqbBhhdbue1+D5vf7EJVp9aTPoDdZuHKi+Zxy/WNLD0tjbXTMVB8ClpBllb/R+PbMAmlPxR4mv2sWuvhzxv2ERjO/lRMhsyYMXM6bDYRQkxTmga33e/hdz8+21D7aEzjgWea+eU9O/hwjynHuWbMNZfWsuofzhpbuGeitMOZAMA+ScHO4dX8aY7Tqqrx7GsdrFyzi7++3kGC3aFiClKYRQcfCCEmX36ejdbnrqQw367bbtPWTr73/7dN+YF/tPw8G9++toEff/2kpD+fIQrx6QATbjWuw4fyjBirsKgnMBxl7cZmVq7ZxY59PlO6N028AFyQ7U6YIWkA8LXzjEXuLhPKawohpp9uf4B1b23XbfPrH5zJ9768ZNxrO/f5+O6vtvHX1xMfMjTVVZU7WfWjs7jq4tr0b6Zg/nRAVImX6E3/cEL2Hgzwuwc83PPYXvxD6Z/pm5/jYGn9AmpKxh5xrKDgsFmxWSZ3heSBvgHWv/uRXpMXmCEBQNJfsdNrqw3daE6BO+3OCCGmHw14ZU8zbf2JnwJXr/Nw6w2NWEadahdTNf7z3p386+3vm3XICwCKouDMcWKz2bBYLFgtVmxWGxoaiqIQi8UIRUKEQiHCERNGRKC9Z4Srv/8yn7+ght/9+GxqKvMmfjMNlEEFrdCE3QHhUdv40qBp8Pwbnaxau4unXm43ZU1GdXEhyxsXctaCGuzWoysgrRYLeQ4HeXYbSqb2kOrYfrA9WQAwY8gaACFEWhTg8pOXcOdLiSsZ7j0Y4MmX2vjcihoAmg4McuOPX+XND9Or0mqxWHC73BTmF+JyunDmOslx5OBwOMh35ePKd+F0xv+fZZwnyUg0Qm9/L719vfT09tDW0cbg0OCE+7N+Sysvvt3NPT87ly9cOG/iP5h6KAgo0FJfcmZimn84GOW+J/dz21oPH+1NP81vURROrpnL8saFLK4sG3Mtx2Yjz2EnxybD0mSRd1oIkbblDQtZ+8a7DIUSP1GvWuvhcytqWL+llf/1j6/hC0zssdRus1NWUkZJQQlul/vIwG632ykuKqa4uJicHGML8+w2O3PK5zCn/Ojphb5BHy2tLext3ktXT1fK/RsYDHPV373ELdcv4VffOz21bYGjRUEJHNoiaLR9UIGQRroL1Vs6hlj9wG7uenQP/f70syR5DjufWDSf8xsXUuI6mh2xoJDjsOFyOCY91S8kABBCmCDHbuOij9XzxHs7ErbZ/GYnX/vnrdz7xN6UV4orikJxQTEVpRUUFxSPSQ273W7Ky8pxuVympIwL3YWc8rFTOOVjpzAYGGTH7h3sbNpJMJT47INjaRqsXLOLNz/0sn7lirG1/1MRBkYAvZpCx6X5J/4evPh2N6vW7mL9llZiJqT55xS6Wd64kI/X1eKwHZPmt9txOuxYspDmF3ESAAghTHHZSY08uX0naoLRXdPgT+v3pnRPRVEoLymnprKG3JzcMdcKCwqpqKjA6TRQcW+C3PluzjnjHM469Sw8ez2888E7BIaMF7Z5fbuXpV95lqdXX0B97cTWSSkjCpr9mEWBGvFqfcH0q/UFQzHWPt3MbWs9vOfpT+9mxP/NTqyqZHnjQhrnVowJR3JsNpx2O7l2GXqmAvlXEEKYotydz2nzqnjnQJsp96sorWDenHnkOMY+Pefk5FBVVYU7f/IWHlutVk5oOIEl9UvY0bSDt99723BGYM+BQZZ+5VmeWn0BZyc6F0DP6EWB2qiiPWk+oLd1D/P7dU3c+UgTPf3pn3aYa7dx7qL5nN+wkHK368j/VxTItdtx2e3YrNkudyhGkwBACGGKcDTGJxvq0g4A8px5LJq3CLdr7ACvKAqVFZWUl5dnZXU4xBcdntR4EovrFvP29rf5cNeHaAbmM3r6Q1xy8/NsuuOixIcD6VHj1QLTXdQHsG1HHyvX7OKBZ1qIRNO/YVm+i6WLF7CsfgF5jqMFDKwWhTy7Q9L8U5gEAEKItGmAPxhkcWUZ1UUFtA34U76HoijUzq2lqqLquAHeYXdQW1tLXl4a2+tMlOPIYdnZy1g4fyGbX95saOeALxDhsm9tYctdF3Py4qLUv2kaY3U4ovLgX1tYtcbDWx+lt/MC4qsMGudWsGLJIk6YWzHm38tus+KyO8ix2TJ2EqQwhwQAQoi0DYfDRNX4CLV8ySLWbn03pdfnOHJorGskPy//uGtut5vamlqstqmXPp5bMZdrrriGl7a+xJ7mPUnb9w6EuOSbz/P6fZ+irvr4n9Vsnd4R/vjwHm5/qIlO70ja98ux2fh43TyWL1lI5ajaLwoKufZDq/mtspp/upAAQAiRFlXVCISOziGftaCGR7d9QDBirMh8cUExi+cvxjbO/u/i4mJqampQpvD5Kw6Hg4vPv5iy0jLeeOeNpFMCXb1BPn/ri7z635fidmWm5u/bH/Wyaq2HB//aQiicfpq/ND+P8xsW8olF83GOTvMrCk6HgzxJ809LEgAIIdIyGA6N2db37oF2w4N/ZVkli+YtGvdaaWkp1VXGKpFOBaedeBrFhcU899JzRKP6P/8HTQPc+JPXeOw354+pjpiOSFTl0ecPsmqth9fe6zHlng1zylnesJCTa+aMTfNbrbgcdnJsdknzT2MSAAghJiymqQTDRwe7jgE/6958z9BrqyurmV81f9xrJSUl02rwP2x+zXw+c9FneHrz00nLDD/xQis/v+tD/unmk9P6nt6BEHc+soffr9tNa9dwWveC+OB+dl0NyxsXUVV09BhnBYUcu5U8Rw4OSfPPCBIACCEmbCgURju0Hy0UjXLXy28SjibfmF47t5aaOTXjXitwF1BdPf0G/8PmVs7ls5d8lg3PbSAS0a92+LPbP+BTS6v4+Emp7wzY7unntvs9rNnYbMpZCsV5Ts5rqGNp/QJcOUcPd7MoCk6HHZfdYVq2QkwNEgAIISZEVTWGw0cHuA3v7aTbn7xITmVZZcLB3+l0UltbO6Xn/I2oKKvgsgsuY+PzG4nFEg/O0ZjG9T96hXfXXW5oPYCqajz1cjur1u7i+Tc6U66oOJ55JUWsaFzEmQuqsY4qx3s4zZ9rz9TZxCLbJAAQQkzI8Kin22ZvHy/t3pf0NSWFJSysWTjuNcWiUDuvdtxDe6aj6jnVXLDsAja9tEm33d6DAX5623ZW/eishG36/WHufmwvqx/w0Nw+lHbfbBYLZy6oYXnjQuaVHN2SqBAv65zncOCQoj0zngQAQoiUaRpHnv5jqsqare8mXf3ucrpoWNCQsIhP9dxqw4f4TBf1C+rx9np57yP9dRF/eHA337iynlMaxtYH2LHPx21rPdz35H6GRowtrNRT4MzlvMV1LFu8AHfu0ff6cJo/z+7AKmn+WUMCACFEyiKxGKoW3172StN+On36hXAsFgsNCxoSPt273W5KSkpM7+dUcM4Z58SPGu5MXCExGtO45ZdvseWuS9A0jY2vtLNqrYdNWztMSfPPLy1mxZJFnF5bdVyaP88eT/PLav7ZRwIAIUTKRg6l/4ORKM98sDtp+7qaOpy54x/aoygKVXOrTO3fVKIoChd+8kIefOJBQuHENfdffLubm3/2Bi+83cWeA8krCyZjtVg4rbaKFY2LWFBWPOZarj1+KE/OOLUXxOwh//pCiJQFo/EAYNOOpjFFgMZTUlhCZWllwutlpWUzLvV/LFeei6VnL2XLq1t02931aPJqgsm4c3NYWr+A8xrqKHQePUFRUcBpt+PKcWBVZsY6C5EeCQCEECkJRqJoGoyEI7zg0T/e12KxUFdTp3u9oqLC7C5OSY2LGmna10RrR2tG7l9TXMiKJYs4c37NmHK8NovlULU+27TfXSHMJQGAECIloUNV7l7b20IoScW/qoqq447zHa2kpATrLFptvuzjy3joiYeOrJ9Il6IonFhVyYoli2icUz7mWo7NRp5D0vwiMfnNEEKkJByLoWoaL3n0t/057A6qKxMX9FFQKCstM7t7U1pxYTFLFi9hx+4dad3HleNg6aL5nNewkGLX0bUViqLgPHQoj3WGbKcUmSMBgBDCsKiqEVNVPmjtoG9Iv+xsdWU1Vkvip/uCggIcDkfC6zPVGSefwa49u1DV1LMAVUUFLG9cyNl187CPypxYLBbyHQ6cdlvCbZZCHEsCACGEYeFYfPHf283689g2q42KUv25/cKiQtP6NZ3ku/JpWNjArj27DLVXFIWGyjJWLFnEidVzxp3FtykKeQ6p2CdSIwGAEMKwSEwlFI3yUVuXbrvKskrdp3+LxUKBuyDh9Znu1BNPTRoAOO12PlE/n/Ma6ijLd+m2jU4gmyCETBIJIQyLxmJ82NpJRKe+vaIozC2fq3sft9s9Y0r+TkRxYTGV5Ym3RgLMLyvmC2eclHTwB1A1bUJTCmJ2m71/gUKIlEVVjXdaEle0AyjIL8Bh15/bz3flm9mtaalxUaPu9T1d3iM7LoyIxCQAEKmRAEAIYUhU1QhHo+zs6NZtV1acfGW/y5X8qXamq19Qj82aeBY2qqo0dXkN3y+ipX8ksJhdJAAQQhgSU2O09vmSpv9LC/XPtrdarTO+8p8RDoeD6rmJt0kC7GjXX2sxmirjv0iRBABCCENUTWO/t0+3jdvlxpak8ExuTq5sVTukZm6N7vVUMgAqMgUgUiMBgBDCEFVNHgAU5Cdf2T8b9/4nkiwD0O0PEI4ae7SPqSYcGyhmFQkAhBCGqGg0JwsAXMkDALvsVz+ipKgEp3P8UxIhnnVpH/AbupfsAhCpMq0OQE8gYNathBBT0OBImIHhYMLriqLgdrmT3ifZDoHZpqy4jIMjBxNeb+v3HXec73himiafwyYIhMPZ7sKkMS0AkPSTEDNb79CQ7vUcR46hg31k/n+skqISDrYnDgDafcYyACCfw2ZQZ9F7KFMAQghD+odGdK/nOnJ1rx82mwsAjae4SP/p3qeTdREiHfKXKIQwZGBEPwAwvLVPEgBjFBUW6V73ByUAEJkhAYAQwpABkzIAqlSsGyM3R/99GxwJTVJPxGwjAYAQwpChJIujjMz/A8R0CgnNRnar/q4IyQCITJEAQAhhiKrpL44yOrcvAcBYikV/TiQqGRORIRIACCEMSTL+Y1GMfZyEI7Nnm5UR0UhUFkaKrJDfOiGEKYwGAKGQzGmPFg6HpYiPyAoJAIQQhmhJUgAxg6fRjAT1FxPONkPD+vUVhMiUpIWA/m39c5PRDyHEFDcY1H9yj8aMnV2vqRqhUEhOBDxkMDCoe13VNPkcnkThWbRGJWkA4A1IdCqESM5oAAAwODgoAQAQjUYZHh5O2k4+h0UmyBSAEMIUkWjEcNtkT72zxdDQEKGwrIkQ2SEBgBDCFKnM7Q8NDaFqsvDN5/MRDMk+f5EdEgAIIUyRSgCgqir+FA65mYlUVcU36CMYlgBAZIcEAEIIU4Qj4ZTWAfT192WwN1Of3+dHUzWGRmR+X2SHBABCCNOksqVtaGhoVhcF8vZ50TSNwSFZDyGyQwIAIYRpfIM+w201TcPr9WawN1NXYCjA8PAww8FhKY0ssibpNsB/+fwlhm5UmpeXdmfS9dyO3WzYvlOvyT3AzyepO2Lm2AqUJ7r4/U8tJz/XkfQmxU4nFiW7Z+G+uf8Af9n6rl6TJ4Fbda7fBPwo0cWBwQFqqTXcn76+PirKK7DZkn4UzSiHAx9/IOk6iB3AFZnujwk2ACckuvg3K86lstCd9CaFzlxsBitKZsrOzh7+sOW1rPZhsiT9qyvLdxm60ZyC5P+4mebOTbqv2Afsm4SuiJlF9xGtxOWkwJn8KNwKd37WA4BCpzNZkwD6fyOPohMABIYDRKNRwwO6qqp0d3VTVV1lqP1MEAgE8PvjA3+fL+k6iOeYHp9ZunsZC/OchsaS0nwX9iyfi9A9GMjq959MMgUghEjFNkA3b9/r603pht4+L8FZdORte0c7EK+bYCADsCnjHRKzlgQAQohUqMAWvQbdvd0p37StrS3pWQMzQW9v75Fgp3egN9nPHAFemox+idlJAgAhRKqe1rs4ODTISCi1A3+Ghofw9s3sBYHhcJiOzo4j/93T15PsJZuA2V0sQWSUBABCiFQ9AugWsJ9IFqCro2vGTgVomkbLgZYjx/4GhgNGtv/dn/GOiVlNAgAhRKr8xBcDJtTp7Ux5e5uqqTS3NM/IbXEdnR2MjBzNirR1tSV7SRBYn8k+CSEBgBBiIu7VuxiLxej0dqZ803A4TMuBlhm1HsDr9Y6pdxAMBY2s/n8MSf+LDJMAQAgxEVuAZr0G7d3tE3qaDwQCHDh4YEYEAT6/b8y8P8DBzoNGfrbfZKxTQhwiAYAQYiJU4Ld6DSLRCK1drRO6uc/no7W1FY3pGwT4/X4OHBgbyAwODRpZ/LcFeCuTfRMCJAAQQkzcnYDuaNbR3THh4277B/qPG0Cni/7+fppbmo/re3Nbs5GX/1cm+iTEsSQAEEJM1DCwUq+BqqnsObBnwt/A5/OxZ+8eolHjpwxmW2dnJwdbDx73/7t6u4ys/P8Q2JiJfglxLAkAhBDpWAl06DXwB/x09Og20TUyMkLTniYCgaldojUajbJv3z66e47fAhkMBWlubTZym7+HaTzvIaYV007giKnZ/51Vs90BIXTEVBUtywedZOBvJAD8I3C3XqOW9hYK8gtwOY2dLXKsSCTC/ub9lJWWUTmnEkuW38dj+Xw+2trbxs1UaJrG7ubdxNSkCyKfIkmRpZlOVVViZPe8DHUaTjlNlGkBQM8UiM7D0Zm3f1jMHL1DurVzJsVIJJyJ294LfBs4I1EDVVXx7PdwSuMp2KwT+9jRNI0ebw8+v4/qqmrc7uwfQBYJR2htb2VwMHFqv6W9hcBw0s/HMPB3ZvZtOuofTq2CZCYEQhn5G5mSplYYLYSYjlTgm4DuRH0wFGR38+60F/WFw2H2N+9nz949BIay8+ARiURo72jHs9ujO/h3ejtp7243cstVwG6z+ieEERIACCHM8Dbwi2SNBvwDNLU0mfINh4eH2bdvH/v27ztyvG6mjQRHaGtrY5dnF16vF1VLPKnS7+9nf+t+I7fdAfyzWX0UwijTpgCEELPevwNXAKfqNfL2e7Hb7NTV1JnyTQOBAIFAALvdTmFhIUWFRTidThTFnLnkcDiMz++jv7/f8FkF/oAfz36PkWxHELgWyH7uW8w6EgAIIcwSBq4hXsSmUK9hR08HqqayaN4i0755JBI5UnbXarPiynOR78onNzcXZ64Tq82a9B4xNUYoGCIUChEYChAYChAJR1LqR7+/H89+z5GDf5L4e+CDlL6BECaRAEAIYaYm4KvEDwvSfQTv8nYRi8Wor63HYjF3NjIWjeH3+8dMDVgsFux2O3abHcWiYLVYiakx1JiKqqlEI1Ei0dQG+2N5+700tTQZXefwOPC7tL6hEGmQAEAIYbbHgf8A/ilZQ2+/l1A4RGNdIw67I6OdUlWVUCj+dG82TdM42HmQ1k7DpY/fAm5E9vyLLJJFgEKITPgX4E9GGg4ODfK+5318AV+Gu5QZkWiEHXt3pDL47wM+CwxlrldCJCcBgBAiEzTgZmCDkcbhSJiPmj6ipb1Fd2X9VNPn62P7ru34Bg0HL73Ap4HjywUKMcmSTgF4A9MnSB2aRQUcxNTRNzRCeALH3mZDIGh++ltHFPgS8DBwuZEXtHW10TfQx8J5Cyl0664jzKpQOMT+1v30+fpSeVkX8Clm4X5/3/AIufbpMePsH5nY4VXTkcLsmoP6DVJtS6SuA5iT7U5MkgeA60y+pwNYA1ydyotKi0qpnVuLM9dpcncmLhaL0d7TTltXm9FV/oc1A5cSXyQ5E70DnJ7tTkySF4ALst0JM0yPkEwIMZ2Fie91/wNwk9EX9Q700ufro6y4jOrKavJy8zLWwWSisSgd3R109HQQjaV8MuFO4oO/4UUCQkwGCQCEEJMhRnxNwIfEz7s39NmjaRo9fT309PVQ6C5kTtkciguLJ+0wIH/AT09fD95+r5HDfMazEfgykNJcgRCTQQIAIcRkWkX8ifgvQEUqL/QN+vAN+rBarZQWllJSVEJhfiFWa/ICP0Zpmsbg0CADgwN4+70EQxOeD44R3wnxf5ld06xiGrERX5Vamu2OTBJvtjsgpqVeZs8agMn4G3mOeLngPwGXpfriWCxGd1833X3dKIpCfl4+bpcbV54Ll9NFriPXUGEhTdMIhoOMBEcYCY7gD/jxB/wTfdIfrQu4Htic7o2mkd5sd2ASzahx5F7iEepM/4oAJ5nzlolZ5hdk//d3sr4uNek9M0IB/hbwm/1z2G12Lc+ZpxW6C7WigiKttKhUKy4o1gryCzRXnkvLceRoiqKY/d6pwF3Mngeq0W4l+7+7k/V1rUnv2ZQwl/jK1Gy/qZn++olZb5iYdQqIr3LO9u9wpr/uMOsNS1EV8d0H2f750/n6AFhm9hszjeQAz5P9f4dMfz1o1hs2FRyu1Z0P/JT4HtWpu/k2dTHiVbdWAk9nuS9iessBfgh8jpn1hKcBLcQH/3VZ7suFxOfMz8lyP1LRAfwS+D3xLONsZiWe0fkiM2/KrA24j3iGR8tyX4QQYsb6LLCN7D/t6X21At8BcjP0HgghhBCz1vnEU64Rsj/gH/56E/gm8YyQEEIIITKoGvgB8RP0sjHotwG/Ak7M9A8qxGTSPa9bCCGmmHriUwQXAcsBdwa+RwR4g/iitueB14ivJxJiRpEAQAgxXdmAM4DTDn2dCtQRX4Bm9LOtH/AQL07kAbYDLyNH9YpZQAIAIcRMYye+tbAMKCIeKBQAAeIDewAYOPQlJXqFEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghdPwPXo5jvRxeT80AAAAASUVORK5CYII=','2024-05-09 21:52:23',NULL),(33,'6','06.04','Confirmar Recepción','/gestion/confirmarrecepcion',3,'data:image/jpeg;base64,',_binary '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','2024-05-09 21:52:24',NULL),(34,'3','03.11','Sucursales','/parametria/sucursal',3,'data:image/jpeg;base64,',_binary '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','2024-05-10 16:11:52',NULL),(35,'3','03.12','Tipo Permiso','/parametria/tipopermiso',3,'data:image/jpeg;base64,',_binary 'iVBORw0KGgoAAAANSUhEUgAAAgAAAAIACAYAAAD0eNT6AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAOxAAADsQBlSsOGwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAACAASURBVHic7N11dFRXuwbwZzKZuCdEIZBAPLg7xaFIi1tKKVparIJTpEWLlSIt7u5Q3N2DhgQJGoi7TGYyM/ePfLmlBsnsPXPmzLy/te5ad63mvOf9wmT2c/Y5Z2+AEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhBBCCCGEEEIIIYQQQgghhkKip/N4APgIQB0AwQD8AJQCYAvAQk89EEIIIYZEASAHQBKAZwAeArgC4DSARF2fXJcBwAVALwARAGrp8DyEEEKIMdEAuAZgA4AtAFJ1cRJdBABvAN8BGITCK3xCCCGEaCcbwHIAcwG85VlYyrGWOYBhAHYDaAya2ieEEEJYWQCoC+DL//3/lwCoeBTmNQMQAGAbgKqc6hFCCCHkn24C6A7gKWshM/Ze0BHADdDgTwghhOhadRSGgPashVhvAfQFsBGANWsjhBBCCCkWKwDdUPhMwC1ti7AEgAEAVjHWIIQQQkjJmQFoB+AVgEhtCmj7DEBHALtAgz8hhBAipAIAnwI4WNIDtQkAFVB4/8FBi2MJIYQQwlcWgBoAHpXkoJI+BCgDsB00+BNCCCGGwh7AJhS+jl9sJZ3C/w6FK/sRQgghxHB4A0hH4VLCxVKSWwDeKJxeoNX9CCGEEMOTBSAQQHxxfrgktwC+Aw3+hBBCiKGyB/BNcX+4uDMALgBeggIAIYQQYsiyAfgCSPvQDxZ3BqAXaPAnhBBCDJ0dgB7F+cHizgBcA1BT63beEVrBFf27hqNFPV+U9XGArbWMR1lCCCFEVHLylHgRl4njl15i1Y77iHqSwqv0FRRuIPRexQkAHihcbpBp4yALmRQ/j2mEIT0qQSrVxS7EhBBCiDipVBos23IHo+ech0LJvNmfBoVjd9L7fqg4twA+AofB/8DvHfFV78o0+BNCCCF/I5VK8HWfKjjwe0dYyJgX2ZWgcOx+r+IEgDqsnfw8phGa1fVlLUMIIYQYtWZ1fTFndEMepT44dhcnAASxdBBawRVDelRiKUEIIYSYjC97VkZoeRfWMh8cu4sTAAJYOujfNZym/QkhhJBikkol+KJrOGuZD47dxQkATiwdtKhfluVwQgghxOS0qMc8djp/6AeKEwDsWTrw9WI6nBBCCDE5vt7MY+cHCxQnAFiwdGBnQ+/5E0IIISVhb8s09AKA5Yd+oKTbARNCCCHECFAAIIQQQkwQBQBCCCHEBFEAIIQQQkwQBQBCCCHEBFEAIIQQQkwQBQBCCCHEBJkL3cCHmIcsZDq+4OFIOj8hhBDyNzQDQAghhJggCgCEEEKICaIAQAghhJggCgCEEEKICaIAQAghhJggCgCEEEKICaIAQAghhJggCgCEEEKICaIAQAghhJggCgCEEEKICaIAQAghhJggCgCEEEKICaIAQAghhJggCgCEEEKICaIAQAghhJggSTF+RsNyAtqP3nTk5CnRYcg+nL32WuhWCCGEfGCMpxkAwgUN/oQQIi4UAAgzGvwJIUR8KAAQJjT4E0KIOFEAIFqjwZ8QQsSLAgDRCg3+hBAibhQASInR4E8IIeJHAYCUCA3+hBBiHCgAkGKjwZ8QQowHBQBSLDT4E0KIcaEAQD6IBn9CCDE+FADIe9HgTwghxokCAPlPNPgTQojxogBA/hUN/oQQYtwoAJB/oMGfEEKMHwUA8hc0+BNCiGl4717B/6PReRfE6NWsVRubtmyHnZ2d0K0QQogoeHu4spZ47xhPMwBE52jwJ4QQw0MBgOgUDf6EEGKYKAAQnaHBnxBCDBcFAKITNPgTQohhowBAuKPBnxBCDB8FAMIVDf6EECIOFAAINzT4E0KIeFAAIFzQ4E8IIeJCAYAwo8GfEELEhwIAYUKDPyGEiBMFAKI1GvwJIUS8KAAQrdDgTwgh4kYBgJQYDf6EECJ+FABIidDgTwghxoECACk2GvwJIcR4mOv6BG8SUnR9CkIIITrAYT96k2bo4x/NABBCCCEmiAIAIYQQYoIoABBCCCEmiAIAIYQQYoIoABBCCCEmiAIAIYQQYoIoABBCCCEmiAIAIYQQYoIoABBCCCEmiAIAIYQQYoIoABBCCCEmiAIAIYQQYoIoABBCCCEmiAIAIYQQYoIoABBCCCEmyFzoBojhSkxMREz0Q8TERCMmOhrPn8UiMysTmRmZyMrKQnZ2NgDAzs4O9vb2cHRyhL2dPcr5+SMoOBhBQcEICg6Bu7u7wP9LCCHaMPT97AkbSTF+RsNyAvoAiUdubi4uXjiH48eO4dTJE3jzJo5LXTc3NzT5qClatGyNxo2bwMHRkUtdQggxZt4erqwl3jvGUwAwcQpFPv44eABbNm3E1atXoFQqdXo+mUyG2nXqolfvPvi4XXvIZBY6PR8hhIgVBQCiEwnx8di4YR3WrV2N5ORkQXpwc3ND9569EfFZX/j6lhWkB0IIMVQUAAhX8W/fYs6cmdixbStUKpXQ7QAApFIpunXvidFjxsHD01PodgghxCBQACBc5ObmYs2qFfhl4fz/f3jP0FhbW+OLAYMwfMQo2NvbC90OIYQIigIAYXboj4MYO/pbwab6S6pUqVKY/fN8tG7TVuhWCCFEMLoOALQOgBGTy+WYNHEcBnzRVzSDPwAkJSXhi88jMPzrL5GTkyN0O4QQYpQoABipyMhbaPZRQ6xasVzoVrS2c8d2tGzeBLdvRwrdCiGEGB0KAEbo0B8H0aljOzyLjRW6FWbPYmPRsV1b7Nu7W+hWCCHEqFAAMDIrV/yOQQP6IT8/X+hWuFEqFRg6ZBCWLvlV6FYIIcRoUAAwEhqNBvN+no0fJo6HWq0Wuh3uNBoNfpo2BZMmjjPK/32EEKJvtBeAkZjyw0SsWP6b0G3o3KoVy6EqUGHGrDlCt0IIIaJGMwBGYOmSX01i8C+yds0q/LZsidBtEEKIqFEAELl9e3djxk/ThG5D736cOhk7tm8Tug1CCBEtCgAiduHCeQz/+iuTvCeu0Wjw3TcjceHCeaFbIYQQUaKVAEXqyePHaN+uNTLS03V+LncPT4RXqgrfcv4o41sO7h6esLGxhZW1DQBAnpeL3NwcJCbE49XL53j5PBb37kQiKTFe5705OjnhwMEjqBAQoPNzEUJKhsNKdqLGOv7RUsDkH1JTU9CuTSs8f/5MZ+fw8PRCs5Yfo1bdBvD2KaNVjbjXL3HtygWcOnYICfFvOXf4p3J+fvjj8DE4O7vo7ByEkJKjAEABgOVw8je5ubno0a0zbly/ppP6AUGh6NK9D6pUrwWJpDgfjw/TaDS4ffMadm3fiEfRUVxq/l2t2nWwZdtOWFtb66Q+IaTkKABQAGA5nLxDocjHZ3164dzZM9xre3h6o3ffgahdryG3gf/vNBoNrl46j03rViAh/g33+k0+aop1GzZBJrPgXpsQUnIUACgAsBxO/kelUmHokIE4sH8f99qNPmqBAV+OgJWVfq6eFYp8bFq3EocP8F/et3Wbtli+cg3MzWmJC0KERgGAAgDL4QSFA+aXgwfi8KE/uNa1tLLC16PGonbdhlzrFtfVy+exeMEs5MvlXOu2a98BS5b9TjMBhAiMAoBhBwB6DdDA5eXl4fPP+nAf/O3tHTBx2hzBBn8AqF23IabMmA9HRyeudQ8e2I/ePbrRVsKEEPIeFAAMWFpaKrp37YQzp09xrevk7IKffl6MoOAwrnW1Ub5CEKbNXgQnzk/wX7hwHn16ddfLa5KEECJGdAvAQD1/9gwRfXrg6ZMnXOtaW9tgyoz58CtvWO/Nv3zxDJPHjkROTjbXuuX8/LB+wxZaJ4DolEajQUJ8PF69eomXL1/g1atXSExIQGpqClKSk5GalobsrCxkZmUCAJQKBXJzcwEA9vb2MJNKYWVpCSsra9jY2sLd3R1ubqXg6uoKNzc3lC5TBuX8/OFXzg+OTnxnzHSJbgEY9i0ACgAG6ML5cxg4oB/3q1epVIqxk6ajcrWaXOvycu/OLcyYMg4qVQHXuk5Ozli+ag0aNBDudgcxHjk5Obhz5zaiHtzHw6goREXdR0x0NOScn2X5L87OLvD390doWDgqVa6MypWrICg4BDKZTC/nLwkKABQAWA43KRqNBqtWLsePUydDqVRyr99/yHC0atuRe12eTp84gmWLfuZeVyqVYuSobzHq2+9hZkZ3vkjxJSUl4dLF87h+/RquX7uKqAcPoFKphG7rLywsLBEeHo469eqjQYOGqF2nrkGsiUEBgAIAy+EmIzU1BcO/HopTJ0/opH77T7oi4oshOqnN24Y1v+PAnu06qd2gYSMsXvo73N3ddVKfiJ9KpcKtmzdw6uQJnD59Evfu3oVGw/Q1qHcymQWq16iBxk0+Qus2bREUFCxIHxQAKACwHG4Sjh45jDHff4PExESd1K9Rqx6+nzBNZwv88KbRaDB35mRcv3JRJ/U9PDwwZ+58tGjZWif1ifio1WrcuH4NBw7sw4F9e3X2tygUX9+yaNGqFdq374iatWrr7buAAgAFAJbDjVpmRgZ++nEqNm5Yp7NzBAaHYuK0OXpb5IcXhSIfM6aMQ9T9Ozo7R/sOHTFrzlzaQ8CEPX78CJs3bsDePbuQkJAgdDt64efvjx49eqNrt+7w9PLS6bkoAFAAYDncKKnVauzYthUzpk9DUlKSzs7jXyEQP/w0FzY2tjo7hy7l5eZi2sTv8PRJjM7O4e7ujvETJ6Nrt+6imSEhbPLz83Fg/z5s2rgeV69cFrodwUilUjT5qCl69OyN1m3aQiqVcj8HBQAKACyHG53IyFuYOG4MIiNv6fQ8ZXzLYcqM+bB3cNTpeXQtKysTU8aNwquXz3V6nurVa+CnGbNRuUoVnZ6HCCclJRlbN2/CypXLkRCv+62qxaRMGV981vdzRHz2ORwc+X1nUACgAMByuNF49CgGc+fMwh8HD+j8gSKfMr744ce5cHYxjj++tLQUTJv4HeJevdTpeSQSCdp36Ihvvx+DgIBAnZ6L6M/zZ8+wdMmv2LF9K/Lz84Vux6A5ODigT0RfDBw0BB6enkK3Y/IoAIjco0cxWLxoIfbs3qWXV4f8ygdgwpRZcOC8vK7QMjPSMX3KWDx7+ljn55JKpejUuQu+Hj6SgoCIxcW9xi8L5mPrlk0oKOC7toSxk8ks0L1HT3w3eiy9MSMgCgAide3qFSz5dRFOnDimt1eIKgQGY/zkWbCzt9fL+fQtNzcHs6aNR3TUfb2cTyKRoEHDRhgwcBCat2hFzwiIRFJSEhbM+xmbNm6AUqkQuh1Rs7W1Rf8BgzBk6FdwcnIWuh2TQwFARBITE7FzxzZs27IZjx8/0uu5q9aojW9G/wBLKyu9nlff8vPzMX/2VETeuKrX8wYGBqF7z17o0rU7SpUqpddzk+JRKpVYt3Y15s6ZhczMTKHbMSqOTk749rvR+Lxff9pqW48oABi49PQ0HDt6FH8c2I/Tp08KMtXYpn0n9O3/pcmscKdWq7Fu1TIcPrBb7+eWyWRo8lEztGvfAS1atqSrIgNx7OgRTJk8Ec+fPRO6FaMWEhqG6TNmoU7dekK3YhIoABgYjUaDh1EPcOHCeZw4fgxXLl8S7P6iVCrFF4OGoUWb9oKcX2jHDx/A6uW/CrYsq7m5OerWq4/mLVqiQYOGCA4JpdsEepaQkICJ48fgj4MHhG7FZEgkEnT8pBOm/TQDbm5uQrdj1CgACCwjPR13797Bvbt3cPt2JC5fuoSUlGSh24KDoxNGfDcBFStXE7oVQd27cwu/zJ2OzAzht/11dXVD3Xr1UKVKVVSqXAUVK1YS1c5tYqLRaLBzx3ZM+WEi0tJShW7HJDk6OWHCxB/QJ6Kv0K0YLQoAOqDRaJCZkQGgcGev9PQ0JPxv686E+Hg8e/YMz5/FIvZZLN6+eSNwt/8UElYJI76bABdXSt8AkJqSjF/mTsfDB3eFbuUfvL194OfnV7iVq58fPDw94erqBnd3dzg5OcPWtnCRJgdHR5o9KKbExESMHP4Vzpw+JXQrBEDbj9th5uy59GyMDph8ADD1hSTeJZFI0Lrdp/jsi8GQSulBnHep1Wrs2rYBO7duEN3GLbpkiAGcxbGjR/DtqBEGMQv3b+ytZSjjagt3J2t4OBb+n4ONBRysZbC3lsHexgJmEsBcagYrWeHKe7n5BVBrNFAUqJGXX4CMPCXSc/KRlq1Aek4+4lJz8SY1B2/SciFXGNYuhEVcXFyxcNFiNG/RUuhWjAoFAAoAAIBS7p74cvh3CK9UVehWDNr9u5FYtmgukhJppTfAeAKAQpGPHyZOwPp1a4Ru5f852lggyMcRwT5O8PdwQDl3O7jYWer0nMlZcjyNz8TjN5l49DYDj99mIEduGGscSCQSfDn0a4wZNwEymUzodowCBQATDwASiQTNWn6MiC8Gw9raRuh2RCE/Px87t67H/t3bTH42wBgCwJu4OAzs/7nOl8/+ECuZFJXKuaB6eTdU8nWBj6vwe2xoNBo8jc/C7ecpuP0sBdFx6VAUqAXtqXqNmvht+Ur4+JQWtA9jQAHAhAOAh6c3Bn/9DV31a+nenVtYvmQBEuIN7zkOfRF7ALh48QKGDOwv2JS/vbUMdQLd0SDEE+G+zpBJDftV23ylCjeeJuPCw3jceJqMfKUwtwycnV2wcvVa1K1XX5DzGwsKACYYACwtLdGhU3d80rknZBYWQrcjagUFBTh2eD+2bVyDvLxcodvROzEHgPXr1mDi+LF6f81WaiZBnUB3NKvkg6p+rpCaifPhzHylCteeJOHEnTjcfp6q99kwmcwCM2fPQa/eEXo9rzGhAGBiAaBewyaI6DcErm70RC1PKclJWL/6N1y+cEboVvRKjAFArVZjxk/TsHTJr3o9r7ujNdpUK41mFX3gZGtcwTshPQ/H7rzGibtvkJat3w2RBg8Ziok/TNHJdsPGjgKAiQSAoJBw9PqsP0LCKgndilF78igau7ZtwM3rV4RuRS/EFgDy8/Mx7KshOHhgv97OGeDliE9rl0XdIA/RXu0Xl1Klxpn7b7H76nPEpeTo7bytWrfBb8tXwdJStw9JGhsKAEYeAAKDQ9Gjzxd0n1/PYqIfYNvGNbh/N1LoVnRKTAEgJycHn0f0wsWLF/RyvuDSTujdsAIql3PRy/kMiUajwZVHidh2MRaxCVl6OWf9+g2wZv0m2NnZ6eV8xoACgBEGAIlEgmo1aqNth84mv5Kf0GKfPMKhA7tx4exJqNXCPj2tC2IJAJkZGejdqztu3riu83P5e9gjonEAqpenhbQ0AC5ExWPjuSd4m6b7Z2SqVq2GTVu30x4axUQBwIgCgJWVNRo3a4mPO3SGp5ePXs+tVCrp3dz3ePsmDof278LZU8cgl+cJ3Q43YggAqakp6Nm9C+7d1e1Kjk62FohoHIDmlbxp1cW/Uak1OHr7NTade4KsPKVOzxUcHIJtO/fQyoHFQAHACAKAf4VANG/1Meo3airIu/z370Zi6S9zMGr0JAQEher9/GKiUOTj5vUrOHHkIO7fjRT9OgKGHgAyMzLQtcsnOh38zSQSdKjpix4NysPGklbQfJ/MPCXWnnqEk3fj2L74PyAkNAy79uyjmYAPoAAg0gBQxrccatVtiEYftYCXt36v9otoNBrs370Nm9evhEajgZOzC2bOW0pvGBTT27jXOHfmBK5dPo9XL58L3Y5WDDkA5OTkoEe3zjqd9i/nbo9hbUMR4OWos3MYo4ev07H0SBReJGXr7BxVqlTFtp17YG9vr7NziB0FAJEEADMzM5QPCEatOvVRq04DeAm8ClZWViYWzZuBO7f++uXq518B02b9AksrK4E6E6e3ca9x7coFXLtyEU8fR4vmeQFDDQByuRwRvbrr7IE/qZkE3er5o1t9f6N/sl9XlCo1Np59gr3XXuhsJqxO3XrYtGU7rK2tdVJf7CgAGGgAkEgkKO1bDuGVqqJi5aoICasEW1vDeLo1JvoBFs75ESnJSf/63+s2aIKR30+k+6BaysnJRtT9O7h/9zbu343E65fPDfZWgSEGALVajSGD+uvsVT8PJ2t826Eign1oK2Ye7r9Mw8KD95GYoZtnY5q3aIk16zbSOgH/ggKAAQQAc3NzeHr5oJx/BfiVD4B/+UD4la8AGxvh1wJ/l1KhwPYt63Bgz/YPXqF26/U5uvSgFbp4yM3NwbOnjxH79DGePX2MZ7GPkfD2jd5XsPs3hhgAfpo2RWeL/NQP9sCwtmF0r5+z3PwCLDx4H1ceJeqkfv+Bg/DjTzN1UlvMKADoIABIJBLY/O9q3draGjKZDA4OTrB3cISDoyOcnF3g6loKnt4+8PTyhqubO8zMDHsN8BfPY7Fk4Ww8j31SrJ+XSCQY8d1E1GvYRLeNmSi1Wo3kpETEv41Dwts3SElJQnpaKjIzMpCVmYHMzHQoFArI5XIAQG5Otk5mEQwtAGzetAHffTOSe10ziQQRTSqgUx2/Yn2pkZLTADh4/SVWn4qBSs3/szp9xmz06z+Ae10xowDA+AvYvv8k0/GGTqVS4eDeHdi2aU2JrzgtLCwxddYClK8QpKPuCKtuHZoxHW9IAeDixQvo2a0z95kRe2sZxnxaGZXKmt6CPkK48zwFc/be5f66oLm5Odau34SmzZpzrStmug4Ahn1ZS97r3p1bGD1iEDatW6HVl6pCkY95M6cgIz1NB90R8qc3cXEYMrA/98Hfw8kasyNq0eCvR5XLuWJe39rwduH7SnNBQQH6RvRC966dsGP7NmRn6+4NBFKIAoAIpSQnYfGCWfhx0vfMr6clJyVi7ozJUCp1u/gHMV0KRT4G9v+c+5a+gd6OmNu3Nkq7GtazOKbA09kGs/rU4v56pUqlwvlzZzFi2FBUqRiC4V9/ibt37nA9B/kTBQARUSjysW/XVowa2g/nTh/nVjcm+gGWL5nPrR4h7/ph4gRERt7iWrOirwt+6lkDjjbGtWufmDjZWmB67xqo5q+bB7Vzc3Oxc8d2tG7ZFF0+7YDjx48a7Ns2YkUBQARUqgKcOHoQI7/8HJvWrdDJUrVnTx3DgT3budclpu3UyRPYsH4t15rV/N0wuXs1WFnQa2NCs5JJMbFLVdQK0O3iYpcuXUTfPr3wUaP6OH78qE7PZUooABgwjUaDyxfPYtTQL7B8yQIkJ+nmFZwiG9cuN5ltconuJSQkYMSwr7hetVXzd8OELlVgYU5fXYbCXGqGMZ9WRs0Kul9h9NGjGPTt0ws9u3dB1IP7Oj+fsaO/IgOkUqlw9tQxDB/8GRbMnob4t3F6Oa9UKkVaKt/7tMQ0aTQajBrxNdf7/hV9XTC+cxXIpPS1ZWhkUjOM61RZbzssnj1zGq1aNMVP06b8/6u0pOToL8mA5Obm4NCB3Rg+OAJLFs5GQvwbvZ3bxdUNk2fMR/NW7fR2TmK8tm7ZhDOnT3GrF+jtiEldq9KVvwErmgkI9NbPvgsqlQpLl/yKFs0a4/q1q3o5p7GhvyYD8Dz2CZYvWYDBfbti7YolSEpM0Ov5Q8IqYdb8ZQgKDtPreYlxSkhIwLSpk7nV83SyxqSuVemevwhYyaSY1LUqfDi/Ivg+T588wacd2+Hn2TOhUqn0dl5jQOtlCiQnJxtXL53HmZNHEB0lzL0siUSC9p92Q8+I/rQON+Fm4vgxyEhP51LL3lqGH7pVo6f9RcTRxgJTulfHd+uuIiNXoZdzqtVqLJg/F7du3cSSZb/DxUX4JeTFgAKAHikVCty6cQXnz55E5I2rgr577+TsgiHDvkW1GnUE64EYn2NHj+CPgwe41JKaSTDm08r0nr8IeThZY/SnlfDDlps6WTb4v5w9cxqtmjfF2vUbERZeUW/nFSsKADqWm5uDu5E3cevGFVy7fAG5uTlCt4TadRti0FejYO9Ae6QTfpRKBaZOmcStXt8mAbTCn4hV9HVBv6aBWHkiRq/njYt7jU86fIxVa9ajUeMmej232FAA0IGE+Le4ef0ybl67jIcP7hrErnAAYG1jg4h+g+lBP6ITK37/Dc9iY7nUqh/sgY61y3GpRYTToWZZPInPxJn7b/V63pycHPSN6IWlv61Am7Yf6/XcYkIBgJFcnoenjx/hcUwUHsc8xKOYKINcWz+8UlV8Ofx7lHL3ELoVYoSSkpLwy0I+q0l6OlljWNsw2tXPSAxtHYrY+Cy8TNbv2v75+fkYNKAfFi/9DR0/6aTXc4sFBYASyMvNxcsXsXj+7Cmexz7Fk8fRePXiGdRqtdCt/SdHJ2d89sUQNGjcDBIJfaUS3Vgw72dkZWUx15GaSfBN+4qwsaSvJmNhJZNizKeV8O3aq5Ar9fuUvkqlwvCvh8LW1g7NW7TU67nFgP7KPmDHlvV4+TwWz589QWJCvGjWopZIJGjZpgN6RHwBW1s7odshRuzVq5fYtHEDl1rd6vkjuLQTl1rEcJRxs8PSwfVx93kq7r1MxZ1nqUjO0s8CPkqlEoMG9MOmLdtRt159vZxTLCgAfMCOLeuEbqHE/PwrYMCXIxAQFCp0K8QELJg/F0ol++te5dzt0a2+P4eOiCFys7dC04reaFrRGwAQm5CFG0+TcPZBPF7p+PaAXC5Hv759cOjICfiXL6/Tc4kJBQAj4upWCp2790HTFm1hZkZrPBHdexYbi53btzHXMZNIMKxtKKRmdJvKVPh72MPfwx7d6vkj+nU6jtx+jXNR8ShQ6eaWamZmJr74PAIHDx+DnR3NigIUAIyCnb09OnbqgbbtO0FmQQumEP1ZtnQxl7dcOtT05b63PBGP4NJOCC7thF4Ny2PXlec4fidOJ0Hg0aMYjBg2FCtXr6NnokBLAYuapaUlOnbugV+Xb0THzj1o8Cd6lZycjB3btzLXcbK1QI8GNC1LAHdHa3zZKgSLB9RDNX/dbCx0+NAfWLH8N53UFhuaARAha2sbNGneGp907gFnWvKSCGTdmlXIz89nrhPROICe+id/4e1igyndq+FidAKWHYlCZh7fVVNnzfgJTZs2R4WA2LD0hQAAIABJREFUAK51xYb+6kTE0ckZLdu0R9sOnenJfiIouVyOtWtWM9fx97BH80reHDoixqh+sAdCSjthwYH7uPM8hVtduVyOEcOGYt/BwzA3N91hkG4BiECZsn4YMuw7LFu9FV179qXBnwju4IH9SElJZq4T0TiA7sWS93Kxs8S0HtXwKeeVISMjb2H578u41hQb040+Bk4mk6FGrXpo3rodwitVpS9JYlA2bVzPXCO4tBOql9fNfV5iXCQSCfo1DYSPqy2WHYnitsHQLwvmoWu3HihVqhSXemJDAcDAePuUwUfNW6Npiza0WQ8xSI8fP8LVK5eZ6/RuWIFDN8SUtKzsAxsLKebtv8clBGRlZWH2zOmYO38hh+7EhwKAAXB1K4VadRuibv3GCAoJo6t9YtA2c1j1L9DbEZXL0U5/pOQahHgCAObuuwc1h5VZt23djC/6D0BoWDhzLbGhACAQGvSNh1yeh8sXzuKj5q2FbkXn1Go19u7dzVznk1plOXRDTFWDEE+kZSuw4kQ0cy2VSoUF8+dixaq17I2JDAUAPZFKpSjrVx7Va9ZB9Zp14VeeHn4yBvlyOWb/OAEP7t3Bm7hX6N13oNAt6dTVK5eREB/PVMPd0Rp1g2hXSsKmfU1fxKXm4NCtV8y1Dh/6A08ePza51wIpAOhYq487okrVmgirVAVWVtZCt0M4ypfLMevH8Xhw7w4AYN+uwkVxjDkE7Nu7h7lGm2qlaclfwsXAFsF4Ep+JR28ymOqo1WosXfor5i9YxKkzcaDXAHWs/+DhqF6rLg3+Rubvg3+Rfbu2YtO6FQJ1pVsqlQqH/jjAVENqJkGzij6cOiKmrmj7aCsLKXOtXTt2IDExkUNX4kEBgJAS+q/Bv4ixhoBbN28gOZnt3f86ge5wsqUlqwk/3i426NuEfepeqVRg187tHDoSDwoAhJTAhwb/IsYYAk6dPMFco1kluvon/LWpVgb+HvbMdbZv3cKhG/GgAEBIMRV38C9ibCHg9OmTTMfbW8tQ1Y/2riD8mUkkGNwyhLlOTEw0IiNvcehIHCgAEFIMJR38ixhLCEhKSsK9u3eZatQJdKeH/4jOhJR2QjV/9oC5n8ODrmJBAYCQD9B28C9iDCHg0sXz0DAuulK0gAshutKjPvu20idPHufQiThQACDkPVgH/yJiDwHXr19jOt7KQopwX2dO3RDy74JLOyHYx4mpxpPHj/Hy5QtOHRk2gw8AUinb6x1qtZrx/GxLJahUBUzHE+HwGvyLlDQEqFQqpvPx3Ob0+rWrTMdXKusCmdTgv26IEWhZhf1B05Mn2B94FQOD/4tkH4DZvkRlMhnT8Uqlkul4Igy5PA/Tp4zhNvgX2bdrK06fOFysn1UzfnZZw3OR7OxsPIyKYqpR3Z92/SP60TDEEzaWbOMGj82uxMDgA4C5OeMMAAUAUkJFy/tGR93nXjsoJBx16jcu1s8WMM4esX52i9y9ewcFBWy9VCpLG/8Q/bCUSVGNMXDevXObUzeGTQQBgHEGQM04jcr4JVpAAUBUeE/7vysoJBzjp8yEtbVNsX6eNbyam/MJAA/u32M63sFaBm9XWy69EFIctSqUYjr+xYvnSEtL5dSN4RJBAGD7ElMxXrlYWLCtWkYzAOJhSIM/ABQwBwA+twAePmSb/g8p7Qx6+Y/oU7XybkyfOY1Gw/zaqxgYfACQWbAFgPz8fKbjWWcAlAoF0/FEPwxt8AcARb6c6bwWFpZMxxeJZrz/H1zakUsfhBSXg7UM3i4l+3v7u6dPn3LqxnAZfACwtWWbOpTL85iOt5CxzQDkM36JE90zxMEfAPLy2D67rH87QOFbNDExbHuu+7mzL9FKSEkFeLMFz7jX7NsMGzqDDwB2dnZMx+fl5TIdb2FpxXR8ZibbNpVEtwx18AfYP7usfzsAkJiQwBxEylEAIAJgDZ6vKQAIz86W7UtMzvjl5ejEtqhERnoa0/FEdwx58AcAeS5bALDlEABevXrJdLyDtQwudnxuRZCSkStUkCvYniMRMw8nti3YX7+iACA4O3u2FJebm8N0vKMjWwDIzEhnOp7ohqEP/gD7LQAeMwCsK6KVpqf/BSFXqDBl201M2XbTZEOAuyNbAEgzgYs3ww8AdmwBIDszk+l4B0e25UszKAAYHDEM/gCQlcX22eURAF4xXgW5M16FkZIrGvyjXqcj6nW6yYYAJ1u257dyGWfgxMDgA4CTM+MUPOMA7ODI9iAJ3QIwLGIZ/AH2z46zM/viO/Fv3zId78F4FUZKRq5U4ccdkYh6/ef3XtTrdPyw7SbyFKa1LLmVjO01WNYZODEw+ADg6sq2ohPrFLwj4wwA3QIwHGIa/AH2z46rG/vyu+mMIYR1GpYUn1yhwpStN3Hv5T8XsIl+nY6p226Z1EyAtQXbInJ5NAMgPFdXtv2dWZ/Cd3RiCwDJyUlMxxM+xDb4A+yzV24cAkBKcjLT8azTsKR4/u3K/+9MbSZAasa2/JQpLOJm8AHAzY1tSUfWaVTWtwAS3r5h3kedsBHj4A9wmAFgnD0DgLR0th7srfgsR0z+W25+ASb/x5X/35niTAD5bwYfAFhnAFJT2a5g3Eq5QyLRPkkqFPlITWHrgWhPrIM/AKSmsM0e8ZgBSE9jC9D2NjQDoEuZeUpM3HwDD99z5f93pvxgIPkrgw8A7u4eTMcnJyYwHW9lZQ0nJ7aHqeLfxjEdT7Qj5sFfo9Ew3z5yK8U2ewYUBlgWdlZs92HJf0vLzsf4jdfxJL7kb4tQCCCACAKAl7c30xV4fn4+shifA/D09mE6/u2b10zHk5IT8+APFE7/s+wjYWZmBi8vL+Y+FIx7WcikBv8VI0ovk7Px/fpreJmcrXUNU3smgPyTwf91WllZMd8GSE5KZDreizkA0AyAPol98AeAJMaZq1Lu7lw2A2INAOYUALi78zwVYzZcQ2IG+2tq0a/TMXnbLQoBJkoUf52lS5dhOp71y9TLuzTT8W/jaAZAX4xh8AeAlGS20Frah+0zW4T1SWhzKW0EzNPhW68wZdtN5Mj5Ddj0YKDpEkUA8CnN9mXGeg+e9RbA82dPmI4nxWMsgz8AvGG8beTDGJqLqFRsg4IZw+078idFgRq/HnqAZUcfQqXm/1YR3Q4wTaIIAKwzAKzbOrLOACQnJSI97cOv6BDtGdPgD7DPGpVmDM3EcMSl5OD7dVdx/I5ubyVGv07HlG23uM4uEMMmigBQtlw5puPfvmELAJ5e3pBK2ZaVfPb0MdPx5L8Z2+APsIdW1r8ZYhhO3XuDUWuv4Flill7O9/B1OkZvuIbkLLlezkeEJYoAUKFCANPxrF+mFhaWKF2mLFONp08eMR1P/p0xDv4Ae2hl/ZshwkrLzsdPOyOx8OB9vd+bf5WcjbEbriMuhW0nVWL4TCIAZGVmMO+s5l8hiOn4WAoA3Bnr4J+RkY7sLLYrPv/yFTh1Q/RJA+Do7dcYuuIirj0WbhnxxIw8jNlwDdFxtJeJMRNFAPDw9GTe2vTl81im4/0ZQ8iTx9FMx5O/MtbBHwBePHvKdLyDgwM8PNgW0CL69zwxC+M3XseSw1EGcR8+M0+J8ZtuYN+1F6DFzI2TKJbpkkgk8PP3x727d7Wu8Tz2CcIqVtH6+PJazACYm5vDv0IggkLCERwaDo1Gw7SoESlkzIM/UPhZZVGerv5FJStPia0XnuKPm6+gNrB9QwpUaqw6GYN7L1Mx4uNw2FvT3g7GRBQBAAACA4PZAgDjVVVZv/IwNzdHQcF/J3MrK2sEBIUgODQcwaEVERQSxmUxFvInYx/8AeDFc7bPakBgIKdOiC7l5hfgwI2X2HP1OXLzhb/if59rj5MwYvVljGoXjopl2ZZGJ4ZDNAEgNCwMu3ZqfzxrAJDJZChT1u8vT/M7O7siODQcQaHhCA4Jh1/5ALrC1yFTGPwB4Hks22c1LLwip06ILuQpCgf+fddeICtPPFvOJmfKMXHzDTQK80K/poFwsaOLG7ETTQAIZ/xSe/3yBZQKBWQW2u9OVqdeIwQGhyI4pPAK35Vxq2JSfKYy+CsU+XgTx/YGQGhYOKduCE9pOfk4cus1Dt58KaqB/10aAGcfvMXVR4n4tHY5dK3nR8s9i5h4AkBFtgCgUhUgNvYxgoLDtK7xaddeTD0Q7ZjK4A8ATx/HMK++F04BwGBoANx7kYqjt1/jUnSCTlbxE4JcqcKWC09x7mE8utTxQ5NwL0jNaPZTbEQT3ZydXeDl7c1U43H0Q07dEH0xpcEfAB7FsH1GS5cuA0cnJ07dEG3Fp+dh64WnGLTsPCZuvoHzUfF6HfydHe2xcf4E1K2m/QVPccSl5OCXP+5j0LLzOHDjJfKVtJ+AmIhmBgAAwsMq4u2bN1of/yjmAYAu/BoiOmVqgz8API6JYjo+NEy3X/jkv8Wl5uJyTAIuRifgaTzbuiMswgLLYeO8CfAr44WP6lRFl68n4/KtBzo9Z1KmHCuOR2P7xVg0CfdC4zAvVPB00Ok5CTtRBYAq1arh+PGjWh8f81C3fwSEH1Mc/AHgUTRbAKhevSanTsiHZOYp8eBlKiKfpSDyWQoS0tm352XVpU1jLPphGGysrQAAtjZW2L10Gj77biaOX7ih8/Nn5Cqw79oL7Lv2AmVcbdEozAsNQzzh7WJ4f2tEZAGgRg22L7e01BQkJSaglDstkmLITHXwT4h/y7xpVLUaNTh1Q96VIy/Ai+RsvEjMQsybDMTEpSMuNVfotv6ftZUl5owZjIhPW/7rf9u0YCKGTJyH3UfP662nVyk52HTuCTadewI3BytU9HVBRV9nhJd1gaeTtd76IP9NVAGgarXqkEqlTA9JPbh3G02ateLYFeHJVAd/ALh/N5LpeKlUiipVqnLqxvjJlSoUqNRQawoX48nKUyA7T4nMPCUSMvKQmJGHxAw53qbmGvTmOGGB5bB69hgE+f33rqkWMnOsmPk9HO3tsGbnYT12Vyg5U47T99/g9P3CW7iONhbwdrGBj4stvF1s4O1iA1c7K1hZSGEpk8LOyhxWMim9YaBjogoAdnZ2CAwMwsOH2k+T3r8bSQHAQJny4A8UhlMWIaFhsLW15dSNfigK1IiNz8Sjtxl49CYDCRl5SM6UI1+pRrZcnK/K6Yu5VIoR/Tpj9KCesLT48Ap9UjMzLJj4FYL8ymDi/FUoYHzbhEVGrgIZuQo8fP3hvQbsrGSwlJmhlIM13B2tEOTthABvB/h7OMDCnAICC1EFAACoXqMmUwC4d+cWx24IL6Y++ANA1H22/+2st8j0JSNXgfNR8Tj3MB6P32QYzatx+hRc3hfLfhyFqqEl36NkSO8OCK7gi36jZyMtQz/bDLPIliuRLQdSsvIRHQeci4oHAEjNJAj0dkTDEE80DPWEo432a7yYKtEFgNp16mDjhnVaH5+WmoK41y/hU9qXY1eEBQ3+QNzrl0hNSWaqUat2bU7d8KcBcCUmAcfuxOH2sxQa9LVkbWWJbwd0w/C+nWEh0/7ru0ntKji1cT4ivp2B+4+ecexQf1RqDR6+TsfD1+lYdTIGVf1c0aJKadQJdAetSFA8ogsA9es3ZK5x9/ZNCgAGggb/Qncj2Z7QlkgkqFuvAadu+LrzPAVrTz8W9NU4Y9C6US3MHjMYZX34PMTsV8YLpzcvwLyV2zFn+RaoRRzKVGoNbjxNxo2nyShbyg49GpRHvWB62PtDRBcAPL28UL5CBTx9ov2OabduXEWbdp9y7Ipogwb/P926cZXp+ICAQIPcAvibNVfwhAZ+JmGB5TB1RD80r1+de22ZuTnGDumFulXD8OUPC/AmgW0WyhC8SMrG7D13aB2CYhDlExQNGjRiOj7q3m3I5cK/s2vKaPD/U75cznz/v35D9pkxXaDBX3s+nm5YOm0kzm/9VSeD/7sa166MSzsWo1+XNjAzkiV96bP3YaIMAPUbsH3ZKZVK5leuiPZo8P+ru7dvQqlke+Kdx60xYhh8PN0w6/tBuLlvOXp1aK63AdnJwQ4LJn6F05sWokbFIL2ckwhLpAGgAaRSKVONW9fZplyJdmjw/yfW6X+pVIp69etz6oYIxa+MFxZM/AqRB1ZiSO8OsLIU5qn2yiHlcXTdz5g3fig83JwF6YHohygDgLOzC6pWY5sSu371ItRqNaeOSHHQ4P9ParUaN65eZKpRvUZNODnRF7VY1akSirU/j8WNfb+jX5c2TE/38yI1M0P/bm1x++BKzPp+ENxdaYMpYyTKAAAAzVv8c8nLkshIT0N01D1O3ZAPocH/3z18cBcZGR9eDOV9mjdvwakboi+O9rYY2L0dLmz/FUfWzsEnLRpAamZ4X8fWVpYY0rsDbu5fjvFD+1AQMDKG94krJh5felcunuPQCX+nTxwxqocU5fI8TJ8yRieDf3BoOCZMnSXKwR8Arlxi/ww2b0krW4qB1MwMTWpXwe/Tv0XMiQ34edwQhAf6Cd1Wsdjb2mD0oB64d3gNlv04CpWCywvdEuGgOE+XML0c+iYhheXw96pZrTLi4l5rfbyTswt+X7sdEonhPPW6Y8s67NiyHkHBYRgv4oGtCF35/zeNRoMh/bojLVX7vxEfn9K4fov/77aIt4erzmqbAnOpFPWqh+OTFg3QoXk9uDk7Ct0SN1cio7D5wEnsO34BGVk5QrejE7ocv4qDw9/fewc34W82MWjarDk2rF+r9fHpaamIjrqPkLCK/JpiUDT4A0BM9APMmDxW1CGABv/3i466xzT4A0ALuvo3OKVcnNCsfjW0bFATTetWhZODndAt6USdqqGoUzUUP48dgmPnr2P7oTM4eekWcvMMd+Mk8leiDgAft2vPFAAA4PyZEwYRAN4d/IuIOQTQ4P9h506fYK7Rtl17Dp0QFl7urqhXLQx1q4WhQfWKCPIvY1CzirpmaSFD+2b10L5ZPeQrlLgc+QAnLt7EiQs3ER37Uuj2yHuI+hZAQUEBqlYKQwrDGuo2NrZYvn4HLCwsOXZWMv82+L9LbLcDaPD/MKVCgUF9uyInJ1vrGi4urrh9Lwrm5rrL8XQL4E+WFjL4+3ojoFxphAWUQ5XQCqgSUoFelXsPpyrthG6BCd0CMGDm5uZo2ao1tmzeqHWN3Nwc3Lx+BXXrN+bYWfF9aPAHxDUTQIN/8Vy/eolp8AeAth+30+ngb+ysLC3+/117e1sbONrbwsnBDk4Odijl4gQvd1eU8SoFL3dXlPPxRBlvd4N8Up8QbYn+26Nd+w5MAQAAzp0+LkgAKM7gX0QMIYAG/+I7d/o4c42PjWj6387WGq0b1UKjmpUQHuQPX293ONrbolSNT5jqpt8+yKlDIoSkG3uRkZWDF3EJuP/oGc5du4Oj568jO8d43pISkugDQIOGjeDk5Iz09DSta9y+eR1paSlwdtbfdGdJBv8ihhwCaPAvvrTUFNyJvM5Uw8nJGfXqG+bufyXh6eaC0YN7omf7prC2Eu42HDFMMnNzuDk7ws3ZEdXDA9G3UyvkyfOx49AZLFyzE7Gv3grdoqiJfj5LJpOhfYeOTDVUqgKcOnaYU0cfps3gX6QoBOTl5XLuSns0+JfMqeOHoVKpmGp0/ORTyGQyTh3pn5WlBcYP7YNbB5bji65taPAnxWZtZYnPOrXC1T3LMGXE57C0EO/fgdBEHwAAoEvXbsw1Thw9qJelgVkG/yKGFAJo8C8ZjUaDU8fZwyaPz7xQ/Mt44dTG+Rg9qAdsrK2EboeIlMzcHCP7dcH+FTNohUItGUUAqFmrNvzLs61MlZKchMib1zh19O94DP5FDCEE0OBfcrdvXkNSYjxTDT9/f1SrXoNTR/pVMcgfR9f9jNCAckK3QoxE7cohOL1pIUIqlBW6FdExigAAAJ06d2WucfzwAQ6d/LvTJw5zG/yLxEQ/wMyp4wRZNpiW99XO8SPsD6V17dZDlO+Z+5fxwu5l01DKha7WCF8+nm7YsXgKzQSUkNEEgC5duzF/KUbevIq3DEsLv0+9Bh8hrGJl7nWjo+5j+g9j9DoTkC+XY/aPExAddZ977aCQcIybPBNWVtbcawst/m0cbl6/zFRDIpGgcxf2sKtvVpYWWDd3HA3+RGdKe5bCxgUT6ZmAEjCaAODrWxb1GzRkqqHRaHDowG5OHf2VpZUVxk6aoZMQoM/bATTtr71D+3dDo2FaVwsNGzVGmTK+nDrSn2/6d0PFIH+h2yBGrlalYIwd0kvoNkTDaAIAAER89jlzjTMnjyArK5O9mX8h9hBAg7/2cnKycebkUeY6PD7j+ubp5oKvI9je5yekuL6K+BR+ZbyEbkMUjCoAtGn7MTw8PZlq5Ofn48RR3S0eItYQQIM/mxNHDjI/q+Hu7o6WrVpz6kh/Rg/uSU/7E72xkBW+HUA+zKgCgLm5OXr0YJ/+OXJgL5QKBYeO/p3YQgAN/myUSiUOH9zDXKdHz96ie/ff3tYGPds3FboNYmK6tmkMWxsKnR9iVAEAAHpHfAapVMpUIy0tBadO6HZhILGEABr82Z09dRSpDBtWAYCZmRl6R3zGqSP9adWoJtMiP6xr7xcwLrhEtMf6u2f5t7extkLLBjWZzm8KjC4AlC5dhss06b5dW1FQUMCho/9m6CGABn92arUa+3dvZ67TslVrUT7816hmJabjLRif6JbLdTeTR96P9XfP+m/fuDb/71VjY3QBAAAGDf6SuUZyUiLOn2Hfr/1DDDUE0ODPx4WzJxH/No65Do/PtBDCGZ/8t5CxbVci1+GtPPJ+efn5TMezvs4XRotNfZBRBoDadeqicpUqzHX27tzMvGZ7cRhaCKDBnw+1Wo09Ozcz16lUuTLq1K3HoSP9K+vjwXQ86yAgz6cAIBTW3z3rv3250mwPhJsCowwAAJ8rprdv4nD21DEO3XyYoYQAGvz5OX/mBOJevWSuM3jIUA7dCMPelu3fWsY6A0ABQDC5ctYZAAum4x3sbJmONwVGGwDate8Ib28f5jo7t67X6RsB7xI6BNDgz49KVYCdW9mXfvby9ka79my7XbKQydi+hFnZWLE9yZ3HOAgR7bE+A2BtKexnz8LC+HeoNNoAIJPJMPhL9iun5KREHDuiuz0C/k6oEECDP18njv6BhHj2vcoHDxkq6Kt/dnZ2TMdn5bC9ieLq5MB0fEZWDtPxRHsZWdlMx7s4s/3bZ2az/duzfvbFwGgDAAD0ieiLUqVKMdfZu2OzXtfa13cIoMGfL4UiH7u3b2Ku4+rqhj4RfTl0pD1bW7Zp1BdxCUzHuzIOAm8SU5iOJ9p7k8D2u2fdN+L5a7ZdNykAiJy1tTWXZwEyMtKxb9dWDh0Vn75CAA3+/B3Ysx1pqewDz6DBX8LGRtjfnYurC9Px92JimY53c3ZkOv4tBQDBvE1i+92zzv7cf/SM6XgXF7bPvhgYdQAAgH79B8LFxZW5zoG9O5CUyHY1U1KWVlYYM2k6gkPDudcu2kqYtvTlKyM9Dfv3sL/37+DggL6f9+PQERt//wpMx5+7xvbZYp4BSGBbgIloj3UGgDUAnL3K9tnzL8/22RcDow8ANjY26D9wEHMdpUKBzetXcuioZKysrDFhymydbSVMW/rytWXDKuTlst8uGjBwMBwc2a5+eagQEMB0/NHz15kexGOdBqZbAMJ5k8gWvtxctP/85+TKcezCDabzs372xcDoAwBQOJXq5ubGXOfS+dM6GTA/RJe3A3gz1Wl/AHjx7CmXHf8cHB0xcNAQDh2xCwoKZjo+OycPOw6d0fr4Ml7uTOenGQDhsM4A+Hpr/2+/4/AZ5ObJmc7P+tkXA5MIALa2thj69XDmOhqNButWLmXe010bYggBpjz4azQarF6+GGq1mrnWsGEj4OjEduXLS526dSGRSJhqLFyzE0otl9VmXcyF9UEwor3ncWy/+3I+2v3b5yuUWLB6B9O5zczMUKduXaYaYmASAQAA+n0xgMu6AE+fxOC4Hl8LfJchhwBTHvwB4OypY3j44C5zHQ8PD3wxgP2WFS+urm4IDg5hqhH76i2WbNir1bHaDgJFUtIzEZ+UylSDlNybhGSkZWRpfbxEItE6/C1ev4f57ZPQsHA4O9NDgEbD0tISI7/5lkutTetWIC1NmHuLhhgCTH3wz8nOwqa1y7nUGjHqW1hbG9azE40aN2GuMXPZJly987DEx9nZWjM/B8D6NDgpufuPnzMd7+7qBBvrki8CdSUyCrN/Z19+m8dnXgxMJgAAhfup+5cvz1wnLzcXm9au4NCRdgwpBJj64A8Am9evREZGOnOdsmXLoXefCA4d8fVppy7MNfIVSkR8Mx1x8SW/J896G+AB42BESu4BY+jSZubn1dtERHw7Awol+y6unTp1Zq4hBiYVAMzNzfHD5Glcap0/cwL37tziUksbhhACaPAvfJ3yxNE/uNSaMGmy4Evv/ptKlStzeSAqMSUdXb6eXOIQEFyebRtk1sGIlBxr6Crpv/nr+CR0/XoKklLZg3hIaBhCw/i/em2ITCoAAIX7qjdu8hFzHY1Gg99+nafXFQL/TsgQQIM/oFQq8fuv87g8FFqjZi183K49h650o0ev3lzqPHzyAh/1Hlmi2wEVGbcUZp2OJiV3P4YtdIUH+RX7Z69ERuGjXqMQ/ZR94y0A6Mnpsy4GJhcAAGDqj9Nhbs62yxgAJCXGY+uG1Rw60p4QIYAG/0LbN6/F61cvmOuYmZlh2k8zmJ+216U+EX25PRSVmJKODgPHY8HqHcWarq3EGAAexb5i3pOAFF9GVg4eP3/NVKNi4If/zRXKAsxbuR0dBo3ncuUPFD702qu34d2G0xWTDACBgUHo2asPl1pH/tjL5elvFvoMATT4F3oW+wQH9+7kUqtL126oUqUql1q6Ymtry2VBrSL5CiWmLlqHWp8OwbrdR9/7znZYYDmmcFSgUuHSrQdaH09K5vKtB1AxvA4rkUgQFljuP/97Tq4ca3cdQc1PBuPHxeu53PMvMnDwEMGX39bwhUjYAAAgAElEQVSn4vxVMc1vsi4GoSvJycloWL82MtLZk6OXtw/mLFwOS8atS1npcl1/gAb/IkqlEuO++RIvX7DfW7azs8P5i1fh4cn2oJs+ZGZkoEG9WkhO5r+4jq2NFVo2qIlGtSqhYpA/yvp4wNHeDhaywpm6qu0H4tkr7XdXHNa3E34c9QWvdsl7jJ+7Eks3avfaJwD4lfFC5IHCh6wVygJkZGXjRVwC7kbH4ty1Ozh24QbzIj//xsPDA+cuXoW9vT332try9mBexv69Y7zJBgAAWL9uDcaO/o5Lreat2mHQV6O41GKhqxBAg/+f1q1ahj/28bn6n/rjdINZ9a84tm/bipHDvxK6jRKrEloBZzYvFLoNk9Cg2zBRvnq5ZNnvXN544UnXAcAkbwEU6RPRF9Vr1ORS68TRg7hy8RyXWix0cTuABv8/3btzC4f27+JSKyQkFJ/368+llr507dYdderWE7qNErsXHYv0TLb96cmHpaZnIerJc6HbKLH69Rvgk09N49W/d5l0ADAzM8OcufO5PBAIACuWLRRsgaB38QwBNPj/KScnG0t/mcPlqf+iz55MJuPQmf5IJBIsXLTYIDYqKgmVWo2LN/W/j4epuXjzHtRq/S+VzsLJyRkLFi026IdwdcWkAwBQeBXW74sBXGplZWZg6S8/C7JXwN/xCAE0+P9Jo9Hgt0VzkZKcxKVer94R3Gaf9M3Xtyx+XbxUdF+Yh85cEboFo/fHaXH9jiUSCeYvXITSpcsI3YogTD4AAMCYcRNQrlzx3zt9nzu3rmPPDvalKHlgCQE0+P/V4YN7cPXyeS61PDw8MGHiD1xqCaVFy9ZcNtjSp0Nnrmq9KRH5MIWyAIfPXhW6jRIZPmIUWrdpK3QbgqEAAMDGxgY/z1/I7Ypm26Y1gq4S+C5tQgAN/n/19EkMt7X+AWDm7LkGs9sfi/ETJnFbIEgf0jKycO6asK/sGrNTl28hIytH6DaKrXOXbhg9drzQbQiKAsD/1K/fAL37fMallkajwaJ5M5CWKvzzAEDJQgAN/n+Vk5ONhXN+hFKp5FKvc5duRnPFIZFIMHvOPLRs1VroVopt34mLQrdgtPafuCR0C8XWqnUbLPjlV9HdxuKNAsA7Jk2eymXLYADISE/DL3OnQ6UyjCnH4oQAGvz/SqPRYPGCWUiI1/7983eVKlUK036azqWWoZDJZFi1Zr1oVk87ePISClQqodswOsoC8Uz/d+3WHctXruH28LeYUQB4h729PeZyvBUQdf8O1q5cyqUWD+8LATT4/9P2zetw89plbvVmzZlnlHuMS6VS/DxvAb4aNsLgr6hSM7Jw+nKk0G0YnZMXbyEtI0voNt5LIpFgxMhvsHDREtG9faMrFAD+pslHTdGvP5+3AgDg6B/7cOLoQW71WP1bCKDB/5+uX7mI3ds3cqvXs1cftGn7Mbd6hkYikWDCxB+wZt1GODk5C93Oe63ZeUToFozO6h2HhG7hvRwcHPD7itUYM26CwYdUfTLplQD/i0KRjzatWuBhFJ/1w6VSc/zw088ICavEpR4PRSsGFhSoaPD/m7hXLzH++6+Ql8tnA5myZcvh+KmzsLOz41LP0L169RIjh3+Ny5cM83671MwMdw+tho+nm9CtGIWXbxJQpd0Ag33/v379BliwaLEoX/WjlQAFYGFhicVLlsHCwpJLPZWqAPNnT0NSYjyXejxYWllhzKTpmDB1Fg3+78hIT8PMaeO4Df7m5uZY8ttykxn8AaBMGV/s2rMf6zZsgpe3t9Dt/INKrca63TQLwMuanUcMcvB3d3fHL78uxfZde0U5+OsDBYD/EBIahvETJ3Grl5GehplTxyMnx3CWI7WysoaVlbXQbRiM/Px8zP5pIhIT+AW1Ud9+j2rVqnOrJyYtWrbG6bMXMXrseLi4MF/JcLV+9zFaE4ADhbIAG/ceF7qNv3B1dcPY8RNx4fJ1dO3Wnab834MCwHsMHDSE6ytbr1+9wJyfJnF7pYzwo9FosHj+TDx5FM2tZr169TF8hPAbRAnJwcEBI0d9i6s3IjH1x+kICQkVuiUAQHxyquhWrTNE+09cRFIq+46qPISEhmHaTzNw9UYkho8YZVKzbtqiZwA+ID09Da2aN8WrVy+51WzctCWGjhhNydSArF+9DAf38tnhDyhc7e/YybMoVaoUt5rG4sH9e9izexfOnj2Dh1EPoGbYO55F1dAAnN68QJBzGwONRoNGPUbgXkysIOc3MzNDSGgYGjf5CJ06dUZoWLggfegSbQdsAG7fjsQn7T+GQpHPrWab9p3Qb6D4tlU1Rvt2bcWmdSu41TMzM8OWbTvRsFFjbjWNVWpqCq5euYKYmGg8fvQIsbFPkJ6WjoyMDOTk5ECpVOj0/Nt+nYxWDcW5J4PQDp25gl4jf9LpOWQyC9ja2sLR0RFOzk4oXz4AFQICEBQUjDp16xrla7XvMvkAwPoL4BVAVq1YjkkTx3GpVaR334Ho2LkH15qkZM6eOsZth78iY8ZNwIiR33CrR/5dt86f4MIFtv0ZqoRWwOlNC2g2TgtNe4/CrQePmWo0bNQY23bs5tSR8aG3AAxE/4GDuO8XvXn9Spw8+gfXmqT4rl4+j2WL+O7e2KJFKwwbPpJbPfLfvhgwiLnG7agnOEULA5XYkXPXmAd/AOjP4d+QaI8CQAnMW/ALKlbi9y6/RqPBimULcen8GW41SfHcibyBRXOnc73/HBAQiMXLfoeZGf1Z6UPLVq3h61uWuc6s3wxj904x+Xn5VuYaZcr4olnzFhy6Idqib6oSsLa2xvoNW+Dh6cmtplqtxqJ503Hx3CluNcn7PXxwD3NnTub6Noa9vT1WrF4Le3t7bjXJ+5mZmeGzz/sx17l+NxqHztAbAcV14OQl3Lz/iLlOv/4DIJVKOXREtEUBoIQ8PD2xYuUabosEAYUh4Nf5M3Hx/GluNcm/i3l4HzOnjkO+XM6tppmZGZYsW47AwCBuNUnx9OnzGWxs2BeyGj93JeT5un3g0BjI8xWYOH8Vcx1ra2v06NmLQ0eEBQUALdSoWQvTZ87iWlOtVmPx/Fm4fsUwl081BtFR9zF98ljI5Xlc6078YQqat2jJtSYpHgdHR3TnMJA8fx2PJRv2cujIuP26fjdexCUw1+nd5zOD3zPCFFAA0FLvPp/hq2EjuNYsXDJ4Ks6eOsa1LgEe3LuDmVPHcR/8e/WOwJAv6XVOIQ0f8Q0sLdln5Oau3IbX8UkcOjJObxKSsWA1+1oZlpaWGPrVMA4dEVYUABiMnzAJnbt041pTpVJh2aKfcfKYYe+uJSY3r1/BjKljkZfHZ33/Ik2bNcesOXO51iQl5+HhgR49ezPXyZPnY9qidRw6Mk6TFqxGbh77rbPeEZ/B08uLQ0eEFQUABhKJBPMX/oL69RtwratWq7F8yXwc2LuDa11TdPH8acydMRlKBd/7u8HBIVj62wqYm5tzrUu0M2z4SMhkFsx1dhw+izNXb3PoyLicvhKJ3UfZ1lwACjda++qr4Rw6IjxQAGAkk1lg+ao1qBAQwLWuRqPBhtW/YdumtVzfUzclhw/uwaK506FS8d30xcenNDZv3QEHBweudYn2vH18uDxUptFo8OWkBUjPNJxNu4SWmZ2DYVMWcfke6tW7j0HuEGmqKABw4Ozsgu079qBMGV/utXdt24Clv8zhPogZM41Ggx1b1mHN8sXcw5OLiyu2bNtJU5gGaOSob2Ftzb675dvEFIz7md/S0GI3etbvXJ6NsLGxMfnNsQwNBQBOPL28sG3Hbri7u3OvffbUMcyYwm+PemNWUFCAxQtmYseW9dxr29vbY/PWHdxnewgfXt7e3B4u23LgJPafoDdyDp25gq0H+axR8tWwERScDQztBcDZvbt30bVzR2RmZnKv7Vc+AGMnTYezge2tbihysrMwb9ZU3L/Lf2lXS0tLbNq6A/Xq1edem/Ajl8vRsF5txMW9Zq7l5uyIy7uWoJSLE4fOxCclPRN1Ow9FYgr7dr9e3t44f/EqlzUbTAntBSAyFStVwtr1m7hMRf7ds6ePMfabL/H0/9q78/CYrj4O4N/JZCKRzRZLIhHRSEIR+5ogEWIvWmttLapvF+qlRVuKVnVF37YoLSq1tLprLVWitMVbbXVB7cTW0ipijWTeP9J5O43ILOece2fmfj/P43mKub9zqbn3d7bf2feL9Nje7sTxHEwcd7+Sl7/FYsFrC97gy98LBAYG4pEJj0qJdebsOQyf8DzydTquWE8FBVbc8+gLUl7+APDY45P58vdATAAUaNa8BZYufwfBwcHSY5/943dMGj+KtQLs/PD9Djw67gGclNDrK8psNuOll19FRvtM6bFJjZ69bkdycn0psbK3fY8Zc4x3VsCTr7yJ9V/ukBKrQYOG0g9SIzmYACjStFlzLFychcDAQOmx8/Ly8OrsZ7FsyeuG3yHw6cfv4ekpE3Ax94L02P7+/pgzbwG639ZTemxSx8/PD8+9MFPaFs3nF6ww1HqAT7O3Sin4AxR+h6bPeI7HLXsoj18D4O02f7EJgwf2xxWJteft1a6TjNHjHkO4wcpqXrt2FQvmzEb252uVxLf1/Hv0vF1JfFJv6hOTMHfOK1JihQQH4fOsF5FQPVpKPE+1/8hxpA0Yg/O5F6XE+9f9D+KxxydLiWVEqtcAMAHQwBebsjF08J24fFluGVqbChEVMeaRybilZqKS+J7m+LGjeOHpJ3As54iS+BaLBf95ZQ66de+hJD5p4/Lly0hvk4LDhw9JiZcYF4N1bz6HsBD5U3ue4HzuRWQMHItfDuVIiRdbvTo2ZG9RMgpqFFwE6ANSW7fBshUrlRWOOXP6N0waPwprP/lQSXxP8vWWbEz8933KXv6lSpXCgoWL+fL3AUFBQXh+5mxpw897Dh5Fv1HTfPLUwCtXr6HvqGnSXv4mkwnPPPsCX/4ejgmARpo0bYaV732I8uUrKIl//fp1vD7vJTw3fRIuXJC/BVFv165dxcL5r2Dms9Ok1/S3KV26NBYvWYqMjA5K4pP2WrRoKeWcAJsvd/yEEY++4FM7A/ILCjBswnP4asdP0mL2HzAQKamtpcUjNTgFoLH9+/ahb+9eOHHiuLI2wsuUxf2jH0G9Bo2VtaGlnCOHMOv5p5BzRM5QbnHCwsPx1tIVaNjIN/7O6G+XLl1Ch4y2OLB/v7SYQ3plYtbj90uLp6eHZ8zFa8tXSYsXW7061q3PRkhIiLSYRsU1AD4oJ+coBvTrjf379ilrw2Qy4bZe/XBH/8Fee2BNQUEBVn3wDpZnvYHr19WVQo6MjELWshVITExS1gbp64edO9G1cyby8uQN348f2R/jR4qfP6Cnp17JwnPzl0uLFxBQCh9/sgZ16taVFtPIuAbAB0VHx+DjVWvQrHkLZW1YrVa8v3IpHnloJA7s977CQb+eOompj41F1qLXlL78ExOT8NGq1Xz5+7i69eph/EQ5BYJsZsxdiidmL5IaU0uzFq6U+vIHgImPPc6XvxfhCICOrl27ilEP3I8PP3hPaTtmsxldbrsDfQYM9fjRAKvVis/XfYLFr8/BVUVbJ21atUrBgoVv8lQ/g7BarRg8sD/Wfya3iNaoIb0wZfRQqTFVm/5qFp59Te7Lv21aOrKWruCef4k4BeDjCgoKMGXy45j/2lzlbcXG3YKR9/8bcbfUVN6WO47lHMH8V2di988/Km+r1+298eKs2VLOkCfvcebMGXRsny7lrAB7I/t3w9Pjhnv8y89qteKRZ+ZJnfMHgKpVo7F63Xpli5yNigmAQWQtWYxHJ4yXOkdZHJPJhPT2nTFw6D0I8pDa3NeuXcWH7y7HByuXIS8vT2lbJpMJY/49DmPGPuzxD2tS4+effkT3rp1wSfLpmn06t8UrU0fD32yWGleW/IICjJ72Mpa8L3cEJDAwEB989Cnq1qsnNS4xATCUr776EiPuHoo//lD/d1aufAUMHX4fmrZIVd5WSXZ+9w1en/sSTp1UtyvCJjg4GC+/Og8dMjsqb4s82yerPsaIYUOll9LOaNUIbzzzMEKDPSO5trl46QpGPPo8Ptm4VWpck8mEOfPms26GIkwADObo0SMYMnAA9uzZrUl7yQ0aY/CwfyGqaowm7dn8euokliyci+1fb9GkvZiYalj4ZhaSkmpp0h55vqenT8N/Zs+SHrdWfCyWz34cMZGVpMd2x4lfz6Df6GnYufuA9NijRo+Rdvoi3YgJgAHl5ubioVH345NVH2vSntnsjw6duuGOfoMQHBKqtK0rVy7jvbffwicfrlQ+3G+Tktoac+bNR7lywl8m8iEFBQW4e+ggrF2zWnrsiHJlsOTFiWiWrG/C+fW3P2Pgv6fjzNlz0mNnduyEBW8shp8fN5OpwgTAoKxWK16bNwdPTZuidBucvdDQMNzebxDapHWQvj7g3Lk/8cWGdVj1wUqcPavNvwmTyYQHRz2EsQ+Ph9lD52VJX1euXEHf3r2wfZvcoXEAKBVgwYuP3ocB3dtJj+2MN99bi7FPz8G1PPnPj6bNmmPZipUs9asYEwCD275tK+4ZcTd+PXVKszZLBQaiWYtUNG/VGkm16yIoyL1k4M+zf+DHnd9h+9eb8c32r5Gfr00iAwDhZcrgpZdfZVlfcuj8+fPo1aMbfv5Jze6T2zJaYfakBxAeqs0hQhcuXsK4p+di+aoNSuInJibh/Q9XIbxMGSXx6W9MAAinT5/GfSOHY8uWzZq3bTabUSM+AdXj4hEZVRWRUdEIDQtH6eBgBAYGIT8/H1cuX8aVq5dx5vRvOHn8GE6eOIb9e/cg5+hhze8XAOolJ2Pe/DcQE1NNl/bJ+/x66hS6demInJyjSuJHV6mI+U+PVT4lsOOnvRg+4TkczDmpJH5kZBQ+WrUakVFRSuLTPxk+ARD9C/CVBMRqteL1Ba9h2pQnlG8V9FYmkwl3DRuOSZOncH8/uezA/v3oeVsXnD59Wkl8i78/Jtw7AKOH3g4/P7lbUPMLCvDi62/jmbnLcD0/X2psm4iICLz/4SeIq1FDSXy6ERMAJgD/sPP77/Gve4fj0MGDet+KR4mIiMCsl15B27R0vW+FvNi+fXtxR8/u+O2335S10bxBbcx6/H4kVI+WEm/PgaMY/eTL2PrdLinxilOpUiW8/e4HiI/3zCJivopnAdA/1EtOxtrPNqJ3n75634rHyOzYCdmbv+LLn4TFx9fEex+sQuUqVZS18fW3P6PVHQ9g/LOv4eIl98tdX7l6DTPmLkXrfqOUvvwrVqyIFSvf58vfB3EEwIut/2wdxo19SNMFgp4kLCwMj016AncOHKz3rZCPyck5itt7dFe2JsCmWlQlPDfhXrRv1cil69Zu/i/GPT0XR0/8qujOClWJjMTKdz9E9bg4pe1Q8TgFwASgROfPncOT06Yga8livW9FU23T0vH8C7NQJTJS71shH3X48CG0aOrai9ldXdNbYNIDgxAfW7XEz+09dAxTXlokvaLfzXy17RvExlbXpC26ERMAJgBO+WTVx5jwyFicOXNG71tRKiwsDFOmPoU+/bz7HHbyDhIewE7z8zOhW3pLPDFqCGKrVv7H7x0/dQbPzV+OrA8+U7bIrzhGeX56KiYATACcdvbsH5g6ZTLeXr5Meo1zT9Ct+22YMm06KlXyjBKr5Pu0TABsAiz+6N+tHcbf2x8Wf3/8Z/F7mLv0I1y5qv3uHyM9Pz0REwAmAC7bvm0rHhn3b/zyyx69b0WKmJhqmD7jWaSl61NRjYxLjwTApnRQYZW9S5fdXygoyojPT0/CXQDksiZNm2Hd5xvxyIRHvbpUp8USgAdGjUb25q/48ifDuXT5iq4vf/J9TAB8lMUSgFGjxyB781fo3KWr3rfjsnYZ7bFx0xZMmPi4VycxRESeigmAj4uJqYb5ry/Cu+9/hNq31tH7dhyKq1EDb2Ytw5tZy1hxjIhIISYABtG8RUusWfc5nn3+RVSoUEHv27lBlchITH1yOjZu+hLtMtrrfTtERD6PiwAN6Nq1q1i7Zg2ylizGls1f6LZjwM/PDy1bpeDOgYPRsVNn+Pv763IfRDej5yJAT8Dnp764C4AJgFIHDxzA0reW4NNPV+HwoUPK2zOZTKh9ax106JCJvv0HICqq5MInRHpiAsDnp56YADAB0Mzhw4ewKXsjNmVvxJdbNuPChQtS4pYtWw4pqalo2zYdbdLSuY+fvAYTAD4/9cQEgAmALqxWK44dy8G+vXvxyy97sG/fXhw9fBi5F3Nx7s9zuHDhAnJzcwEAoaGhCA0NRVh4GMJCwxBTLRY1ExKQmJiEmjUTlB6sQqQSEwA+P/Vk+ASAiEgvog/g8mXC8Puf5yXdjfZt8/mtLxYCIiLyUt9+PB+jh96OwFIBmrVp8ffHkF6Z2P7BXM3aJO/EEQAior9cvnwZ3/x3O9atW4M1n36K48ePCcX78/tVAIBjp07jyZeXYMUnG5XuuslMbYLp44YjLrpw2q1McheheBEREWjdpi0y2meides2CAsPl3Gb5CROARARKXTkyGF8tm4tPlu3Ftu2bsW1a1elxbYlADb//WEPHn1+Abb/IPecjnpJNTB97HC0bHjrP35dNAGwZzabUfvWW5GR0QEZ7TNRp25dmEzOvELIXUwAiIgkys3NxeYvNmHD5+uxccPnOHHiuLK2iiYAAFBQYMV7a7/AzIXv4Oe9h4Xi164ZizF39UaP9inw87vxcS4zASgqMjIKbdPSkZbeDimprRESEqKsLaNiAkBEJEhlL78kxSUA9rZ+twtPz30Lm7btdClus+RaGD30dnRIbVxiL1xlAmCPowNqMAEgInKRlr38kmxaNhv1khyfafHVjp8wc+FKrP9yx03XCJhMJrRr2RBj7roDzRvUdhhz5+4DaN1vlMv3LANHB+RgAkBE5ITdu3dh44bPsfHz9di+fRvy8vL0viV0bNMUy2Y97vTnf/zlIF7J+gDvr92Mq9cK779UgAU9OqTgvjtvQ52EOKdj9Rs9Dauzt7l8z7JZLBY0adIUbdPS0Ta9HZKSaul9S17DExKAqwDc3sOy98ARZn9EJJ2n9PJLYjKZkL10llOjAPZO//EnFr27BgAwpFcmIsqVcen6nbsPoE3/0bqd81GSKpGRSEtrh7T0dmiVkorQ0FC9b8kj5ebmomaNaiIhrgIo8Sx1ZxKAMwDcTkOyN3+FmjUT3L2ciOj/du/ehY1/vfA9pZfviKujADJ4Su/fEY4O3NyePbuR1rqVSIgzACJK+oAzx6+dhUACsCl7IxMAInKLN/TyHVmzaTt27j7g8iiAu3buPoA1m7Zr0paovLw8fPnlFnz55RY8OW3K/0cH2qalIyW1taFHBzZlbxQNcdbRB5wZAVgNINPdO0hISMT6jV/AbDa7G4KIDMQbe/mOaDkK4C29f0eMPDqQn5+P9DYp2Lv3F5EwnwLoXNIHnEkAZgEQWkr65FMzcNew4SIhiMhH+UIv3xF31wK4ypPn/kUZaXRgwfx5mPTYRNEwMwGMKekDziQAfQAsF7kLi8WCrKUrkJLaWiQMEfkIX+zlO6LFKICv9P4dsVgsaNy4CdLS2/nc6MDmLzbhzv59ZHwnegN4p6QPOJMAVARwysnP3pTFEoDJT0zF4KF3cTqAyGCM0Mt3RPUogC/3/h3xhdGB69evY9HC1zFtymQZL/8CAJVQuBDwppx9qW8F0FT0jgCgZs0E9L9zIFJbt0F0dAyCg4NlhCUiD2PEXr4jKkcBjNL7d+QfowNp6Uiq5bhokl4uXryInJyj2JS9EcveyhKd87f3FYCWjj7kbAJwH4CXhW6HiIiw4a2ZaFA7XmrMH/YcQOt+xuz9U7HuBeDwPGg/J4MtA3BR6HaIiLxUVEgQ+iVEi82D/uW5+UJLqor19Nylwi9/E4B+CdGICgmSc1OklwsAVjjzQWfqAADAHwDmwcGKQiIiX5OV2Rh9a1YFAOTmXcfHB08KxZNdF0DWvv8ucVWwpEMjAMDyvcdw55r/CsckXcyBEzUAAOdHAADgeQC5bt0OEZGXstgdszupSaLwKIDVasWMeUsFo/xtxjw5vf9JTRL//3NLMUcLk1c4D+AFZz/sSgJwEsAUl2+HiMiLHcu9/P//rl+xDLrEVRGOuTp7G779eZ9wnB/2yOn9d42rgvoV/z5vIOfC5RI+TR5sEoDfnP2wKwkAAMwGsMPFa4iIvNbx3Cv/+LmMUQBAzloAWXP/j9v1/gHgxMUrxX+YPNl2AK+4coGrCUAeCgsDnXPxOiIizVnMfogJF9sTnnPh0j9+LmsUwLYWwF0y5/7te//AjX9mV8WEh8JidvX1QgL+BNAXwHVXLnLn/9ABAANdbYiISAtRYSEY1rA23u3bGWfGj8ALmSlC8eynAGw8YS2Airl/m+L+zK54ITMFZ8aPwLt9O2NYw9qICuOR8ApdBzAAwCFXL3R2F0BRHwO4B8ACCFYIJCISYTH7oWVMJDJvqYaONauhbqUK//j96HCxl0/RKQDg71EAvXYEqOz9A8X/mV0RHR6CsFIB6FmrBnrWKvyz/fDrGazeewRr9h/Bl0dPIC+/QKgNAgBYAQxD4cE/LnM3AQCAN1CYeSwAYBGIQ0TkkorBQehwSzV0TayOjBoxKBNY6qafrSrY+zxx8TLyrVaYTf/s60xumohVB09CpA9utVrxzLxlWDrrMZeuk9H7B4BHG994VHu+1YoTF8VGAKKLmXapW6kC6laqgEdSGuLitTx8nXMKH/9yEB/sPoij5y4ItWdQ+QBGAljsbgCRBAAA3kRhjYAsAOGCsYiIiuWol1+SyiHB8Pfzw/UC93qc1wusOHXxyg0FcpIj5IwCrN60zaVRAFm9/65xVdCoUtkbfv3UxSu4XuB+cuHv54dKwaVL/ExwgAXtakSjXY1ozO7UmqMDrvsThcP+bvX8bUQTAABYBaABCisPNZIQj4gIUWEh6BhfDZnx1U3uZf8AABIbSURBVJBRIwZhpQLcimP2MyEyNFiol3k898YEACicP5cxCjBj3lKnzwhQOfcPiA//R4YGw+xiHQH70YHzV69h/YEcrN53GGv2HcGx8yw/U8R2FC74c3nOvygZCQAAHATQHIVnBkwFECYpLhEZhNnPhOTKEeiSUB1dE6qjQZWKMElaYVQ1PEQoAcjJvYQmuLG3LGstgK0ugKMzAlTt+7d3VHAHgOiai6JrBw6ePYeP9xzCqr2H8MXhE7iWny8U34tdBDANhYV+pCzCl5UAAIU3NBvAcgBjUTg3waWfRHRTsnr5joiuAyhpVbyMUQCgsC6Ao1EAVfv+7R0XnP+XveI/rmw4RjVPxqjmyUYdHbiAwvK+L8CFIj/OkJkA2PwKYByA6QD6oXDLYFNwtwCR4VnMfmgRXQUd42NdnssXUdyiNFeUNCyu1Y4A1Sv/bcR3AIj9XZfEQDsLrAC+BrAEhdPrTtX2d5WKBMDmLIBX//oRAaAtgGYAEgHEAagAIBSAmpSfiDyCVr38koiOADgqjKPFWgDVc/82okWARP+uXeEDaweuobCHfwaFU+m7AWwFsPGvX1NKZQJg7zSAt//6QUTy3Y3CYULdt+SqnMt3l8opAED9WgAt5v5tcgSLAImuAXCXl6wduA5gNFws2auKVgkAEalhAjD5rx+6cWVfvh5UFAMqSkZdAAB4fv6KG+oCyJj7B4CJxez7L+q4aAIQpm4KwBX2awc8qO6AP4CXAdQEMAaFe/l1wwSAyHuVRuGi2656NN6gSkXcXvsWdKoZi3qVtZnLd5eqYkD2VNUFUL3v316+1YqTggcBRYUFC12vQnF1Bz7dexgrf96PHSekrqtz1oMAYlG4Tk5szkUAEwAi7xSGwhocYoXuXdQoqiLuqB2P22vfgriy3lP7S1UxoKJUrAXQau4fkFMEqHKI5yUARdnWDoxPaYSDZ89h5c/78c7P+/DNcU2TgW4AVqMwgT+vZcM2TACIvE9ZFD44mmrRWCl/M7olxGFMi/poFl1ZiyalM/uZUCU0GDkKigHZk70WwN/sp9ncPyB+CJA7RYD0Flc2HA+3aoiHWzXEdydPY+5/f0TWzj24lKfJeXepADYAyIQGi/6KYgJA5F0qoHCF8K2qG6ocUhqjmidjWMPaqFC65BefN4gODxFKAG5WDKgomXUBACjf929PNAGoqtMCQFnqV4nAvG5peKpdcyzY8TNmf/09TuUqH6FviMIkoC2A31U3Zo8JAJH3CAewFopf/mWDSmFcy4Z4sFk9BAfovqlAGtU7AWxk1gWQwdG+f3vCCYCPHPtboXQQxqc0wgNN62H21u/x3JZv8eeVqyqbrANgDYB0aDgd4KdVQ0QkJBjAJyg8d0OJIIs/xqc0woHRQzAhtZFPvfwBtcWAiprUJFG48pnVatVs7t/Gk4sA6SE4wIKJqY1x8KEheCSlIQL9zSqba4TCdT0ln6QkERMAIs/nD+AdAC1VNdC2elXs/Fd/PJ3RAmWDPGsLnyyqiwHZs40C6M2V3j/gXUWAtFQ2qBRmZLTED/cNQJvqVVU2lYLC77rSTMOGCQCR55sJoKOKwGUCS2FetzR8PqQn4ss7/6LwRlpNAdhMbio+CiDqUSf2/dvz1iJAWokvXwYbhvTE4p4ZKF86UFUznQC8qCq4PSYARJ7t/r9+SJdRIwa7HxyIEY1u1b1Snxa0KAZkLzmiDLrqOArQzYl9/0WdEJwC8NURAHsmEzAoOQk/3X8n2tWIVtXMgyg8XVcpJgBEnisdwCzZQc1+JkxJa4Y1g7qjcohm0426k1UMyBWPS1gL4A5XVv7b5FutOCF4EqAREgCbyiGlsXbQbXiibVNVWx9nAUhTEdiGCQCRZ4oE8BYkzwVWDimNdYN6YFKbJvAzQrffjq0YkLtsxYBcUb+iPqMAzu77t2eUIkAy+ZlMmNy2KdYOug2V5CfT/gCWAlD2D4gJAJHnMQN4E0AlmUFrRZTDtnv6IC1O6SImj2UrBiTCnVXyk3RYC+BMzf+ijFgESJb0uGhsG9EHSRHlZIeuBGAZFC0KZAJA5HmmoHD4X5qUapHYMuwOxPjYNi1Xia4DyHGjKIzWawHcmfsHWARIVLUyodgy7Ha0jJH+/7o1gEmygwJMAIg8TVMA42UG7FXrFqwb3MNnt/e5QuudADZarQVwZ+7fhkWAxJULCsRng3ugx18HOUk0EUBj2UGZABB5jlIA3oDE4b6etWpgee9M1QVMvIaWxYDsaVUXwJ25f5tjF8QSAKOPLtkEWfzxTp9O6HNrTZlh/VE4LSi1JjcTACLPMR1ALVnBuiRUx/I7OgotfPM1WhYDKkpGdcCSiPT+AfERgCiOAPyf2c+EN3tloFPNWJlhE1E4PSgNnwxEnqEOCvf+SpEeF413+nSCxcyvuD29pgAA9aMAIr1/gEWAZAswm/Fe387IjK8mM+wYAPVkBePTgUh/JgBzIOlwrnqVK+DD/l047F8MrYsBFaVqFEC09w+wCJAKpfzNeKdPJ9StVEFWSDOAlwA5/4yYABDpbxAk1fkvXzoQ7/Xr7HMH+ciiRzEge6pGAUR7/zKKAPnaQUCyhARY8NGArogIljZ9nwqgv4xATACI9BUMYIaMQBazH97t2xlxZcNlhPNJehQDKurORPnlYwcIxpRRBKhSsHGqSrqqWplQvN27o8wpuWch4dRAJgBE+noQQGUZgWZmpqJ1bJSMUD5Lr2JANkt2H8Vdn+0Qar84d322A0t2H3X7etGpjSoGLgLkrDbVq2JmZqqscJGQcEYIEwAi/ZQBMFZGoMz4avhXk7oyQvk8PYoBXcnPx0ObfsDQz3bgYl6+UPvFuZiXj6Gf7cCQde7FPyp4DHAMFwA65b6mddElobqscOMBuF7xyQ4TACL9jAUgXDs0IjgIi3pkGOJEPxm03gmw+48LaLI8G//ZeUCoXWdk7TmK5m9nY/cfF1y67rjg/D+3ADpvfvd0WesByqJwV4DbmAAQ6SMMko75ndO1rYqDSHyWlsWAsvYcRfMV2dj1+3mhNl2x6/fzaLJ8Ixb8dNjpa1gESDuVQ0pjfndplb4fBOD2oh8mAET6GAGBL67NgLoJ6FXrFgm3YxxaFAO6dD0fw9Z/iyHrdiA377pQe+64fD0fIzd8h2Hrv8Wl646nBFgESFvdE+PQt46USoFhAO5292ImAETas0BC0Z+QAAueaS9l96ChqJ4C+OVsLlq+vQmLdh0RakeGRbuOoMmyjfjJwQgEiwBp7/kOrWRt130IQIA7FzIBINJeHwDCe8EmpjZmz8sNoi+rkhKAJbuPosnyDfjxzDmhNmTac/YCWr6dXeIugeM8CEhzUWEhGJ/SSEaoqgB6uXMhEwAi7Y0QDRBXNhwPtagv414MR7gYUO6VG4oBqV7lL6qkXQL5VitOCtY2YBEg94xr2QDx5d0v4GRnuDsXMQEg0lYCgFaiQaalN2OpXzeJFgPKt/6zGNAuDVf5i7LtEthlt0uARYD0U8rfjEltmsgI1QaAy4uBmAAQaetuCNbxrlEuHL1vjZd0O8YjsxhQ4Sr/jZqu8he16/fzaGq3S0B0AWAkiwAJ6VcnQcYogAnAXa5eJOXwESJyih+AO0WDTExtrNkRv6ZJLwldb50q7YBDqaLDQ5BzzrW98vZ+OXsBr/10yCMW+rnDtktg66k/0DpK7KCaqh68ANAb/v2a/UwY16oBRny4QTTUIACPAShw9gKOABBppyUAoZNgYsJDMbCe2KlvJL4OYOSG77z25W9v0a4jGLnhO6EYXAAobnBykoy/xygAzVy5gAkAkXbcWqlr74Fm9WQeKGJYog/bq/lOd7LcEhxgwcIeGVjYI0P5yY6ifxYmAOICzGbc37SejFAuPWP4JCHShglAD5EA/n5+uJO9fyk8edV6YoWy+Hp4bwypn4Qh9ZPwzci+qFOpvN63dVOsAijH4PpJMpL7O+DCGiMmAETaqAcgRiRAl4TqqMySv1J4aq91cPKNL3xbQjA4OUnHO7s51qKQo3JIaXSMjxUNEw2gjrMfZgJApI0M0QB3N6gl4z4InpcABFn8MatjKhb1LH7IPzjAgkU9M7D4Jr+vJ1YBlOcuOd/xds5+kAkAkTaETv+ICA5CZnw1WfdieJ700qoVUQ7fjOyLUc2THX52UHIStt/TB7UihA+RlMbTkilv1rlmLMqXDhQNwwSAyIOUgmDxn47xsZpt/TMC0WJAsgx244VeK6Ictt/TxyOmBPz9/FA5RKymAv3N389PxjRAKpw8G0D/bwCR76sPQOgp2TWhuqRbIUBOMSARjob8HfGUKQEWAZKvc81Y0RDBABwPJ4EJAJEWGotcbDH7IaOG0PpBKoZe0wCJFcpi24g+Tg35OzKomEWDWvKkqRRf0TE+VsZuAKeeOUwAiNQTOvKrVUwkwgPdOu2TSqDH3HVxq/xF6blLgDsA5AsPDEDzaKF6YYCTzxwmAETqCY0AtIgRfhhQMbRMAEpb/LGwR4bbQ/6O2KYEFvbIQGmLdhXeuQBQjZbi33kmAEQeIABATZEATatWlnQrZE+rYkCJFcpi64g+GFJffQ99SP0k7Li3n2ZTAiwCpEbjqEqiIRIBOMw0mQAQqVUDgNC5vY0iK0q6FbKnRe91YL1EzefobWsMRjS6VXlbnnwQkDdrJp70+wOIdfQhJgBEagmd2xsTHqrranVfpjIBCPQ3Y1bHVLzZq70uq/SDLP6Y1y1N+S4BTgGoUSU0WMb6Cocjj0wAiNQSSgBu9eAa8N5O1Qp2Vwr7qDYoOQnbRvRWVjiICYA6EkaNHCYA2q0WITImof171cuGyboPKsJWDOh6gbyT/QbWS8Scrm2d7nVrcV597Yrl8c3Ivhi9+gu89s1PQu3ZYxEgtWLLCH/3ox19gCMARGoJreapFs4EQBWZxYD0HvJ3RMWUAIsAqVWtjPACS4fPHiYARGoJreDjCIBaMqYBEiuUxfZ7PGPI3xGZhYNYBEgtCd99h88eJgBEakWIXMxtVmqJzmGrKOyjmqzCQSwCpJaE0T8mAEQ6KytyMSsAquVuAqC6sI9qMgoHcQGgWhK++w6fPUwAiNQSOtvTG18u3sSdl5iWhX1UEykcpFUhJaOS8N0v5egDTACI1HL4JSyJlmVdjcjVl5gehX1Uc7dwENcAqBVsEU4AHHY+mAAQqSWUAEh4CFAJnB0B8PRV/qLc2SXAKQC1JPw7c5gAsHtBpJbQt7iUv1AVYXLAmV5srYhyeLtPR9Su6Du9/psZlJyEhpEV0XvFauw6/UeJn2UCoFag+Hff4SICjgAQkWHZigHdzMB6idh+Tx9DvPxtbIWDhje8+ZQAiwD5BiYARGRYNysG5OtD/o4EWfzxWvebTwmwCJBvYAJARIZWdBrAmwr7qHazwkFcAOgbmAAQkaHZz2X74ip/UbZdAvZTAlXDuAXQFzABICJDiw4PNfyQvyNFpwQ4AuAbuAuAiAytdWwUhtZPMtRCP3fZdgkcPHte71shCZgAEJGhdU2orvcteJXaFcszWfIRTACIiHRinfqg3rdABsY1AERERAbEBICIiMiAmAAQEREZEBMAIiIiA2ICQEREZEBMAIiIiAyICQAREZEBMQEgIiIyICYAREREBsQEgIiIyICYABARERkQEwAiIiIDYgJARERkQEwAiIiIDIgJABERkQH5630DRERGZZr0ktD11qkPSroTMiKOABARERkQEwAiIiIDYgJARERkQEwAiIiIDIgJABERkQExASAiIjIgJgBEREQGxASAiIjIgJgAEBERGRATACIiIgNiAkBERGRATACIiIgMiAkAERGRATEBICIiMiAmAERERAbkr/cNEBEZlXXqg3rfAhkYRwCIiIgMiAkAERGRATEBICIiMiAmAERERAbEBICIiMiAmAAQEREZEBMAIiIiA2ICQEREZEBMAIiIiAyICQAREZEBMQEgIiIyICYAREREBsQEgIiIyICYABARERkQEwAiIiIDMul9A0Q+zqr3DRCRYZX4jucIABERkQExASAiIjIgJgBEREQGxASAiIjIgJgAEBERGRATACIiIgNiAkBERGRATACIiIgMiAkAERGRATEBICIiMiAmAERERAbEBICIiMiAmAAQEREZEBMAIiIiA2ICQERERERERERERERERERERERERERERERERERERERERERERESko/8BXdk/jkRh35gAAAAASUVORK5CYII=','2024-05-29 14:40:20',NULL),(36,'3','03.13','Tipo Modulo','/parametria/tipomodulo',3,'data:image/jpeg;base64,',_binary 'iVBORw0KGgoAAAANSUhEUgAAAgAAAAIACAYAAAD0eNT6AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAOxAAADsQBlSsOGwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAACAASURBVHic7N13fBTV+sfxz256IaH3Eor03kWkqygCXi8qIOpVFLGAgj+xd2xYABVERS+KvVwRxQJSRK6V3ktoAQSkhyRAys7vjwEvSAIpZ3Z2N9/363VeYth9zpPJkPPszJlzQEREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREREQc53E7ARERkRAQC9QESgNRQEnsMTYVSD/e/gR2uJXg36kAEBERKZhzgHZAW6A1UAuokM/3pgPrgXXAUmAusAjIMZ+miIiIFEUY0BUYC2wELMPtEDAdGAwk+ul7EhERkTxUAx4FUjA/6OfVMoD3gZ7oKr2IiIhfNQQ+ALLx38CfW1sG9Me+AiEiIiIOqYU98Ofg7sD/97YOuNLB71tERKRYigDuANJwf7A/U5uLfXVCREREiqgN9qx8twf3/LajwMPotoCIiEiheLA/9R/D/UG9MG0eUNn0QREREQll8cCXuD+IF7XtAroZPjYiIiIhqQr2wjtuD96mWhZwg9EjJCIiEmLqYy/F6/agbbr5gDsNHicREZGQUQ/4A/cHayfbQ8aOloiISAioRWh+8s+t3WLomImIiAS1BGAF7g/M/mo5wBVGjpyIiEiQigBm4f6g7O92BGhp4PiJiIgEpadxfzB2qyWjnQVFRKQY6oT7m/m43T4u8lEUEREJIiWB7bg/AAdCu7aIx1JERCRovIL7A2+gtN1AqdwOkqcgR1RERCTAtQR+w4XNcsLDvSRVL0ON6mVIKBFNeHgYqYePsP9ABuvW7yL18FF/p3TCq8Ctf/+iCgAREQklPwId/dVZ/boVueqfrenRtT5tWyURGRme52s3bdnL3PnrmD5jGd/MWkVW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','2024-05-29 14:48:19',NULL);
/*!40000 ALTER TABLE `TipoModulo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoPermiso`
--

DROP TABLE IF EXISTS `TipoPermiso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoPermiso` (
  `IdTipoPermiso` int NOT NULL AUTO_INCREMENT,
  `Detalle` varchar(45) NOT NULL,
  PRIMARY KEY (`IdTipoPermiso`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoPermiso`
--

LOCK TABLES `TipoPermiso` WRITE;
/*!40000 ALTER TABLE `TipoPermiso` DISABLE KEYS */;
INSERT INTO `TipoPermiso` VALUES (1,'Nivel 1'),(2,'Nivel 2'),(3,'Nivel 3'),(4,'Nivel 4');
/*!40000 ALTER TABLE `TipoPermiso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoPermisoDetalle`
--

DROP TABLE IF EXISTS `TipoPermisoDetalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoPermisoDetalle` (
  `IdTipoPermisoDetalle` int NOT NULL AUTO_INCREMENT,
  `IdTipoPermiso` int NOT NULL,
  `Method` varchar(45) NOT NULL,
  PRIMARY KEY (`IdTipoPermisoDetalle`),
  KEY `fk_TipoPermisoDetalle_TipoPermiso1_idx` (`IdTipoPermiso`),
  CONSTRAINT `fk_TipoPermisoDetalle_TipoPermiso1` FOREIGN KEY (`IdTipoPermiso`) REFERENCES `TipoPermiso` (`IdTipoPermiso`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoPermisoDetalle`
--

LOCK TABLES `TipoPermisoDetalle` WRITE;
/*!40000 ALTER TABLE `TipoPermisoDetalle` DISABLE KEYS */;
INSERT INTO `TipoPermisoDetalle` VALUES (1,1,'GET'),(2,1,'PUT'),(3,1,'DELETE'),(4,1,'POST'),(5,2,'GET'),(6,2,'PUT'),(7,2,'POST'),(8,3,'GET'),(9,3,'POST'),(10,4,'GET');
/*!40000 ALTER TABLE `TipoPermisoDetalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoPersona`
--

DROP TABLE IF EXISTS `TipoPersona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoPersona` (
  `IdTipoPersona` int NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(45) NOT NULL,
  PRIMARY KEY (`IdTipoPersona`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoPersona`
--

LOCK TABLES `TipoPersona` WRITE;
/*!40000 ALTER TABLE `TipoPersona` DISABLE KEYS */;
INSERT INTO `TipoPersona` VALUES (1,'Jurídica'),(2,'Física');
/*!40000 ALTER TABLE `TipoPersona` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoPersonaSistema`
--

DROP TABLE IF EXISTS `TipoPersonaSistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoPersonaSistema` (
  `IdTipoPersonaSistema` int NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(45) NOT NULL,
  `FechaBaja` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`IdTipoPersonaSistema`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoPersonaSistema`
--

LOCK TABLES `TipoPersonaSistema` WRITE;
/*!40000 ALTER TABLE `TipoPersonaSistema` DISABLE KEYS */;
INSERT INTO `TipoPersonaSistema` VALUES (1,'Empleado',NULL),(2,'Proveedor',NULL),(3,'Cliente',NULL);
/*!40000 ALTER TABLE `TipoPersonaSistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoProducto`
--

DROP TABLE IF EXISTS `TipoProducto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoProducto` (
  `IdTipoProducto` int NOT NULL AUTO_INCREMENT,
  `Detalle` varchar(45) NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdTipoProducto`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoProducto`
--

LOCK TABLES `TipoProducto` WRITE;
/*!40000 ALTER TABLE `TipoProducto` DISABLE KEYS */;
INSERT INTO `TipoProducto` VALUES (1,'Envasado',NULL),(2,'Preparado',NULL),(3,'Suelto',NULL),(7,'Otro',NULL),(10,'Empaquetado',NULL);
/*!40000 ALTER TABLE `TipoProducto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoRol`
--

DROP TABLE IF EXISTS `TipoRol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoRol` (
  `IdTipoRol` int NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(45) NOT NULL,
  `FechaBaja` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`IdTipoRol`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoRol`
--

LOCK TABLES `TipoRol` WRITE;
/*!40000 ALTER TABLE `TipoRol` DISABLE KEYS */;
INSERT INTO `TipoRol` VALUES (1,'Dueño',NULL),(2,'Empleado',NULL),(3,'Repartidor',NULL),(4,'Gerente',NULL),(11,'Administracion','2024-06-11 23:47:54'),(12,'Cajero',NULL);
/*!40000 ALTER TABLE `TipoRol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Usuario`
--

DROP TABLE IF EXISTS `Usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuario` (
  `IdUsuario` int NOT NULL AUTO_INCREMENT,
  `IdPersona` int NOT NULL,
  `Usuario` varchar(45) NOT NULL,
  `Clave` varchar(255) NOT NULL,
  `IdUsuarioCarga` varchar(45) NOT NULL,
  `FechaAlta` datetime NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdUsuario`),
  KEY `fk_Usuario_Persona1_idx` (`IdPersona`),
  CONSTRAINT `fk_Usuario_Persona1` FOREIGN KEY (`IdPersona`) REFERENCES `Persona` (`IdPersona`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuario`
--

LOCK TABLES `Usuario` WRITE;
/*!40000 ALTER TABLE `Usuario` DISABLE KEYS */;
INSERT INTO `Usuario` VALUES (1,1,'lautaro','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','1','2024-05-09 21:52:14',NULL),(3,2,'cecilia','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','1','2024-05-10 15:30:35','2024-06-08 20:04:18'),(4,3,'Samuel123','dafcc6108173f4fa342a94a7a61bff594a41db5995991dfb6292306e7f8757e4','1','2024-05-15 17:16:05',NULL),(5,4,'Ezequiel10','1674c21e2f88ca87814cf5e3f6cfb980d62d3484166be920bbe63fd6c42305d1','1','2024-05-22 02:46:24',NULL),(6,3,'Samuel112','dafcc6108173f4fa342a94a7a61bff594a41db5995991dfb6292306e7f8757e4','1','2024-05-22 18:49:15',NULL),(7,5,'gabriel','ad1e6adb36b135fd8caefc23c6e49609363bae82ee5aa80e3448fe4cac61b857','24','2024-05-22 22:22:10',NULL),(8,6,'Alejandro','e55efa410fdc75342e4147513acc7c704e56874c62cbbe05661fcbf31fe60f07','7','2024-05-28 16:54:28',NULL),(9,7,'luciano','73b62c0e7e35a59d0852aab0df552e157da1f750a25f5baa601a0fe582052065','24','2024-05-28 17:07:36',NULL),(10,8,'Daniela','2c3fd6f508d38350efdfb168bebbea84661f0849156e5b3434fa5036578edad3','6','2024-05-28 19:53:31',NULL),(11,9,'Beatriz','f3e60cc5203609e4055e2ccef32bdab572dd58551231089b532830a6342b31b5','24','2024-05-29 19:10:35','2024-06-11 19:11:49'),(12,10,'Carlos','d4b5ede3db62d26e7fdc00b1be4a6484396c55232a4193738157352906739f44','1','2024-05-29 19:14:19','2024-05-10 15:30:35'),(13,16,'Eduardo','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','1','2024-05-29 19:14:19',NULL),(14,17,'Fernanda','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','1','2024-05-29 19:14:19',NULL),(15,18,'Helena','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','1','2024-05-29 19:14:19',NULL),(16,32,'Ignacio','53b6b53728e6db86eb10942ffca3195fb8b2ca88b2016e498a0f9bd9384ba4f0','1','2024-06-05 12:54:22','2024-06-05 18:15:18'),(17,23,'Kevin','2c3fd6f508d38350efdfb168bebbea84661f0849156e5b3434fa5036578edad3','1','2024-06-05 17:18:47',NULL),(18,11,'Lorena','15e350c69fe7c8c954d891ce8984ab3ce91da86cf063d10f672b6d1454306277','1','2024-06-06 10:55:47',NULL),(19,22,'Oscar','059698cf132a4bc03fd200e557a62602ea55c17787f4c2ba4f09caa4c0017122','5','2024-06-06 15:41:38',NULL),(20,24,'Ricardo','6ed0ee39ee7c68efdd134cd338d3018a9e2108624de64502ba02c5e755ef0a56','5','2024-06-06 15:47:40',NULL),(21,31,'Sofia','a184712a824240be01cac45109027e926f730825c7a3ddd277cce1c532179462','1','2024-06-06 15:50:34','2024-06-06 18:15:35'),(22,27,'Valeria','7f52f4be8c6c8977eb519ca0fba5b63f1f33f138577d72772bc05b039f95ba87','1','2024-06-06 15:57:07','2024-06-06 18:11:21'),(23,12,'Patricia','4368718038cc44cf4ffbe855b0014059722e64bdcb7ce2c5b130f186ee177d12','1','2024-06-06 15:57:40','2024-06-06 18:10:56'),(24,42,'Alberto','dafcc6108173f4fa342a94a7a61bff594a41db5995991dfb6292306e7f8757e4','24','2024-06-06 15:57:40',NULL),(25,43,'Bianca','4dc199afe2e52f0d590d072ae45de5b136588a4f3e4a4a84546d7818aacee145','24','2024-06-11 18:37:52',NULL),(26,38,'Diana','201a875d0d0c97bed5bb0e8a0ec9bcfe791b3bf6941120859561d63850890aea','18','2024-06-13 16:47:51',NULL),(27,48,'Javier','abf2c5fff614e9386391d5f99af24a1688c8e711ba6ef921e493cb8fda443002','18','2024-06-13 17:07:45',NULL);
/*!40000 ALTER TABLE `Usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UsuarioPorSucursal`
--

DROP TABLE IF EXISTS `UsuarioPorSucursal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UsuarioPorSucursal` (
  `IdUsuarioPorSucursal` int NOT NULL AUTO_INCREMENT,
  `IdUsuario` int NOT NULL,
  `IdSucursal` int NOT NULL,
  `FechaUltModificacion` datetime NOT NULL,
  `FechaAlta` datetime NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdUsuarioPorSucursal`),
  KEY `fk_UsuarioPorSucursal_Usuario1_idx` (`IdUsuario`),
  KEY `fk_UsuarioPorSucursal_Sucursal1_idx` (`IdSucursal`),
  CONSTRAINT `fk_UsuarioPorSucursal_Sucursal1` FOREIGN KEY (`IdSucursal`) REFERENCES `Sucursal` (`IdSucursal`),
  CONSTRAINT `fk_UsuarioPorSucursal_Usuario1` FOREIGN KEY (`IdUsuario`) REFERENCES `Usuario` (`IdUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UsuarioPorSucursal`
--

LOCK TABLES `UsuarioPorSucursal` WRITE;
/*!40000 ALTER TABLE `UsuarioPorSucursal` DISABLE KEYS */;
INSERT INTO `UsuarioPorSucursal` VALUES (1,1,3,'2024-06-05 18:05:36','2024-05-09 21:52:40',NULL);
/*!40000 ALTER TABLE `UsuarioPorSucursal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UsuarioRol`
--

DROP TABLE IF EXISTS `UsuarioRol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UsuarioRol` (
  `IdUsuarioRol` int NOT NULL AUTO_INCREMENT,
  `IdUsuario` int NOT NULL,
  `IdTipoRol` int NOT NULL,
  `IdUsuarioCarga` int NOT NULL,
  `IdUsuarioBaja` int DEFAULT NULL,
  `FechaCarga` datetime NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdUsuarioRol`),
  KEY `fk_UsuarioRol_Usuario1_idx` (`IdUsuario`),
  KEY `fk_UsuarioRol_TipoRol1_idx` (`IdTipoRol`),
  KEY `fk_UsuarioRol_Usuario2_idx` (`IdUsuarioCarga`),
  KEY `fk_UsuarioRol_Usuario3_idx` (`IdUsuarioBaja`),
  CONSTRAINT `fk_UsuarioRol_TipoRol1` FOREIGN KEY (`IdTipoRol`) REFERENCES `TipoRol` (`IdTipoRol`),
  CONSTRAINT `fk_UsuarioRol_Usuario1` FOREIGN KEY (`IdUsuario`) REFERENCES `Usuario` (`IdUsuario`),
  CONSTRAINT `fk_UsuarioRol_Usuario2` FOREIGN KEY (`IdUsuarioCarga`) REFERENCES `Usuario` (`IdUsuario`),
  CONSTRAINT `fk_UsuarioRol_Usuario3` FOREIGN KEY (`IdUsuarioBaja`) REFERENCES `Usuario` (`IdUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UsuarioRol`
--

LOCK TABLES `UsuarioRol` WRITE;
/*!40000 ALTER TABLE `UsuarioRol` DISABLE KEYS */;
INSERT INTO `UsuarioRol` VALUES (1,1,1,1,NULL,'2024-06-06 17:49:17',NULL);
/*!40000 ALTER TABLE `UsuarioRol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UsuarioToken`
--

DROP TABLE IF EXISTS `UsuarioToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UsuarioToken` (
  `IdUsuarioToken` int NOT NULL AUTO_INCREMENT,
  `IdPersona` int NOT NULL,
  `IdUsuario` int NOT NULL,
  `Token` text NOT NULL,
  `FechaCaducidad` time NOT NULL,
  `Activo` bit(1) NOT NULL,
  `FechaAlta` datetime NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdUsuarioToken`),
  KEY `fk_UsuarioToken_Persona1_idx` (`IdPersona`),
  KEY `fk_UsuarioToken_Usuario1_idx` (`IdUsuario`),
  CONSTRAINT `fk_UsuarioToken_Persona1` FOREIGN KEY (`IdPersona`) REFERENCES `Persona` (`IdPersona`),
  CONSTRAINT `fk_UsuarioToken_Usuario1` FOREIGN KEY (`IdUsuario`) REFERENCES `Usuario` (`IdUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=488 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UsuarioToken`
--

LOCK TABLES `UsuarioToken` WRITE;
/*!40000 ALTER TABLE `UsuarioToken` DISABLE KEYS */;
INSERT INTO `UsuarioToken` VALUES (342,1,1,'135c82990fd0a950638121e435c238be','17:34:18',_binary '\0','2024-06-11 17:00:54',NULL),(343,42,24,'b26aac7bc7ee36570960868cc885fc1a','19:26:48',_binary '\0','2024-06-11 17:03:13',NULL),(344,1,1,'2cfb789be71f0ebc1aa02316c76f8509','18:53:30',_binary '\0','2024-06-11 17:31:53',NULL),(345,1,1,'8ae25b031b37a61c1d2d44d814331c8a','19:38:22',_binary '\0','2024-06-11 18:38:22',NULL),(346,1,1,'2be61a5765964d26cb323d230b889ebc','19:16:46',_binary '\0','2024-06-11 18:39:35',NULL),(347,1,1,'dce1157d3a565b40b86ea49850ec0969','20:01:29',_binary '\0','2024-06-11 19:01:29',NULL),(348,1,1,'0f78b851d2862bdcba98e632795b39dc','20:02:16',_binary '\0','2024-06-11 19:02:16',NULL),(349,1,1,'c1d7180449ead196b777942498400cc9','20:04:40',_binary '\0','2024-06-11 19:04:40',NULL),(350,1,1,'483db07d809a2b46149af763ff6fbac6','19:42:40',_binary '\0','2024-06-11 19:05:16',NULL),(351,42,24,'ead19b4f1e9189c54948fcb26777e347','19:36:20',_binary '\0','2024-06-11 19:09:06',NULL),(352,42,24,'d830861b5ecf490afcad816187adfc6f','19:42:07',_binary '\0','2024-06-11 19:20:00',NULL),(353,4,5,'79682100ce373dee839de5beb6635493','20:20:30',_binary '\0','2024-06-11 19:20:30',NULL),(354,1,1,'48ebd28a06b7b143f2c7143138629f1b','20:24:13',_binary '\0','2024-06-11 19:24:13',NULL),(355,1,1,'b1aa01603f72d92a2cd852bda6d7257b','19:46:06',_binary '\0','2024-06-11 19:25:43',NULL),(356,42,24,'094cb37756829ac82a2c1b0d6572b60a','20:26:14',_binary '\0','2024-06-11 19:26:14',NULL),(357,1,1,'45fca85b9c46694cf2d76626fc9b35af','20:26:20',_binary '\0','2024-06-11 19:26:20',NULL),(358,42,24,'86c5161d0fc622f1288d06c788939af3','20:26:39',_binary '\0','2024-06-11 19:26:39',NULL),(359,5,7,'cd7175c03af2e0fe3b176b5cc1d7336d','19:48:19',_binary '\0','2024-06-11 19:27:44',NULL),(360,42,24,'ab8f1bf2f0cd18f577c4f4b460d599ba','20:27:55',_binary '\0','2024-06-11 19:27:55',NULL),(361,1,1,'f1845256939f58cc852590631a188b0a','19:54:21',_binary '\0','2024-06-11 19:28:06',NULL),(362,5,7,'643ecc88b349b1925f3b8d7bb8535b3e','19:51:04',_binary '\0','2024-06-11 19:29:17',NULL),(363,1,1,'ef41bc8aa0a6c255c60100312f115fe6','20:34:43',_binary '\0','2024-06-11 19:34:43',NULL),(364,5,7,'db05ffc4d256cbad096ab7bfd584039b','20:35:04',_binary '\0','2024-06-11 19:35:04',NULL),(365,5,7,'3f15ebe9723f1fa4ca42324cda39f0d7','20:36:06',_binary '\0','2024-06-11 19:36:06',NULL),(366,1,1,'7e321c3a737a469bfe123b242d4fa9be','19:56:54',_binary '\0','2024-06-11 19:36:17',NULL),(367,42,24,'658462c8013cd313f65568aa09d6d821','20:36:29',_binary '\0','2024-06-11 19:36:29',NULL),(368,1,1,'6c716ee5771c30cf06fd54419f541ded','00:19:25',_binary '\0','2024-06-11 22:55:43',NULL),(369,42,24,'ccd8bbdbccf76cfa808fc3245562f5a0','00:07:53',_binary '\0','2024-06-11 23:35:11',NULL),(370,42,24,'332a6fa0b22e049b5be4f5c8f18d9067','00:57:43',_binary '\0','2024-06-11 23:57:43',NULL),(371,42,24,'40428b1e2ab1ff9990a5679b79f9469b','01:01:35',_binary '\0','2024-06-12 00:01:35',NULL),(372,1,1,'d79d9464a45d7ee52a5590dadf51fe1c','00:59:40',_binary '\0','2024-06-12 00:03:08',NULL),(373,42,24,'0b1e48d08d99a594533afffa94331ae2','00:38:37',_binary '\0','2024-06-12 00:10:30',NULL),(374,42,24,'eac36009ce5c69d4c160bb27827dc5e8','01:26:31',_binary '\0','2024-06-12 00:26:31',NULL),(375,42,24,'f9c583c53f1053673935491088cdfdf0','01:28:37',_binary '\0','2024-06-12 00:28:37',NULL),(376,42,24,'90eb2179b7e078321136c055a80b973b','01:33:55',_binary '\0','2024-06-12 00:33:55',NULL),(377,42,24,'e5e857ecd8249512222318af3fef1770','01:38:44',_binary '\0','2024-06-12 00:38:44',NULL),(378,42,24,'085315407bccc60e39572311611d7696','01:40:13',_binary '\0','2024-06-12 00:40:13',NULL),(379,5,7,'a9b1a1f0645fdba163e422d0f3038e59','02:29:11',_binary '\0','2024-06-12 01:41:33',NULL),(380,42,24,'22ab334a001d134769cc40e303e54061','13:08:03',_binary '\0','2024-06-12 12:08:03',NULL),(381,42,24,'b6b4c5f84689f4dd0d807b644186297f','13:21:22',_binary '\0','2024-06-12 12:21:22',NULL),(382,4,5,'b3bafb858fc5b22641ddc725f398d7d3','13:35:58',_binary '\0','2024-06-12 12:35:58',NULL),(383,5,7,'9e3c9c3d66c3318cbdc3baea6ac5bb8e','13:07:39',_binary '\0','2024-06-12 12:37:27',NULL),(384,5,7,'95a59a05967621bf7e3ee5f5629a0e10','13:09:25',_binary '\0','2024-06-12 12:48:09',NULL),(385,5,7,'840b93baff302cb1538431c127583d6e','13:55:33',_binary '\0','2024-06-12 12:55:33',NULL),(386,5,7,'2af0cbc13121da9cfd59d4b7a3194d3b','13:58:11',_binary '\0','2024-06-12 12:58:11',NULL),(387,5,7,'fb0349eb9d56d56824e4e3a56d16efca','14:59:22',_binary '\0','2024-06-12 13:59:22',NULL),(388,5,7,'bb82639592cee7be5941cebd3d9b1e41','14:59:50',_binary '\0','2024-06-12 13:59:50',NULL),(389,42,24,'254f94b09b8b60a0844f798bbb7366d1','14:25:39',_binary '\0','2024-06-12 14:05:00',NULL),(390,42,24,'2d57b5aa69700200e56502e69806886b','14:43:01',_binary '\0','2024-06-12 14:21:53',NULL),(391,42,24,'099e0556e1554590744fae96fd6b2ba0','15:32:20',_binary '\0','2024-06-12 14:32:20',NULL),(392,1,1,'3922576ad7f3c6e717729189f5f03640','15:48:02',_binary '\0','2024-06-12 14:48:02',NULL),(393,1,1,'b1785e1ed12eef444c0000cbbc26f967','17:35:32',_binary '\0','2024-06-12 14:54:36',NULL),(394,42,24,'e8189a1274cf196fef6a55fa358a1b8b','16:25:09',_binary '\0','2024-06-12 15:25:09',NULL),(395,1,1,'ddf1cedd6be4af5eac7a896f95a2021c','18:15:47',_binary '\0','2024-06-12 17:51:18',NULL),(396,1,1,'5fdb5e74aa5cadf6fa156f9567908b8f','18:53:13',_binary '\0','2024-06-12 18:27:59',NULL),(397,1,1,'d9f9bc797afd0bc05fd7957a13eca1f5','19:58:00',_binary '\0','2024-06-12 18:58:00',NULL),(398,42,24,'7aaec73903bdcdbda9a340423424336e','20:27:05',_binary '\0','2024-06-12 19:27:05',NULL),(399,42,24,'b1d202500935004fe205c44e0c1405aa','20:28:44',_binary '\0','2024-06-12 19:28:44',NULL),(400,1,1,'5c9ae5f3433fb6bfeedba0ee2c99d835','20:35:19',_binary '\0','2024-06-12 19:35:19',NULL),(401,1,1,'fa7f25db318a86312d39642a2d1a8ca7','19:59:26',_binary '\0','2024-06-12 19:36:38',NULL),(402,1,1,'e9ebb9ec0a7e2cabfbc8bc833c10e40e','20:03:33',_binary '\0','2024-06-12 19:40:30',NULL),(403,1,1,'77b54c147b7c4daad9de1e950e473d34','21:02:58',_binary '\0','2024-06-12 20:02:58',NULL),(404,1,1,'92f70bb9109671a99cb9140bcfdcd66e','21:04:14',_binary '\0','2024-06-12 20:04:14',NULL),(405,1,1,'f712ff3114edfb3d423ba2c3f2e0f252','21:10:09',_binary '\0','2024-06-12 20:10:09',NULL),(406,42,24,'3ac5f3148f5434147a3b73e07f434b2e','20:34:20',_binary '\0','2024-06-12 20:11:37',NULL),(407,42,24,'d790093e87bcdadbeb0806e9a20089be','21:16:04',_binary '\0','2024-06-12 20:16:04',NULL),(408,42,24,'c1ed8b23227e83f4303b81023d2f839e','20:41:50',_binary '\0','2024-06-12 20:20:48',NULL),(409,4,5,'bd41d000524d5294ed787c7b9c5b42e7','21:21:44',_binary '\0','2024-06-12 20:21:44',NULL),(410,42,24,'79988d9340bc2b201ccf334d0ded2da9','21:26:26',_binary '\0','2024-06-12 20:26:26',NULL),(411,42,24,'bd0c1a611a437558d4bbf7853d1a85f3','21:29:31',_binary '\0','2024-06-12 20:29:31',NULL),(412,1,1,'affcd0c905bb879617b33d824b3e17be','21:01:52',_binary '\0','2024-06-12 20:38:16',NULL),(413,1,1,'981624ddd48097ad3e94e0c547c3e8d6','21:22:18',_binary '\0','2024-06-12 20:52:41',NULL),(414,1,1,'6b836f626988425ae2792b1efe360e1c','22:08:47',_binary '\0','2024-06-12 21:08:47',NULL),(415,1,1,'0a8da7f6796aaa21795927b6b5385135','21:30:25',_binary '\0','2024-06-12 21:09:16',NULL),(416,1,1,'730d06a7d896934a1143d9109bb77d71','21:48:52',_binary '\0','2024-06-12 21:27:15',NULL),(417,1,1,'a8ca04ba7fc8bc05ab17dd61da6c9fc4','22:59:20',_binary '\0','2024-06-12 21:59:20',NULL),(418,1,1,'cd4cc8c39d1030d6c60f839669bd0306','23:08:48',_binary '\0','2024-06-12 22:08:48',NULL),(419,1,1,'fb4b7652f4346e95116a454c2df554a0','23:10:48',_binary '\0','2024-06-12 22:27:26',NULL),(420,1,1,'b6187337e23f8fb51b65bff8603e5765','23:17:00',_binary '\0','2024-06-12 22:54:30',NULL),(421,1,1,'46b1d6099c896eb57835abfe2ba62e2d','00:05:23',_binary '\0','2024-06-12 23:05:23',NULL),(422,1,1,'a4e31a8cb22724773b8f9ac31ae1f463','00:08:41',_binary '\0','2024-06-12 23:08:41',NULL),(423,1,1,'883fab5c62d48cff5f9003f5247a92fb','23:54:06',_binary '\0','2024-06-12 23:27:44',NULL),(424,1,1,'e783cdd1cc03ed36d3591e6e4e5f8cd8','00:34:44',_binary '\0','2024-06-12 23:34:44',NULL),(425,1,1,'2a582a4b2169371012805ec39b542976','00:45:33',_binary '\0','2024-06-12 23:45:33',NULL),(426,5,7,'29548dc61e6b9a9618aef442fbd9f1a8','02:29:55',_binary '\0','2024-06-13 01:29:55',NULL),(427,5,7,'72e113e989c35e959fdda19be17d073d','02:31:17',_binary '\0','2024-06-13 01:31:17',NULL),(428,5,7,'fee526805898ebfab1619673b90f1b8e','02:34:31',_binary '\0','2024-06-13 01:34:31',NULL),(429,5,7,'c404f8437038f1b5b1beee1864a3c8a4','02:36:31',_binary '\0','2024-06-13 01:36:31',NULL),(430,5,7,'5dfeda4e3147f65f86128ef5e07cbce3','02:40:45',_binary '\0','2024-06-13 01:40:45',NULL),(431,1,1,'27f03cec457ae9e0c7e7e36b5263a148','02:02:57',_binary '\0','2024-06-13 01:41:16',NULL),(432,1,1,'aa743eb04c451225383e51ffbd86ba4e','02:05:00',_binary '\0','2024-06-13 01:44:23',NULL),(433,1,1,'82f43be875d4b003f4538c97936c55ea','02:13:02',_binary '\0','2024-06-13 01:52:18',NULL),(434,1,1,'4a0d42cafc02b77c123b8d7dd14f4c90','14:27:50',_binary '\0','2024-06-13 13:27:50',NULL),(435,1,1,'0ee9625f66b80f5818a59bc9a833a929','14:57:34',_binary '\0','2024-06-13 13:57:34',NULL),(436,1,1,'589df7d03a879ac86797094ea841fdd6','14:37:39',_binary '\0','2024-06-13 14:16:21',NULL),(437,1,1,'3801bb2010172006ea70fba890bcf3ce','15:18:20',_binary '\0','2024-06-13 14:18:20',NULL),(438,4,5,'45164d1ce3a88e001e39594d31c9a38e','15:25:07',_binary '\0','2024-06-13 14:25:07',NULL),(439,1,1,'286dc1cac5a3a71e26eef8f2737d9af0','15:27:39',_binary '\0','2024-06-13 14:27:39',NULL),(440,1,1,'3117bf7e575af5a2af7f0ac494c08c19','14:50:45',_binary '\0','2024-06-13 14:29:18',NULL),(441,4,5,'d2888d25f1ed0b23fbf2a67ed9832326','15:34:26',_binary '\0','2024-06-13 14:34:26',NULL),(442,1,1,'5ed7a113c03f16ae034ccf5e75f92ad0','15:48:51',_binary '\0','2024-06-13 14:45:21',NULL),(443,4,5,'4903e914ff86afd4ce18a5a4bdea2b9e','15:48:30',_binary '\0','2024-06-13 14:48:30',NULL),(444,4,5,'77722703fa32fae2b1b7e5893b7c5493','15:53:09',_binary '\0','2024-06-13 14:53:09',NULL),(445,5,7,'c00854156248ad4fe0d19fb286c09a70','16:22:16',_binary '\0','2024-06-13 15:04:57',NULL),(446,1,1,'d7b58939583de450a9d9eca82cf46748','18:00:20',_binary '\0','2024-06-13 15:31:30',NULL),(447,42,24,'6762d9e80e83c66aa3e4b9f92fafa217','16:21:17',_binary '\0','2024-06-13 15:58:58',NULL),(448,42,24,'3ac7a4675de38ce8c76d615eed00f3cc','16:24:03',_binary '\0','2024-06-13 16:02:54',NULL),(449,4,5,'9cd10963e20179bd4b3a6d0d02e74d06','17:10:19',_binary '\0','2024-06-13 16:10:19',NULL),(450,4,5,'5e531034882081b679c707cf9950a5d2','17:18:26',_binary '\0','2024-06-13 16:18:26',NULL),(451,11,18,'677aa26ac25fdb3209c16c2e5af81de8','17:31:54',_binary '\0','2024-06-13 16:31:54',NULL),(452,4,5,'f4c2a6753c097833c04db966841dcd88','17:33:22',_binary '\0','2024-06-13 16:33:22',NULL),(453,11,18,'2ad10c80014fa5f8b78dfcfe3bacff0b','16:57:41',_binary '\0','2024-06-13 16:36:35',NULL),(454,4,5,'90d6ac69b101a7cd1b89940df802e981','17:38:13',_binary '\0','2024-06-13 16:38:13',NULL),(455,11,18,'23bc705102fb95a9d645f50965e9098a','17:02:18',_binary '\0','2024-06-13 16:41:25',NULL),(456,11,18,'7b1a405b73519f63a7cc22b8767100a8','17:03:40',_binary '\0','2024-06-13 16:43:07',NULL),(457,4,5,'c924f34fd954a01618bbbf55f7cb89dc','17:45:27',_binary '\0','2024-06-13 16:45:27',NULL),(458,11,18,'6b38cc9e4f723b332a419ffd105144e5','17:09:59',_binary '\0','2024-06-13 16:45:30',NULL),(459,42,24,'c44da36d3eae27dc108c2b5263fb0323','17:47:50',_binary '\0','2024-06-13 16:47:50',NULL),(460,4,5,'4056417ba72a541bc541af5283f97876','17:53:36',_binary '\0','2024-06-13 16:53:36',NULL),(461,11,18,'a39b060a6c99d47fbdea49e0803df367','17:55:17',_binary '\0','2024-06-13 16:55:17',NULL),(462,42,24,'06abb96f69b9bace9a4a32df7681458c','17:55:58',_binary '\0','2024-06-13 16:55:58',NULL),(463,4,5,'de156dd1b9546bf3dd65c1a7e6f3af20','17:58:32',_binary '\0','2024-06-13 16:58:32',NULL),(464,11,18,'cfeb60585fefd744fbf81e978b41f70f','18:02:19',_binary '\0','2024-06-13 17:02:19',NULL),(465,11,18,'8d7ba6c0e63229493ec41cde2bab2fde','18:02:41',_binary '\0','2024-06-13 17:02:41',NULL),(466,4,5,'5c0daaf66bfea6472855712184e8c8e4','18:02:56',_binary '\0','2024-06-13 17:02:56',NULL),(467,11,18,'e1a94fbc6b4b7b478393e33a23e41516','18:04:10',_binary '\0','2024-06-13 17:04:10',NULL),(468,11,18,'2f58d948074add864c7f09e590cfc223','17:33:57',_binary '\0','2024-06-13 17:04:55',NULL),(469,4,5,'97cacbbe7fbb71a150562235551d40db','18:05:38',_binary '\0','2024-06-13 17:05:38',NULL),(470,4,5,'6b65d47712a5465bac1bb22597331eb3','18:06:49',_binary '\0','2024-06-13 17:06:49',NULL),(471,42,24,'a7251b62094068d3cde7dad77598e6c6','17:29:48',_binary '\0','2024-06-13 17:08:12',NULL),(472,4,5,'7d14ac0021afc49f0511b3cdd21ae229','17:35:50',_binary '\0','2024-06-13 17:11:03',NULL),(473,11,18,'919498aa1f9fc2e911fef34c69f8f074','17:36:14',_binary '\0','2024-06-13 17:15:13',NULL),(474,4,5,'cf1a26ef01232f29cb0f2cd2288d4053','18:16:58',_binary '\0','2024-06-13 17:16:58',NULL),(475,42,24,'e0d78e94f94ea37089100a8779d03aee','17:38:52',_binary '\0','2024-06-13 17:17:04',NULL),(476,5,7,'c20b6e7e6b5b2001987f46772d20fbfd','17:40:51',_binary '','2024-06-13 17:19:42',NULL),(477,4,5,'2b9755d9e57f45d8c5ab25838079eab3','18:22:06',_binary '\0','2024-06-13 17:22:06',NULL),(478,11,18,'cdd3d652f3cadc9bef13ff74ee64f39b','17:43:24',_binary '\0','2024-06-13 17:22:24',NULL),(479,11,18,'fc45e37682cd3bd0bc18f2b22ed11009','17:44:14',_binary '\0','2024-06-13 17:23:33',NULL),(480,11,18,'cc3c636467e6ced7189faf748a1dfefb','17:48:05',_binary '\0','2024-06-13 17:27:06',NULL),(481,4,5,'298cd2df26117a790391604a9bfd4862','18:30:40',_binary '','2024-06-13 17:30:40',NULL),(482,11,18,'bfdd9f7648b652238deb59b7aff252f3','17:52:45',_binary '','2024-06-13 17:31:11',NULL),(483,42,24,'944c016dd02106298e9d33afb9c98602','18:39:56',_binary '','2024-06-13 17:39:56',NULL),(484,1,1,'8f7b1867c6451e4f6d879f092eb7d9e5','00:48:21',_binary '\0','2024-06-13 23:48:21',NULL),(485,1,1,'70401bc833022b8e07ab41987b6544e2','01:10:24',_binary '\0','2024-06-14 00:10:24',NULL),(486,1,1,'53c51cc5c38db42e84e76f553bf17f2b','01:16:02',_binary '\0','2024-06-14 00:16:02',NULL),(487,1,1,'3c37d1d4cf89d5ef5f6ce3cad1855235','00:45:36',_binary '','2024-06-14 00:21:38',NULL);
/*!40000 ALTER TABLE `UsuarioToken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Venta`
--

DROP TABLE IF EXISTS `Venta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Venta` (
  `IdVenta` int NOT NULL AUTO_INCREMENT,
  `IdDetalleFactura` int NOT NULL,
  `IdSucursal` int NOT NULL,
  `Fecha` datetime NOT NULL,
  `NroVenta` int NOT NULL,
  `Cantidad` decimal(18,2) NOT NULL,
  `IdUsuarioCarga` int NOT NULL,
  `FechaAlta` datetime NOT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdVenta`),
  KEY `fk_Ventas_DetalleFactura1_idx` (`IdDetalleFactura`),
  KEY `fk_Ventas_Sucursal1_idx` (`IdSucursal`),
  KEY `fk_Ventas_Usuario1_idx` (`IdUsuarioCarga`),
  CONSTRAINT `fk_Ventas_DetalleFactura1` FOREIGN KEY (`IdDetalleFactura`) REFERENCES `DetalleFactura` (`IdDetalleFactura`),
  CONSTRAINT `fk_Ventas_Sucursal1` FOREIGN KEY (`IdSucursal`) REFERENCES `Sucursal` (`IdSucursal`),
  CONSTRAINT `fk_Ventas_Usuario1` FOREIGN KEY (`IdUsuarioCarga`) REFERENCES `Usuario` (`IdUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Venta`
--

LOCK TABLES `Venta` WRITE;
/*!40000 ALTER TABLE `Venta` DISABLE KEYS */;
/*!40000 ALTER TABLE `Venta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `VentaDetalle`
--

DROP TABLE IF EXISTS `VentaDetalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `VentaDetalle` (
  `IdVentaDetalle` int NOT NULL AUTO_INCREMENT,
  `IdVenta` int NOT NULL,
  `IdProductos` int NOT NULL,
  `IdGeneradorPrecios` int NOT NULL,
  `Cantidad` decimal(18,2) DEFAULT NULL,
  `FechaBaja` datetime DEFAULT NULL,
  PRIMARY KEY (`IdVentaDetalle`),
  KEY `fk_VentaDetalle_Ventas1_idx` (`IdVenta`),
  KEY `fk_VentaDetalle_Productos1_idx` (`IdProductos`) /*!80000 INVISIBLE */,
  KEY `fk_VentaDetalle_GeneradorPrecios1_idx` (`IdGeneradorPrecios`),
  CONSTRAINT `fk_VentaDetalle_GeneradorPrecios1` FOREIGN KEY (`IdGeneradorPrecios`) REFERENCES `GeneradorPrecios` (`IdGeneradorPrecios`),
  CONSTRAINT `fk_VentaDetalle_Productos1` FOREIGN KEY (`IdProductos`) REFERENCES `Producto` (`IdProducto`),
  CONSTRAINT `fk_VentaDetalle_Ventas1` FOREIGN KEY (`IdVenta`) REFERENCES `Venta` (`IdVenta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VentaDetalle`
--

LOCK TABLES `VentaDetalle` WRITE;
/*!40000 ALTER TABLE `VentaDetalle` DISABLE KEYS */;
/*!40000 ALTER TABLE `VentaDetalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'railway'
--

--
-- Dumping routines for database 'railway'
--
/*!50003 DROP FUNCTION IF EXISTS `FN_ObtenerUsuDesdeBearer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `FN_ObtenerUsuDesdeBearer`(
    p_UsuarioBearer text(500)
) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_IdUsu INT;
    SELECT IdUsuario INTO v_IdUsu
    FROM UsuarioToken
    WHERE Token = p_UsuarioBearer AND Activo = 1; 
    RETURN v_IdUsu;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_AgregarRolUsuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_AgregarRolUsuario`(
    IN p_IdUsuario INT, 
    IN p_IdRol INT, 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_Message VARCHAR(255);
    DECLARE existe_Usuario INT;
    DECLARE existe_Rol INT;
    DECLARE v_IdUsuarioCarga INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    
    -- Verificar si el usuario existe y no está dado de baja
    SELECT COUNT(*) INTO existe_Usuario 
    FROM Usuario 
    WHERE IdUsuario = p_IdUsuario 
      AND FechaBaja IS NULL;
      
    -- Verificar si el rol existe y no está dado de baja
    SELECT COUNT(*) INTO existe_Rol 
    FROM TipoRol 
    WHERE IdTipoRol = p_IdRol 
      AND FechaBaja IS NULL;
      
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF existe_Usuario > 0 THEN
			IF existe_Rol > 0 THEN
				-- Verificar si el usuario ya posee el rol
				IF (SELECT COUNT(*) FROM UsuarioRol WHERE IdUsuario = p_IdUsuario AND IdTipoRol = p_IdRol AND FechaBaja IS NULL) = 0 THEN
					INSERT INTO UsuarioRol (IdUsuario, IdTipoRol, IdUsuarioCarga, IdUsuarioBaja, FechaCarga) 
					VALUES (p_IdUsuario, p_IdRol, v_IdUsuarioCarga, null, NOW());
					SET v_Message = 'OK';
				ELSE
					SET v_Message = 'El usuario ya posee dicho rol.';
				END IF;
			ELSE
				SET v_Message = 'El rol no existe en la base de datos.';
			END IF;
		ELSE
			SET v_Message = 'El usuario no existe en la base de datos.';
		END IF;
	ELSE
        SET v_Message = 'Token Inválido';
    END IF;
    
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_AgregarStock` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_AgregarStock`(
    IN p_IdProducto INT,
    IN p_Cantidad DECIMAL(18,2),
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(255);

    -- Obtener el ID del usuario desde el token
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Validar si el usuario es válido
    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Validar si el producto existe y no está dado de baja
        IF NOT EXISTS (SELECT 1 FROM Producto WHERE IdProducto = p_IdProducto AND FechaBaja IS NULL) THEN
            SET v_Message = 'El producto ingresado no existe o ha sido dado de baja.';
        ELSE
            -- Insertar el stock en la tabla StockSucursal para la sucursal con ID 3 (Galpón)
            INSERT INTO StockSucursal (IdProducto, IdSucursal, Cantidad, IdUsuarioUltMod, FechaAlta, FechaUltMod)
            VALUES (p_IdProducto, 3, p_Cantidad, v_IdUsuarioCarga, NOW(), NOW());

            -- Verificar si se realizó la inserción correctamente
            IF ROW_COUNT() > 0 THEN
                SET v_Message = 'OK';
            ELSE
                SET v_Message = 'Hubo un error al agregar el stock.';
            END IF;
        END IF;
    ELSE
        -- Token Inválido
        SET v_Message = 'Token Inválido';
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_Clientes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_Clientes`(
    IN p_IdTipoPersona INT,
    IN p_IdTipoDomicilio INT,
    IN p_Calle VARCHAR(45),
    IN p_Nro VARCHAR(45),
    IN p_Piso VARCHAR(45),
    IN p_IdLocalidad INT,
    IN p_IdTipoDocumentacion INT,
    IN p_Documentacion VARCHAR(45),
    IN p_Nombre VARCHAR(45),
    IN p_Apellido VARCHAR(45),
    IN p_Mail VARCHAR(45),
    IN p_RazonSocial VARCHAR(45),
    IN p_FechaNacimiento DATE,
    IN p_Telefono VARCHAR(45),
    IN p_IdProvincia INT,
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_Message VARCHAR(255);
    DECLARE v_IdDomicilio INT;
    DECLARE v_DocumentacionExists INT;
    DECLARE v_TelefonoExists INT;
    DECLARE v_LocalidadProvincia INT;
    DECLARE v_DomicilioExists INT;
    DECLARE v_IdTipoPersonaSistema INT DEFAULT 3;
    DECLARE v_IdUsuarioCarga INT;

    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Verificar si el tipo de persona sistema es igual a 3
    IF v_IdTipoPersonaSistema <> 3 THEN
        SET v_Message = 'Solo se puede crear un cliente si el tipo de persona sistema es igual a Cliente.';
    -- Verificar si el tipo de persona existe
    ELSEIF NOT EXISTS (SELECT 1 FROM TipoPersona WHERE idTipoPersona = p_IdTipoPersona) THEN
        SET v_Message = 'El tipo persona ingresado no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM TipoDomicilio WHERE IdTipoDomicilio = p_IdTipoDomicilio) THEN
        SET v_Message = 'El ID de tipo de domicilio no existe en la base de datos.';
    ELSEIF NOT EXISTS (SELECT 1 FROM TipoDocumentacion WHERE IdTipoDocumentacion = p_IdTipoDocumentacion) THEN
        SET v_Message = 'El ID de tipo de documentación no existe en la base de datos.';
    ELSEIF NOT EXISTS (SELECT 1 FROM Localidad WHERE IdLocalidad = p_IdLocalidad) THEN
        SET v_Message = 'No existe localidad ingresada en la base de datos.';
    ELSEIF p_Calle IS NULL OR p_Calle = '' THEN
        SET v_Message = 'El nombre de la calle no puede estar vacío.';
    ELSEIF p_Nro IS NULL OR p_Nro = '' THEN
        SET v_Message = 'El número de la calle no puede estar vacío.';
    ELSEIF p_FechaNacimiento > DATE_SUB(CURDATE(), INTERVAL 18 YEAR) THEN
        SET v_Message = 'El cliente debe ser mayor de 18 años.';
    ELSEIF NOT p_Telefono REGEXP '^[0-9]+$' THEN
        SET v_Message = 'Ingrese sin ningun tipo de signo su numero de telefono.';
    ELSEIF NOT p_Nro REGEXP '^[0-9]+$' THEN
        SET v_Message = 'El número de domicilio debe contener solo dígitos positivos.';
    ELSEIF NOT p_Nombre REGEXP  '^[a-zA-Z]+$' THEN
        SET v_Message = 'El nombre no puede contener números.';
    ELSEIF NOT p_Apellido REGEXP  '^[a-zA-Z]+$' THEN
        SET v_Message = 'El apellido no puede contener números.';
    ELSEIF NOT p_Mail REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' THEN
        SET v_Message = 'El correo electrónico no tiene un formato válido.';
    ELSEIF NOT p_RazonSocial REGEXP '^[a-zA-Z]+$' THEN
        SET v_Message = 'La razón social no puede contener numeros.';
    ELSE
        -- Verificar si el número de documentación ya existe en la base de datos
        SELECT COUNT(*) INTO v_DocumentacionExists FROM Persona WHERE Documentacion = p_Documentacion;
        IF v_DocumentacionExists > 0 THEN
            SET v_Message = 'El número de documentación ya está registrado.';
        ELSE
            -- Verificar si el número de teléfono ya existe en la base de datos
            SELECT COUNT(*) INTO v_TelefonoExists FROM Persona WHERE Telefono = p_Telefono;
            IF v_TelefonoExists > 0 THEN
                SET v_Message = 'El número de teléfono ya está registrado.';
            ELSE
                -- Verificar si ya existe una dirección igual
                SELECT COUNT(*) INTO v_DomicilioExists FROM Domicilio WHERE Calle = p_Calle AND Nro = p_Nro AND Piso = p_Piso;
                IF v_DomicilioExists > 0 THEN
                    SET v_Message = 'Ya existe una dirección igual en la base de datos.';
                ELSE
                    -- Obtener la provincia de la localidad
                    SELECT IdProvincia INTO v_LocalidadProvincia FROM Localidad WHERE IdLocalidad = p_IdLocalidad;

                    -- Verificar si la localidad pertenece a la provincia especificada
                    IF NOT EXISTS (SELECT 1 FROM Provincia WHERE IdProvincia = p_IdProvincia AND IdProvincia = v_LocalidadProvincia) THEN
                        SET v_Message = 'La localidad no pertenece a la provincia especificada.';
                    ELSE
                        -- Insertar datos en la tabla Domicilio
                        INSERT INTO Domicilio (IdTipoDomicilio, Calle, Nro, Piso)
                        VALUES (p_IdTipoDomicilio, p_Calle, p_Nro, p_Piso);

                        -- Obtener el IdDomicilio insertado
                        SET v_IdDomicilio = LAST_INSERT_ID();

                        -- Insertar el nuevo cliente
                        INSERT INTO Persona (IdTipoPersonaSistema, IdTipoPersona, IdDomicilio, IdLocalidad, IdTipoDocumentacion, Documentacion, Nombre, Apellido, Mail, RazonSocial, FechaNacimiento, Telefono, FechaAlta, IdUsuarioCarga)
                        VALUES (v_IdTipoPersonaSistema, p_IdTipoPersona, v_IdDomicilio, p_IdLocalidad, p_IdTipoDocumentacion, p_Documentacion, p_Nombre, p_Apellido, p_Mail, p_RazonSocial, p_FechaNacimiento, p_Telefono, NOW(), v_IdUsuarioCarga);

                        -- Verificar si se realizó la inserción correctamente
                        IF ROW_COUNT() > 0 THEN
                            SET v_Message = 'OK';
                        ELSE
                            SET v_Message = 'Hubo un error al dar de alta al cliente.';
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_GenerarVenta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_GenerarVenta`(
	IN UsuarioBearer VARCHAR(500),
    IN v_IdFactura INT,
    IN v_IdTipoFormaDePago INT,
    IN v_Subtotal DECIMAL(18,2),
    IN v_Total DECIMAL(18,2),
    IN v_DescVenta DECIMAL(18,2),
    IN v_Pago DECIMAL(18,2),
    IN v_Vuelto DECIMAL(18,2)
    )
BEGIN
	DECLARE IdUsuarioCarga INT;
    DECLARE Message VARCHAR(50);
    SET IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(UsuarioBearer);
    
    IF IdUsuarioCarga IS NOT NULL THEN
		SET Message = 'Token Inválido.';
    ELSE
        SET Message = 'Token Inválido.';
    END IF;
    SELECT Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_Personal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_Personal`(
		IN p_IdTipoPersona INT,
		IN p_IdTipoDomicilio INT,
		IN p_Calle VARCHAR(45),
		IN p_Nro VARCHAR(45),
		IN p_Piso VARCHAR(45),
		IN p_IdLocalidad INT,
		IN p_IdTipoDocumentacion INT,
		IN p_Documentacion VARCHAR(45),
		IN p_Nombre VARCHAR(45),
		IN p_Apellido VARCHAR(45),
		IN p_Mail VARCHAR(45),
		IN p_FechaNacimiento DATE,
		IN p_Telefono VARCHAR(45),
		IN p_IdProvincia INT,
        IN p_UsuarioBearer TEXT(500)
	)
BEGIN
		DECLARE v_Message VARCHAR(255);
		DECLARE v_IdDomicilio INT;
		DECLARE v_DocumentacionExists INT;
		DECLARE v_TelefonoExists INT;
		DECLARE v_LocalidadProvincia INT;
        DECLARE v_IdTipoPersonaSistema INT DEFAULT 1;
        DECLARE v_IdUsuarioCarga INT;
        
        SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);


		-- Verificar si el tipo de persona existe
		IF NOT EXISTS (SELECT 1 FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = v_IdTipoPersonaSistema) THEN
			SET v_Message = 'No existe el tipo persona sistema ingresado.';
		ELSEIF NOT EXISTS (SELECT 1 FROM TipoPersona WHERE idTipoPersona = p_IdTipoPersona) THEN
			SET v_Message = 'El tipo persona ingresado no existe.';
		ELSEIF NOT EXISTS (SELECT 1 FROM TipoDomicilio WHERE IdTipoDomicilio = p_IdTipoDomicilio) THEN
			SET v_Message = 'El ID de tipo de domicilio no existe en la base de datos.';
		ELSEIF NOT EXISTS (SELECT 1 FROM TipoDocumentacion WHERE IdTipoDocumentacion = p_IdTipoDocumentacion) THEN
			SET v_Message = 'El ID de tipo de documentación no existe en la base de datos.';
		ELSEIF NOT EXISTS (SELECT 1 FROM Localidad WHERE IdLocalidad = p_IdLocalidad) THEN
			SET v_Message = 'No existe localidad ingresada en la base de datos.';
		ELSEIF p_FechaNacimiento > DATE_SUB(CURDATE(), INTERVAL 18 YEAR) THEN
			SET v_Message = 'El cliente debe ser mayor de 18 años.';
		ELSEIF NOT p_Telefono REGEXP '^[0-9]+$' THEN
			SET v_Message = 'Ingrese sin ningun tipo de signo su numero de telefono.';
		ELSEIF length(p_Telefono) <=10 then 
			set  v_Message = 'El numero de telefono minimo debe tener 10 digitos';
		ELSEIF NOT p_Nro REGEXP '^[0-9]+$' THEN
			SET v_Message = 'El número de domicilio debe contener solo dígitos positivos.';
		ELSEIF NOT p_Nombre REGEXP  '^[a-zA-Z]+$' THEN
			SET v_Message = 'El nombre no puede contener números.';
		ELSEIF NOT p_Apellido REGEXP  '^[a-zA-Z]+$' THEN
			SET v_Message = 'El apellido no puede contener números.';
		ELSEIF NOT p_Mail REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' THEN
			SET v_Message = 'El correo electrónico no tiene un formato válido.';
		ELSE
			-- Verificar si el número de documentación ya existe en la base de datos
			SELECT COUNT(*) INTO v_DocumentacionExists FROM Persona WHERE Documentacion = p_Documentacion;
			IF v_DocumentacionExists > 0 THEN
				SET v_Message = 'El número de documentación ya está registrado.';
			ELSE
				-- Verificar si el número de teléfono ya existe en la base de datos
				SELECT COUNT(*) INTO v_TelefonoExists FROM Persona WHERE Telefono = p_Telefono;
				IF v_TelefonoExists > 0 THEN
					SET v_Message = 'El número de teléfono ya está registrado.';
				ELSE
					-- Obtener la provincia de la localidad
					SELECT IdProvincia INTO v_LocalidadProvincia FROM Localidad WHERE IdLocalidad = p_IdLocalidad;

					-- Verificar si la localidad pertenece a la provincia especificada
					IF NOT EXISTS (SELECT 1 FROM Provincia WHERE IdProvincia = p_IdProvincia AND IdProvincia = v_LocalidadProvincia) THEN
						SET v_Message = 'La localidad no pertenece a la provincia especificada.';
					ELSE
						-- Insertar datos en la tabla Domicilio
						INSERT INTO Domicilio (IdTipoDomicilio, Calle, Nro, Piso)
						VALUES (p_IdTipoDomicilio, p_Calle, p_Nro, p_Piso);

						-- Obtener el IdDomicilio insertado
						SET v_IdDomicilio = LAST_INSERT_ID();

						-- Insertar el nuevo cliente
						INSERT INTO Persona (IdTipoPersonaSistema, IdTipoPersona, IdDomicilio, IdLocalidad, IdTipoDocumentacion, Documentacion, Nombre, Apellido, Mail, FechaNacimiento, Telefono, FechaAlta,IdUsuarioCarga)
						VALUES (v_IdTipoPersonaSistema, p_IdTipoPersona, v_IdDomicilio, p_IdLocalidad, p_IdTipoDocumentacion, p_Documentacion, p_Nombre, p_Apellido, p_Mail, p_FechaNacimiento, p_Telefono, NOW(),v_IdUsuarioCarga);

						-- Verificar si se realizó la inserción correctamente
						IF ROW_COUNT() > 0 THEN
							SET v_Message = 'OK';
						ELSE
							SET v_Message = 'Hubo un error al dar de alta al cliente.';
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;

		SELECT v_Message;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_Producto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_Producto`(
    IN p_IdTipoMedida INT,
    IN p_IdTipoCategoria INT,
    IN p_IdTipoProducto INT,
    IN p_Codigo VARCHAR(255),
    IN p_Nombre VARCHAR(45),
    IN p_IdPersona INT(45),
    IN p_Marca VARCHAR(45),
    IN p_PrecioCosto DECIMAL(18,2),
    IN p_Tamano DECIMAL(18,2),
    IN p_CantMinima INT,
    IN p_CantMaxima INT,
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_Message VARCHAR(255);
    DECLARE v_IdUsuarioCarga INT;
	SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    -- Verificar si el usuario que carga existe
    IF NOT EXISTS (SELECT 1 FROM Usuario WHERE IdUsuario = v_IdUsuarioCarga) THEN
        SET v_Message = 'El ID de usuario que carga no existe en la base de datos.';
    ELSE
        -- Verificar si el producto ya existe con el mismo código
        IF EXISTS (SELECT 1 FROM Producto WHERE Codigo = p_Codigo) THEN
            SET v_Message = 'El producto ya existe con este código.';
        ELSE
            IF p_PrecioCosto < 0 or p_Tamano < 0 or p_CantMinima < 0 THEN 
                SET v_Message = 'No debe ingresar números negativos.';
            ELSEIF p_CantMinima > p_CantMaxima THEN 
                SET v_Message = 'La cantidad mínima no puede ser mayor a la máxima.';
            ELSEIF length(p_Codigo) < 8 THEN 
                SET v_Message = 'El código debe contener al menos 8 dígitos.';
			 -- Verificar si el ID de tipo de medida existe en la base de datos
            ELSEIF NOT EXISTS (SELECT 1 FROM TipoMedida WHERE IdTipoMedida = p_IdTipoMedida) THEN
                SET v_Message = 'El ID de tipo de medida no existe en la base de datos.';
                -- Verificar si el ID de tipo de categoría existe en la base de datos
			ELSEIF NOT EXISTS (SELECT 1 FROM TipoCategoria WHERE IdTipoCategoria = p_IdTipoCategoria) THEN
				SET v_Message = 'El ID de tipo de categoría no existe en la base de datos.';
                    -- Verificar si el ID de tipo de producto existe en la base de datos
			ELSEIF NOT EXISTS (SELECT 1 FROM TipoProducto WHERE IdTipoProducto = p_IdTipoProducto) THEN
					SET v_Message = 'El ID de tipo de producto no existe en la base de datos.';
            ELSE
                -- Insertar el nuevo producto
                INSERT INTO Producto (IdTipoMedida, IdTipoCategoria, IdTipoProducto, Codigo, Nombre, Marca, PrecioCosto, Tamano, CantMinima, CantMaxima, IdUsuarioCarga, FechaAlta,IdPersona)
                VALUES (p_IdTipoMedida, p_IdTipoCategoria, p_IdTipoProducto, p_Codigo, p_Nombre, p_Marca, p_PrecioCosto, p_Tamano, p_CantMinima, p_CantMaxima, v_IdUsuarioCarga, NOW(),p_IdPersona);
                SET v_Message = 'OK';
            END IF;
        END IF;
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_Proveedor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_Proveedor`(
    IN p_IdTipoPersona INT,
    IN p_IdTipoDomicilio INT,
    IN p_Calle VARCHAR(45),
    IN p_Nro VARCHAR(45),
    IN p_Piso VARCHAR(45),
    IN p_IdLocalidad INT,
    IN p_IdTipoDocumentacion INT,
    IN p_Documentacion VARCHAR(45),
    IN p_Mail VARCHAR(45),
    IN p_RazonSocial VARCHAR(45),
    IN p_Telefono VARCHAR(45),
    IN p_IdProvincia INT,
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_Message VARCHAR(255);
    DECLARE v_IdDomicilio INT;
    DECLARE v_DocumentacionExists INT;
    DECLARE v_TelefonoExists INT;
    DECLARE v_RazonSocialExists INT;
    DECLARE v_EmailExists INT;
    DECLARE v_DireccionExists INT;
    DECLARE v_LocalidadProvincia INT;
	DECLARE v_IdTipoPersonaSistema INT DEFAULT 2;
	DECLARE v_IdUsuarioCarga INT;
        
	SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);


    -- Verificar si el tipo de persona existe
    IF NOT EXISTS (SELECT 1 FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = v_IdTipoPersonaSistema) THEN
        SET v_Message = 'No existe el tipo persona sistema ingresado.';
    ELSEIF NOT EXISTS (SELECT 1 FROM TipoPersona WHERE idTipoPersona = p_IdTipoPersona) THEN
        SET v_Message = 'El tipo persona ingresado no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM TipoDomicilio WHERE IdTipoDomicilio = p_IdTipoDomicilio) THEN
        SET v_Message = 'El ID de tipo de domicilio no existe en la base de datos.';
    ELSEIF NOT EXISTS (SELECT 1 FROM TipoDocumentacion WHERE IdTipoDocumentacion = p_IdTipoDocumentacion) THEN
        SET v_Message = 'El ID de tipo de documentación no existe en la base de datos.';
    ELSEIF NOT EXISTS (SELECT 1 FROM Localidad WHERE IdLocalidad = p_IdLocalidad) THEN
        SET v_Message = 'No existe localidad ingresada en la base de datos.';
    ELSEIF NOT p_Telefono REGEXP '^[0-9]+$' THEN
        SET v_Message = 'Ingrese sin ningún tipo de signo su número de teléfono.';
    ELSEIF LENGTH(p_Telefono) < 10 THEN
        SET v_Message = 'El número de teléfono debe tener mínimo 10 dígitos.';
    ELSEIF NOT p_Nro REGEXP '^[0-9]+$' THEN
        SET v_Message = 'El número de domicilio debe contener solo dígitos positivos.';
    ELSEIF NOT p_Mail REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$' THEN
        SET v_Message = 'El correo electrónico no tiene un formato válido.';
    ELSEIF NOT p_RazonSocial REGEXP '^[a-zA-Z ]+$' THEN
        SET v_Message = 'La razón social no puede contener números ni caracteres especiales.';
    ELSE
        -- Verificar si el número de documentación ya existe en la base de datos
        SELECT COUNT(*) INTO v_DocumentacionExists FROM Persona WHERE Documentacion = p_Documentacion;
        IF v_DocumentacionExists > 0 THEN
            SET v_Message = 'El número de documentación ya está registrado.';
        ELSE
            -- Verificar si el número de teléfono ya existe en la base de datos
            SELECT COUNT(*) INTO v_TelefonoExists FROM Persona WHERE Telefono = p_Telefono;
            IF v_TelefonoExists > 0 THEN
                SET v_Message = 'El número de teléfono ya está registrado.';
            ELSE
                -- Verificar si la razón social ya existe en la base de datos
                SELECT COUNT(*) INTO v_RazonSocialExists FROM Persona WHERE RazonSocial = p_RazonSocial;
                IF v_RazonSocialExists > 0 THEN
                    SET v_Message = 'La razón social ya está registrada.';
                ELSE
                    -- Verificar si el email ya existe en la base de datos
                    SELECT COUNT(*) INTO v_EmailExists FROM Persona WHERE Mail = p_Mail;
                    IF v_EmailExists > 0 THEN
                        SET v_Message = 'El email ya está registrado.';
                    ELSE
                        -- Verificar si la dirección ya existe en la base de datos
                        SELECT COUNT(*) INTO v_DireccionExists FROM Domicilio WHERE Calle = p_Calle AND Nro = p_Nro;
                        IF v_DireccionExists > 0 THEN
                            SET v_Message = 'La dirección ya está registrada.';
                        ELSE
                            -- Obtener la provincia de la localidad
                            SELECT IdProvincia INTO v_LocalidadProvincia FROM Localidad WHERE IdLocalidad = p_IdLocalidad;

                            -- Verificar si la localidad pertenece a la provincia especificada
                            IF NOT EXISTS (SELECT 1 FROM Provincia WHERE IdProvincia = p_IdProvincia AND IdProvincia = v_LocalidadProvincia) THEN
                                SET v_Message = 'La localidad no pertenece a la provincia especificada.';
                            ELSE
                                -- Insertar datos en la tabla Domicilio
                                INSERT INTO Domicilio (IdTipoDomicilio, Calle, Nro, Piso)
                                VALUES (p_IdTipoDomicilio, p_Calle, p_Nro, p_Piso);

                                -- Obtener el IdDomicilio insertado
                                SET v_IdDomicilio = LAST_INSERT_ID();

                                -- Insertar el nuevo proveedor
                                INSERT INTO Persona (IdTipoPersonaSistema, IdTipoPersona, IdDomicilio, IdLocalidad, IdTipoDocumentacion, Documentacion, Mail, RazonSocial, Telefono, FechaAlta,IdUsuarioCarga)
                                VALUES (v_IdTipoPersonaSistema, p_IdTipoPersona, v_IdDomicilio, p_IdLocalidad, p_IdTipoDocumentacion, p_Documentacion, p_Mail, p_RazonSocial, p_Telefono, NOW(),v_IdUsuarioCarga);

                                -- Verificar si se realizó la inserción correctamente
                                IF ROW_COUNT() > 0 THEN
                                    SET v_Message = 'OK';
                                ELSE
                                    SET v_Message = 'Hubo un error al dar de alta al proveedor.';
                                END IF;
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_RolModulo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_RolModulo`(
    IN v_IdTipoRol INT,
    IN v_IdTipoModulo INT,
    IN v_IdTipoPermiso INT,
    IN UsuarioBearer VARCHAR(500)
)
BEGIN
    DECLARE IdUsuarioCarga INT;
    DECLARE Message VARCHAR(50);
    SET IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(UsuarioBearer);

    IF IdUsuarioCarga IS NOT NULL THEN
        -- Verificar si el tipo de rol proporcionado existe en la tabla TipoRol
        IF EXISTS (SELECT 1 FROM TipoRol WHERE IdTipoRol = v_IdTipoRol) THEN
            -- Verificar si el tipo de módulo proporcionado existe en la tabla TipoModulo
            IF EXISTS (SELECT 1 FROM TipoModulo WHERE IdTipoModulo = v_IdTipoModulo) THEN
                -- Verificar si el tipo de permiso proporcionado existe en la tabla TipoPermiso
                IF EXISTS (SELECT 1 FROM TipoPermiso WHERE IdTipoPermiso = v_IdTipoPermiso) THEN
                    -- Verificar si el registro ya existe
                    IF EXISTS (SELECT 1 FROM RolModulo WHERE IdTipoRol = v_IdTipoRol AND IdTipoModulo = v_IdTipoModulo AND IdTipoPermiso = v_IdTipoPermiso) THEN
                        SET Message = 'El rolModulo ya existe.';
                    ELSE
                        -- Insertar el nuevo registro
                        INSERT INTO RolModulo (IdTipoRol, IdTipoModulo, IdTipoPermiso) 
                        VALUES (v_IdTipoRol, v_IdTipoModulo, v_IdTipoPermiso);
                        SET Message = 'OK';
                    END IF;
                ELSE
                    SET Message = 'El nivel de permiso proporcionado no existe.';
                END IF;
            ELSE
                SET Message = 'El tipo de módulo proporcionado no existe.';
            END IF;
        ELSE
            SET Message = 'El tipo de rol proporcionado no existe.';
        END IF;
    ELSE
        SET Message = 'Token Inválido.';
    END IF;
    
    SELECT Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_Sucursal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_Sucursal`(
    IN p_IdTipoDomicilio INT, 
    IN p_Descripcion VARCHAR(50), 
    IN p_Calle VARCHAR(50), 
    IN p_Nro VARCHAR(50), 
    IN p_Piso VARCHAR(50), 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(100);
    DECLARE v_DomicilioExiste INT;
    DECLARE v_TipoDomicilioExiste INT;
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    
    SELECT COUNT(*) INTO v_TipoDomicilioExiste FROM TipoDomicilio WHERE IdTipoDomicilio = p_IdTipoDomicilio;

    IF v_IdUsuarioCarga IS NOT NULL THEN
		IF v_TipoDomicilioExiste = 1 THEN
			IF (SELECT COUNT(*) FROM Sucursal WHERE Descripcion = p_Descripcion) = 0 THEN
				SELECT COUNT(*) INTO v_DomicilioExiste FROM Domicilio WHERE Calle = p_Calle AND Nro = p_Nro AND Piso = p_Piso;
				IF v_DomicilioExiste = 0 THEN
					INSERT INTO Domicilio (IdTipoDomicilio, Calle, Nro, Piso)
					VALUES (p_IdTipoDomicilio, p_Calle, p_Nro, p_Piso);
					SET @last_id = LAST_INSERT_ID();
					INSERT INTO Sucursal (IdDomicilio, Descripcion, IdUsuarioCarga, FechaAlta, FechaBaja)
					VALUES (@last_id, p_Descripcion, v_IdUsuarioCarga, NOW(), NULL);

					SET v_Message = 'OK';
				ELSE
					SET v_Message = 'Ya existe un registro en Domicilio con los mismos datos.';
				END IF;
			ELSE 
				SET v_Message = 'El valor ingresado ya existe en Sucursal';
			END IF;
		ELSE 
			SET v_Message = 'El valor ingresado no corresponde a ningún tipo de domicilio.';
		END IF;
    ELSE
        SET v_Message = 'Token Inválido';
    END IF;

    -- Devolver el mensaje
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_TipoCategoria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_TipoCategoria`(
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoCategoria WHERE Descripcion = p_Descripcion) = 0 THEN
			INSERT INTO TipoCategoria (Descripcion, FechaBaja)
			VALUES (p_Descripcion, NULL);
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El valor ingresado ya existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
	-- Devolver el mensaje
	SELECT v_Message;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_TipoFormaDePago` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_TipoFormaDePago`(
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoFormaDePago WHERE Descripcion = p_Descripcion) = 0 THEN
			INSERT INTO TipoFormaDePago (Descripcion, FechaBaja)
			VALUES (p_Descripcion, NULL);
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El valor ingresado ya existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
	-- Devolver el mensaje
	SELECT v_Message;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_TipoImpuesto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_TipoImpuesto`(
    IN p_Descripcion VARCHAR(50), 
    IN p_Porcentaje DECIMAL(18,2), 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoAumento WHERE Detalle = p_Descripcion AND Porcentaje = p_Porcentaje) = 0 THEN
			INSERT INTO TipoAumento (Detalle, Porcentaje, FechaBaja)
			VALUES (p_Descripcion, p_Porcentaje, NULL);
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El valor ingresado ya existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
	-- Devolver el mensaje
	SELECT v_Message;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_TipoPersonaSistema` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_TipoPersonaSistema`(
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoPersonaSistema WHERE Descripcion = p_Descripcion) = 0 THEN
			INSERT INTO TipoPersonaSistema (Descripcion, FechaBaja)
			VALUES (p_Descripcion, NULL);
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El valor ingresado ya existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
	-- Devolver el mensaje
	SELECT v_Message;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_TipoProducto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_TipoProducto`(
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoProducto WHERE Detalle = p_Descripcion) = 0 THEN
			INSERT INTO TipoProducto (Detalle, FechaBaja)
			VALUES (p_Descripcion, NULL);
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El valor ingresado ya existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
	-- Devolver el mensaje
	SELECT v_Message;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_TipoRol` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_TipoRol`(
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoRol WHERE Descripcion = p_Descripcion) = 0 THEN
			INSERT INTO TipoRol (Descripcion, FechaBaja)
			VALUES (p_Descripcion, NULL);
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El valor ingresado ya existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
	-- Devolver el mensaje
	SELECT v_Message;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_Usuarios` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_Usuarios`(
    IN id_persona INT, -- ID de la persona asociada al usuario
    IN nombreUsuario VARCHAR(255),
    IN clave VARCHAR(255),
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE usuario_count INT;
    DECLARE persona_count INT;
    DECLARE hashed_usuario VARCHAR(64);
    DECLARE v_Message VARCHAR(255);
    DECLARE v_IdUsuarioCarga INT;
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    
    -- Verifico que el usuario tenga al menos 8 caracteres
	IF NOT (nombreUsuario REGEXP '[[:digit:]]') THEN
        SET v_Message = 'El usuario debe contener al menos un numero.';
	END IF;
    -- Verifico que la contraseña tenga al menos 8 caracteres
    IF LENGTH(clave) < 8 THEN
        SET v_Message = 'La contraseña debe tener al menos 8 caracteres.';
    END IF;

    -- Verifico que la contraseña contenga al menos una letra mayúscula y al menos un número
    IF NOT (clave REGEXP '[[:upper:]]') THEN
        SET v_Message = 'La contraseña debe contener al menos una letra mayúscula.';
    ELSEIF NOT (clave REGEXP '[[:digit:]]') THEN
        SET v_Message = 'La contraseña debe contener al menos un número.';
    END IF;

    -- Verifico existencia de usuario y persona
    SELECT COUNT(*) INTO usuario_count FROM Usuario WHERE Usuario = nombreUsuario AND FechaBaja IS NULL;
    SELECT COUNT(*) INTO persona_count FROM Usuario WHERE IdPersona = id_persona AND FechaBaja IS NULL;
    
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF usuario_count > 0 OR persona_count > 0 THEN
				SET v_Message = 'El nombre de usuario ya está en uso o la persona ya tiene un usuario habilitado.';
		ELSE
			-- Creo el usuario
			INSERT INTO Usuario (IdPersona, Usuario, Clave, IdUsuarioCarga, FechaAlta)
			VALUES (id_persona, nombreUsuario, SHA2(clave,256), v_IdUsuarioCarga, NOW());
			SET v_Message = 'OK';
		END IF;
	ELSE
		SET v_Message = 'Token invalido.';
	END IF;

    
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPA_UsuarioToken` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPA_UsuarioToken`(
    IN IdPersonalIN INT,
    IN Token TEXT
)
BEGIN
    DECLARE Message VARCHAR(50);
    DECLARE NombrePersonal VARCHAR(100);
    DECLARE DocumentacionPersonal VARCHAR(100);
    DECLARE SucursalPersonal VARCHAR(100);
    DECLARE UsuarioId INT;
    DECLARE TiempoToken INT;
    DECLARE UsuarioPersonal VARCHAR(100);
    DECLARE SucursalId INT;

    SELECT IdUsuario, Usuario INTO UsuarioId, UsuarioPersonal
	FROM Usuario
	WHERE IdPersona = IdPersonalIN AND FechaBaja IS NULL AND IdPersona IS NOT NULL;

    IF UsuarioId IS NOT NULL THEN
		SET TiempoToken = 60;
        SET Message = 'Ok';
        UPDATE UsuarioToken
		SET Activo = 0
		WHERE IdPersona = IdPersonalIN;
		
		INSERT INTO UsuarioToken(IdPersona, IdUsuario, Token, FechaAlta, FechaCaducidad, Activo)
		VALUES(IdPersonalIN, UsuarioId, Token, NOW(), DATE_ADD(NOW(), INTERVAL TiempoToken MINUTE), 1);
		
		SELECT Nombre, Documentacion INTO NombrePersonal, DocumentacionPersonal
		FROM Persona
		WHERE IdPersona = IdPersonalIN;
                
        SELECT s.IdSucursal, s.Descripcion INTO SucursalId, SucursalPersonal
		FROM Sucursal s
		JOIN (
			SELECT IdSucursal
			FROM UsuarioPorSucursal
			WHERE IdUsuario = IdPersonalIN
		) AS ups ON s.IdSucursal = ups.IdSucursal;

    ELSE
        SET Message = 'Personal Inexistente';
    END IF;
    
    SELECT Message AS Mensaje,
           TiempoToken AS TiempoCaduca,
           NombrePersonal AS NombrePersonal,
           UsuarioPersonal AS UsuarioPersonal,
           DocumentacionPersonal AS DocumentacionPersonal,
           SucursalId AS SucursalId,
           SucursalPersonal AS SucursalPersonal,
           UsuarioId AS UsuarioId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPB_Cliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPB_Cliente`(
    IN p_IdCliente INT,
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_Message VARCHAR(255);
    DECLARE v_FechaBaja DATE;
    DECLARE v_IdTipoPersonaSistema INT;
    DECLARE v_IdUsuarioCarga INT;

    -- Obtener el ID del usuario desde el token Bearer
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Validar que el IdCliente exista
        IF NOT EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdCliente) THEN
            SET v_Message = 'El IdCliente ingresado no existe.';
        ELSE
            -- Obtener IdTipoPersonaSistema y FechaBaja del cliente
            SELECT IdTipoPersonaSistema, FechaBaja INTO v_IdTipoPersonaSistema, v_FechaBaja 
            FROM Persona 
            WHERE IdPersona = p_IdCliente;

            -- Verificar si el tipo de persona sistema es igual a 3
            IF v_IdTipoPersonaSistema <> 3 THEN
                SET v_Message = 'Solo se puede dar de baja a clientes';
            -- Verificar si el cliente ya está dado de baja
            ELSEIF v_FechaBaja IS NOT NULL THEN
                SET v_Message = 'El cliente ya está dado de baja.';
            ELSE
                -- Verificar si se realizó la actualización correctamente
                IF ROW_COUNT() > 0 THEN
					-- Dar de baja lógica en la tabla Persona
                    UPDATE Persona
                    SET FechaBaja = CURDATE(),IdUsuarioCarga= v_IdUsuarioCarga
                    WHERE IdPersona = p_IdCliente AND FechaBaja IS NULL;
                    SET v_Message = 'OK';
                ELSE
                    SET v_Message = 'Hubo un error al dar de baja al proveedor.';
                END IF;
            END IF;
        END IF;
    ELSE
        SET v_Message = 'Token Inválido';
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPB_Personal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPB_Personal`(
    IN p_IdPersona INT,
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(255);
    DECLARE v_IdTipoPersonaSistema INT DEFAULT 1;

    -- Obtener el ID del usuario desde el token Bearer
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Verificar si la persona ya está dada de baja
        IF EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdPersona AND FechaBaja IS NOT NULL) THEN
            SET v_Message = 'El personal ya está dado de baja.';
        -- Verificar si el ID de la persona existe en la base de datos
        ELSEIF NOT EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdPersona) THEN
            SET v_Message = 'El ID del personal ingresado no existe.';
        ELSE
            -- Dar de baja lógica a la persona
            UPDATE Persona
            SET FechaBaja = NOW(),IdUsuarioCarga= v_IdUsuarioCarga
            WHERE IdPersona = p_IdPersona;

            -- Verificar si se realizó la actualización correctamente
            IF ROW_COUNT() > 0 THEN
                SET v_Message = 'OK';
            ELSE
                SET v_Message = 'Hubo un error al dar de baja al personal.';
            END IF;
        END IF;
    ELSE
        SET v_Message = 'Token Inválido';
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPB_Producto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPB_Producto`(
    IN id_producto INT,
    IN p_UsuarioBearer TEXT(500)  -- Parámetro para recibir el token Bearer
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(255);

    -- Obtener el ID de usuario válido desde el token Bearer
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Validar si el token Bearer es válido
    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Verificar si el producto con el ID especificado existe y no está dado de baja
        IF NOT EXISTS (SELECT 1 FROM Producto WHERE IdProducto = id_producto) THEN
            SET v_Message = 'El producto ingresado no existe en la base de datos.';
        ELSEIF EXISTS (SELECT 1 FROM Producto WHERE IdProducto = id_producto AND FechaBaja IS NOT NULL) THEN
            SET v_Message = 'El producto ya se encontraba dado de baja.';
        ELSE
            -- Dar de baja lógica al producto
            UPDATE Producto
            SET FechaBaja = NOW()
            WHERE IdProducto = id_producto;

            -- Verificar si se realizó la actualización correctamente
            IF ROW_COUNT() > 0 THEN
                SET v_Message = 'OK';
            ELSE
                SET v_Message = 'Hubo un error al dar de baja el producto.';
            END IF;
        END IF;
    ELSE
        SET v_Message = 'Token Inválido';
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPB_Proveedor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPB_Proveedor`(
    IN p_IdPersona INT,
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(255);
    DECLARE v_IdTipoPersonaSistema INT DEFAULT 2;

    -- Obtener el ID del usuario desde el token Bearer
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Verificar si el proveedor ya está dado de baja
        IF EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdPersona AND FechaBaja IS NOT NULL) THEN
            SET v_Message = 'El proveedor ya está dado de baja.';
        -- Verificar si el ID del proveedor existe en la base de datos
        ELSEIF NOT EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdPersona) THEN
            SET v_Message = 'El ID del proveedor ingresado no existe.';
        ELSE
            -- Obtener el IdTipoPersonaSistema del proveedor
            SELECT IdTipoPersonaSistema INTO v_IdTipoPersonaSistema FROM Persona WHERE IdPersona = p_IdPersona;

            -- Verificar si el IdTipoPersonaSistema es distinto de 2
            IF v_IdTipoPersonaSistema <> 2 THEN
                SET v_Message = 'se puede dar de baja solo a proveedores.';
            ELSE
				UPDATE Persona
				SET FechaBaja = NOW(),IdUsuarioCarga= v_IdUsuarioCarga
				WHERE IdPersona = p_IdPersona;

                -- Verificar si se realizó la actualización correctamente
				IF ROW_COUNT() > 0 THEN
					SET v_Message = 'OK';
				ELSE
					SET v_Message = 'Hubo un error al dar de baja al personal.';
				END IF;
					
                END IF;
            END IF;
    ELSE
        SET v_Message = 'Token Inválido';
    END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPB_RolModulo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPB_RolModulo`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM RolModulo WHERE IdRolModulo = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE RolModulo 
			SET FechaBaja = NOW() 
			WHERE IdRolModulo = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está deshabilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPB_Sucursal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPB_Sucursal`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_IdDomicilio INT;
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
	SELECT IdDomicilio INTO v_IdDomicilio FROM Sucursal WHERE IdSucursal = p_Id AND FechaBaja IS NULL;
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM Sucursal WHERE IdSucursal = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE Sucursal 
			SET FechaBaja = NOW() 
			WHERE IdSucursal = p_Id;
            
			UPDATE Domicilio 
			SET FechaBaja = NOW() 
			WHERE IdDomicilio = v_IdDomicilio;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está deshabilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPB_TipoCategoria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPB_TipoCategoria`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoCategoria WHERE IdTipoCategoria = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE TipoCategoria 
			SET FechaBaja = NOW() 
			WHERE IdTipoCategoria = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está deshabilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPB_TipoFormaDePago` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPB_TipoFormaDePago`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoFormaDePago WHERE IdTipoFormaDePago = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE TipoFormaDePago 
			SET FechaBaja = NOW() 
			WHERE IdTipoFormaDePago = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está deshabilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPB_TipoImpuesto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPB_TipoImpuesto`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoAumento WHERE IdTipoAumento = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE TipoAumento 
			SET FechaBaja = NOW() 
			WHERE IdTipoAumento = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está deshabilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPB_TipoPersonaSistema` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPB_TipoPersonaSistema`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE TipoPersonaSistema 
			SET FechaBaja = NOW() 
			WHERE IdTipoPersonaSistema = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está deshabilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPB_TipoProducto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPB_TipoProducto`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoProducto WHERE IdTipoProducto = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE TipoProducto 
			SET FechaBaja = NOW() 
			WHERE IdTipoProducto = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está deshabilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPB_TipoRol` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPB_TipoRol`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoRol WHERE IdTipoRol = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE TipoRol 
			SET FechaBaja = NOW() 
			WHERE IdTipoRol = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está deshabilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPB_UsuarioRol` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPB_UsuarioRol`(
    IN p_IdUsuarioRol INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM UsuarioRol WHERE IdUsuarioRol = p_IdUsuarioRol AND FechaBaja IS NULL) > 0 THEN
			UPDATE UsuarioRol 
			SET FechaBaja = NOW() 
			WHERE IdUsuarioRol = p_IdUsuarioRol;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está deshabilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPB_Usuarios` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPB_Usuarios`(
    IN id_usuario INT,
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(150);
    DECLARE user_exists INT;

    -- Obtener el ID del usuario desde el token Bearer
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Verificar si el usuario con el ID ingresado existe
        SELECT COUNT(*) INTO user_exists FROM Usuario WHERE IdUsuario = id_usuario;

        IF user_exists = 0 THEN
            SET v_Message = 'No existe ningún usuario con el ID especificado.';
        ELSE
            -- Verificar si el usuario ya está dado de baja
            SELECT IFNULL(FechaBaja, 'No') INTO v_Message FROM Usuario WHERE IdUsuario = id_usuario;

            -- Si el usuario ya está dado de baja
            IF v_Message != 'No' THEN
                SET v_Message = 'El usuario ya está dado de baja.';
            ELSE
                -- Dar de baja lógica al usuario
                UPDATE Usuario
                SET FechaBaja = NOW()
                WHERE IdUsuario = id_usuario;

                -- Dar de baja lógica en las tablas asociadas
                UPDATE UsuarioRol
                SET FechaBaja = NOW()
                WHERE IdUsuario = id_usuario AND FechaBaja IS NULL;
                
                UPDATE UsuarioToken
				SET FechaBaja = NOW()
				WHERE IdUsuario = id_usuario AND FechaBaja IS NULL;

                -- Verificar si se realizó la actualización correctamente
                IF ROW_COUNT() > 0 THEN
                    SET v_Message = 'OK';
                ELSE
                    SET v_Message = 'Error al dar de baja al usuario en las tablas asociadas.';
                END IF;
            END IF;
        END IF;
    ELSE
        SET v_Message = 'Token Inválido';
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPC_RegistrarAuditoria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPC_RegistrarAuditoria`(
    IN p_IdUsuario INT,
    IN p_Tabla VARCHAR(45),
    IN p_Campo VARCHAR(45),
    IN p_Identificador INT,
    IN p_ValorAnterior VARCHAR(45),
    IN p_ValorActual VARCHAR(45),
    IN p_Tipo VARCHAR(45)
)
BEGIN
    INSERT INTO Auditoria (
        IdUsuario, Fecha, Tabla, Campo, Identificador, ValorAnterior, ValorActual, Tipo, Pendiente
    ) VALUES (
        p_IdUsuario, NOW(), p_Tabla, p_Campo, p_Identificador, p_ValorAnterior, p_ValorActual, p_Tipo, 1
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPG_ObtenerCantClientes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPG_ObtenerCantClientes`(
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CantClientes INT;

    -- Obtener el ID del usuario desde el token
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Validar si el usuario es válido
    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Contar la cantidad de clientes activos
        SELECT COUNT(*) INTO v_CantClientes
        FROM Persona
        WHERE FechaBaja IS NULL
        AND IdTipoPersonaSistema = 3;

        -- Devolver el resultado
        SELECT v_CantClientes AS CantClientes;
    ELSE
        -- Token Inválido
        SET v_Message = 'Token Inválido';
        SELECT v_Message AS Message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPG_ObtenerCantPersonalPorSucursal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPG_ObtenerCantPersonalPorSucursal`(
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);

    -- Obtener el ID del usuario desde el token
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Validar si el usuario es válido y el token no es nulo
    IF v_IdUsuarioCarga IS NOT NULL AND p_UsuarioBearer IS NOT NULL THEN
        -- Crear una tabla temporal para almacenar los resultados
        CREATE TEMPORARY TABLE IF NOT EXISTS temp_results (
            Sucursal VARCHAR(100),
            cantPersonal INT
        );

        -- Seleccionar la cantidad total de personal por sucursal que son empleados, excluyendo sucursales y personal dados de baja
        INSERT INTO temp_results (Sucursal, cantPersonal)
        SELECT 
            s.Descripcion AS Sucursal, 
            COUNT(p.IdPersona) AS cantPersonal
        FROM 
            Persona p
        JOIN 
            Sucursal s ON p.IdDomicilio = s.IdDomicilio
        JOIN
            Domicilio d ON p.IdDomicilio = d.IdDomicilio
        WHERE 
            p.FechaBaja IS NULL
            AND s.FechaBaja IS NULL
            AND d.FechaBaja IS NULL
            AND p.IdTipoPersonaSistema = 1 -- Solo empleados
        GROUP BY 
            s.Descripcion;

        -- Devolver el resultado ordenado por la cantidad de personal de mayor a menor
		SELECT 
			s.IdSucursal,
			temp_results.*
		FROM 
			temp_results
		JOIN 
			Sucursal s ON temp_results.Sucursal = s.Descripcion
		ORDER BY 
			s.IdSucursal;

        -- Eliminar la tabla temporal
        DROP TEMPORARY TABLE IF EXISTS temp_results;
    ELSE
        -- Token o usuario inválido
        SET v_Message = 'Token o usuario inválido';
        SELECT v_Message AS Message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPG_ObtenerCantPersonalTotal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPG_ObtenerCantPersonalTotal`(
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CantPersonalTotal INT;

    -- Obtener el ID del usuario desde el token
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Validar si el usuario es válido
    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Contar la cantidad total de personal que son empleados (IdTipoPersonaSistema = 1) y que no están dados de baja
        SELECT COUNT(*) INTO v_CantPersonalTotal
        FROM Persona
        WHERE IdTipoPersonaSistema = 1 AND FechaBaja IS NULL;

        -- Devolver la cantidad total de personal
        SELECT v_CantPersonalTotal AS PersonalTotal;
    ELSE
        -- Token Inválido
        SET v_Message = 'Token Inválido';
        SELECT v_Message AS Message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPG_ObtenerCantProductos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPG_ObtenerCantProductos`(
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CantidadProductos INT;

    -- Obtener el ID del usuario desde el token
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Validar si el usuario es válido
    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Contar la cantidad total de productos que no están dados de baja
        SELECT COUNT(*) INTO v_CantidadProductos
        FROM Producto
        WHERE FechaBaja IS NULL;

        -- Devolver la cantidad total de productos
        SELECT v_CantidadProductos AS CantProductos;
    ELSE
        -- Token Inválido
        SET v_Message = 'Token Inválido';
        SELECT v_Message AS Message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPG_ObtenerCantProductosPorSucursal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPG_ObtenerCantProductosPorSucursal`(
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);

    -- Obtener el ID del usuario desde el token
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Validar si el usuario es válido y el token no es nulo
    IF v_IdUsuarioCarga IS NOT NULL AND p_UsuarioBearer IS NOT NULL THEN
        -- Crear una tabla temporal para almacenar los resultados
        CREATE TEMPORARY TABLE IF NOT EXISTS temp_results (
            IdSucursal INT,
            Sucursal VARCHAR(100),
            CantidadProductos INT
        );

        -- Seleccionar la cantidad total de productos por sucursal, excluyendo sucursales y productos dados de baja
        INSERT INTO temp_results (IdSucursal, Sucursal, CantidadProductos)
        SELECT 
            s.IdSucursal,
            s.Descripcion AS Sucursal, 
            COUNT(st.IdProducto) AS CantidadProductos
        FROM 
            Sucursal s
        LEFT JOIN 
            StockSucursal st ON s.IdSucursal = st.IdSucursal
        JOIN 
            Producto p ON st.IdProducto = p.IdProducto
        WHERE 
            s.FechaBaja IS NULL
            AND st.FechaBaja IS NULL
            AND p.FechaBaja IS NULL
        GROUP BY 
            s.IdSucursal, s.Descripcion;

        -- Devolver el resultado ordenado por el IdSucursal
        SELECT * FROM temp_results
        ORDER BY IdSucursal;

        -- Eliminar la tabla temporal
        DROP TEMPORARY TABLE IF EXISTS temp_results;
    ELSE
        -- Token o usuario inválido
        SET v_Message = 'Token o usuario inválido';
        SELECT v_Message AS Message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPG_ObtenerCantProveedores` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPG_ObtenerCantProveedores`(
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CantProveedores INT;

    -- Obtener el ID del usuario desde el token
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Validar si el usuario es válido
    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Contar la cantidad de proveedores (IdTipoPersonaSistema = 2) que no estén dados de baja
        SELECT COUNT(*) INTO v_CantProveedores
        FROM Persona
        WHERE IdTipoPersonaSistema = 2
        AND FechaBaja IS NULL;

        -- Devolver la cantidad de proveedores
        SELECT v_CantProveedores AS CantProveedores;
    ELSE
        -- Token Inválido
        SET v_Message = 'Token Inválido';
        SELECT v_Message AS Message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPG_ObtenerStockSucursal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPG_ObtenerStockSucursal`(
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);

    -- Obtener el ID del usuario desde el token
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Validar si el usuario es válido
    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Seleccionar la suma total de cantidades por sucursal, excluyendo productos y sucursales dados de baja
        SELECT 
            s.IdSucursal,
            s.Descripcion AS Sucursal,
            COALESCE(SUM(st.Cantidad), 0) AS TotalProductos
        FROM 
            Sucursal s
        LEFT JOIN 
            StockSucursal st ON s.IdSucursal = st.IdSucursal AND st.FechaBaja IS NULL
        LEFT JOIN 
            Producto p ON st.IdProducto = p.IdProducto AND p.FechaBaja IS NULL
        WHERE 
            s.FechaBaja IS NULL
        GROUP BY 
            s.IdSucursal, s.Descripcion
        HAVING 
            TotalProductos > 0; 
    ELSE
        -- Token Inválido
        SET v_Message = 'Token Inválido';
        SELECT v_Message AS Message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPG_ObtenerStockSucursalPorCategoria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPG_ObtenerStockSucursalPorCategoria`(
    IN p_IdCategoria INT,
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CategoriaExiste INT; 
    DECLARE v_CategoriaDadaDeBaja INT;
    DECLARE v_SucursalNombre VARCHAR(100); 
    DECLARE v_TotalCantidad DECIMAL(10,2); 
    DECLARE v_IdSucursal INT; -- Agrega esta línea para declarar v_IdSucursal
    DECLARE done INT DEFAULT FALSE; 

	-- Crear el cursor
	DECLARE cur CURSOR FOR 
		SELECT s.IdSucursal, s.Descripcion AS Sucursal, COALESCE(SUM(st.Cantidad), 0) AS CantidadProductos
		FROM Sucursal s
		LEFT JOIN StockSucursal st ON s.IdSucursal = st.IdSucursal
		JOIN Producto p ON st.IdProducto = p.IdProducto
		WHERE p.IdTipoCategoria = p_IdCategoria
		AND p.FechaBaja IS NULL
		AND st.FechaBaja IS NULL
		AND s.FechaBaja IS NULL
		GROUP BY s.IdSucursal, s.Descripcion;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Obtener el ID del usuario desde el token
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Validar si el usuario es válido
    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Verificar si la categoría existe y no está dada de baja
        SELECT COUNT(*), COALESCE(SUM(CASE WHEN FechaBaja IS NOT NULL THEN 1 ELSE 0 END), 0) INTO v_CategoriaExiste, v_CategoriaDadaDeBaja 
        FROM TipoCategoria 
        WHERE IdTipoCategoria = p_IdCategoria;

        -- Si la categoría existe y no está dada de baja
        IF v_CategoriaExiste > 0 THEN
            IF v_CategoriaDadaDeBaja = 0 THEN
                -- Obtener el nombre de la categoría
                SELECT Descripcion INTO v_SucursalNombre FROM TipoCategoria WHERE IdTipoCategoria = p_IdCategoria;

				-- Crear una tabla temporal para almacenar los resultados
				CREATE TEMPORARY TABLE IF NOT EXISTS temp_results (
					IdSucursal INT, -- Agrega esta línea para incluir la columna IdSucursal
					Sucursal VARCHAR(100),
					CantidadProductos DECIMAL(10,2)
				);

			-- Abrir el cursor y almacenar los resultados en la tabla temporal
			OPEN cur;
			read_loop: LOOP
				FETCH cur INTO v_IdSucursal, v_SucursalNombre, v_TotalCantidad; 
				IF done THEN
					LEAVE read_loop;
				END IF;
				INSERT INTO temp_results (IdSucursal, Sucursal, CantidadProductos) VALUES (v_IdSucursal, v_SucursalNombre, v_TotalCantidad);
			END LOOP;
			CLOSE cur;

                -- Devolver el resultado
                SELECT * FROM temp_results;
                DROP TEMPORARY TABLE IF EXISTS temp_results;
            ELSE
                -- Si la categoría está dada de baja, devolver mensaje de error
                SET v_Message = 'La categoría está dada de baja.';
                SELECT v_Message AS Message;
            END IF;
        ELSE
            -- Si la categoría no existe, devolver mensaje de error
            SET v_Message = 'El Id de la categoría no existe.';
            SELECT v_Message AS Message;
        END IF;
    ELSE
        -- Token Inválido
        SET v_Message = 'Token Inválido';
        SELECT v_Message AS Message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPH_Cliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPH_Cliente`(
    IN p_IdCliente INT,
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_Message VARCHAR(255);
    DECLARE v_FechaBaja DATE;
    DECLARE v_IdTipoPersonaSistema INT;
    DECLARE v_IdUsuarioCarga INT;
	SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    -- Verificar si el IdCliente existe
    IF NOT EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdCliente) THEN
        SET v_Message = 'No existe el IdCliente ingresado';
    ELSE
        -- Obtener IdTipoPersonaSistema y FechaBaja del cliente
        SELECT IdTipoPersonaSistema, FechaBaja INTO v_IdTipoPersonaSistema, v_FechaBaja 
        FROM Persona 
        WHERE IdPersona = p_IdCliente;

        -- Verificar si el tipo de persona sistema es igual a 3
        IF v_IdTipoPersonaSistema <> 3 THEN
            SET v_Message = 'Solo se puede habilitar a clientes';
        -- Verificar si el cliente ya está habilitado
        ELSEIF v_FechaBaja IS NULL THEN
            SET v_Message = 'El cliente ya se encuentra habilitado.';
        ELSE
            -- Habilitar el cliente
            UPDATE Persona
            SET FechaBaja = NULL,IdUsuarioCarga= v_IdUsuarioCarga
            WHERE IdPersona = p_IdCliente;

            -- Verificar si se realizó la actualización correctamente
            IF ROW_COUNT() > 0 THEN
                SET v_Message = 'OK';
            ELSE
                SET v_Message = 'Hubo un error al habilitar al cliente.';
            END IF;
        END IF;
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPH_Personal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPH_Personal`(
    IN p_IdPersona INT,
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_Message VARCHAR(255);
    DECLARE v_IdUsuarioCarga INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Verificar si el cliente existe y está dado de baja
    IF NOT EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdPersona) THEN
        SET v_Message = 'El personal no existe en la base de datos.';
    ELSEIF EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdPersona AND FechaBaja IS NULL) THEN
        SET v_Message = 'El personal ya se encuentra habilitado.';
    ELSE
        -- Habilitar nuevamente al cliente
        UPDATE Persona
        SET FechaBaja = NULL, IdUsuarioCarga= v_IdUsuarioCarga
        WHERE IdPersona = p_IdPersona;

        -- Verificar si se realizó la actualización correctamente
        IF ROW_COUNT() > 0 THEN
            SET v_Message = 'OK';
        ELSE
            SET v_Message = 'Hubo un error al habilitar nuevamente al cliente.';
        END IF;
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPH_Producto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPH_Producto`(
    IN id_producto INT,
    IN p_UsuarioBearer TEXT(500)  -- Parámetro para recibir el token Bearer
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(255);

    -- Obtener el ID de usuario válido desde el token Bearer
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Validar si el token Bearer es válido
    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Verificar si el producto con el ID especificado existe
        IF NOT EXISTS (SELECT 1 FROM Producto WHERE IdProducto = id_producto) THEN
            SET v_Message = 'El producto ingresado no existe en la base de datos.';
        ELSEIF EXISTS (SELECT 1 FROM Producto WHERE IdProducto = id_producto AND FechaBaja IS NULL) THEN
            SET v_Message = 'El producto ya se encuentra habilitado.';
        ELSE
            -- Habilitar el producto
            UPDATE Producto
            SET FechaBaja = NULL
            WHERE IdProducto = id_producto;

            -- Verificar si se realizó la actualización correctamente
            IF ROW_COUNT() > 0 THEN
                SET v_Message = 'OK';
            ELSE
                SET v_Message = 'Hubo un error al habilitar el producto.';
            END IF;
        END IF;
    ELSE
        SET v_Message = 'Token Inválido';
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPH_Proveedor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPH_Proveedor`(
    IN p_IdPersona INT,
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_Message VARCHAR(255);
    DECLARE v_IdTipoPersonaSistema INT DEFAULT 2;
	DECLARE v_IdUsuarioCarga INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Verificar si el proveedor ya está habilitado
    IF NOT EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdPersona) THEN
        SET v_Message = 'El proveedor no existe en la base de datos.';
    ELSEIF EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdPersona AND FechaBaja IS NULL) THEN
        SET v_Message = 'El proveedor ya se encuentra habilitado.';
    ELSE
        -- Obtener el IdTipoPersonaSistema del proveedor
        SELECT IdTipoPersonaSistema INTO v_IdTipoPersonaSistema FROM Persona WHERE IdPersona = p_IdPersona;

        -- Verificar si el IdTipoPersonaSistema es distinto de 2
        IF v_IdTipoPersonaSistema <> 2 THEN
            SET v_Message = 'Solo se puede habilitar proveedores.';
        ELSE
            -- Habilitar nuevamente al proveedor
            UPDATE Persona
            SET FechaBaja = NULL, IdUsuarioCarga= v_IdUsuarioCarga
            WHERE IdPersona = p_IdPersona;

            -- Verificar si se realizó la actualización correctamente
            IF ROW_COUNT() > 0 THEN
                SET v_Message = 'OK';
            ELSE
                SET v_Message = 'Hubo un error al habilitar nuevamente al proveedor.';
            END IF;
        END IF;
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPH_RolModulo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPH_RolModulo`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Verificar si el registro está deshabilitado y existe
        IF (SELECT COUNT(*) FROM RolModulo WHERE IdRolModulo = p_Id AND FechaBaja IS NOT NULL) > 0 THEN
            -- Habilitar el registro estableciendo la fecha de baja como NULL
            UPDATE RolModulo 
            SET FechaBaja = NULL
            WHERE IdRolModulo = p_Id;
            SET v_Message = 'OK';
        ELSE 
            SET v_Message = 'El registro ya está habilitado o no existe';
        END IF;
    ELSE
        SET v_Message = 'Token Inválido';
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPH_TipoCategoria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPH_TipoCategoria`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoCategoria WHERE IdTipoCategoria = p_Id AND FechaBaja IS NOT NULL) > 0 THEN
			UPDATE TipoCategoria 
			SET FechaBaja = NULL
			WHERE IdTipoCategoria = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está habilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPH_TipoFormaDePago` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPH_TipoFormaDePago`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoFormaDePago WHERE IdTipoFormaDePago = p_Id AND FechaBaja IS NOT NULL) > 0 THEN
			UPDATE TipoFormaDePago 
			SET FechaBaja = NULL
			WHERE IdTipoFormaDePago = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está habilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPH_TipoImpuesto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPH_TipoImpuesto`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoAumento WHERE IdTipoAumento = p_Id AND FechaBaja IS NOT NULL) > 0 THEN
			UPDATE TipoAumento 
			SET FechaBaja = NULL
			WHERE IdTipoAumento = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está habilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPH_TipoPersonaSistema` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPH_TipoPersonaSistema`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = p_Id AND FechaBaja IS NOT NULL) > 0 THEN
			UPDATE TipoPersonaSistema 
			SET FechaBaja = NULL
			WHERE IdTipoPersonaSistema = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está habilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPH_TipoProducto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPH_TipoProducto`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoProducto WHERE IdTipoProducto = p_Id AND FechaBaja IS NOT NULL) > 0 THEN
			UPDATE TipoProducto 
			SET FechaBaja = NULL
			WHERE IdTipoProducto = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está habilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPH_TipoRol` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPH_TipoRol`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoRol WHERE IdTipoRol = p_Id AND FechaBaja IS NOT NULL) > 0 THEN
			UPDATE TipoRol 
			SET FechaBaja = NULL
			WHERE IdTipoRol = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está habilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_AumentoPorProducto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_AumentoPorProducto`(	IN IdProducto INT)
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS TempAumentosProducto (
        IdTipoAumento INT,
        Detalle VARCHAR(45),
        PorcentajeExtra DECIMAL(18,2)
    );

    INSERT INTO TempAumentosProducto (IdTipoAumento, Detalle, PorcentajeExtra)
        SELECT TA.IdTipoAumento, TA.Detalle, AP.PorcentajeExtra
        FROM AumentoPorProducto AP
        JOIN TipoAumento TA ON AP.IdTipoAumento = TA.IdTipoAumento
        WHERE AP.IdProducto = IdProducto AND AP.FechaBaja IS NULL;
    
    SELECT * FROM TempAumentosProducto;

    DROP TEMPORARY TABLE IF EXISTS TempAumentosProducto;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_BusquedaProdVentas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_BusquedaProdVentas`(IN IdSucursal INT)
BEGIN
	CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
		Codigo VARCHAR(50),
        NombreProducto VARCHAR(1000), -- Nombre, Marca, TipoMedida, Tamaño
        Precio DECIMAL(18,2), -- GeneradorPrecios
        CantidadExistente INT
    );
    
    INSERT INTO TempResultados (Codigo, NombreProducto, Precio, CantidadExistente)
    SELECT 
        p.Codigo, 
        CONCAT(IFNULL(p.Nombre, ''), ' ', '/', ' ', IFNULL(p.Marca, ''), ' ', '/', ' ', IFNULL(p.Tamano, ''), ' ',IFNULL(tm.Abreviatura, '')) AS NombreProducto,  
        gp.PrecioFinal, 
        ss.Cantidad
    FROM 
        Producto p
    JOIN 
        TipoMedida tm ON p.IdTipoMedida = tm.IdTipoMedida
	JOIN 
		GeneradorPrecios gp ON p.IdProducto = gp.IdProducto
		AND gp.IdGeneradorPrecios = (SELECT MAX(gp2.IdGeneradorPrecios) FROM GeneradorPrecios gp2 WHERE gp2.IdProducto = p.IdProducto)
	JOIN 
		StockSucursal ss ON p.IdProducto = ss.IdProducto AND ss.IdSucursal = IdSucursal
    WHERE 
        p.FechaBaja IS NULL
        AND tm.FechaBaja IS NULL
        AND gp.FechaBaja IS NULL
        AND ss.FechaBaja IS NULL;
        
	SELECT * FROM TempResultados;
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_Cliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_Cliente`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);

    -- Verificar el tipo de lista proporcionado y realizar la consulta correspondiente
    IF TipoLista = 1 THEN
        -- Clientes habilitados
        SELECT 
            p.IdPersona AS IdCliente,
            p.IdTipoPersona,
            p.IdLocalidad,
            p.IdTipoDocumentacion,
            p.Documentacion,
            p.Nombre, 
            p.Apellido, 
            p.Mail, 
            p.RazonSocial,
            p.FechaNacimiento,
            p.Telefono,
            p.FechaAlta, 
            p.FechaBaja,
            d.Calle,
            d.Nro,
            d.Piso,
            d.IdTipoDomicilio,
            l.IdProvincia
        FROM 
            Persona p
            LEFT JOIN Domicilio d ON p.IdDomicilio = d.IdDomicilio
            LEFT JOIN Localidad l ON p.IdLocalidad = l.IdLocalidad
        WHERE 
            p.FechaBaja IS NULL 
            AND p.IdTipoPersonaSistema = 3;
    ELSEIF TipoLista = 2 THEN
        -- Clientes inhabilitados
        SELECT 
            p.IdPersona AS IdCliente,
            p.IdTipoPersona,
            p.IdLocalidad,
            p.IdTipoDocumentacion,
            p.Documentacion,
            p.Nombre, 
            p.Apellido, 
            p.Mail, 
            p.RazonSocial,
            p.FechaNacimiento,
            p.Telefono,
            p.FechaAlta, 
            p.FechaBaja,
            d.Calle,
            d.Nro,
            d.Piso,
            d.IdTipoDomicilio,
            l.IdProvincia
        FROM 
            Persona p
            LEFT JOIN Domicilio d ON p.IdDomicilio = d.IdDomicilio
            LEFT JOIN Localidad l ON p.IdLocalidad = l.IdLocalidad
        WHERE 
            p.FechaBaja IS NOT NULL 
            AND p.IdTipoPersonaSistema = 3;
    ELSE
        -- Tipo de lista no válido
        SET Message = 'Tipo de lista no válido';
        SELECT Message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_Localidad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_Localidad`()
Begin
	CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdLocalidad INT,
        Detalle VARCHAR(50)
    );

    INSERT INTO TempResultados (IdLocalidad, Detalle)
        SELECT IdLocalidad, Detalle
        FROM Localidad;
	SELECT * FROM TempResultados;

    DROP TEMPORARY TABLE IF EXISTS TempResultados;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_LocalidadPorProvincia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_LocalidadPorProvincia`(IN v_IdProvincia INT)
BEGIN
	CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdLocalidad INT,
        Detalle VARCHAR(50),
        IdProvincia INT
    );
    
    INSERT INTO TempResultados (IdLocalidad, Detalle, IdProvincia)
	SELECT IdLocalidad, Detalle, IdProvincia
	FROM Localidad
	WHERE IdProvincia = v_IdProvincia;
	SELECT * FROM TempResultados;

    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_Personal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_Personal`(IN TipoLista INT)
BEGIN
	DECLARE Message VARCHAR(50);

    -- Verificar el tipo de lista proporcionado y realizar la consulta correspondiente
    IF TipoLista = 1 THEN
        -- Clientes habilitados
        SELECT 
            p.IdPersona,
            p.IdTipoPersona,
            p.IdLocalidad,
            p.IdTipoDocumentacion,
            p.Documentacion,
            p.Nombre, 
            p.Apellido, 
            p.Mail, 
            p.RazonSocial,
            p.FechaNacimiento,
            p.Telefono,
            p.FechaAlta, 
            p.FechaBaja,
            d.Calle,
            d.Nro,
            d.Piso,
            d.IdTipoDomicilio,
            l.IdProvincia
        FROM 
            Persona p
            LEFT JOIN Domicilio d ON p.IdDomicilio = d.IdDomicilio
            LEFT JOIN Localidad l ON p.IdLocalidad = l.IdLocalidad
        WHERE 
            p.FechaBaja IS NULL 
            AND p.IdTipoPersonaSistema = 1;
    ELSEIF TipoLista = 2 THEN
        -- Clientes inhabilitados
        SELECT 
            p.IdPersona,
            p.IdTipoPersona,
            p.IdLocalidad,
            p.IdTipoDocumentacion,
            p.Documentacion,
            p.Nombre, 
            p.Apellido, 
            p.Mail, 
            p.RazonSocial,
            p.FechaNacimiento,
            p.Telefono,
            p.FechaAlta, 
            p.FechaBaja,
            d.Calle,
            d.Nro,
            d.Piso,
            d.IdTipoDomicilio,
            l.IdProvincia
        FROM 
            Persona p
            LEFT JOIN Domicilio d ON p.IdDomicilio = d.IdDomicilio
            LEFT JOIN Localidad l ON p.IdLocalidad = l.IdLocalidad
        WHERE 
            p.FechaBaja IS NOT NULL 
            AND p.IdTipoPersonaSistema = 1;
    ELSE
        -- Tipo de lista no válido
        SET Message = 'Tipo de lista no válido';
        SELECT Message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_Producto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_Producto`(
    IN p_TipoLista INT)
BEGIN
    SET SQL_SAFE_UPDATES = 0;

    -- Crear tabla temporal
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdProducto INT, IdTipoMedida INT, IdTipoCategoria INT, IdTipoProducto INT, Codigo VARCHAR(50), Nombre VARCHAR(100), 
        Marca VARCHAR(50), PrecioCosto DECIMAL(18,2), Tamano DECIMAL(18,2), CantMinima VARCHAR(50), CantMaxima INT, 
        FechaAlta DATETIME, FechaBaja DATETIME, CategoriaDescripcion VARCHAR(50), TipoProductoDescripcion VARCHAR(50),
        TipoMedidaDescripcion VARCHAR(50), IdPersona INT, RazonSocial VARCHAR(100)
    );

    -- Insertar datos en la tabla temporal
    INSERT INTO TempResultados (IdProducto, IdTipoMedida, IdTipoCategoria, IdTipoProducto, Codigo, Nombre, Marca, PrecioCosto, 
        Tamano, CantMinima, CantMaxima, FechaAlta, FechaBaja, CategoriaDescripcion, TipoProductoDescripcion,
        TipoMedidaDescripcion, IdPersona, RazonSocial)
    SELECT 
        p.IdProducto, tm.IdTipoMedida, tc.IdTipoCategoria, tp.IdTipoProducto, p.Codigo, p.Nombre, p.Marca, 
        p.PrecioCosto, p.Tamano, p.CantMinima, p.CantMaxima, p.FechaAlta, p.FechaBaja, tc.Descripcion, tp.Detalle, tm.Detalle, p.IdPersona, pr.RazonSocial
    FROM 
        Producto p
    JOIN 
        TipoCategoria tc ON p.IdTipoCategoria = tc.IdTipoCategoria
    JOIN 
        TipoProducto tp ON p.IdTipoProducto = tp.IdTipoProducto
    JOIN 
        TipoMedida tm ON p.IdTipoMedida = tm.IdTipoMedida
    JOIN 
        Persona pr ON p.IdPersona = pr.IdPersona
    WHERE 
        tc.FechaBaja IS NULL
        AND tp.FechaBaja IS NULL
        AND tm.FechaBaja IS NULL;
        
    -- Filtrar resultados según el parámetro p_TipoLista
    IF p_TipoLista = 1 THEN
        DELETE FROM TempResultados WHERE FechaBaja IS NOT NULL;
    ELSEIF p_TipoLista = 2 THEN
        DELETE FROM TempResultados WHERE FechaBaja IS NULL;
    END IF;

    -- Seleccionar resultados finales
    SELECT * FROM TempResultados;

    -- Eliminar tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_Proveedor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_Proveedor`( IN TipoLista INT)
BEGIN
	DECLARE Message VARCHAR(50);

    -- Verificar el tipo de lista proporcionado y realizar la consulta correspondiente
    IF TipoLista = 1 THEN
        -- Clientes habilitados
        SELECT 
            p.IdPersona,
            p.IdTipoPersona,
            p.IdLocalidad,
            p.IdTipoDocumentacion,
            p.Documentacion, 
            p.Mail, 
            p.RazonSocial,
            p.FechaNacimiento,
            p.Telefono,
            p.FechaAlta, 
            p.FechaBaja,
            d.Calle,
            d.Nro,
            d.Piso,
            d.IdTipoDomicilio,
            l.IdProvincia
        FROM 
            Persona p
            LEFT JOIN Domicilio d ON p.IdDomicilio = d.IdDomicilio
            LEFT JOIN Localidad l ON p.IdLocalidad = l.IdLocalidad
        WHERE 
            p.FechaBaja IS NULL 
            AND p.IdTipoPersonaSistema = 2;
    ELSEIF TipoLista = 2 THEN
        -- Clientes inhabilitados
        SELECT 
            p.IdPersona,
            p.IdTipoPersona,
            p.IdLocalidad,
            p.IdTipoDocumentacion,
            p.Documentacion,
            p.Mail, 
            p.RazonSocial,
            p.FechaNacimiento,
            p.Telefono,
            p.FechaAlta, 
            p.FechaBaja,
            d.Calle,
            d.Nro,
            d.Piso,
            d.IdTipoDomicilio,
            l.IdProvincia
        FROM 
            Persona p
            LEFT JOIN Domicilio d ON p.IdDomicilio = d.IdDomicilio
            LEFT JOIN Localidad l ON p.IdLocalidad = l.IdLocalidad
        WHERE 
            p.FechaBaja IS NOT NULL 
            AND p.IdTipoPersonaSistema = 2;
    ELSE
        -- Tipo de lista no válido
        SET Message = 'Tipo de lista no válido';
        SELECT Message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_Provincia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_Provincia`()
Begin
	CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdProvincia INT,
        Detalle VARCHAR(50)
    );

    INSERT INTO TempResultados (IdProvincia, Detalle)
        SELECT IdProvincia, Detalle
        FROM Provincia;
	SELECT * FROM TempResultados;

    DROP TEMPORARY TABLE IF EXISTS TempResultados;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_RolModulo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_RolModulo`(
    IN p_IdTipoRol INT,
    IN p_TipoLista INT
)
BEGIN
	SET SQL_SAFE_UPDATES = 0;
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
		IdRolModulo INT,
        IdTipoRol INT,
        DescripcionTipoRol VARCHAR(50),
        IdTipoModulo INT,
        DetalleTipoModulo VARCHAR(50),
        IdTipoPermiso INT,
        DetalleTipoPermiso VARCHAR(50),
        FechaBaja VARCHAR(8)
    );
    IF p_IdTipoRol = 0 THEN
		SET p_IdTipoRol = null;
	END IF;
    
    INSERT INTO TempResultados (IdRolModulo, IdTipoRol, DescripcionTipoRol, IdTipoModulo, DetalleTipoModulo, IdTipoPermiso, DetalleTipoPermiso, FechaBaja)
	SELECT 
		a.IdRolModulo,
		a.IdTipoRol, 
		b.Descripcion AS DescripcionTipoRol, 
		a.IdTipoModulo, 
		c.Detalle AS DetalleTipoModulo, 
		a.IdTipoPermiso, 
		d.Detalle AS DetalleTipoPermiso, 
		DATE_FORMAT(a.FechaBaja, '%Y%m%d') AS FechaBaja  -- Asegúrate de que coincida con el tipo VARCHAR(8)
	FROM 
		RolModulo AS a 
	INNER JOIN 
		TipoRol AS b ON a.IdTipoRol = b.IdTipoRol
	INNER JOIN 
		TipoModulo AS c ON a.IdTipoModulo = c.IdTipoModulo
	INNER JOIN 
		TipoPermiso AS d ON a.IdTipoPermiso = d.IdTipoPermiso
	WHERE 
		(IFNULL(p_IdTipoRol, b.IdTipoRol) = b.IdTipoRol);


    IF p_TipoLista = 1 THEN
        DELETE FROM TempResultados WHERE FechaBaja IS NOT NULL;
    ELSEIF p_TipoLista = 2 THEN
        DELETE FROM TempResultados WHERE FechaBaja IS NULL;
	ELSE
		DELETE FROM TempResultados;
    END IF;

    SELECT * FROM TempResultados
    ORDER BY IdTipoModulo;
    
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_Sucursal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_Sucursal`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdSucursal INT,
        IdDomicilio INT,
        IdTipoDomicilio INT,
        Descripcion VARCHAR(100),
        Calle VARCHAR(100),
        Nro VARCHAR(100),
        Piso VARCHAR(100),
        IdUsuarioCarga INT,
        FechaAlta datetime,
        FechaBaja datetime null
    );

    IF TipoLista = 1 THEN
        INSERT INTO TempResultados (IdSucursal, IdDomicilio, IdTipoDomicilio, Descripcion, Calle, Nro, Piso, IdUsuarioCarga, FechaAlta, FechaBaja)
		SELECT 
			s.IdSucursal, 
			s.IdDomicilio,
            d.IdTipoDomicilio, 
			s.Descripcion, 
			d.Calle, 
			d.Nro, 
			d.Piso, 
			s.IdUsuarioCarga, 
			s.FechaAlta, 
			s.FechaBaja
		FROM 
			Sucursal s
		JOIN 
			Domicilio d ON s.IdDomicilio = d.IdDomicilio
        WHERE s.FechaBaja IS NULL AND d.FechaBaja IS NULL;
    ELSEIF TipoLista = 2 THEN
		INSERT INTO TempResultados (IdSucursal, IdDomicilio, IdTipoDomicilio, Descripcion, Calle, Nro, Piso, IdUsuarioCarga, FechaAlta, FechaBaja)
		SELECT 
			s.IdSucursal, 
			s.IdDomicilio,
            d.IdTipoDomicilio,
			s.Descripcion, 
			d.Calle, 
			d.Nro, 
			d.Piso, 
			s.IdUsuarioCarga, 
			s.FechaAlta, 
			s.FechaBaja
		FROM 
			Sucursal s
		JOIN 
			Domicilio d ON s.IdDomicilio = d.IdDomicilio
        WHERE s.FechaBaja IS NOT NULL AND d.FechaBaja IS NOT NULL;
    END IF;

    IF TipoLista = 1 OR TipoLista = 2 THEN
        SELECT * FROM TempResultados;
	ELSE
		SET Message = 'Tipo de lista no válido';
        SELECT Message;
    END IF;

    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoAumento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoAumento`()
BEGIN
	CREATE TEMPORARY TABLE IF NOT EXISTS TempTiposAumento (
        IdTipoAumento INT,
        Detalle VARCHAR(45)
);

    INSERT INTO TempTiposAumento (IdTipoAumento, Detalle)
        SELECT IdTipoAumento, Detalle
        FROM TipoAumento
        WHERE FechaBaja IS NULL;
    
    SELECT * FROM TempTiposAumento;

    DROP TEMPORARY TABLE IF EXISTS TempTiposAumento;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoCategoria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoCategoria`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoCategoria INT,
        Descripcion VARCHAR(50),
        FechaBaja datetime
    );

    IF TipoLista = 1 THEN
        INSERT INTO TempResultados (IdTipoCategoria, Descripcion, FechaBaja)
        SELECT IdTipoCategoria, Descripcion, FechaBaja
        FROM TipoCategoria
        WHERE FechaBaja IS NULL;
    ELSEIF TipoLista = 2 THEN
        INSERT INTO TempResultados (IdTipoCategoria, Descripcion, FechaBaja)
        SELECT IdTipoCategoria, Descripcion, FechaBaja
        FROM TipoCategoria
        WHERE FechaBaja IS NOT NULL;
    END IF;

    IF TipoLista = 1 OR TipoLista = 2 THEN
        SELECT * FROM TempResultados;
	ELSE
		SET Message = 'Tipo de lista no válido';
        SELECT Message;
    END IF;

    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoDestinatarioFactura` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoDestinatarioFactura`()
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoDestinatarioFactura INT,
        Descripcion VARCHAR(50)
    );

    INSERT INTO TempResultados (IdTipoDestinatarioFactura, Descripcion)
        SELECT IdTipoDestinatarioFactura, Descripcion
        FROM TipoDestinatarioFactura;
	SELECT * FROM TempResultados;

    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoDocumentacion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoDocumentacion`()
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoDocumentacion INT,
        Descripcion VARCHAR(50)
    );

    INSERT INTO TempResultados (IdTipoDocumentacion, Descripcion)
        SELECT IdTipoDocumentacion, Descripcion
        FROM TipoDocumentacion;
	SELECT * FROM TempResultados;
    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoDomicilio` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoDomicilio`()
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoDomicilio INT,
        Descripcion VARCHAR(50)
    );

    INSERT INTO TempResultados (IdTipoDomicilio, Descripcion)
        SELECT IdTipoDomicilio, Descripcion
        FROM TipoDomicilio;
	SELECT * FROM TempResultados;

    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoFactura` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoFactura`()
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoFactura INT,
        Descripcion VARCHAR(50)
    );

    INSERT INTO TempResultados (IdTipoFactura, Descripcion)
        SELECT IdTipoFactura, Descripcion
        FROM TipoFactura;
	SELECT * FROM TempResultados;

    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoFormaDePago` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoFormaDePago`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoFormaDePago INT,
        Descripcion VARCHAR(50),
        FechaBaja datetime
    );

    IF TipoLista = 1 THEN
        INSERT INTO TempResultados (IdTipoFormaDePago, Descripcion, FechaBaja)
        SELECT IdTipoFormaDePago, Descripcion, FechaBaja
        FROM TipoFormaDePago
        WHERE FechaBaja IS NULL;
    ELSEIF TipoLista = 2 THEN
        INSERT INTO TempResultados (IdTipoFormaDePago, Descripcion, FechaBaja)
        SELECT IdTipoFormaDePago, Descripcion, FechaBaja
        FROM TipoFormaDePago
        WHERE FechaBaja IS NOT NULL;
    END IF;

    IF TipoLista = 1 OR TipoLista = 2 THEN
        SELECT * FROM TempResultados;
	ELSE
		SET Message = 'Tipo de lista no válido';
        SELECT Message;
    END IF;

    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoImpuesto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoImpuesto`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoImpuesto INT,
        Detalle VARCHAR(50),
        Porcentaje VARCHAR(50),
        FechaBaja datetime
    );

    IF TipoLista = 1 THEN
        INSERT INTO TempResultados (IdTipoImpuesto, Detalle, Porcentaje, FechaBaja)
        SELECT IdTipoAumento, Detalle, Porcentaje, FechaBaja
        FROM TipoAumento
        WHERE FechaBaja IS NULL;
    ELSEIF TipoLista = 2 THEN
        INSERT INTO TempResultados (IdTipoImpuesto, Detalle, Porcentaje, FechaBaja)
        SELECT IdTipoAumento, Detalle, Porcentaje, FechaBaja
        FROM TipoAumento
        WHERE FechaBaja IS NOT NULL;
    END IF;

    IF TipoLista = 1 OR TipoLista = 2 THEN
        SELECT * FROM TempResultados;
	ELSE
		SET Message = 'Tipo de lista no válido';
        SELECT Message;
    END IF;

    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoMedida` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoMedida`()
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoMedida INT,
        Detalle VARCHAR(45),
        Abreviatura VARCHAR(45),
        FechaBaja DATETIME
    );

    INSERT INTO TempResultados (IdTipoMedida, Detalle, Abreviatura)
        SELECT IdTipoMedida, Detalle, Abreviatura
        FROM TipoMedida;
	SELECT * FROM TempResultados;
    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoModulo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoModulo`(IN TipoLista INT)
BEGIN
	DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoModulo INT,
        IdPadre INT,
        Orden INT,
        Detalle VARCHAR(50),
        FechaBaja datetime
    );

    IF TipoLista = 1 THEN
        INSERT INTO TempResultados (IdTipoModulo, IdPadre, Orden, Detalle, FechaBaja)
        SELECT IdTipoModulo, IdPadre, Orden, Detalle, FechaBaja
        FROM TipoModulo
        WHERE FechaBaja IS NULL;
    ELSEIF TipoLista = 2 THEN
        INSERT INTO TempResultados (IdTipoModulo, IdPadre, Orden, Detalle, FechaBaja)
        SELECT IdTipoModulo, IdPadre, Orden, Detalle, FechaBaja
        FROM TipoModulo
        WHERE FechaBaja IS NOT NULL;
    END IF;

    IF TipoLista = 1 OR TipoLista = 2 THEN
        SELECT * FROM TempResultados;
	ELSE
		SET Message = 'Tipo de lista no válido';
        SELECT Message;
    END IF;

    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoPermiso` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoPermiso`()
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoPermiso INT,
        Detalle VARCHAR(50)
    );

    INSERT INTO TempResultados (IdTipoPermiso, Detalle)
        SELECT IdTipoPermiso, Detalle
        FROM TipoPermiso;
	SELECT * FROM TempResultados;

    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoPermisoDetalle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoPermisoDetalle`(
    IN p_IdTipoPermiso INT
)
BEGIN
	DECLARE v_Exists INT;
    DECLARE v_Message VARCHAR(100);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoPermisoDetalle INT,
        TipoPermiso VARCHAR(45),
        Method VARCHAR(45)
    );
    -- Verificar si p_IdTipoPermiso existe en la tabla TipoPermiso
    SELECT COUNT(*) INTO v_Exists FROM TipoPermiso WHERE IdTipoPermiso = p_IdTipoPermiso;

	IF v_Exists = 0 and p_IdTipoPermiso IS NOT NULL THEN
        SET v_Message = 'El IdTipoPermiso proporcionado no existe en la tabla TipoPermiso';
        SELECT v_Message;
    ELSE
		IF p_IdTipoPermiso IS NOT NULL THEN
			-- Si se pasa un valor para IdTipoPermiso, filtrar por ese valor
			INSERT INTO TempResultados (IdTipoPermisoDetalle, TipoPermiso, Method)
			SELECT tpd.IdTipoPermisoDetalle, tp.Detalle AS TipoPermiso, tpd.Method
			FROM TipoPermisoDetalle tpd
			INNER JOIN TipoPermiso tp ON tp.IdTipoPermiso = tpd.IdTipoPermiso
			WHERE tp.IdTipoPermiso = p_IdTipoPermiso;
		ELSE
			-- Si se pasa NULL, mostrar todos los registros
			INSERT INTO TempResultados (IdTipoPermisoDetalle, TipoPermiso, Method)
			SELECT tpd.IdTipoPermisoDetalle, tp.Detalle AS TipoPermiso, tpd.Method
			FROM TipoPermisoDetalle tpd
			INNER JOIN TipoPermiso tp ON tp.IdTipoPermiso = tpd.IdTipoPermiso;
		END IF;
        SELECT * FROM TempResultados;
		DROP TEMPORARY TABLE IF EXISTS TempResultados;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoPersona` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoPersona`()
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoPersona INT,
        Descripcion VARCHAR(50)
    );

    INSERT INTO TempResultados (IdTipoPersona, Descripcion)
        SELECT IdTipoPersona, Descripcion
        FROM TipoPersona;
	SELECT * FROM TempResultados;

    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoPersonaSistema` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoPersonaSistema`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoPersonaSistema INT,
        Descripcion VARCHAR(50),
        FechaBaja datetime
    );

    IF TipoLista = 1 THEN
        INSERT INTO TempResultados (IdTipoPersonaSistema, Descripcion, FechaBaja)
        SELECT IdTipoPersonaSistema, Descripcion, FechaBaja
        FROM TipoPersonaSistema
        WHERE FechaBaja IS NULL;
    ELSEIF TipoLista = 2 THEN
        INSERT INTO TempResultados (IdTipoPersonaSistema, Descripcion, FechaBaja)
        SELECT IdTipoPersonaSistema, Descripcion, FechaBaja
        FROM TipoPersonaSistema
        WHERE FechaBaja IS NOT NULL;
    END IF;

    IF TipoLista = 1 OR TipoLista = 2 THEN
        SELECT * FROM TempResultados;
	ELSE
		SET Message = 'Tipo de lista no válido';
        SELECT Message;
    END IF;

    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoProducto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoProducto`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoProducto INT,
        Detalle VARCHAR(50),
        FechaBaja datetime
    );

    IF TipoLista = 1 THEN
        INSERT INTO TempResultados (IdTipoProducto, Detalle, FechaBaja)
        SELECT IdTipoProducto, Detalle, FechaBaja
        FROM TipoProducto
        WHERE FechaBaja IS NULL;
    ELSEIF TipoLista = 2 THEN
        INSERT INTO TempResultados (IdTipoProducto, Detalle, FechaBaja)
        SELECT IdTipoProducto, Detalle, FechaBaja
        FROM TipoProducto
        WHERE FechaBaja IS NOT NULL;
    END IF;

    IF TipoLista = 1 OR TipoLista = 2 THEN
        SELECT * FROM TempResultados;
	ELSE
		SET Message = 'Tipo de lista no válido';
        SELECT Message;
    END IF;

    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_TipoRol` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_TipoRol`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoRol INT,
        Descripcion VARCHAR(50),
        FechaBaja DATETIME
    );

    IF TipoLista = 1 THEN
        INSERT INTO TempResultados (IdTipoRol, Descripcion, FechaBaja)
        SELECT IdTipoRol, Descripcion, FechaBaja
        FROM TipoRol
        WHERE FechaBaja IS NULL;
    ELSEIF TipoLista = 2 THEN
        INSERT INTO TempResultados (IdTipoRol, Descripcion, FechaBaja)
        SELECT IdTipoRol, Descripcion, FechaBaja
        FROM TipoRol
        WHERE FechaBaja IS NOT NULL;
    END IF;

    IF TipoLista = 1 OR TipoLista = 2 THEN
        SELECT * FROM TempResultados;
	ELSE
		SET Message = 'Tipo de lista no válido';
        SELECT Message;
    END IF;

    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPL_Usuarios` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPL_Usuarios`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);

    IF TipoLista = 1 THEN
		SELECT u.IdUsuario, u.Usuario, p.Nombre, p.Apellido, p.Documentacion, u.FechaAlta, u.FechaBaja, sps.IdSucursal, sr.IdTipoRol, s.Descripcion
		FROM Usuario u
		LEFT JOIN Persona p ON u.IdPersona = p.IdPersona
		LEFT JOIN UsuarioPorSucursal sps ON u.IdUsuario = sps.IdUsuario
		LEFT JOIN (
			SELECT sr.IdUsuario, MIN(sr.IdTipoRol) AS IdTipoRol
			FROM UsuarioRol sr
			WHERE sr.FechaBaja IS NULL
			GROUP BY sr.IdUsuario
		) sr ON u.IdUsuario = sr.IdUsuario
        LEFT JOIN Sucursal s ON s.IdSucursal = sps.IdSucursal
		WHERE u.FechaBaja IS NULL AND sps.FechaBaja IS NULL ;
    ELSEIF TipoLista = 2 THEN
		SELECT u.IdUsuario, u.Usuario, p.Nombre, p.Apellido, p.Documentacion, u.FechaAlta, u.FechaBaja, sps.IdSucursal, sr.IdTipoRol, s.Descripcion
		FROM Usuario u
		LEFT JOIN Persona p ON u.IdPersona = p.IdPersona
		LEFT JOIN UsuarioPorSucursal sps ON u.IdUsuario = sps.IdUsuario
		LEFT JOIN (
			SELECT sr.IdUsuario, MIN(sr.IdTipoRol) AS IdTipoRol
			FROM UsuarioRol sr
			WHERE sr.FechaBaja IS NULL
			GROUP BY sr.IdUsuario
		) sr ON u.IdUsuario = sr.IdUsuario
        LEFT JOIN Sucursal s ON s.IdSucursal = sps.IdSucursal
		WHERE u.FechaBaja IS NOT NULL;
    ELSE
        SET Message = 'Tipo de lista no válido.';
        SELECT Message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_AumentoEnMasa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_AumentoEnMasa`(IN json_data JSON)
BEGIN
    DECLARE i INT DEFAULT 2; -- Comienza desde 2 para saltar el Token y PorcentajeExtra
    DECLARE n INT;
    DECLARE v_IdProducto INT;
    DECLARE v_PrecioCosto DECIMAL(10, 2);
    DECLARE v_PorcentajeExtra DECIMAL(5, 2);
    DECLARE V_PrecioCostoFinal DECIMAL(10, 2);
    DECLARE v_Message VARCHAR(100);
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Token VARCHAR(500);

    -- Extract the Token and PorcentajeExtra
    SET v_Token = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$[0].Token'));
    SET v_PorcentajeExtra = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$[1].PorcentajeExtra'));
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(v_Token);

    -- Determine the length of the JSON array
    SET n = JSON_LENGTH(json_data) - 1; 

    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Iterate through JSON array and update records
        WHILE i <= n DO
            SET v_IdProducto = JSON_UNQUOTE(JSON_EXTRACT(json_data, CONCAT('$[', i, '].IdProducto')));
            SET v_PrecioCosto = JSON_UNQUOTE(JSON_EXTRACT(json_data, CONCAT('$[', i, '].PrecioCosto')));
			SET V_PrecioCostoFinal = v_PrecioCosto + (v_PrecioCosto * v_PorcentajeExtra / 100);
            -- Verificar que los valores no sean NULL antes de continuar
            IF v_IdProducto IS NOT NULL AND v_PrecioCosto IS NOT NULL THEN
                -- Update Producto table
                UPDATE Producto
                SET PrecioCosto = V_PrecioCostoFinal
                WHERE IdProducto = v_IdProducto;
            ELSE
                -- Manejar el caso de datos incompletos o incorrectos
                SET v_Message = CONCAT('Datos incompletos o incorrectos para IdProducto: ', IFNULL(v_IdProducto, 'NULL'));
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_Message;
            END IF;

            SET i = i + 1;
        END WHILE;
        SET v_Message = 'OK';
    ELSE
        SET v_Message = 'Token Inválido';
    END IF;
    SELECT v_Message AS ResultMessage;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_AumentosProducto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_AumentosProducto`(
    IN p_IdProducto INT,
    IN p_Aumentos JSON,
    IN p_AumentoExtra DECIMAL(10,2),
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdTipoAumento INT;
    DECLARE v_Indice INT DEFAULT 0;
    DECLARE v_Longitud INT;
    DECLARE v_Siguiente JSON;
    DECLARE v_Existe INT;
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(100);

    -- Obtener el ID del usuario desde el Bearer Token
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Obtener la longitud del array JSON
        SET v_Longitud = JSON_LENGTH(p_Aumentos);

        -- Insertar o actualizar los aumentos seleccionados
        WHILE v_Indice < v_Longitud DO
            SET v_Siguiente = JSON_EXTRACT(p_Aumentos, CONCAT('$[', v_Indice, ']'));
            SET v_IdTipoAumento = JSON_UNQUOTE(JSON_EXTRACT(v_Siguiente, '$.IdTipoAumento'));

            -- Comprobar si el aumento ya existe
            SELECT COUNT(*) INTO v_Existe 
            FROM AumentoPorProducto 
            WHERE IdProducto = p_IdProducto AND IdTipoAumento = v_IdTipoAumento;

            -- Si el aumento no existe, insertar
            IF v_Existe = 0 THEN
                INSERT INTO AumentoPorProducto (IdProducto, IdTipoAumento, PorcentajeExtra) 
                VALUES (p_IdProducto, v_IdTipoAumento, NULL);
            END IF;

            SET v_Indice = v_Indice + 1;
        END WHILE;

        -- Eliminar los aumentos que no están en el JSON de entrada
        DELETE FROM AumentoPorProducto
        WHERE IdProducto = p_IdProducto 
        AND IdTipoAumento IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM JSON_TABLE(p_Aumentos, '$[*]' COLUMNS (IdTipoAumento INT PATH '$.IdTipoAumento')) AS jt
            WHERE jt.IdTipoAumento = AumentoPorProducto.IdTipoAumento
        );

        -- Manejar el aumento extra
        IF p_AumentoExtra IS NOT NULL THEN
            -- Comprobar si el aumento extra ya existe para el mismo producto
            SELECT COUNT(*) INTO v_Existe 
            FROM AumentoPorProducto 
            WHERE IdProducto = p_IdProducto AND IdTipoAumento IS NULL;

            SET v_Message = 'OK';

            -- Si el aumento extra no existe, insertar; de lo contrario, actualizar
            IF v_Existe = 0 THEN
                INSERT INTO AumentoPorProducto (IdProducto, IdTipoAumento, PorcentajeExtra) 
                VALUES (p_IdProducto, NULL, p_AumentoExtra);
            ELSE
                UPDATE AumentoPorProducto 
                SET PorcentajeExtra = p_AumentoExtra 
                WHERE IdProducto = p_IdProducto AND IdTipoAumento IS NULL;
            END IF;
        ELSE
            -- Si p_AumentoExtra es NULL, eliminar cualquier registro existente con IdTipoAumento IS NULL para este producto
            DELETE FROM AumentoPorProducto 
            WHERE IdProducto = p_IdProducto AND IdTipoAumento IS NULL;
        END IF;
    ELSE
        SET v_Message = 'Token Inválido';
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_Cliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_Cliente`(
    IN p_IdCliente INT,
    IN p_IdTipoPersona INT,
    IN p_IdTipoDomicilio INT,
    IN p_Calle VARCHAR(45),
    IN p_Nro VARCHAR(45),
    IN p_Piso VARCHAR(45),
    IN p_IdLocalidad INT,
    IN p_IdTipoDocumentacion INT,
    IN p_Documentacion VARCHAR(45),
    IN p_Nombre VARCHAR(45),
    IN p_Apellido VARCHAR(45),
    IN p_Mail VARCHAR(45),
    IN p_RazonSocial VARCHAR(45),
    IN p_FechaNacimiento DATE,
    IN p_Telefono VARCHAR(45),
    IN p_IdProvincia INT,
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_Message VARCHAR(255);
    DECLARE v_OriginalDocumentacion VARCHAR(45);
    DECLARE v_TelefonoActual VARCHAR(45);
    DECLARE v_IdTipoPersonaSistema INT DEFAULT 3;
	DECLARE v_IdUsuarioCarga INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
	
		-- Verificar si el IdCliente existe
		IF NOT EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdCliente) THEN
			SET v_Message = 'No existe el cliente ingresado.';
		-- Verificar si el usuario está dado de baja
		ELSEIF EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdCliente AND FechaBaja IS NOT NULL) THEN
			SET v_Message = 'No se puede modificar un usuario dado de baja.';
		-- Verificar si el IdTipoPersonaSistema es distinto de 3
		ELSEIF EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdCliente AND IdTipoPersonaSistema <> 3) THEN
			SET v_Message = 'Solo se pueden modificar clientes';
		ELSEIF p_Calle IS NULL OR p_Calle = '' THEN
			SET v_Message = 'El nombre de la calle no puede estar vacío.';
		ELSEIF p_Nro IS NULL OR p_Nro = '' THEN
			SET v_Message = 'El número de la calle no puede estar vacío.';
		ELSEIF NOT EXISTS (SELECT 1 FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = v_IdTipoPersonaSistema) THEN
			SET v_Message = 'No existe el tipo persona sistema ingresado.';
		ELSEIF NOT EXISTS (SELECT 1 FROM TipoPersona WHERE idTipoPersona = p_IdTipoPersona) THEN
			SET v_Message = 'El tipo persona ingresado no existe.';
		ELSEIF NOT EXISTS (SELECT 1 FROM TipoDomicilio WHERE IdTipoDomicilio = p_IdTipoDomicilio) THEN
			SET v_Message = 'El ID de tipo de domicilio no existe en la base de datos.';
		ELSEIF NOT EXISTS (SELECT 1 FROM TipoDocumentacion WHERE IdTipoDocumentacion = p_IdTipoDocumentacion) THEN
			SET v_Message = 'El ID de tipo de documentación no existe en la base de datos.';
		ELSEIF NOT EXISTS (SELECT 1 FROM Localidad WHERE IdLocalidad = p_IdLocalidad) THEN
			SET v_Message = 'No existe localidad ingresada en la base de datos.';
		ELSEIF NOT EXISTS (SELECT 1 FROM Provincia WHERE IdProvincia = p_IdProvincia) THEN
			SET v_Message = 'No existe provincia ingresada en la base de datos.';
		ELSEIF p_FechaNacimiento > DATE_SUB(CURDATE(), INTERVAL 18 YEAR) THEN
			SET v_Message = 'El cliente debe ser mayor de 18 años.';
		ELSEIF NOT p_Telefono REGEXP '^[0-9]+$' THEN
			SET v_Message = 'Ingrese sin ningún tipo de signo su número de teléfono.';
		ELSEIF LENGTH(p_Telefono) < 10 THEN
			SET v_Message = 'El número de teléfono debe tener al menos 10 dígitos.';
		ELSEIF NOT p_Nro REGEXP '^[0-9]+$' THEN
			SET v_Message = 'El número de domicilio debe contener solo dígitos positivos.';
		ELSEIF NOT p_Nombre REGEXP '^[a-zA-Z]+$' THEN
			SET v_Message = 'El nombre no puede contener números.';
		ELSEIF NOT p_Apellido REGEXP '^[a-zA-Z]+$' THEN
			SET v_Message = 'El apellido no puede contener números.';
		ELSEIF NOT p_Mail REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' THEN
			SET v_Message = 'El correo electrónico no tiene un formato válido.';
		ELSE
			-- Obtener el número de documentación original
			SELECT Documentacion INTO v_OriginalDocumentacion FROM Persona WHERE IdPersona = p_IdCliente;

			-- Verificar si el número de documentación ha cambiado
			IF v_OriginalDocumentacion <> p_Documentacion THEN
				SET v_Message = 'No puede modificar su número de documentación.';
			ELSE
				-- Verificar si la localidad pertenece a la provincia indicada
				IF NOT EXISTS (SELECT 1 FROM Localidad WHERE IdLocalidad = p_IdLocalidad AND IdProvincia = p_IdProvincia) THEN
					SET v_Message = 'La localidad ingresada no pertenece a la provincia indicada.';
				ELSE
					-- Verificar si el número de teléfono ya existe
					SELECT Telefono INTO v_TelefonoActual FROM Persona WHERE IdPersona = p_IdCliente;
					IF p_Telefono <> v_TelefonoActual AND EXISTS (SELECT 1 FROM Persona WHERE Telefono = p_Telefono) THEN
						SET v_Message = 'El número de teléfono ya existe en la base de datos.';
					ELSE
						-- Actualizar datos en la tabla Domicilio
						UPDATE Domicilio
						SET IdTipoDomicilio = p_IdTipoDomicilio,
							Calle = p_Calle,
							Nro = p_Nro,
							Piso = p_Piso
						WHERE IdDomicilio = (SELECT IdDomicilio FROM Persona WHERE IdPersona = p_IdCliente);

						-- Actualizar datos en la tabla Persona
						UPDATE Persona
						SET IdTipoPersonaSistema = v_IdTipoPersonaSistema,
							IdTipoPersona = p_IdTipoPersona,
							IdLocalidad = p_IdLocalidad,
							IdTipoDocumentacion = p_IdTipoDocumentacion,
							Nombre = p_Nombre,
							Apellido = p_Apellido,
							Mail = p_Mail,
							RazonSocial = p_RazonSocial,
							FechaNacimiento = p_FechaNacimiento,
							Telefono = p_Telefono,
							IdUsuarioCarga= v_IdUsuarioCarga
						WHERE IdPersona = p_IdCliente;
						
						SET v_Message = 'OK';
					END IF;
				END IF;
			END IF;
		END IF;
	ELSE
        SET v_Message = 'Token Inválido';
	END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_Personal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_Personal`(
    IN p_IdPersona INT,
    IN p_IdTipoPersona INT,
    IN p_IdTipoDomicilio INT,
    IN p_Calle VARCHAR(45),
    IN p_Nro VARCHAR(45),
    IN p_Piso VARCHAR(45),
    IN p_IdLocalidad INT,
    IN p_IdTipoDocumentacion INT,
    IN p_Documentacion VARCHAR(45),
    IN p_Nombre VARCHAR(45),
    IN p_Apellido VARCHAR(45),
    IN p_Mail VARCHAR(45),
    IN p_FechaNacimiento DATE,
    IN p_Telefono VARCHAR(45),
    IN p_IdProvincia INT,
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_Message VARCHAR(255);
    DECLARE v_IdDomicilio INT;
    DECLARE v_OriginalDocumentacion VARCHAR(45);
    DECLARE v_IdTipoPersonaSistema INT DEFAULT 1;
    DECLARE v_IdUsuarioCarga INT;

	SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    -- Verificar si el IdPersonal existe
    IF NOT EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdPersona) THEN
        SET v_Message = 'No existe el IdPersonal ingresado.';
    -- Verificar si el usuario está dado de baja
    ELSEIF EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdPersona AND FechaBaja IS NOT NULL) THEN
        SET v_Message = 'No se puede modificar un usuario dado de baja.';
    ELSEIF NOT EXISTS (SELECT 1 FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = v_IdTipoPersonaSistema) THEN
        SET v_Message = 'No existe el tipo persona sistema ingresado.';
    ELSEIF NOT EXISTS (SELECT 1 FROM TipoPersona WHERE idTipoPersona = p_IdTipoPersona) THEN
        SET v_Message = 'El tipo persona ingresado no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM TipoDomicilio WHERE IdTipoDomicilio = p_IdTipoDomicilio) THEN
        SET v_Message = 'El ID de tipo de domicilio no existe en la base de datos.';
    ELSEIF NOT EXISTS (SELECT 1 FROM TipoDocumentacion WHERE IdTipoDocumentacion = p_IdTipoDocumentacion) THEN
        SET v_Message = 'El ID de tipo de documentación no existe en la base de datos.';
    ELSEIF NOT EXISTS (SELECT 1 FROM Localidad WHERE IdLocalidad = p_IdLocalidad) THEN
        SET v_Message = 'No existe localidad ingresada en la base de datos.';
    ELSEIF NOT EXISTS (SELECT 1 FROM Provincia WHERE IdProvincia = p_IdProvincia) THEN
        SET v_Message = 'No existe provincia ingresada en la base de datos.';
    ELSEIF p_FechaNacimiento > DATE_SUB(CURDATE(), INTERVAL 18 YEAR) THEN
        SET v_Message = 'El cliente debe ser mayor de 18 años.';
    ELSEIF NOT p_Telefono REGEXP '^[0-9]+$' THEN
        SET v_Message = 'Ingrese sin ningún tipo de signo su número de teléfono.';
    ELSEIF LENGTH(p_Telefono) < 10 THEN
        SET v_Message = 'El número de teléfono debe tener al menos 10 dígitos.';
    ELSEIF NOT p_Nro REGEXP '^[0-9]+$' THEN
        SET v_Message = 'El número de domicilio debe contener solo dígitos positivos.';
    ELSEIF NOT p_Nombre REGEXP '^[a-zA-Z]+$' THEN
        SET v_Message = 'El nombre no puede contener números.';
    ELSEIF NOT p_Apellido REGEXP '^[a-zA-Z]+$' THEN
        SET v_Message = 'El apellido no puede contener números.';
    ELSEIF NOT p_Mail REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' THEN
        SET v_Message = 'El correo electrónico no tiene un formato válido.';
    ELSE
        -- Obtener el número de documentación original
        SELECT Documentacion INTO v_OriginalDocumentacion FROM Persona WHERE IdPersona = p_IdPersona;

        -- Verificar si el número de documentación ha cambiado
        IF v_OriginalDocumentacion <> p_Documentacion THEN
            SET v_Message = 'No puede modificar su número de documentación.';
        ELSE
            -- Verificar si la localidad pertenece a la provincia indicada
            IF NOT EXISTS (SELECT 1 FROM Localidad WHERE IdLocalidad = p_IdLocalidad AND IdProvincia = p_IdProvincia) THEN
                SET v_Message = 'La localidad ingresada no pertenece a la provincia indicada.';
            ELSE
                -- Actualizar datos en la tabla Domicilio
                UPDATE Domicilio
                SET IdTipoDomicilio = p_IdTipoDomicilio,
                    Calle = p_Calle,
                    Nro = p_Nro,
                    Piso = p_Piso
                WHERE IdDomicilio = (SELECT IdDomicilio FROM Persona WHERE IdPersona = p_IdPersona);

                -- Actualizar datos en la tabla Persona
                UPDATE Persona
                SET IdTipoPersonaSistema = v_IdTipoPersonaSistema,
                    IdTipoPersona = p_IdTipoPersona,
                    IdLocalidad = p_IdLocalidad,
                    IdTipoDocumentacion = p_IdTipoDocumentacion,
                    Nombre = p_Nombre,
                    Apellido = p_Apellido,
                    Mail = p_Mail,
                    FechaNacimiento = p_FechaNacimiento,
                    Telefono = p_Telefono,
                    IdUsuarioCarga= v_IdUsuarioCarga
                WHERE IdPersona = p_IdPersona;
                
                SET v_Message = 'OK';
            END IF;
        END IF;
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_Producto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_Producto`(
    IN p_IdProducto INT,
    IN p_IdTipoMedida INT,
    IN p_IdTipoCategoria INT,
    IN p_IdTipoProducto INT,
    IN p_Codigo VARCHAR(255),
    IN p_Nombre VARCHAR(45),
    IN p_IdPersona INT(45),
    IN p_Marca VARCHAR(45),
    IN p_PrecioCosto DECIMAL(18,2),
    IN p_Tamano DECIMAL(18,2),
    IN p_CantMinima INT,
    IN p_CantMaxima INT,
    IN p_UsuarioBearer text(500)
)
BEGIN
    DECLARE v_Message VARCHAR(255);
	DECLARE v_IdUsuarioCarga INT;
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    -- Verificar si el producto está dado de baja
    SELECT IFNULL(FechaBaja, 'No') INTO v_Message FROM Producto WHERE IdProducto = p_IdProducto;

    IF v_Message != 'No' THEN
        SET v_Message = 'El producto está dado de baja y no se puede editar.';
    ELSE
        -- Verificar si el ID de usuario de carga existe en la base de datos
        IF NOT EXISTS (SELECT 1 FROM Usuario WHERE IdUsuario = v_IdUsuarioCarga) THEN
            SET v_Message = 'El ID de usuario de carga no existe en la base de datos.';
        ELSE
            -- Verificar si el ID de tipo de medida existe en la base de datos
            IF NOT EXISTS (SELECT 1 FROM TipoMedida WHERE IdTipoMedida = p_IdTipoMedida) THEN
                SET v_Message = 'El ID de tipo de medida no existe en la base de datos.';
            ELSE
                -- Verificar si el ID de tipo de categoría existe en la base de datos
                IF NOT EXISTS (SELECT 1 FROM TipoCategoria WHERE IdTipoCategoria = p_IdTipoCategoria) THEN
                    SET v_Message = 'El ID de tipo de categoría no existe en la base de datos.';
                ELSE
                    -- Verificar si el ID de tipo de producto existe en la base de datos
                    IF NOT EXISTS (SELECT 1 FROM TipoProducto WHERE IdTipoProducto = p_IdTipoProducto) THEN
                        SET v_Message = 'El ID de tipo de producto no existe en la base de datos.';
                    ELSE
                        -- Verificar que la cantidad mínima no sea mayor que la máxima
                        IF p_CantMinima > p_CantMaxima THEN
                            SET v_Message = 'La cantidad mínima no puede ser mayor que la máxima.';
                        ELSE
                            -- Verificar que no se ingresen números negativos en ningún campo
                            IF p_PrecioCosto < 0 OR p_Tamano < 0 OR p_CantMinima < 0 OR p_CantMaxima < 0 THEN
                                SET v_Message = 'No debe ingresar números negativos en ningún campo.';
                            ELSE
                                -- Verificar si el código ya está siendo utilizado por otro producto
                                IF EXISTS (SELECT 1 FROM Producto WHERE Codigo = p_Codigo AND IdProducto != p_IdProducto) THEN
                                     SET v_Message = 'El código ingresado ya pertenece a otro producto. Ingrese otro código.';
                                ELSE
                                    -- Validar longitud del código
                                    IF LENGTH(p_Codigo) < 8 THEN
                                        SET v_Message = 'El código debe tener 8 dígitos.';
                                    ELSE
                                        -- Actualizar los datos del producto
                                        UPDATE Producto 
                                        SET IdTipoMedida = p_IdTipoMedida,
                                            IdTipoCategoria = p_IdTipoCategoria,
                                            IdTipoProducto = p_IdTipoProducto,
                                            Codigo = p_Codigo,
                                            Nombre = p_Nombre,
                                            Marca = p_Marca,
                                            PrecioCosto = p_PrecioCosto,
                                            Tamano = p_Tamano,
                                            CantMinima = p_CantMinima,
                                            CantMaxima = p_CantMaxima,
                                            IdUsuarioCarga = v_IdUsuarioCarga,
                                            IdPersona= p_IdPersona
                                        WHERE IdProducto = p_IdProducto;

                                        -- Mensaje de éxito
                                        SET v_Message = 'OK';
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_Proveedor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_Proveedor`(
    IN p_IdPersona INT,
    IN p_IdTipoPersona INT,
    IN p_IdTipoDomicilio INT,
    IN p_Calle VARCHAR(45),
    IN p_Nro VARCHAR(45),
    IN p_Piso VARCHAR(45),
    IN p_IdLocalidad INT,
    IN p_IdTipoDocumentacion INT,
    IN p_Documentacion VARCHAR(45),
    IN p_Mail VARCHAR(45),
    IN p_RazonSocial VARCHAR(45),
    IN p_Telefono VARCHAR(45),
    IN p_IdProvincia INT,
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_Message VARCHAR(255);
    DECLARE v_OriginalDocumentacion VARCHAR(45);
    DECLARE v_TelefonoActual VARCHAR(45);
    DECLARE v_IdTipoPersonaSistema INT DEFAULT 2;
    DECLARE v_IdUsuarioCarga INT;

    -- Obtener el ID del usuario desde el bearer
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    IF v_IdUsuarioCarga IS NULL THEN
        SET v_Message = 'El usuario no es válido.';
    ELSE
        -- Verificar si el IdCliente existe
        IF NOT EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdPersona) THEN
            SET v_Message = 'No existe el proveedor ingresado.';
        -- Verificar si el usuario está dado de baja
        ELSEIF EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdPersona AND FechaBaja IS NOT NULL) THEN
            SET v_Message = 'No se puede modificar un proveedor dado de baja.';
        -- Verificar si el IdTipoPersonaSistema es distinto de 2
        ELSEIF EXISTS (SELECT 1 FROM Persona WHERE IdPersona = p_IdPersona AND v_IdTipoPersonaSistema <> 2) THEN
            SET v_Message = 'Solo se pueden modificar proveedores';
        -- Validaciones adicionales
        ELSEIF p_Calle IS NULL OR p_Calle = '' THEN
            SET v_Message = 'El nombre de la calle no puede estar vacío.';
        ELSEIF p_Nro IS NULL OR p_Nro = '' THEN
            SET v_Message = 'El número de la calle no puede estar vacío.';
        ELSEIF NOT EXISTS (SELECT 1 FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = v_IdTipoPersonaSistema) THEN
            SET v_Message = 'No existe el tipo persona sistema ingresado.';
        ELSEIF NOT EXISTS (SELECT 1 FROM TipoPersona WHERE idTipoPersona = p_IdTipoPersona) THEN
            SET v_Message = 'El tipo persona ingresado no existe.';
        ELSEIF NOT EXISTS (SELECT 1 FROM TipoDomicilio WHERE IdTipoDomicilio = p_IdTipoDomicilio) THEN
            SET v_Message = 'El ID de tipo de domicilio no existe en la base de datos.';
        ELSEIF NOT EXISTS (SELECT 1 FROM TipoDocumentacion WHERE IdTipoDocumentacion = p_IdTipoDocumentacion) THEN
            SET v_Message = 'El ID de tipo de documentación no existe en la base de datos.';
        ELSEIF NOT EXISTS (SELECT 1 FROM Localidad WHERE IdLocalidad = p_IdLocalidad) THEN
            SET v_Message = 'No existe localidad ingresada en la base de datos.';
        ELSEIF NOT EXISTS (SELECT 1 FROM Provincia WHERE IdProvincia = p_IdProvincia) THEN
            SET v_Message = 'No existe provincia ingresada en la base de datos.';
        ELSEIF NOT p_Telefono REGEXP '^[0-9]+$' THEN
            SET v_Message = 'Ingrese sin ningún tipo de signo su número de teléfono.';
        ELSEIF LENGTH(p_Telefono) < 10 THEN
            SET v_Message = 'El número de teléfono debe tener al menos 10 dígitos.';
        ELSEIF NOT p_Nro REGEXP '^[0-9]+$' THEN
            SET v_Message = 'El número de domicilio debe contener solo dígitos positivos.';
        ELSEIF NOT p_Mail REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' THEN
            SET v_Message = 'El correo electrónico no tiene un formato válido.';
        ELSE
            -- Obtener el número de documentación original
            SELECT Documentacion INTO v_OriginalDocumentacion FROM Persona WHERE IdPersona = p_IdPersona;

            -- Verificar si el número de documentación ha cambiado
            IF v_OriginalDocumentacion <> p_Documentacion THEN
                SET v_Message = 'No puede modificar su número de documentación.';
            ELSE
                -- Verificar si la localidad pertenece a la provincia indicada
                IF NOT EXISTS (SELECT 1 FROM Localidad WHERE IdLocalidad = p_IdLocalidad AND IdProvincia = p_IdProvincia) THEN
                    SET v_Message = 'La localidad ingresada no pertenece a la provincia indicada.';
                ELSE
                    -- Verificar si el número de teléfono ya existe
                    SELECT Telefono INTO v_TelefonoActual FROM Persona WHERE IdPersona = p_IdPersona;
                    IF p_Telefono <> v_TelefonoActual AND EXISTS (SELECT 1 FROM Persona WHERE Telefono = p_Telefono) THEN
                        SET v_Message = 'El número de teléfono ya existe en la base de datos.';
                    ELSE
                        -- Actualizar datos en la tabla Domicilio
                        UPDATE Domicilio
                        SET IdTipoDomicilio = p_IdTipoDomicilio,
                            Calle = p_Calle,
                            Nro = p_Nro,
                            Piso = p_Piso
                        WHERE IdDomicilio = (SELECT IdDomicilio FROM Persona WHERE IdPersona = p_IdPersona);

                        -- Actualizar datos en la tabla Persona
                        UPDATE Persona
                        SET IdTipoPersonaSistema = v_IdTipoPersonaSistema,
                            IdTipoPersona = p_IdTipoPersona,
                            IdLocalidad = p_IdLocalidad,
                            IdTipoDocumentacion = p_IdTipoDocumentacion,
                            Mail = p_Mail,
                            RazonSocial = p_RazonSocial,
                            Telefono = p_Telefono,
                            IdUsuarioCarga = v_IdUsuarioCarga
                        WHERE IdPersona = p_IdPersona;

                        SET v_Message = 'OK';
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;

    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_Sucursal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_Sucursal`(
    IN p_IdSucursal INT,
    IN p_IdDomicilio INT, 
    IN p_IdTipoDomicilio INT, 
    IN p_Descripcion VARCHAR(50), 
    IN p_Calle VARCHAR(50), 
    IN p_Nro VARCHAR(50), 
    IN p_Piso VARCHAR(50), 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(100);
    DECLARE v_IdSucursalExiste INT;
    DECLARE v_DomicilioExiste INT;
    DECLARE v_DescripcionExiste INT;
    DECLARE v_RegistroNoModificado INT;
    DECLARE v_DomicilioIgual INT;
    DECLARE v_RegistroDadoDeBaja INT;

    -- Obtener el ID del usuario desde el token
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    
    SELECT COUNT(*) INTO v_IdSucursalExiste FROM Sucursal WHERE IdSucursal = p_IdSucursal;

    -- Verificar si el token es válido
    IF v_IdUsuarioCarga IS NOT NULL THEN
    
		SELECT COUNT(*) INTO v_RegistroNoModificado
		FROM Sucursal s
		JOIN Domicilio d ON s.IdDomicilio = d.IdDomicilio
		WHERE s.Descripcion = p_Descripcion
		AND s.IdSucursal = p_IdSucursal
		AND LOWER(d.Calle) = LOWER(p_Calle)
		AND LOWER(d.Nro) = LOWER(p_Nro)
		AND LOWER(d.Piso) = LOWER(Piso)
		AND d.IdTipoDomicilio = p_IdTipoDomicilio;
        
		SELECT COUNT(*) INTO v_RegistroDadoDeBaja
		FROM Sucursal s
		JOIN Domicilio d ON s.IdDomicilio = d.IdDomicilio
		WHERE s.IdSucursal = p_IdSucursal
        AND s.FechaBaja IS NOT NULL
        AND d.FechaBaja IS NOT NULL;
        
        -- Verificar si la descripción ingresada ya está en uso en otra sucursal
        SELECT COUNT(*) INTO v_DescripcionExiste FROM Sucursal WHERE Descripcion = p_Descripcion AND IdSucursal != p_IdSucursal;
		IF v_IdSucursalExiste = 1 THEN
			IF v_RegistroDadoDeBaja = 0 THEN
				IF v_RegistroNoModificado = 0 THEN
					IF v_DescripcionExiste = 0 AND v_RegistroNoModificado = 0 THEN
						-- Verificar si ya existe un registro en Domicilio con la misma calle, número y piso, excluyendo el registro que se está modificando
						SELECT COUNT(*) INTO v_DomicilioExiste 
						FROM Domicilio 
						WHERE LOWER(Calle) = LOWER(p_Calle) 
						AND LOWER(Nro) = LOWER(p_Nro) 
						AND LOWER(Piso) = LOWER(p_Piso) 
						AND IdDomicilio != p_IdDomicilio;
						
						IF v_DomicilioExiste = 0 THEN
							-- Actualizar Domicilio existente
							UPDATE Domicilio 
							SET 
								IdTipoDomicilio = p_IdTipoDomicilio, 
								Calle = p_Calle, 
								Nro = p_Nro, 
								Piso = p_Piso 
							WHERE IdDomicilio = (SELECT IdDomicilio FROM Sucursal WHERE IdSucursal = p_IdSucursal);

							-- Actualizar Sucursal
							UPDATE Sucursal 
							SET 
								Descripcion = p_Descripcion, 
								IdUsuarioCarga = v_IdUsuarioCarga, 
								FechaBaja = NULL 
							WHERE IdSucursal = p_IdSucursal;

							SET v_Message = 'OK';
						ELSE
							SET v_Message = 'Ya existe un registro en Domicilio con los mismos datos.';
						END IF;
					ELSE 
						SET v_Message = 'La descripción ingresada ya está en uso.';
					END IF;
				ELSE 
					SET v_Message = 'No realizó ninguna modificación.';
				END IF;
			ELSE 
				SET v_Message = 'El registro está deshabilitado.';
			END IF;
		ELSE 
			SET v_Message = 'El Id de la sucursal no existe.';
		END IF;
    ELSE
        SET v_Message = 'Token Inválido';
    END IF;

    -- Devolver el mensaje
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_TipoCategoria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_TipoCategoria`(
	IN p_Id INT, 
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer text(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CountExistTipoCategoria INT;
    DECLARE v_CountExistDescripcion INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    SELECT COUNT(*) INTO v_CountExistTipoCategoria FROM TipoCategoria WHERE IdTipoCategoria = p_Id;
    SELECT COUNT(*) INTO v_CountExistDescripcion FROM TipoCategoria WHERE Descripcion = p_Descripcion;
    
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF v_CountExistDescripcion = 0 THEN
			IF v_CountExistTipoCategoria = 0 THEN
				SET v_Message = 'El TipoCategoria ingresado no existe.';
			ELSE
				IF (SELECT COUNT(*) FROM TipoCategoria WHERE IdTipoCategoria = p_Id AND Descripcion = p_Descripcion) = 0 THEN
					IF (SELECT COUNT(*) FROM TipoCategoria WHERE IdTipoCategoria = p_Id AND FechaBaja IS NOT NULL) = 0 THEN
						UPDATE TipoCategoria 
						SET Descripcion = p_Descripcion, FechaBaja = NULL 
						WHERE IdTipoCategoria = p_Id;
						SET v_Message = 'OK';
					ELSE 
						SET v_Message = 'El ID ingresado se encuentra inhabilitado.';
					END IF;
				ELSE 
					SET v_Message = 'La descripción ingresada ya existe.';
				END IF;
			END IF;
		ELSE 
			SET v_Message = 'La descripción ingresada ya existe.';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido.';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_TipoFormaDePago` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_TipoFormaDePago`(
	IN p_Id INT, 
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer text(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CountExistTipoFormaDePago INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    SELECT COUNT(*) INTO v_CountExistTipoFormaDePago FROM TipoFormaDePago WHERE IdTipoFormaDePago = p_Id;
    
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF v_CountExistTipoFormaDePago = 0 THEN
			SET v_Message = 'El TipoFormaDePago ingresado no existe.';
		ELSE
			IF (SELECT COUNT(*) FROM TipoFormaDePago WHERE IdTipoFormaDePago = p_Id AND Descripcion = p_Descripcion) = 0 THEN
				IF (SELECT COUNT(*) FROM TipoFormaDePago WHERE IdTipoFormaDePago = p_Id AND FechaBaja IS NOT NULL) = 0 THEN
					UPDATE TipoFormaDePago 
					SET Descripcion = p_Descripcion, FechaBaja = NULL 
					WHERE IdTipoFormaDePago = p_Id;
					SET v_Message = 'OK';
				ELSE 
					SET v_Message = 'El ID ingresado se encuentra inhabilitado.';
				END IF;
			ELSE 
				SET v_Message = 'La descripción ingresada ya existe.';
			END IF;
		END IF;
	ElSE
		SET v_Message = 'Token Inválido.';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_TipoImpuesto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_TipoImpuesto`(
	IN p_Id INT, 
    IN p_Descripcion VARCHAR(50),
    IN p_Porcentaje DECIMAL(18,2),
    IN p_UsuarioBearer text(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CountExistTipoImpuesto INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    SELECT COUNT(*) INTO v_CountExistTipoImpuesto FROM TipoAumento WHERE IdTipoAumento = p_Id;
    
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF p_Porcentaje > 500 THEN
			SET v_Message = 'El porcentaje ingresado es elevado.';
		ELSE
			IF v_CountExistTipoImpuesto = 0 THEN
				SET v_Message = 'El TipoAumento ingresado no existe.';
			ELSE
				IF (SELECT COUNT(*) FROM TipoAumento WHERE IdTipoAumento = p_Id AND Detalle = p_Descripcion AND Porcentaje = p_Porcentaje) = 0 THEN
					IF (SELECT COUNT(*) FROM TipoAumento WHERE IdTipoAumento = p_Id AND FechaBaja IS NOT NULL) = 0 THEN
						UPDATE TipoAumento 
						SET Detalle = p_Descripcion, Porcentaje = p_Porcentaje, FechaBaja = NULL 
						WHERE IdTipoAumento = p_Id;
						SET v_Message = 'OK';
					ELSE 
						SET v_Message = 'El ID ingresado se encuentra inhabilitado.';
					END IF;
				ELSE 
					SET v_Message = 'La descripción ingresada ya existe.';
				END IF;
			END IF;
		END IF;
	ElSE
		SET v_Message = 'Token Inválido.';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_TipoPersonaSistema` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_TipoPersonaSistema`(
	IN p_Id INT, 
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer text(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CountExistTipoPersonaSistema INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    SELECT COUNT(*) INTO v_CountExistTipoPersonaSistema FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = p_Id;
    
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF v_CountExistTipoPersonaSistema = 0 THEN
			SET v_Message = 'El TipoPersonaSistema ingresado no existe.';
		ELSE
			IF (SELECT COUNT(*) FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = p_Id AND Descripcion = p_Descripcion) = 0 THEN
				IF (SELECT COUNT(*) FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = p_Id AND FechaBaja IS NOT NULL) = 0 THEN
					UPDATE TipoPersonaSistema 
					SET Descripcion = p_Descripcion, FechaBaja = NULL 
					WHERE IdTipoPersonaSistema = p_Id;
					SET v_Message = 'OK';
				ELSE 
					SET v_Message = 'El ID ingresado se encuentra inhabilitado.';
				END IF;
			ELSE 
				SET v_Message = 'La descripción ingresada ya existe.';
			END IF;
		END IF;
	ElSE
		SET v_Message = 'Token Inválido.';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_TipoProducto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_TipoProducto`(
	IN p_Id INT, 
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer text(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CountExistTipoProducto INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    SELECT COUNT(*) INTO v_CountExistTipoProducto FROM TipoProducto WHERE IdTipoProducto = p_Id;
    
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF v_CountExistTipoProducto = 0 THEN
			SET v_Message = 'El TipoProducto ingresado no existe.';
		ELSE
			IF (SELECT COUNT(*) FROM TipoProducto WHERE IdTipoProducto = p_Id AND Detalle = p_Descripcion) = 0 THEN
				IF (SELECT COUNT(*) FROM TipoProducto WHERE IdTipoProducto = p_Id AND FechaBaja IS NOT NULL) = 0 THEN
					UPDATE TipoProducto 
					SET Detalle = p_Descripcion, FechaBaja = NULL 
					WHERE IdTipoProducto = p_Id;
					SET v_Message = 'OK';
				ELSE 
					SET v_Message = 'El ID ingresado se encuentra inhabilitado.';
				END IF;
			ELSE 
				SET v_Message = 'La descripción ingresada ya existe.';
			END IF;
		END IF;
	ElSE
		SET v_Message = 'Token Inválido.';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_TipoRol` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_TipoRol`(
	IN p_Id INT, 
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer text(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CountExistTipoRol INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    SELECT COUNT(*) INTO v_CountExistTipoRol FROM TipoRol WHERE IdTipoRol = p_Id;
    
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF v_CountExistTipoRol = 0 THEN
			SET v_Message = 'El TipoRol ingresado no existe.';
		ELSE
			IF (SELECT COUNT(*) FROM TipoRol WHERE IdTipoRol = p_Id AND Descripcion = p_Descripcion) = 0 THEN
				IF (SELECT COUNT(*) FROM TipoRol WHERE IdTipoRol = p_Id AND FechaBaja IS NOT NULL) = 0 THEN
					UPDATE TipoRol 
					SET Descripcion = p_Descripcion, FechaBaja = NULL 
					WHERE IdTipoRol = p_Id;
					SET v_Message = 'OK';
				ELSE 
					SET v_Message = 'El valor ingresado se encuentra inhabilitado.';
				END IF;
			ELSE 
				SET v_Message = 'El valor ingresado ya existe.';
			END IF;
		END IF;
	ElSE
		SET v_Message = 'Token Inválido.';
	END IF;
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_Usuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_Usuario`(
    IN id_usuario INT,           -- ID del usuario a modificar
    IN nuevo_usuario VARCHAR(45),-- Nuevo nombre de usuario
    IN nueva_clave VARCHAR(255), -- Nueva clave de acceso
    IN p_UsuarioBearer TEXT      -- Usuario Bearer token
)
BEGIN
    DECLARE usuario_existente INT;
    DECLARE clave_existente VARCHAR(255);
    DECLARE v_Message VARCHAR(255) DEFAULT '';
    DECLARE v_IdUsuarioCarga INT;

    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Verificar si el nuevo nombre de usuario ya está en uso
    SELECT COUNT(*) INTO usuario_existente 
    FROM Usuario 
    WHERE Usuario = nuevo_usuario 
      AND IdUsuario != id_usuario;

    IF usuario_existente > 0 THEN
        SET v_Message = 'El nuevo nombre de usuario ya está en uso.';
    ELSE
        IF NOT (nuevo_usuario REGEXP '[0-9]') THEN
            SET v_Message = 'El nuevo nombre de usuario debe contener al menos un número.';
        ELSE
            IF LENGTH(nuevo_usuario) < 8 THEN
                SET v_Message = 'El nuevo usuario debe tener al menos 8 caracteres.';
            ELSE
                -- Obtener la clave existente para el usuario
                SELECT Clave INTO clave_existente 
                FROM Usuario 
                WHERE IdUsuario = id_usuario;

                -- Verificar si se proporciona una nueva clave
                IF nueva_clave != '' THEN
                    -- Verificar que la nueva clave cumpla con los requisitos
                    IF LENGTH(nueva_clave) < 8 THEN
                        SET v_Message = 'La nueva contraseña debe tener al menos 8 caracteres.';
                    ELSEIF NOT (nueva_clave REGEXP '[[:upper:]]' AND nueva_clave REGEXP '[0-9]') THEN
                        SET v_Message = 'La nueva contraseña debe contener al menos una letra mayúscula y al menos un número.';
                    ELSE
                        -- Realizar la actualización si todas las validaciones son correctas
                        UPDATE Usuario
                        SET Usuario = nuevo_usuario, 
                            Clave = SHA2(nueva_clave, 256), 
                            IdUsuarioCarga = v_IdUsuarioCarga
                        WHERE IdUsuario = id_usuario;

                        SET v_Message = 'OK';
                    END IF;
                ELSE
                    -- Mantener la misma clave si no se proporciona una nueva
                    SET nueva_clave = clave_existente;

                    UPDATE Usuario
                    SET Usuario = nuevo_usuario, 
                        Clave = SHA2(nueva_clave, 256), 
                        IdUsuarioCarga = v_IdUsuarioCarga
                    WHERE IdUsuario = id_usuario;

                    SET v_Message = 'OK';
                END IF;
            END IF;
        END IF;
    END IF;

    -- Seleccionar el mensaje de salida
    SELECT v_Message;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPM_UsuarioPorSucursal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPM_UsuarioPorSucursal`(
    IN p_IdUsuario INT, 
    IN p_IdSucursal INT, 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_IdUsuarioExiste INT;
    DECLARE v_IdSucursalExiste INT;
    DECLARE v_IdUsuarioPorSucursal INT;
    DECLARE v_UsuarioActual INT;
    DECLARE v_SucursalActual INT;
    DECLARE v_Message VARCHAR(100);

    -- Obtener el IdUsuario desde el token Bearer
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    -- Verificar existencia del usuario y sucursal
    SELECT COUNT(*) INTO v_IdUsuarioExiste 
    FROM Usuario 
    WHERE IdUsuario = p_IdUsuario 
        AND FechaBaja IS NULL;

    SELECT COUNT(*) INTO v_IdSucursalExiste 
    FROM Sucursal 
    WHERE IdSucursal = p_IdSucursal 
        AND FechaBaja IS NULL;

    IF v_IdUsuarioExiste = 0 OR v_IdSucursalExiste = 0 THEN
        SET v_Message = 'El usuario o la sucursal ingresado no es válido.';
    ELSE
        -- Verificar si ya existe una relación válida en UsuarioPorSucursal
        SELECT IdUsuario, IdSucursal INTO v_UsuarioActual, v_SucursalActual
        FROM UsuarioPorSucursal 
        WHERE IdUsuario = p_IdUsuario 
		AND FechaBaja IS NULL;

        IF v_SucursalActual = p_IdSucursal THEN
                SET v_Message = 'El usuario ya pertenece a dicha sucursal.';
		ELSE
			-- Actualizar la relación existente a la nueva sucursal
			UPDATE `railway`.`UsuarioPorSucursal` 
			SET
				`IdSucursal` = p_IdSucursal,
				`FechaUltModificacion` = NOW()
			WHERE `IdUsuario` = p_IdUsuario 
			AND FechaBaja IS NULL;
			SET v_Message = 'OK';
		END IF;
        
        IF v_UsuarioActual IS NULL OR v_SucursalActual IS NULL THEN
			INSERT INTO `railway`.`UsuarioPorSucursal`
            (`IdUsuario`,`IdSucursal`,`FechaUltModificacion`,`FechaAlta`)
			VALUES(p_IdUsuario, p_IdSucursal, now(), now());

			SET v_Message = 'OK';
		END IF;
        
    END IF;

    -- Devolver el mensaje final
    SELECT v_Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SPP_ValidarBearer_API` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SPP_ValidarBearer_API`(
    IN Bearer VARCHAR(500),
    IN MethodConsume VARCHAR(255),
    IN RouteConsume VARCHAR(255)
)
BEGIN
    DECLARE Message VARCHAR(100);
    DECLARE Id INT;
    DECLARE IdUsuario INT;
    DECLARE TiempoToken INT;
    DECLARE PoseePermiso INT;

    -- Verificar el token
    SELECT UsuarioToken.IdUsuarioToken, UsuarioToken.IdUsuario INTO Id, IdUsuario
    FROM UsuarioToken
    WHERE UsuarioToken.Token = Bearer
    AND UsuarioToken.Activo = 1;

    -- Si existe la configuración de tiempo
    IF Id IS NOT NULL THEN        
		-- Verificar permisos
		SELECT count(*) INTO PoseePermiso
		FROM SistemaAPIs SisAPI
		JOIN SistemaModuloAPIs SisModApi ON SisAPI.IdSistemaAPIs = SisModApi.IdSistemasAPIs
		JOIN TipoModulo TipoMod ON SisModApi.IdTipoModulo = TipoMod.IdTipoModulo
		JOIN RolModulo RolMod ON RolMod.IdTipoModulo = TipoMod.IdTipoModulo
		JOIN UsuarioRol UsrRol ON UsrRol.IdTipoRol = RolMod.IdTipoRol
		JOIN TipoPermiso TipPer ON TipPer.IdTipoPermiso = RolMod.IdTipoPermiso
		JOIN TipoPermisoDetalle TipPerDet ON TipPerDet.IdTipoPermiso = TipPer.IdTipoPermiso
		WHERE SisAPI.Path = RouteConsume
		AND SisAPI.Method = MethodConsume
		AND TipPerDet.Method = MethodConsume
		AND SisAPI.FechaBaja IS NULL
		AND SisModApi.FechaBaja IS NULL
		AND TipoMod.FechaBaja IS NULL
		AND RolMod.FechaBaja IS NULL
		AND UsrRol.FechaBaja IS NULL
		AND UsrRol.IdUsuario = IdUsuario;

		IF PoseePermiso > 0 THEN
			-- Actualizar el tiempo de vida del token
			UPDATE UsuarioToken
			SET FechaCaducidad = DATE_ADD(NOW(), INTERVAL 20 MINUTE)
			WHERE IdUsuarioToken = Id;
			SET Message = 'Ok';
		ELSE
			SET Message = 'No posee permisos para realizar la acción';
		END IF;
    ELSE
        SET Message = 'Token inválido';
    END IF;

    SELECT Message AS Mensaje;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_GetImagenSubMenu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SP_GetImagenSubMenu`(
    IN p_RoutePath VARCHAR(100)
)
BEGIN
DECLARE v_count INT;
    DECLARE Mensaje VARCHAR(100);
    
    SELECT COUNT(*) INTO v_count
    FROM TipoModulo
    WHERE PathRout = p_RoutePath;
    IF v_count = 0 THEN
        SET Mensaje = 'No se encontró ninguna coincidencia.';
    ELSEIF v_count > 1 THEN
        SET Mensaje = 'Se encontraron múltiples coincidencias.';
    ELSE
        -- Si hay exactamente una coincidencia, hacer la selección
        SELECT 
            IdTipoModulo,
            TipoIcono,
            Icono
        FROM TipoModulo
        WHERE PathRout = p_RoutePath;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_GetMenu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SP_GetMenu`(
    IN p_bearer TEXT
)
BEGIN
    DECLARE v_Id INT;
    SET SQL_SAFE_UPDATES = 0;

    CREATE TEMPORARY TABLE Menues (
        IdTipoModulo INT,
        Orden VARCHAR(10),
        Detalle VARCHAR(100),
        PathRoute VARCHAR(100),
        TipoMenu INT,
        TipoIcono VARCHAR(100),
        Icono mediumblob,
        PoseePermiso INT
    );

    INSERT INTO Menues(IdTipoModulo, Orden, Detalle, PathRoute, TipoMenu, TipoIcono, Icono)
    SELECT IdTipoModulo, Orden, Detalle, PathRout, TipoMenu, TipoIcono, Icono
    FROM TipoModulo
    WHERE FechaBaja IS NULL AND IdPadre = 0;

    UPDATE Menues
    SET PathRoute = CONCAT('/', CAST(IdTipoModulo AS CHAR(10)), '/submenu')
    WHERE TipoMenu = 2;

	UPDATE Menues
	SET PoseePermiso = 1
	WHERE IdTipoModulo IN (
		SELECT D.IdTipoModulo
		FROM Persona AS E
		INNER JOIN Usuario AS F ON E.IdPersona = F.IdPersona
		INNER JOIN UsuarioToken AS T ON T.IdPersona = E.IdPersona
		INNER JOIN UsuarioRol AS UR ON UR.IdUsuario = F.IdUsuario
		INNER JOIN TipoRol AS TR ON TR.IdTipoRol = UR.IdTipoRol
		INNER JOIN RolModulo AS C ON C.IdTipoRol = TR.IdTipoRol
		INNER JOIN TipoModulo AS D ON D.IdTipoModulo = C.IdTipoModulo
		WHERE T.Token = p_bearer
		AND D.FechaBaja IS NULL
		AND D.PathRout IS NOT NULL
	);
    
    UPDATE Menues 
    SET PoseePermiso = 0
    WHERE PoseePermiso IS NULL;

    SELECT * FROM Menues;
	DROP TABLE IF EXISTS Menues;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_GetMenuUsuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SP_GetMenuUsuario`(
    IN p_IdPersona INT
)
BEGIN
    SELECT 
        B.Descripcion AS Rol,
        C.IdTipoPermiso AS Nivel,
        D.Detalle AS MenuDescripcion,
        D.PathRout AS MenuRutaHabilitada 
    FROM Persona AS E 
    INNER JOIN Usuario AS F ON E.IdPersona = F.IdPersona
    INNER JOIN UsuarioRol AS A ON E.IdPersona = A.IdUsuario
    INNER JOIN TipoRol AS B ON A.IdTipoRol = B.IdTipoRol
    INNER JOIN RolModulo AS C ON B.IdTipoRol = C.IdTipoRol
    INNER JOIN TipoModulo AS D ON C.IdTipoModulo = D.IdTipoModulo
    WHERE E.IdPersona = p_IdPersona
    AND D.PathRout IS NOT NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_GetSubMenu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SP_GetSubMenu`(
    IN p_bearer TEXT,
    IN p_IdMenu INT
)
BEGIN
    DECLARE v_Id INT;
	SET SQL_SAFE_UPDATES = 0;
    CREATE TEMPORARY TABLE Menues (
        Id INT,
        Orden VARCHAR(10),
        Detalle VARCHAR(100),
        PathRoute VARCHAR(100),
        TipoIcono VARCHAR(100),
        Icono MEDIUMBLOB,
        PoseePermiso INT
    );

    INSERT INTO Menues(Id, Orden, Detalle, PathRoute, TipoIcono, Icono)
    SELECT IdTipoModulo, Orden, Detalle, PathRout, TipoIcono, Icono
    FROM TipoModulo
    WHERE FechaBaja IS NULL AND IdPadre = p_IdMenu;

    UPDATE Menues
    SET PoseePermiso = 1
    WHERE Id IN (
        SELECT D.IdTipoModulo
        FROM Persona AS E
        INNER JOIN Usuario AS F ON E.IdPersona = F.IdPersona
        INNER JOIN UsuarioToken AS T ON T.IdPersona = E.IdPersona
        INNER JOIN UsuarioRol AS UR ON UR.IdUsuario = F.IdUsuario
        INNER JOIN TipoRol AS TR ON TR.IdTipoRol = UR.IdTipoRol
        INNER JOIN RolModulo AS C ON C.IdTipoRol = TR.IdTipoRol
        INNER JOIN TipoModulo AS D ON D.IdTipoModulo = C.IdTipoModulo
        WHERE T.Token = p_bearer
        AND D.FechaBaja IS NULL
        AND D.PathRout IS NOT NULL
    );

    UPDATE Menues 
    SET PoseePermiso = 0
    WHERE PoseePermiso IS NULL;

    SELECT * FROM Menues;
    DROP TEMPORARY TABLE IF EXISTS Menues;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_ListaPersonas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SP_ListaPersonas`()
BEGIN
	DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdPersona INT,
        NombrePersona VARCHAR(50)
    );

    INSERT INTO TempResultados (IdPersona, NombrePersona)
		SELECT IdPersona, 
		CONCAT(COALESCE(Nombre, ''), ' ', COALESCE(Apellido, '')) AS NombrePersona
		FROM Persona p
		WHERE FechaBaja IS NULL 
		AND IdTipoPersonaSistema = 1
        AND p.IdPersona NOT IN (SELECT u.IdPersona FROM Usuario u)
        AND p.Nombre IS NOT NULL
        AND p.Apellido IS NOT NULL
		ORDER BY NombrePersona;
	SELECT * FROM TempResultados;
    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_ListaUsuariosRol` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SP_ListaUsuariosRol`(IN p_IdUsuario INT)
BEGIN
	DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
		IdUsuarioRol INT,
        IdUsuario INT,
        IdTipoRol INT,
        Descripcion VARCHAR(50)
    );

    INSERT INTO TempResultados (IdUsuarioRol, IdUsuario, IdTipoRol, Descripcion)
		SELECT ur.IdUsuarioRol, ur.IdUsuario, ur.IdTipoRol, tp.Descripcion
		FROM UsuarioRol ur
        LEFT JOIN TipoRol tp ON tp.IdTipoRol = ur.IdTipoRol
		WHERE ur.IdUsuario = p_IdUsuario AND ur.FechaBaja IS NULL;
	SELECT * FROM TempResultados;
    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_SistemaAPIs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SP_SistemaAPIs`(
    IN Metodo VARCHAR(100),
    IN Nombre VARCHAR(100)
)
BEGIN
    SELECT IdSistemaAPIs, Detalle, Method, Path
    FROM cleandb.SistemaAPIs
    WHERE (Method = COALESCE(Metodo, Method)) 
    AND (Detalle LIKE CONCAT('%', COALESCE(Nombre, Detalle), '%'));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_SistemaModuloApis` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SP_SistemaModuloApis`(
    IN p_IdTipoModulo INT,
    IN p_Pagina INT,
    IN p_CantRegistros INT,
    IN p_TipoLista TINYINT
)
BEGIN
    DECLARE SkipRegistros INT;
    
    SET SkipRegistros = (p_Pagina - 1) * p_CantRegistros;

    IF p_TipoLista IN (1, 2, 3) THEN
        SELECT 
            a.IdSistemaModuloAPIs AS Id,
            a.IdTipoModulo,
            b.Detalle AS Modulo,
            a.IdSistemasAPIs AS IdSistemaAPIs,
            c.Detalle AS SistemaAPIs,
            c.Method AS Metodo,
            c.Path AS Ruta,
            (SELECT COUNT(*) FROM SistemaModuloApis WHERE IdTipoModulo = p_IdTipoModulo) AS CantRegistros
        FROM
            SistemaModuloApis a
        INNER JOIN
            TipoModulo b ON a.IdTipoModulo = b.IdTipoModulo
        INNER JOIN
            SistemaAPIs c ON a.IdSistemasAPIs = c.IdSistemaAPIs
        WHERE
            a.IdTipoModulo = COALESCE(p_IdTipoModulo, a.IdTipoModulo)
        ORDER BY
            a.IdSistemaModuloAPIs
        LIMIT SkipRegistros, p_CantRegistros;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_ValidarUsuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SP_ValidarUsuario`(IN p_usuario VARCHAR(45), IN p_clave VARCHAR(255), OUT p_resultado BOOLEAN)
BEGIN
    DECLARE v_count INT;
	DECLARE v_hashed_clave VARCHAR(255);
    -- Deshashear la contraseña proporcionada
    SET v_hashed_clave = SHA2(p_clave, 256);

    -- Verificar si el usuario y la contraseña coinciden en la tabla Usuario
    SELECT COUNT(*) INTO v_count
    FROM Usuario u
    JOIN Persona p ON u.IdPersona = p.IdPersona
    WHERE u.Usuario = p_usuario 
    AND u.Clave = v_hashed_clave
    AND u.FechaBaja IS NULL;

    -- Si el conteo es mayor que 0, significa que las credenciales son válidas
    IF v_count > 0 THEN
        SET p_resultado = TRUE;
    ELSE
        SET p_resultado = FALSE;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-13 21:28:39