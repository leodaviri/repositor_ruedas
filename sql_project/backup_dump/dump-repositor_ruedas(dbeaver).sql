-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: repositor_ruedas
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `asegurados`
--

DROP TABLE IF EXISTS `asegurados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asegurados` (
  `asegurado_id` int NOT NULL AUTO_INCREMENT,
  `asegurado_nombre` varchar(50) NOT NULL,
  `asegurado_apellido` varchar(50) NOT NULL,
  `asegurado_telefono` bigint DEFAULT NULL,
  `asegurado_mail` varchar(100) DEFAULT 'pendiente agendar mail',
  PRIMARY KEY (`asegurado_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1261 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Información básica de asegurados';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `asegurado_tel` AFTER INSERT ON `asegurados` FOR EACH ROW BEGIN
    -- Verifica si el campo asegurado_telefono está vacío
    IF NEW.asegurado_telefono IS NULL OR NEW.asegurado_telefono = '' THEN
        -- Lanza una advertencia con el mensaje especificado
        SIGNAL SQLSTATE '01000'
        SET MESSAGE_TEXT = 'Recuerde registrar un contacto telefónico';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ciudades`
--

DROP TABLE IF EXISTS `ciudades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ciudades` (
  `ciudad_id` int NOT NULL AUTO_INCREMENT,
  `ciudad_nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`ciudad_id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Ciudad en la que se ubica la casa central';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facturas`
--

DROP TABLE IF EXISTS `facturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facturas` (
  `factura_id` varchar(20) NOT NULL,
  `factura_tipo` varchar(10) NOT NULL COMMENT 'tipo de emisión de factura según cuit y monto',
  `factura_fecha` datetime DEFAULT (now()),
  `factura_pdv` int NOT NULL,
  `factura_nro` int NOT NULL,
  `rueda_item` int NOT NULL,
  `rueda_precio` decimal(10,0) NOT NULL,
  `rueda_cantidad` int NOT NULL DEFAULT '1',
  `factura_precio` decimal(10,0) NOT NULL,
  PRIMARY KEY (`factura_id`),
  KEY `fk_facturas_tipos` (`factura_tipo`),
  CONSTRAINT `fk_facturas_tipos` FOREIGN KEY (`factura_tipo`) REFERENCES `facturas_tipos` (`factura_tipo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tabla de hechos que describen datos de facturación y ruedas, NO ADMITE NULOS';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_factura_fecha` BEFORE INSERT ON `facturas` FOR EACH ROW BEGIN
    DECLARE siniestro_fecha DATETIME;

    -- Obtener la fecha del siniestro correspondiente
    SELECT siniestro_fecha INTO siniestro_fecha
    FROM siniestros
    WHERE siniestro_nro = NEW.factura_nro;

    -- Verificar si la fecha de la factura es anterior a la fecha del siniestro
    IF NEW.factura_fecha < siniestro_fecha THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de la factura no puede ser anterior a la fecha del siniestro.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `facturas_tipos`
--

DROP TABLE IF EXISTS `facturas_tipos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facturas_tipos` (
  `factura_tipo_id` varchar(10) NOT NULL DEFAULT 'FA',
  `factura_tipo_descripcion` varchar(100) NOT NULL,
  PRIMARY KEY (`factura_tipo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tipo de factura emitida según cuit y monto';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `licitadores`
--

DROP TABLE IF EXISTS `licitadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `licitadores` (
  `licitador_id` int NOT NULL AUTO_INCREMENT,
  `licitador_nombre` varchar(50) NOT NULL,
  `licitador_web` varchar(100) DEFAULT 'pendiente asigar web',
  PRIMARY KEY (`licitador_id`),
  UNIQUE KEY `licitador_nombre` (`licitador_nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Datos de utilidad sobre los entes licitadores';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `link_facturas_ruedas`
--

DROP TABLE IF EXISTS `link_facturas_ruedas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `link_facturas_ruedas` (
  `id_facturas` varchar(20) NOT NULL,
  `id_ruedas` int NOT NULL,
  `cantidad` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_facturas`,`id_ruedas`),
  KEY `fk_facturas_ruedas` (`id_ruedas`),
  CONSTRAINT `fk_facturas_ruedas` FOREIGN KEY (`id_ruedas`) REFERENCES `ruedas` (`rueda_id`),
  CONSTRAINT `fk_ruedas_facturas` FOREIGN KEY (`id_facturas`) REFERENCES `facturas` (`factura_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tabla vínculo entre facturas y ruedas';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log` (
  `id_log` int NOT NULL AUTO_INCREMENT,
  `tabla` varchar(100) NOT NULL COMMENT 'Nombre de la tabla afectada por el DML',
  `id_pk` varchar(100) NOT NULL COMMENT 'PK del registro modificado/insertado/eliminado',
  `usuario` varchar(100) NOT NULL COMMENT 'Nombre del usuario que ejecutó la alteración',
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  `operacion` varchar(10) NOT NULL COMMENT 'Tipo de operación: INSERT, UPDATE, DELETE',
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `marcas_cub`
--

DROP TABLE IF EXISTS `marcas_cub`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marcas_cub` (
  `marca_id` int NOT NULL,
  `marca_descripcion` varchar(50) NOT NULL,
  PRIMARY KEY (`marca_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Marca fabricante de la cubierta';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `marcas_veh`
--

DROP TABLE IF EXISTS `marcas_veh`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marcas_veh` (
  `marca_id` int NOT NULL AUTO_INCREMENT,
  `marca_nombre` varchar(50) DEFAULT 'Pendiente asignar marca',
  PRIMARY KEY (`marca_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Marca fabricante del vehículo';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modelos`
--

DROP TABLE IF EXISTS `modelos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modelos` (
  `modelo_id` int NOT NULL AUTO_INCREMENT,
  `modelo_descripcion` varchar(100) DEFAULT 'Pendiente asignar descripcion' COMMENT 'refiere a modelo, NO año de fabricación',
  PRIMARY KEY (`modelo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Especificaciones de modelo del vehículo';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `polizas`
--

DROP TABLE IF EXISTS `polizas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `polizas` (
  `poliza_id` int NOT NULL COMMENT 'número de póliza real según compañía',
  `poliza_tipo` varchar(50) NOT NULL DEFAULT 'falta asignar tipo de póliza',
  `cobertura` decimal(10,2) NOT NULL COMMENT 'porcentaje de cobertura',
  `asegurado` int NOT NULL,
  PRIMARY KEY (`poliza_id`),
  KEY `fk_polizas_asegurados` (`asegurado`),
  CONSTRAINT `fk_polizas_asegurados` FOREIGN KEY (`asegurado`) REFERENCES `asegurados` (`asegurado_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Información específica de pólizas según siniestros';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `provincias`
--

DROP TABLE IF EXISTS `provincias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provincias` (
  `provincia_id` int NOT NULL AUTO_INCREMENT,
  `provincia_nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`provincia_id`),
  UNIQUE KEY `provincia_nombre` (`provincia_nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Provincia en la que se ubica la casa central';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ruedas`
--

DROP TABLE IF EXISTS `ruedas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ruedas` (
  `rueda_id` int NOT NULL AUTO_INCREMENT,
  `rueda_descripcion` varchar(50) NOT NULL DEFAULT 'pendiente asignar descripcion',
  `cubierta_marca` int NOT NULL,
  `rodado_llanta` int NOT NULL,
  PRIMARY KEY (`rueda_id`),
  KEY `fk_ruedas_marcas` (`cubierta_marca`),
  CONSTRAINT `fk_ruedas_marcas` FOREIGN KEY (`cubierta_marca`) REFERENCES `marcas_cub` (`marca_id`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Características básicas de la rueda a reponer';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguros`
--

DROP TABLE IF EXISTS `seguros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seguros` (
  `seguro_id` varchar(20) NOT NULL COMMENT 'número de CUIT con guiones',
  `seguro_nombre` varchar(100) NOT NULL COMMENT 'razón social',
  `seguro_alias` varchar(50) NOT NULL COMMENT 'nombre resumido o comercial',
  `seguro_ciudad` int NOT NULL,
  `seguro_provincia` int NOT NULL,
  `seguro_web` varchar(100) DEFAULT NULL,
  `seguro_telefono` bigint NOT NULL COMMENT 'requiere siempre un télefono de contacto',
  `seguro_mail` varchar(100) DEFAULT 'pendiente asignar mail',
  PRIMARY KEY (`seguro_id`),
  UNIQUE KEY `seguro_nombre` (`seguro_nombre`),
  UNIQUE KEY `seguro_alias` (`seguro_alias`),
  UNIQUE KEY `seguro_web` (`seguro_web`),
  UNIQUE KEY `seguro_mail` (`seguro_mail`),
  KEY `fk_seguros_ciudades` (`seguro_ciudad`),
  KEY `fk_seguros_provincias` (`seguro_provincia`),
  CONSTRAINT `fk_seguros_ciudades` FOREIGN KEY (`seguro_ciudad`) REFERENCES `ciudades` (`ciudad_id`),
  CONSTRAINT `fk_seguros_provincias` FOREIGN KEY (`seguro_provincia`) REFERENCES `provincias` (`provincia_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Información de contacto y ubicación de las companías de seguros';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `siniestros`
--

DROP TABLE IF EXISTS `siniestros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `siniestros` (
  `siniestro_id` int NOT NULL AUTO_INCREMENT,
  `siniestro_nro` bigint NOT NULL COMMENT 'número de siniestro real según compañía',
  `siniestro_fecha` datetime NOT NULL,
  `factura_nro` varchar(10) DEFAULT 'Pendiente',
  `siniestro_tipo` varchar(50) NOT NULL,
  `cantidad_ruedas` int NOT NULL,
  `seguro_cia` varchar(20) NOT NULL,
  `poliza_nro` int NOT NULL COMMENT 'número de póliza real según compañía',
  `licitador` int NOT NULL,
  `vehiculo` int NOT NULL,
  `observaciones` text COMMENT 'para especificaciones puntuales y necesarias',
  PRIMARY KEY (`siniestro_id`),
  KEY `fk_siniestros_facturas` (`siniestro_tipo`),
  KEY `fk_siniestros_seguros` (`seguro_cia`),
  KEY `fk_siniestros_polizas` (`poliza_nro`),
  KEY `fk_siniestros_licitadores` (`licitador`),
  KEY `fk_siniestros_vehiculos` (`vehiculo`),
  KEY `fk_siniestro_facturas` (`factura_nro`),
  CONSTRAINT `fk_siniestro_facturas` FOREIGN KEY (`factura_nro`) REFERENCES `facturas` (`factura_id`),
  CONSTRAINT `fk_siniestro_tipo` FOREIGN KEY (`siniestro_tipo`) REFERENCES `tipos_siniestros` (`siniestro_tipo_id`),
  CONSTRAINT `fk_siniestros_licitadores` FOREIGN KEY (`licitador`) REFERENCES `licitadores` (`licitador_id`),
  CONSTRAINT `fk_siniestros_polizas` FOREIGN KEY (`poliza_nro`) REFERENCES `polizas` (`poliza_id`),
  CONSTRAINT `fk_siniestros_seguros` FOREIGN KEY (`seguro_cia`) REFERENCES `seguros` (`seguro_id`),
  CONSTRAINT `fk_siniestros_vehiculos` FOREIGN KEY (`vehiculo`) REFERENCES `vehiculos` (`vehiculo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1263 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tabla de hechos destinada a asignar los casos por siniestros, NO ADMITE NULOS';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cant_x_siniestro` AFTER INSERT ON `siniestros` FOR EACH ROW BEGIN
    -- Verifica si la cantidad de ruedas supera 5
    IF NEW.cantidad_ruedas > 5 THEN
        -- Lanza un error con el mensaje especificado
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad de ruedas no puede superar las 5 unidades';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `siniestros_insert_log` AFTER INSERT ON `siniestros` FOR EACH ROW BEGIN
    INSERT INTO log (tabla, id_pk, usuario, operacion)
    VALUES ('siniestros', NEW.siniestro_id, USER(), 'INSERT');
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `siniestros_update_log` AFTER UPDATE ON `siniestros` FOR EACH ROW BEGIN
    INSERT INTO log (tabla, id_pk, usuario, operacion)
    VALUES ('siniestros', NEW.siniestro_id, USER(), 'UPDATE');
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `siniestros_delete_log` AFTER DELETE ON `siniestros` FOR EACH ROW BEGIN
    INSERT INTO log (tabla, id_pk, usuario, operacion)
    VALUES ('siniestros', OLD.siniestro_id, USER(), 'DELETE');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tipos_siniestros`
--

DROP TABLE IF EXISTS `tipos_siniestros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_siniestros` (
  `siniestro_tipo_id` varchar(50) NOT NULL,
  `siniestro_tipo_descripcion` varchar(100) NOT NULL DEFAULT 'pendiente descripción',
  PRIMARY KEY (`siniestro_tipo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Especifica el tipo de siniestro, puntualmente posición de rueda sustraída';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `utilidades`
--

DROP TABLE IF EXISTS `utilidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilidades` (
  `utilidad_id` int NOT NULL AUTO_INCREMENT,
  `utilidad_descripcion` varchar(100) NOT NULL DEFAULT 'pendiente asignar utilidad',
  PRIMARY KEY (`utilidad_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Especificaciones de uso del vehículo';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vehiculos`
--

DROP TABLE IF EXISTS `vehiculos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehiculos` (
  `vehiculo_id` int NOT NULL AUTO_INCREMENT,
  `vehiculo_marca` int NOT NULL,
  `vehiculo_modelo` int NOT NULL,
  `vehiculo_utilidad` int NOT NULL,
  PRIMARY KEY (`vehiculo_id`),
  KEY `fk_vehiculos_marcas_veh` (`vehiculo_marca`),
  KEY `fk_vehiculos_modelos` (`vehiculo_modelo`),
  KEY `fk_vehiculo_utilidades` (`vehiculo_utilidad`),
  CONSTRAINT `fk_vehiculo_utilidades` FOREIGN KEY (`vehiculo_utilidad`) REFERENCES `utilidades` (`utilidad_id`),
  CONSTRAINT `fk_vehiculos_marcas_veh` FOREIGN KEY (`vehiculo_marca`) REFERENCES `marcas_veh` (`marca_id`),
  CONSTRAINT `fk_vehiculos_modelos` FOREIGN KEY (`vehiculo_modelo`) REFERENCES `modelos` (`modelo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Conecta con las tablas categóricas marca, modelo y utilidad';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `view_cia_prom`
--

DROP TABLE IF EXISTS `view_cia_prom`;
/*!50001 DROP VIEW IF EXISTS `view_cia_prom`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_cia_prom` AS SELECT 
 1 AS `Compania`,
 1 AS `Promedio_orden`,
 1 AS `Ultimo_mes`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_reincidencias`
--

DROP TABLE IF EXISTS `view_reincidencias`;
/*!50001 DROP VIEW IF EXISTS `view_reincidencias`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_reincidencias` AS SELECT 
 1 AS `Poliza`,
 1 AS `Reincidencias`,
 1 AS `Asegurado`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_ruedas`
--

DROP TABLE IF EXISTS `view_ruedas`;
/*!50001 DROP VIEW IF EXISTS `view_ruedas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_ruedas` AS SELECT 
 1 AS `Cantidad`,
 1 AS `Llanta`,
 1 AS `Marca_cubierta`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_siniestros_vehiculos`
--

DROP TABLE IF EXISTS `view_siniestros_vehiculos`;
/*!50001 DROP VIEW IF EXISTS `view_siniestros_vehiculos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_siniestros_vehiculos` AS SELECT 
 1 AS `Suma_siniestros`,
 1 AS `Modelo`,
 1 AS `Marca`,
 1 AS `Cant_ruedas`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_taxes`
--

DROP TABLE IF EXISTS `view_taxes`;
/*!50001 DROP VIEW IF EXISTS `view_taxes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_taxes` AS SELECT 
 1 AS `Mes`,
 1 AS `IVA_21`,
 1 AS `IIBB`,
 1 AS `Provincia`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_vehiculos`
--

DROP TABLE IF EXISTS `view_vehiculos`;
/*!50001 DROP VIEW IF EXISTS `view_vehiculos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_vehiculos` AS SELECT 
 1 AS `Marca`,
 1 AS `Modelo`,
 1 AS `Utilidad`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'repositor_ruedas'
--

--
-- Dumping routines for database 'repositor_ruedas'
--
/*!50003 DROP FUNCTION IF EXISTS `cant_x_cia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `cant_x_cia`(seguro_alias_param VARCHAR(50)) RETURNS int
    NO SQL
    DETERMINISTIC
BEGIN
    DECLARE total_cantidad INT;

    -- Calcula la suma de cantidad de ruedas para cada seguro
    SELECT SUM(s.cantidad_ruedas)
    INTO total_cantidad
    FROM siniestros AS s
    JOIN seguros AS e
		ON s.seguro_cia = e.seguro_id
    WHERE e.seguro_alias = seguro_alias_param;

    RETURN total_cantidad;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ganancia_neta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `ganancia_neta`(precio DECIMAL(10,2)) RETURNS varchar(20) CHARSET utf8mb4
    NO SQL
    DETERMINISTIC
BEGIN
    DECLARE ganancia DECIMAL(10,2);
    DECLARE resultado VARCHAR(20);
    
    -- Calcular la ganancia
    SET ganancia = precio * 0.79 * 0.03;
    
    -- Convertir el resultado a un formato con coma como separador decimal
    SET resultado = REPLACE(FORMAT(ganancia, 2), '.', ',');
    
    -- Añadir el signo de dólar al principio
    SET resultado = CONCAT('$', resultado);
    
    RETURN resultado;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `porcent_licitador` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `porcent_licitador`(licitador_nombre VARCHAR(50)) RETURNS varchar(10) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE total_siniestros INT;
    DECLARE licitador_count INT;
    DECLARE percentage DECIMAL(5,2);
    DECLARE result VARCHAR(10);

    -- Contar el total de siniestros
    SELECT COUNT(*)
    INTO total_siniestros
    FROM siniestros;

    -- Contar la cantidad de veces que aparece el licitador especificado
    SELECT COUNT(*)
    INTO licitador_count
    FROM siniestros sin
    JOIN licitadores lic ON sin.licitador = lic.licitador_id
    WHERE lic.licitador_nombre = licitador_nombre;

    -- Calcular el porcentaje
    SET percentage = (licitador_count / total_siniestros) * 100;

    -- Formatear el resultado
    SET result = CONCAT(FORMAT(percentage, 2), '%');

    RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `agregar_factura` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_factura`(
    IN p_siniestro_id INT,
    IN p_factura_tipo VARCHAR(10),
    IN p_factura_pdv INT,
    IN p_factura_nro INT,
    IN p_rueda_item INT,
    IN p_rueda_precio DECIMAL(10, 2),
    IN p_rueda_cantidad INT
)
BEGIN
    DECLARE v_siniestro_existente INT;
    DECLARE v_factura_id VARCHAR(20);
    DECLARE v_factura_precio DECIMAL(10, 2);

    -- Verificar si el siniestro existe y si el campo factura_nro es 'Pendiente'
    SELECT COUNT(*) INTO v_siniestro_existente
    FROM siniestros
    WHERE siniestro_id = p_siniestro_id AND factura_nro = 'Pendiente';

    IF v_siniestro_existente = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Siniestro inexistente, por favor corrobore';
    ELSE
        -- Construir el ID de la factura
        SET v_factura_id = CONCAT(p_factura_tipo, '-', p_factura_pdv, '-', p_factura_nro);

        -- Validar campos de entrada
        IF p_factura_tipo IS NULL OR p_factura_tipo = '' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe asignar tipo de factura';
        ELSEIF p_factura_pdv IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe indicar punto de venta';
        ELSEIF p_factura_nro IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe asignar nro de factura';
        ELSEIF p_rueda_item IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe indicar item de rueda';
        ELSEIF p_rueda_precio IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe asignar precio a la rueda';
        ELSE
            -- Calcular el precio total de la factura
            SET v_factura_precio = p_rueda_precio * p_rueda_cantidad;

            -- Insertar nueva factura en la tabla facturas
            INSERT INTO facturas (
                factura_id,
                factura_tipo,
                factura_fecha,
                factura_pdv,
                factura_nro,
                rueda_item,
                rueda_precio,
                rueda_cantidad,
                factura_precio
            )
            VALUES (
                v_factura_id,
                p_factura_tipo,
                CURRENT_TIMESTAMP,
                p_factura_pdv,
                p_factura_nro,
                p_rueda_item,
                p_rueda_precio,
                p_rueda_cantidad,
                v_factura_precio
            );

            -- Actualizar el campo factura_nro en la tabla siniestros
            UPDATE siniestros
            SET factura_nro = v_factura_id
            WHERE siniestro_id = p_siniestro_id;

            -- Insertar en la tabla link_facturas_ruedas
            INSERT INTO link_facturas_ruedas (
                id_facturas,
                id_ruedas,
                cantidad
            )
            VALUES (
                v_factura_id,
                p_rueda_item,
                p_rueda_cantidad
            );

            -- Mostrar el último registro insertado en la tabla facturas
            SELECT * FROM facturas
            ORDER BY factura_fecha DESC
            LIMIT 1;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `agregar_vehiculo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_vehiculo`(
    IN p_marca_nombre VARCHAR(50),
    IN p_modelo_descripcion VARCHAR(100),
    IN p_utilidad_descripcion VARCHAR(100)
)
BEGIN
    DECLARE v_marca_id INT;
    DECLARE v_modelo_id INT;
    DECLARE v_utilidad_id INT;
    DECLARE v_vehiculo_id INT;
    
    -- Insertar o obtener marca_id
    INSERT INTO marcas_veh (marca_nombre)
    VALUES (p_marca_nombre)
    ON DUPLICATE KEY UPDATE marca_id = LAST_INSERT_ID(marca_id);
    SET v_marca_id = LAST_INSERT_ID();
    
    -- Insertar o obtener modelo_id
    INSERT INTO modelos (modelo_descripcion)
    VALUES (p_modelo_descripcion)
    ON DUPLICATE KEY UPDATE modelo_id = LAST_INSERT_ID(modelo_id);
    SET v_modelo_id = LAST_INSERT_ID();
    
    -- Insertar o obtener utilidad_id
    INSERT INTO utilidades (utilidad_descripcion)
    VALUES (p_utilidad_descripcion)
    ON DUPLICATE KEY UPDATE utilidad_id = LAST_INSERT_ID(utilidad_id);
    SET v_utilidad_id = LAST_INSERT_ID();
    
    -- Insertar en la tabla vehiculos
    INSERT INTO vehiculos (vehiculo_marca, vehiculo_modelo, vehiculo_utilidad)
    VALUES (v_marca_id, v_modelo_id, v_utilidad_id);
    SET v_vehiculo_id = LAST_INSERT_ID();
    
    -- Devolver los IDs insertados o actualizados
    SELECT v_vehiculo_id AS vehiculo_id, v_marca_id AS marca_id, 
           v_modelo_id AS modelo_id, v_utilidad_id AS utilidad_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `exportar_tablas_a_csv` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `exportar_tablas_a_csv`()
BEGIN
  DECLARE tabla VARCHAR(100);
  DECLARE done INT DEFAULT FALSE;
  DECLARE cursor_tablas CURSOR FOR 
    SELECT table_name 
    FROM information_schema.tables 
    WHERE table_schema = DATABASE();
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cursor_tablas;

  read_loop: LOOP
    FETCH cursor_tablas INTO tabla;
    IF done THEN
      LEAVE read_loop;
    END IF;

    SET @sql = CONCAT(
      'SELECT * INTO OUTFILE ''', 
      '/var/lib/mysql-files/', -- Directorio seguro para exportación
      tabla, 
      '.csv'' FIELDS TERMINATED BY '','' ENCLOSED BY ''"'' LINES TERMINATED BY ''\n'' FROM ', 
      tabla
    );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END LOOP;
  
  CLOSE cursor_tablas;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ingreso_siniestro` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ingreso_siniestro`(
IN p_siniestro_nro BIGINT,
IN p_siniestro_fecha DATETIME,
IN p_siniestro_tipo VARCHAR(50),
IN p_cantidad_ruedas INT,
IN p_seguro_cia VARCHAR(20),
IN p_poliza_nro INT,
IN p_licitador INT,
IN p_vehiculo INT,
IN p_observaciones TEXT)
BEGIN
-- Determinamos validaciones con mensajes de errores
IF p_siniestro_nro IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Debe completar nro de siniestro';
END IF;

IF p_seguro_cia IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Debe asignar una companía de seguro';
END IF;

IF p_poliza_nro IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Debe completar el nro de póliza';
END IF;

IF p_licitador IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Debe asignar un ente licitador';
END IF;

IF p_vehiculo IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Debe indicar un vehículo';
END IF;

-- Si la fecha no se proporciona, usamos la fecha actual
IF p_siniestro_fecha IS NULL THEN
SET p_siniestro_fecha = CURRENT_TIMESTAMP();
END IF;
    
-- Determinamos campos para insertar nuevo registro
INSERT INTO siniestros (
siniestro_nro, siniestro_fecha, siniestro_tipo, cantidad_ruedas,
seguro_cia, poliza_nro, licitador, vehiculo, observaciones)
VALUES (
p_siniestro_nro, p_siniestro_fecha, p_siniestro_tipo, p_cantidad_ruedas,
p_seguro_cia, p_poliza_nro, p_licitador, p_vehiculo, IFNULL(p_observaciones, '')
);

-- Mostramos el último registro insertado
SELECT * FROM siniestros
ORDER BY siniestro_fecha DESC
LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `view_cia_prom`
--

/*!50001 DROP VIEW IF EXISTS `view_cia_prom`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_cia_prom` AS select `sg`.`seguro_alias` AS `Compania`,avg(`f`.`factura_precio`) AS `Promedio_orden`,date_format(max(`f`.`factura_fecha`),'%M') AS `Ultimo_mes` from ((`seguros` `sg` join `siniestros` `s` on((`sg`.`seguro_id` = `s`.`seguro_cia`))) join `facturas` `f` on((`s`.`factura_nro` = `f`.`factura_id`))) group by `Compania` order by `Promedio_orden` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_reincidencias`
--

/*!50001 DROP VIEW IF EXISTS `view_reincidencias`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_reincidencias` AS select `s`.`poliza_nro` AS `Poliza`,count(0) AS `Reincidencias`,concat(`a`.`asegurado_nombre`,' ',`a`.`asegurado_apellido`) AS `Asegurado` from ((`siniestros` `s` join `polizas` `p` on((`s`.`poliza_nro` = `p`.`poliza_id`))) join `asegurados` `a` on((`p`.`asegurado` = `a`.`asegurado_id`))) group by `Poliza`,`p`.`asegurado` having (count(0) >= 2) order by `Reincidencias` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_ruedas`
--

/*!50001 DROP VIEW IF EXISTS `view_ruedas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_ruedas` AS select sum(`f`.`rueda_cantidad`) AS `Cantidad`,`r`.`rodado_llanta` AS `Llanta`,`m`.`marca_descripcion` AS `Marca_cubierta` from ((`facturas` `f` join `ruedas` `r` on((`f`.`rueda_item` = `r`.`rueda_id`))) join `marcas_cub` `m` on((`r`.`cubierta_marca` = `m`.`marca_id`))) group by `Llanta`,`Marca_cubierta` order by `Cantidad` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_siniestros_vehiculos`
--

/*!50001 DROP VIEW IF EXISTS `view_siniestros_vehiculos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_siniestros_vehiculos` AS select count(`s`.`siniestro_id`) AS `Suma_siniestros`,`mo`.`modelo_descripcion` AS `Modelo`,`mv`.`marca_nombre` AS `Marca`,sum(`s`.`cantidad_ruedas`) AS `Cant_ruedas` from (((`siniestros` `s` join `vehiculos` `v` on((`s`.`vehiculo` = `v`.`vehiculo_id`))) join `modelos` `mo` on((`v`.`vehiculo_modelo` = `mo`.`modelo_id`))) join `marcas_veh` `mv` on((`v`.`vehiculo_marca` = `mv`.`marca_id`))) group by `Modelo`,`Marca` order by `Suma_siniestros` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_taxes`
--

/*!50001 DROP VIEW IF EXISTS `view_taxes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_taxes` AS select date_format(`f`.`factura_fecha`,'%M') AS `Mes`,sum((`f`.`factura_precio` * 0.21)) AS `IVA_21`,sum((`f`.`factura_precio` * 0.03)) AS `IIBB`,`p`.`provincia_nombre` AS `Provincia` from (((`facturas` `f` join `siniestros` `s` on((`f`.`factura_id` = `s`.`factura_nro`))) join `seguros` `se` on((`s`.`seguro_cia` = `se`.`seguro_id`))) join `provincias` `p` on((`se`.`seguro_provincia` = `p`.`provincia_id`))) group by `Mes`,`Provincia` order by `IVA_21` desc limit 10 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_vehiculos`
--

/*!50001 DROP VIEW IF EXISTS `view_vehiculos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_vehiculos` AS select `mv`.`marca_nombre` AS `Marca`,`m`.`modelo_descripcion` AS `Modelo`,`u`.`utilidad_descripcion` AS `Utilidad` from (((`vehiculos` `v` join `marcas_veh` `mv` on((`v`.`vehiculo_marca` = `mv`.`marca_id`))) join `modelos` `m` on((`v`.`vehiculo_modelo` = `m`.`modelo_id`))) join `utilidades` `u` on((`v`.`vehiculo_utilidad` = `u`.`utilidad_id`))) order by `mv`.`marca_nombre`,`m`.`modelo_descripcion`,`u`.`utilidad_descripcion` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-08-20  0:34:10
