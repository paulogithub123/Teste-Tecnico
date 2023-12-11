-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: pedido
-- ------------------------------------------------------
-- Server version	5.7.29-log

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
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `CODIGO_CLI` int(11) NOT NULL AUTO_INCREMENT,
  `NOME_CLI` varchar(100) DEFAULT NULL,
  `CIDADE_CLI` varchar(80) DEFAULT NULL,
  `UF_CLI` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`CODIGO_CLI`),
  KEY `CODIGO_CLI` (`CODIGO_CLI`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'Marlon','Guariba','SP'),(2,'Maria','Jaboticabal','SP'),(3,'Magno','Araraquara','SP'),(4,'Miriam','Guariba','SP'),(5,'Jorge','Matão','SP'),(6,'Carla','Jaboticabal','SP'),(7,'Evandro','Sertãozinho','SP'),(8,'Lira','Sertãozinho','SP'),(9,'Vanessa','Araraquara','SP'),(10,'Rose','Matão','SP'),(11,'Claudio','Guariba','SP'),(12,'Matheus','Pradópolis','SP'),(13,'Aline','Guariba','SP'),(14,'Silvia','Ribeirão Preto','SP'),(15,'João','Ribeirão Preto','SP'),(16,'Renan','Pradópolis','SP'),(17,'Joyce','Guariba','SP'),(18,'Luciana','Ribeirão Preto','SP'),(19,'Sandra','Guariba','SP'),(20,'Marcos','Jaboticabal','SP');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-08 13:17:30
