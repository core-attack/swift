-- MySQL dump 10.13  Distrib 5.1.49, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: swift_development
-- ------------------------------------------------------
-- Server version	5.1.49-3-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `swift_development`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `swift_development` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `swift_development`;

--
-- Table structure for table `accesses`
--

DROP TABLE IF EXISTS `accesses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accesses` (
  `read_only` tinyint(1) DEFAULT '0',
  `accessible_id` int(11) NOT NULL,
  `accessible_type` varchar(255) NOT NULL,
  `account_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`accessible_id`,`accessible_type`,`account_id`),
  UNIQUE KEY `unique_accesses_key` (`accessible_id`,`accessible_type`),
  KEY `index_accesses_account` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accesses`
--

LOCK TABLES `accesses` WRITE;
/*!40000 ALTER TABLE `accesses` DISABLE KEYS */;
/*!40000 ALTER TABLE `accesses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `surname` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `crypted_password` varchar(70) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `uid` varchar(255) DEFAULT NULL,
  `group_id` int(11) DEFAULT '6',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'admin','group','admin@localhost','$2a$10$sG1P2w41TQQxv21vZCR6YOoWSuX4xGBU91VzbsTWv/rC24paKBz.m',NULL,NULL,NULL),(2,'designer','group','designer@localhost','$2a$10$cHhWYvttbVIlg5/FhY718OJb6t8RZhJ3Af7kifs6lT3DYzuOhqhdy',NULL,NULL,NULL),(3,'auditor','group','auditor@localhost','$2a$10$PU2f4H75EbAlf87hEwTTD.bTzJPNAeX7UU/Hzo.U.oLWC3/W9zbLa',NULL,NULL,NULL),(4,'editor','group','editor@localhost','$2a$10$eiKO4ObMJ8LhlA79vVzBgePy7sabRe8xM3vY.f9oKv.cZWW3fu9jq',NULL,NULL,NULL),(5,'robot','group','robot@localhost','$2a$10$aO8eg1wRJV7pbxQ43xNrS.gkF206B/CCsHmlTxoLCRf79zX3Mx4/a',NULL,NULL,NULL),(6,'user','group','user@localhost','$2a$10$mY6GFR6PKUjjDnKP8V5MROS8wP8khzAWXa97g5G5CKLPRHE8KVZRe',NULL,NULL,NULL);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assets`
--

DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `folder_id` int(11) DEFAULT '2',
  `created_by_id` int(10) unsigned DEFAULT NULL,
  `updated_by_id` int(10) unsigned DEFAULT NULL,
  `file_content_type` varchar(63) DEFAULT NULL,
  `file_size` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_assets_created_by` (`created_by_id`),
  KEY `index_assets_updated_by` (`updated_by_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (1,'Устав предприятия','120224144857_Устав_предприятия.pdf','2012-02-24 14:48:57','2012-03-11 12:30:40',3,1,1,'application/pdf',1954928),(2,'Приказ о назначении генерального директора','120224144904_Приказ_о_назначении_генерального_директора.rar','2012-02-24 14:49:04','2012-03-11 12:30:47',3,1,1,'application/x-rar',103927),(3,'Реестр выданных сертификатов','120229150234_Реестр_выданных_сертификатов.pdf','2012-02-29 15:02:34','2012-03-11 12:30:51',3,1,1,'application/pdf',732789),(4,'Образец заявки на сертификацию соответствия','120229150239_Образец_заявки_на_сертификацию_соответствия.doc','2012-02-29 15:02:39','2012-03-11 12:30:55',3,1,1,'application/msword',29696),(21,'Стандарты раскрытия информации (план 2011)','120319153519_1302066798.xls','2012-03-19 15:35:19','2012-03-19 15:35:38',3,NULL,1,'application/vnd.ms-excel',701952),(22,'Стандарты раскрытия информации (Факт 2010)','120319153519_1302066799.xls','2012-03-19 15:35:19','2012-03-19 15:35:49',3,NULL,1,'application/vnd.ms-excel',701952),(23,'Стандарты раскрытия информациии 2012','120319153519_1318238896.xls','2012-03-19 15:35:19','2012-03-19 15:36:05',3,NULL,1,'application/vnd.ms-excel',694784),(24,'Отзыв заместителя министра строительства, архитектуры и жилищной политики Удмуртской республики, Сивцова А.Н., о работе ГУП «ТПО ЖКХ УР»','120321152532_1110360447.zip','2012-03-21 15:25:32','2012-03-21 15:25:32',6,NULL,NULL,'application/zip',194358);
/*!40000 ALTER TABLE `assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blocks`
--

DROP TABLE IF EXISTS `blocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blocks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `text` text,
  `slug` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by_id` int(10) unsigned DEFAULT NULL,
  `updated_by_id` int(10) unsigned DEFAULT NULL,
  `folder_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_blocks_created_by` (`created_by_id`),
  KEY `index_blocks_updated_by` (`updated_by_id`),
  KEY `index_blocks_folder` (`folder_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blocks`
--

LOCK TABLES `blocks` WRITE;
/*!40000 ALTER TABLE `blocks` DISABLE KEYS */;
INSERT INTO `blocks` VALUES (2,'Адрес','Почтовый адрес: 426069, ул. Песочная, 9, г. Ижевск, Удмуртская Республика\r\nТел.: 59-88-49, Факс: 58-61-91\r\ne-mail: office@tpo.udcom.ru\r\n','address','2012-03-21 14:32:18','2012-03-21 14:32:18',1,1,NULL);
/*!40000 ALTER TABLE `blocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bonds`
--

DROP TABLE IF EXISTS `bonds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bonds` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `parent_model` varchar(31) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `child_model` varchar(31) DEFAULT NULL,
  `child_id` int(11) DEFAULT NULL,
  `relation` int(11) DEFAULT '1',
  `manual` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bonds`
--

LOCK TABLES `bonds` WRITE;
/*!40000 ALTER TABLE `bonds` DISABLE KEYS */;
INSERT INTO `bonds` VALUES (12,'2012-03-26 15:02:46','2012-03-26 15:02:46','Page',63,'Folder',5,1,1),(13,'2012-03-26 15:02:46','2012-03-26 15:02:46','Page',63,'Image',92,1,1);
/*!40000 ALTER TABLE `bonds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `folders`
--

DROP TABLE IF EXISTS `folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `folders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `created_by_id` int(10) unsigned DEFAULT NULL,
  `updated_by_id` int(10) unsigned DEFAULT NULL,
  `account_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_folders_created_by` (`created_by_id`),
  KEY `index_folders_updated_by` (`updated_by_id`),
  KEY `index_folders_account` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folders`
--

LOCK TABLES `folders` WRITE;
/*!40000 ALTER TABLE `folders` DISABLE KEYS */;
INSERT INTO `folders` VALUES (1,'Layout graphics','2012-02-24 14:47:35','2012-02-24 14:47:35','images',NULL,NULL,NULL),(2,'Common files','2012-02-24 14:47:35','2012-02-24 14:47:35','files',NULL,NULL,NULL),(3,'Официальные документы','2012-03-02 14:48:56','2012-03-02 14:48:56','official',1,1,1),(4,'Котлы','2012-03-11 12:37:46','2012-03-11 12:38:30','boiler',1,1,1),(5,'Фотогалерея','2012-03-11 13:12:22','2012-03-11 13:12:22','gallery',1,1,1),(6,'Отзывы','2012-03-21 15:08:47','2012-03-21 15:08:47','replies',1,1,1);
/*!40000 ALTER TABLE `folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fragments`
--

DROP TABLE IF EXISTS `fragments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fragments` (
  `title` varchar(255) DEFAULT NULL,
  `is_fragment` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by_id` int(10) unsigned DEFAULT NULL,
  `updated_by_id` int(10) unsigned DEFAULT NULL,
  `id` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_fragments_created_by` (`created_by_id`),
  KEY `index_fragments_updated_by` (`updated_by_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fragments`
--

LOCK TABLES `fragments` WRITE;
/*!40000 ALTER TABLE `fragments` DISABLE KEYS */;
INSERT INTO `fragments` VALUES ('Footer',1,'2012-02-24 14:47:35','2012-03-27 13:42:17',NULL,1,'footer'),('Фотогалерея',0,'2012-03-21 15:49:55','2012-03-21 17:11:48',1,1,'gallery'),('Header',1,'2012-02-24 14:47:35','2012-03-27 14:28:31',NULL,1,'header'),('Главная',0,'2012-03-20 16:32:20','2012-03-27 13:39:06',1,1,'index'),('Новости',0,'2012-03-27 11:22:16','2012-03-27 12:32:06',1,1,'news'),('Показ новости',0,'2012-03-27 11:23:21','2012-03-27 11:23:21',1,1,'news-show'),('Default page',0,'2012-02-24 14:47:35','2012-03-20 16:35:33',NULL,1,'page');
/*!40000 ALTER TABLE `fragments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `images`
--

DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `images` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `folder_id` int(11) DEFAULT '1',
  `created_by_id` int(10) unsigned DEFAULT NULL,
  `updated_by_id` int(10) unsigned DEFAULT NULL,
  `file_content_type` varchar(63) DEFAULT NULL,
  `file_size` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_images_created_by` (`created_by_id`),
  KEY `index_images_updated_by` (`updated_by_id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `images`
--

LOCK TABLES `images` WRITE;
/*!40000 ALTER TABLE `images` DISABLE KEYS */;
INSERT INTO `images` VALUES (68,'Котел','120311124019_1110360365.gif','2012-03-11 12:40:19','2012-03-11 13:14:46',4,NULL,1,'image/gif',11181),(69,'Котел КВа','120311124019_1110360366.gif','2012-03-11 12:40:19','2012-03-11 13:14:33',4,NULL,1,'image/gif',11815),(70,'Транспортабельная котельная','120311131256_1110360368.jpg','2012-03-11 13:12:56','2012-03-11 13:13:10',5,NULL,1,'image/jpeg',6834),(71,'Котел в с.Июльское','120311131256_1110360375.jpg','2012-03-11 13:12:56','2012-03-11 13:13:26',5,NULL,1,'image/jpeg',8842),(72,'Котельная школы-интернат в с.Шаркан','120311131256_1110360397.jpg','2012-03-11 13:12:56','2012-03-11 13:13:34',5,NULL,1,'image/jpeg',9062),(73,'Буровая в работе с.Подшивалово','120311131256_1222008975.jpg','2012-03-11 13:12:56','2012-03-11 13:13:43',5,NULL,1,'image/jpeg',127775),(74,'Котельная школы-интернат в с.Шаркан','120311131256_1222008976.jpg','2012-03-11 13:12:56','2012-03-11 13:13:53',5,NULL,1,'image/jpeg',104919),(78,'Свидетельство 1890','120319164706_1222008780.jpg','2012-03-19 16:47:06','2012-03-19 16:47:06',3,NULL,NULL,'image/jpeg',111997),(79,'Фото здания','120321150218_1110360400.jpg','2012-03-21 14:42:51','2012-03-21 15:02:18',5,NULL,1,'image/jpeg',16299),(92,'Справка-отзыв начальника Государственной жилищной инспекции для участия ГУП «ТПО ЖКХ УР» во всероссийском конкурсе на лучшую организацию, предприятие сферы ЖКХ по эффективности работы в новых экономических условиях за 2002 год','120321151407_1110360172.jpg','2012-03-21 15:14:07','2012-03-21 15:16:36',6,NULL,1,'image/jpeg',67053),(93,'Отзыв о работе ГУП \"ТПО ЖКХ УР\" для представления на всероссийский конкурс на лучшую организацию, предприятие сферы ЖКХ по эффективности работы в новых экономических условиях за 2003 год','120321151407_1110360174.jpg','2012-03-21 15:14:07','2012-03-21 15:16:58',6,NULL,1,'image/jpeg',53079),(94,'Отзыв на выполнение ГУП «ТПО ЖКХ УР» работ по проектиованию и бурению поисково-эксплутационной скважины в п. Кез','120321151407_1110360175.jpg','2012-03-21 15:14:07','2012-03-21 15:16:21',6,NULL,1,'image/jpeg',28214),(95,'Отзыв Администрации Малопургинского района о работе ГУП «ТПО ЖКХ УР»','120321151407_1110360176.jpg','2012-03-21 15:14:07','2012-03-21 15:16:07',6,NULL,1,'image/jpeg',49865),(96,'Отзыв о работе водогрейных котлов КВ-0,4 Гс, производства ГУП «ТПО ЖКХ УР», в котельной школы с. Бураново Малопургинского района','120321151407_1110360181.jpg','2012-03-21 15:14:07','2012-03-21 15:21:57',6,NULL,1,'image/jpeg',67345),(97,'Отзыв директора МУП ЖКХ \"Энергия\" с. Июльское о работе водогрейных котлов КВ-0,63 Гс, производства ГУП «ТПО ЖКХ УР»','120321151407_1110360182.jpg','2012-03-21 15:14:07','2012-03-21 15:21:43',6,NULL,1,'image/jpeg',45712),(98,'Благодарственное письмо от Администрации Ярского района Удмуртской Республики','120321151407_1110360512.jpg','2012-03-21 15:14:07','2012-03-21 15:15:51',6,NULL,1,'image/jpeg',56413),(99,'Благодарственное письмо от Федерального агенства по строительству и жилищно-коммунальному хозяйству','120321151407_1110360513.jpg','2012-03-21 15:14:07','2012-03-21 15:15:39',6,NULL,1,'image/jpeg',80202),(100,'Почетная грамота Минстроя Удмуртской Республики','120321151407_1110360514.jpg','2012-03-21 15:14:07','2012-03-21 15:15:23',6,NULL,1,'image/jpeg',47456),(101,'Сертификат в номинации Оборудование для ЖКХ','120321151407_1110361216.jpg','2012-03-21 15:14:07','2012-03-21 15:15:09',6,NULL,1,'image/jpeg',68804),(102,'Диплом выставки \"Сделано в Удмуртии\"','120321151407_1110363604.jpg','2012-03-21 15:14:07','2012-03-21 15:14:51',6,NULL,1,'image/jpeg',169877),(103,'Фавиконка','bandura.png','2012-03-27 12:36:43','2012-03-27 12:36:43',1,NULL,NULL,'image/png',2278);
/*!40000 ALTER TABLE `images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `layouts`
--

DROP TABLE IF EXISTS `layouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `layouts` (
  `title` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by_id` int(10) unsigned DEFAULT NULL,
  `updated_by_id` int(10) unsigned DEFAULT NULL,
  `id` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_layouts_created_by` (`created_by_id`),
  KEY `index_layouts_updated_by` (`updated_by_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `layouts`
--

LOCK TABLES `layouts` WRITE;
/*!40000 ALTER TABLE `layouts` DISABLE KEYS */;
INSERT INTO `layouts` VALUES ('Default app','2012-02-24 14:47:35','2012-03-21 14:38:01',NULL,1,'application'),('Raw data','2012-02-24 14:47:35','2012-02-24 14:47:35',NULL,NULL,'raw');
/*!40000 ALTER TABLE `layouts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news_articles`
--

DROP TABLE IF EXISTS `news_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news_articles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `text` text,
  `slug` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `news_rubric_id` int(11) DEFAULT '1',
  `created_by_id` int(10) unsigned DEFAULT NULL,
  `updated_by_id` int(10) unsigned DEFAULT NULL,
  `is_published` tinyint(1) DEFAULT '0',
  `publish_at` datetime DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_news_articles_slug` (`slug`),
  KEY `index_news_articles_created_by` (`created_by_id`),
  KEY `index_news_articles_updated_by` (`updated_by_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news_articles`
--

LOCK TABLES `news_articles` WRITE;
/*!40000 ALTER TABLE `news_articles` DISABLE KEYS */;
INSERT INTO `news_articles` VALUES (3,'Стандарты раскрытия информации 2012','[file 23 Стандарты раскрытия информациии 2012]\r\n[file 22 Стандарты раскрытия информации (Факт 2010)]\r\n[file 21 Стандарты раскрытия информации (план 2011)]\r\n                ','info-2012','2012-03-19 15:37:37','2012-03-27 14:42:20',1,1,1,1,'2011-12-28 00:00:00',''),(4,'Информация о размещении заказа','','order-info','2012-03-19 16:43:44','2012-03-27 14:38:39',1,1,1,0,'2009-03-05 00:00:00',''),(5,'Всероссийская книга почета','22 октября 2008 года по предложению органа исполнительной власти Удмуртской Республики ГУП «Территориальное производственное объединение жилищно-коммунального хозяйства УР» включено в Реестр «Всероссийская Книга Почета» Свидетельство №0001890, город Москва, http://www.kniga-pocheta/ru\r\n\r\n[image 78 Свидетельство 1890]','honor-book','2012-03-19 16:48:50','2012-03-27 14:42:50',1,1,1,1,'2008-11-07 00:00:00','22 октября 2008 года по предложению органа исполнительной власти Удмуртской Республики ГУП «Территориальное производственное объединение жилищно-коммунального хозяйства УР» включено в Реестр «Всероссийская Книга Почета» Свидетельство № 0001890, город Москва, http://www.kniga-pocheta/ru');
/*!40000 ALTER TABLE `news_articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news_rubrics`
--

DROP TABLE IF EXISTS `news_rubrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news_rubrics` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `text` text,
  `slug` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by_id` int(10) unsigned DEFAULT NULL,
  `updated_by_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_news_rubrics_slug` (`slug`),
  KEY `index_news_rubrics_created_by` (`created_by_id`),
  KEY `index_news_rubrics_updated_by` (`updated_by_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news_rubrics`
--

LOCK TABLES `news_rubrics` WRITE;
/*!40000 ALTER TABLE `news_rubrics` DISABLE KEYS */;
INSERT INTO `news_rubrics` VALUES (1,'Site news','Default news rubric','default','2012-03-16 15:04:01','2012-03-16 15:07:37',NULL,1);
/*!40000 ALTER TABLE `news_rubrics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pages`
--

DROP TABLE IF EXISTS `pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `text` text,
  `path` varchar(2000) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `is_published` tinyint(1) DEFAULT '0',
  `publish_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by_id` int(10) unsigned DEFAULT NULL,
  `updated_by_id` int(10) unsigned DEFAULT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `layout_id` varchar(20) DEFAULT 'application',
  `fragment_id` varchar(20) DEFAULT 'page',
  PRIMARY KEY (`id`),
  KEY `index_pages_created_by` (`created_by_id`),
  KEY `index_pages_updated_by` (`updated_by_id`),
  KEY `index_pages_parent` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pages`
--

LOCK TABLES `pages` WRITE;
/*!40000 ALTER TABLE `pages` DISABLE KEYS */;
INSERT INTO `pages` VALUES (35,'Index','','/',10,'index',1,NULL,'2012-02-24 14:47:34','2012-03-20 16:34:15',NULL,1,NULL,'application','index'),(36,'Error','Default error page','/error',99,'error',0,NULL,'2012-02-24 14:47:34','2012-03-20 16:02:31',NULL,1,35,'application','page'),(37,'Admin panel','','/admin',100,'admin',0,'2012-03-26 16:48:48','2012-02-24 14:47:34','2012-03-26 16:48:51',NULL,1,35,'application','page'),(38,'О компании','ГУП «ТПО ЖКХ УР» основано 17 ноября Постановлением Совета Министров Удмуртской АССР 1988г. Сегодня ГУП «ТПО ЖКХ УР» – многоотраслевое предприятие жилищно-коммунального хозяйства Удмуртии. Объединение выполняет проектирование, строительство и капитальный ремонт котельных, центральных тепловых пунктов, сетей - электро- тепло- газо- водоснабжения, бурение, ремонт и реконструкцию артезианских скважин на воду, монтаж и сервисное обслуживание приборов учета тепла и воды, КИП и автоматики, пусконаладочные работы и режимно-наладочные испытания котельных на всех видах топлива, сертифицирует жилищно-коммунальные услуги и персонал организаций всех форм собственности в Удмуртской Республике в Системе добровольной сертификации в жилищно-коммунальной сфере Российской Федерации «Росжилкоммунсертификация».\r\n\r\nОбъединение выполняет инженерные изыскания для строительства зданий и сооружений, изыскания источников водоснабжения на базе подземных вод, разработку проектно-сметной документации, оказывает жилищно-коммунальные услуги по электроснабжению, теплоснабжению, газоснабжению, водоснабжению. Объединение разработало и изготавливает высокоэффективные энергосберегающие многотопливные газо- угольные отопительные водогрейные котлы КВа производительностью от 0,25 до 1,25 МВт.\r\n\r\nРейтинг объединения:\r\n\r\nПо итогам работы в 2006 году Объединение стало Победителем Х Всероссийского конкурса «На лучшее организацию, предприятие сферы жилищно-коммунального хозяйства» и награждено Дипломом I степени. По итогам работы в 2007 году Указом Президента Удмуртской Республики А.А. Волкова от 25 октября 2007 №132 «За значительный вклад в социально-экономическое развитие Удмуртской Республики коллектив территориального производственного объединения жилищно-коммунального хозяйства занесен на «Доску почета Удмуртской Республики».\r\n\r\nЕжегодно выставляя высокоэффективное уникальное тепло-производящее оборудование на Международных специализированных выставках «ГОРОД ХХI ВЕКА», «Сделано в Удмуртии» в номинациях «Оборудование для ЖКХ», ГУП «ТПО ЖКХ УР» награждалось Сертификатами, «Серебряной» и «Бронзовой» медалями.\r\n\r\n[asset 1 Устав предприятия]\r\n[asset 2 Приказ о назначении генерального директора]\r\n\r\nГосударственное унитарное предприятие «Территориальное производственное объединение жилищно-коммунального хозяйства Удмуртской Республики»\r\nпочтовый адрес: 426069, ул. Песочная, 9, г. Ижевск, Удмуртская Республика Тел.: 59-88-49, Факс: 58-61-91\r\ne-mail: office@tpo.udcom.ru. http://www.udmtpo.ru\r\nГенеральный директор Воробьев Александр Маркович','/about',10,'about',0,NULL,'2012-02-24 14:47:35','2012-03-26 17:40:38',NULL,1,35,'application','page'),(43,'404 Страница не найдена','Простите, по этой ссылке ничего нет','/error/404',10,'404',0,NULL,'2012-02-24 14:47:35','2012-03-27 14:51:39',NULL,1,36,'application','page'),(44,'501 Service Unavailable','Sorry, requested service is unavailable','/error/501',20,'501',0,NULL,'2012-02-24 14:47:35','2012-03-12 14:36:31',NULL,1,36,'application','page'),(52,'Группа по проектированию объектов ЖКХ','Свидетельство №01-МРП-056 о допуске на выполнение проектных работ, которые оказывают влияние на безопасность объектов капитального строительства, выданно члену СРО НП Межрегионпроект - ГУП \"ТПО ЖКХ УР\"\r\n\r\n**Руководитель**: Катаргин Сергей Анатольевич Тел. 59-88-54\r\n\r\nГруппа по проектированию объектов ЖКХ осуществляет все стадии проектирования - составляет технико-экономическое обоснование, проводит обследования технического состояния зданий и сооружений, проводит архитектурное, техническое и рабочее проектирование, разрабатывает сметную документацию, представляет документацию в органы государственного надзора, проводит авторский надзор следующих систем, объектов и разделов:\r\n\r\n - Генеральный план и транспорт;\r\n - Архитектурно-строительные решения;\r\n - Технологические решения;\r\n - Производственные здания и сооружения и их комплексы:\r\n - электрические и тепловые сети;\r\n - насосные станции;\r\n - котельные;\r\n - емкостные сооружения для жидкостей и газов.\r\n - Инженерное оборудование, сети и системы:\r\n - отопление, вентиляция и кондиционирование;\r\n - водоснабжение и канализация;\r\n - теплоснабжение;\r\n - газоснабжение;\r\n - электроснабжение до 10 кВ включительно;\r\n - электрооборудование и электроосвещение;\r\n - связь и сигнализация;\r\n - диспетчеризация, автоматизация и управление инженерными системами.\r\n - Специальные разделы проектной документации:\r\n - охрана окружающей среды.\r\n - Сметная документация;\r\n - Обследование технического состояния зданий и сооружений.\r\n - Проектно-сметная группа ГУП «ТПО ЖКХ УР» осуществляет функции генерального проектировщика.\r\n\r\nОсновой каждого успешного проекта строительства или реконструкции здания является качественная проектная документация. Опыт реализации проектов разного уровня сложности, высокий уровень автоматизации проектной деятельности, а также налаженная система управления проектной документацией позволяют специалистам группы разрабатывать проектную документацию высокого качества в сжатые сроки.','/services/objects',60,'objects',1,NULL,'2012-02-29 14:34:29','2012-03-13 15:59:51',1,1,59,'application','page'),(53,'Участок по бурению и ремонту скважин','Лицензия от 28 ноября 2006г ГС-4-18-02-28-0-1831010200-003171-3 Федерального агентства по строительству и жилищно-коммунальному хозяйству разрешает осуществление\r\n\r\nИНЖЕНЕРНЫЕ ИЗЫСКАНИЯ ДЛЯ СТРОИТЕЛЬСТВА ЗДАНИЙ И СООРУЖЕНИЙ I И II УРОВНЕЙ ОТВЕТСТВЕННОСТИ В СООТВЕТСТВИИ С ГОСУДАРСТВЕННЫМ СТАНДАРТОМ.\r\n\r\nНачальник: Соковиков Александр Павлович Тел. 58-89-86\r\n\r\nУчасток по бурению и ремонту скважин осуществляет проектирование, бурение, ремонт артезианских скважин, выполняет весь комплекс работ от проектирования до сдачи скважин заказчику «под ключ». Основные виды работ, выполняемые участком:\r\n\r\n - Проектирование артезианских скважин;\r\n - Бурение скважин физическим и юридическим лицам;\r\n - Монтаж систем автоматики скважин и устройство узлов учета воды;\r\n - Каптаж родников;\r\n - Тампонаж (ликвидация) скважин;\r\n - Реконструкция и капитальный ремонт скважин;\r\n - Ремонт водоподъемного оборудования;','/services/drill_and_repair',30,'drill_and_repair',1,NULL,'2012-02-29 14:36:58','2012-03-13 15:59:59',1,1,59,'application','page'),(54,'Строительно-монтажные работы объектов энергетического хозяйства','Лицензия от 09 ноября 2004г ГС-4-18-02-27-0-1831010200-002012-5 Федерального агентства по строительству и жилищно-коммунальному хозяйству разрешает осуществление\r\nСТРОИТЕЛЬСТВО ЗДАНИЙ И СООРУЖЕНИЙ I И II УРОВНЕЙ ОТВЕТСТВЕННОСТИ В СООТВЕТСТВИИ С ГОСУДАРСТВЕННЫМ СТАНДАРТОМ\r\n\r\nНачальник Строительно-монтажного управления: Багаев Валерий Васильевич Тел. 59-87-95\r\n\r\nСтроительно-монтажное управление состоит из монтажного участка, монтажно-наладочного участка и сметно-договорной группы\r\n\r\nМонтажный участок.\r\n\r\nНачальник участка: Дедюхин Алексей Васильевич Тел. 59-87-95\r\n\r\nМонтажный участок создан в 1991 году для изготовления котлов и монтажа котельных. В 1995 году была смонтирована первая котельная детского санатория «Селычка», мощностью 1,5 Мвт. С тех пор силами участка смонтировано более 120-ти котельных и ЦТП. Объемы выполняемых работ постоянно наращиваются и выполняются в срок. Качество смонтированных котельных и ЦТП, объектов капитального ремонта, технического перевооружения, по отзывам заказчиков, хорошее. За это время работники участка приобрели существенный опыт монтажно-строительных работ.\r\n\r\nОсновные виды работ выполняемые монтажным участком монтажа:\r\n\r\n - Монтаж, реконструкция и модернизация котельных на всех видах топлива. центральных и индивидуальных тепловых пунктов, в том числе:\r\n - монтаж дымовых труб;\r\n - монтаж тепломеханического оборудования, систем отопления, холодного и горячего водоснабжения и пожарного водопровода;\r\n - монтаж газового оборудования;\r\n - работы по изоляции трубопроводов и газоходов;\r\n - Изготовление трубной части котлов на твердом топливе типа КОВ, КВС.\r\n - Изготовление систем химводоподготовки (фильтров натрий-катионирования, солерастворителей);\r\n - Изготовление нестандартизированного оборудования.\r\n\r\nУчасток ведет гарантийное и постгарантийное обслуживание смонтированных котельных и установленного оборудования. Котельные, смонтированные силами участка, эксплуатируются во всех районах Удмуртской Республики.\r\n\r\n**Монтажно-наладочный участок.**\r\n\r\n**Начальник**: Файзрахманов Илдус Мухаметгаязович Тел. 59-14-42\r\n\r\nМонтажно-наладочный участок работает с февраля 1996 года. Выполняет пусконаладочные работы и режимно-наладочные испытания на котельных. Выполняемые монтажно-наладочным участком работы включает:\r\n\r\n - монтаж и пусконаладку КИП и А на ЦТП и котельных на всех видах топлива;\r\n - комплекс электромонтажных работ с начала строительства до ввода в эксплуатацию, а также монтаж, реконструкцию и модернизацию систем централизованного теплоснабжения, тепловых сетей и сооружений на них, в том числе водоподогревательных установок.\r\n - монтаж и пусконаладку узлов учета газа;\r\n - монтаж и пусконаладку узлов учета тепловой энергии;\r\n - пусконаладочные работы тепломеханического оборудования;\r\n - режимно-наладочные испытания котлоагрегатов.\r\n - Монтаж приборов учета электрической энергии;\r\n - Монтаж наружных и внутренних (воздушных и кабельных) сетей напряжением до 1000В;\r\n - Монтаж заземляющих устройств всех типов и цепей заземления. Все работы выполняются качественно и в срок. Работников монтажно-наладочного участка знают в Удмуртии как опытных и энергичных специалистов.','/services/build',10,'build',1,NULL,'2012-02-29 14:38:45','2012-03-13 15:59:32',1,1,59,'application','page'),(55,'Энергетическая служба','Лицензия №60017999 от 31 декабря 2003г Министерство энергетики Российской Федерации разрешает осуществление ДЕЯТЕЛЬНОСТИ ПО ЭКСПЛУАТАЦИИ ТЕПЛОВЫХ СЕТЕЙ\r\n\r\nЛицензия №50018003 от 31 декабря 2003г Министерство энергетики Российской Федерации разрешает осуществление ДЕЯТЕЛЬНОСТИ ПО ЭКСПЛУАТАЦИИ ЭЛЕКТРИЧЕСКИХ СЕТЕЙ\r\n\r\nИ.о. начальника энергетической службы: Савин Виталий Леонидович Тел. 59-15-07\r\nЗаместитель начальника энергетической службы по электроэнергетическому хозяйству: Варакин Анатолий Алексеевич Тел. 59-15-07\r\n\r\nЭнергетическая служба осуществляет эксплуатацию и техническое обслуживание современных автоматизированных: газовых котельных, центральных тепловых пунктов, индивидуальных тепловых пунктов, а также тепловых и электрических сетей. Основные виды работ, выполняемых энергетической службой:\r\n\r\n - Испытания и наладочные работы на основном и вспомогательном оборудовании тепловых сетей;\r\n - Режимная наладка и регулировка систем теплоснабжения, тепловых сетей;\r\n - Ремонт теплопроводов и арматуры тепловых сетей;\r\n - Сварочные работы;\r\n - Проведение эксплуатационных испытаний тепловых сетей;\r\n - Прием, передача и распределение между потребителями тепловой энергии;\r\n - Электроизмерительная лаборатория энергетической службы (Свидетельство о регистрации №241 от 19 августа 2004г.) выполняет испытания и измерения электрооборудования и электроустановок напряжением до 1000В:\r\n - Испытание электрооборудования напряжением до 1000В;\r\n - Измерение сопротивления заземляющих устройств;\r\n - Измерение сопротивления петли «фаза-нуль»;\r\n - Испытание изоляции электроустановок напряжением до 1000В;\r\n\r\nСпециалисты энергетической службы имеют многолетний опыт в осуществлении данной деятельности. Наши решения позволяют экономить средства клиентов, как на этапе монтажа, так и в процессе эксплуатации. Среди наших клиентов крупнейшие предприятия и организации Удмуртской Республики.','/services/energy',40,'energy',1,NULL,'2012-02-29 14:43:11','2012-03-13 16:00:33',1,1,59,'application','page'),(56,'Отдел инженерных изысканий','Свидетельство 01-И-№0571 от 23 ноября 2009 года о допуске к работам по выполнению инженерных изысканий, которые оказывают влияние на безопасность объектов капитального строительства, выдано члену СРО - ГУП ТПО ЖКХ УР.\r\n\r\nНачальник: Плетнева Ирина Олеговна Тел. 59-88-49 (доб. 138).\r\n\r\nОтдел инженерных изысканий (ОИИ) создан при ГУП «ТПО ЖКХ УР» в 2003 году, имеет необходимое техническое и научное обеспечение. Специалистами отдела накоплен богатый опыт работы в условиях Удмуртской Республики. Изысканиями охвачено большинство населенных пунктов Удмуртии, имеется полная база данных архивных материалов.\r\nВ состав отдела инженерных изысканий входят: топографическая партия, геологическая партия, лаборатория механики грунтов.\r\nВыполняются любые виды инженерно-геодезических и инженерно-геологических работ, а также все виды лабораторных исследований грунтов.\r\nПри производстве изысканий применяются современные методы работы с использованием приборов и оборудования, соответствующих требованиям государственных стандартов. Большинство видов работ компьютеризировано. Отдел выполняет изыскания под строительство любых объектов:\r\n\r\n - всех видов зданий и сооружений жилищно-бытового, культурного, производственного назначения, любых размеров и этажности;\r\n - объектов газоснабжения (межпоселковые и внутриквартальные разводящие газопроводы);\r\n - объектов водоснабжения и электроснабжения;\r\n - разбивочные геодезические работы;\r\n - изыскания под пруды;\r\n - изыскания под автодорожное строительство;\r\n - инженерно-геологическая разведка месторождений строительных материалов (глин, песков, ПГС);\r\n - изыскания для обустройства нефтяных месторождений.\r\n\r\nРабота выполняется в заявленный срок, с соблюдением всех требований, действующих нормативных документов. Предусмотрена коррекция договорной цены изыскательских работ в зависимости от продолжительности сотрудничества, объема заказа и условий оплаты.\r\nНеоднократно отдел выполнял заказы на проведение изысканий для ГУ «УКС Правительства УР», ОАО «Уральская нефть», ОАО «Удмуртгеология», администраций городов и районов Удмуртской Республики.','/services/engineer',50,'engineer',1,NULL,'2012-02-29 14:44:15','2012-03-13 16:00:17',1,1,59,'application','page'),(57,'Сертификация продукции, работ и услуг, персонала и систем менеджмента качества','МИНИСТЕРСТВО РЕГИОНАЛЬНОГО РАЗВИТИЯ РОССИЙСКОЙ ФЕДЕРАЦИИ\r\nРОСЖИЛКОММУНСЕРТИФИКАЦИЯ\r\nОРГАН ПО СЕРТИФИКАЦИИ\r\nГОСУДАРСТВЕННОЕ УНИТАРНОЕ ПРЕДПРИЯТИЕ «ТЕРРИТОРИАЛЬНОЕ ПРОИЗВОДСТВЕННОЕ ОБЪЕДИНЕНИЕ ЖИЛИЩНО-КОММУНАЛЬНОГО ХОЗЯЙСТВА УДМУРТСКОЙ РЕСПУБЛИКИ»\r\n(ГУП «ТПО ЖКХ УР»)\r\n\r\nВ целях реализации Указа Президента Российской Федерации от 4 июня 2008 года № 889 «О некоторых мерах по повышению энергетической и экологической эффективности российской экономики»; Федерального закона Российской Федерации от 27 декабря 2002 № 184 «О техническом регулировании», Федерального закона Российской Федерации от 07 февраля 1992г. № 2300-1 «О защите прав потребителей», приказа Министерства регионального развития Российской Федерации от «19» мая 2009 года «О системе добровольной сертификации в жилищно-коммунальном комплексе Российской Федерации «Росжилкоммунсертификация», распоряжения Правительства Удмуртской Республики «О добровольной сертификации в жилищно-коммунальной сфере» от 06 июня 2005 года №544, приказа Министерства строительства архитектуры и жилищной политики Удмуртской республики от 13.07.2005 №139 «О сертификации услуг и персонала в жилищно-коммунальной сфере Удмуртской Республики», с августа 2005 года ГУП «Территориальное производственное объединение жилищно-коммунального хозяйства Удмуртской Республики» (ГУП «ТПО ЖКХ УР») занимается развитием Системы добровольной сертификации в жилищно-коммунальном комплексе Российской Федерации «Росжилкоммунсертификация» в Удмуртской Республике Трижды аккредитовано Органом по сертификации. Свидетельство серии 18 ОС 0072 от 08 августа 2009 года.\r\n\r\nКоды (организаций) предприятий:\r\n\r\n- 010 Органы управления жилищно-коммунальным хозяйством;\r\n- 020 Управляющие компании, в том числе служба заказчика, ТСЖ, ЖК, ТОС и другие;\r\n- 030 Проектные, изыскательские и консультационные организации;\r\n- 040 Предприятия промышленности строительных материалов;\r\n- 060 Подрядные (субподрядные) ремонтно-строительные организации;\r\n- 070 Жилищно-эксплуатационные предприятия;\r\n- 080 Дорожные подрядные (субподрядные) ремонтно-строительные организации;\r\n- 090 Дорожные эксплуатационные организации;\r\n- 100 Служба эксплуатации мостовых сооружений и объектов инженерной защиты;\r\n- 110 Предприятия водопроводно-канализационного хозяйства;\r\n- 120 Предприятия электроэнергетического хозяйства;\r\n- 130 Предприятия теплоэнергетического хозяйства;\r\n- 140 Предприятия газового хозяйства;\r\n- 160 Предприятия зеленого хозяйства и цветоводства;\r\n- 170 Предприятия садово-паркового строительства и эксплуатации зеленых насаждений;\r\n- 180 Спецавтохозяйства по уборке территорий;\r\n- 190 Предприятия по переработке твердых бытовых отходов;\r\n- 200 Спецкомбинаты «Радон»;\r\n- 210 Многоотраслевые предприятия жилищно-коммунального хозяйства\r\n- 220 Предприятия потребительского рынка и бытового обслуживания;\r\n\r\nСертификация продукции, работ и услуг, персонала и систем менеджмента качества. Индивидуальный подход к каждому клиенту желающему правильно и быстро оформить необходимые документы для проведения сертификации соответствия.\r\nОбразец заявки на сертификацию соответствия\r\n\r\nЗвоните, заходите на Сайт! Мы всегда готовы к сотрудничеству с Вами!\r\n426069, Россия, Удмуртская Республика, г.Ижевск, ул. Песочная, 9, к. 315 тел.: (3412) 59-87-77, 59-14-42, факс: (3412) 58-61-91 e-mail: office@tpo.udcom.ru. xan@tpo.udcom.ru. http://www.udmtpo.ru\r\n\r\nРеестр выданных сертификатов','/services/certify',20,'certify',1,NULL,'2012-02-29 15:02:20','2012-03-13 15:59:40',1,1,59,'application','page'),(58,'Стандартизация','Стратегическая политика ГУП «ТПО ЖКХ УР» направлена на установление долгосрочных взаимовыгодных деловых отношений, плодотворное сотрудничество с нашими заказчиками и клиентами. Укрепления свое положение на рынке продукции, объединение постоянно стремится к поддержанию и улучшению стандартов обслуживания, регулярно инвестирует в развитие персонала и организационной культуры.\r\nГУП «ТПО ЖКХ УР» содействует развитию экономики и способствует защите прав потребителей путем подтверждения качества поступающих на жилищно-коммунальный рынок услуг Удмуртской Республики через сертификацию организаций и специалистов оказывающих жилищно-коммунальные услуги.\r\nПринципы ГУП «ТПО ЖКХ УР»:\r\n\r\n- Профессионализм – с клиентами;\r\n- Забота – о сотрудниках;\r\n- Надежность - с партнерами;\r\n- Этичность – с конкурентами;\r\n- Честность и открытость при выполнении своих обязательств – с государством.\r\n\r\nВ ноябре 2007 года отдел сертификации завершил разработку первого стандарта предприятия. Приказом ГУП «ТПО ЖКХ УР» «Об утверждении стандарта «Стандарты предприятия. Общие правила разработки и применения» от 13 ноября 2007 года №280 стандарт был утвержден и введен в действие.\r\nУправление качеством\r\nВ целях развития ГУП «ТПО ЖКХ УР», формирования четкого набора услуг, критериев качества и оптимального использования финансовых средств, и в соответствии с требованиями МС ИСО 9001-2000, приказ ГУП «ТПО ЖКХ УР» «О разработке системы менеджмента качества» от 13 ноября 2007 года №280 определил в первом квартале 2008 года приступить к разработке и внедрению системы менеджмента качества (МСК) Государственного унитарного предприятия «Территориальное производственное объединение жилищно-коммунального хозяйства Удмуртской Республики»\r\nРуководство ГУП «ТПО ЖКХ УР» всесторонне поддерживает, контролирует и улучшает деятельность, направленную на создание и поддержание системы управления качеством.\r\nТакая деятельность способствует все более полному удовлетворению потребителей продукции (работ и услуг), улучшению репутации ГУП «ТПО ЖКХ УР» как надежного, честного и выгодного поставщика продукции.\r\nГУП «ТПО ЖКХ УР» с декабря 2007 года разрабатывает, документирует, внедряет и поддерживает в рабочем состоянии систему менеджмента качества. Деятельность всех сотрудников ГУП «ТПО ЖКХ УР» призвана постоянно повышать результативность системы менеджмента качества. ','/services/standards',70,'standards',1,NULL,'2012-02-29 15:05:04','2012-03-13 16:00:40',1,1,59,'application','page'),(59,'Услуги','','/services',31,'services',1,NULL,'2012-03-13 15:59:22','2012-03-13 16:03:55',1,1,35,'application','page'),(60,'Прайс-лист','','/price',11,'price',0,'2012-03-21 15:04:39','2012-03-21 14:40:44','2012-03-26 17:40:38',1,1,35,'application','page'),(61,'Контактная информация','[image 79 Фото здания]\r\n\r\n[block address]\r\n','/contact',12,'contact',1,'2012-03-21 15:04:39','2012-03-21 15:04:25','2012-03-21 15:04:39',1,1,35,'application','page'),(62,'Отзывы','[file 24 Отзыв заместителя министра строительства, архитектуры и жилищной политики Удмуртской республики, Сивцова А.Н., о работе ГУП «ТПО ЖКХ УР»]','/replies',13,'replies',1,'2012-03-21 15:28:41','2012-03-21 15:28:36','2012-03-21 15:28:41',1,1,35,'application','page'),(63,'Фотогалерея','','/gallery',14,'gallery',1,'2012-03-23 13:49:36','2012-03-23 13:49:30','2012-03-23 13:49:36',1,1,35,'application','gallery'),(64,'Новости','','/news',15,'news',0,NULL,'2012-03-27 11:21:29','2012-03-27 12:31:57',1,1,35,'application','news'),(65,'Показ новости','','/news/show%',1,'show%',0,NULL,'2012-03-27 11:21:55','2012-03-27 12:31:51',1,1,64,'application','news-show');
/*!40000 ALTER TABLE `pages` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-03-27 17:13:58