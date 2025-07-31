-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: event_mgmt_db
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `attendees`
--

DROP TABLE IF EXISTS `attendees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `event_type` varchar(50) NOT NULL,
  `status` enum('Attending','Not Attending','Maybe') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendees`
--

LOCK TABLES `attendees` WRITE;
/*!40000 ALTER TABLE `attendees` DISABLE KEYS */;
INSERT INTO `attendees` VALUES (1,'Prabhat Singh','kanika@gmail.com','07985136531','birthday','Attending','2025-07-27 14:36:32'),(2,'pranhu','prabhu@gmail.com','98787656','wedding','Not Attending','2025-07-27 16:35:06');
/*!40000 ALTER TABLE `attendees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `tickets` int NOT NULL,
  `event_name` varchar(100) NOT NULL,
  `payment_status` enum('pending','approved','failed') DEFAULT 'pending',
  `booking_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(100) NOT NULL,
  `ticket_price` decimal(10,2) DEFAULT '0.00',
  `description` text,
  `event_type` varchar(50) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `event_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `status` enum('active','cancelled') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `image_filename` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `events_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (4,8,'Live concern',500.00,NULL,NULL,'delhi','2025-08-02','10:00:00','07:00:00','active','2025-07-28 12:06:06','2025-07-31 10:56:10','event1-liveconcert.jpg'),(5,8,'Birthday Event',200.00,NULL,NULL,'noida','2025-08-01','10:00:00','06:00:00','active','2025-07-31 03:49:40','2025-07-31 10:57:25','event1-liveconcert.jpg'),(6,8,'marrige event ',300.00,NULL,NULL,'delhi','2025-08-01','11:00:00','08:00:00','active','2025-07-31 03:50:16','2025-07-31 10:57:32','event1-liveconcert.jpg');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_bookings`
--

DROP TABLE IF EXISTS `ticket_bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket_bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int NOT NULL,
  `user_id` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `num_tickets` int DEFAULT NULL,
  `upi_id` varchar(100) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Booked',
  `booking_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ticket_price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_bookings`
--

LOCK TABLES `ticket_bookings` WRITE;
/*!40000 ALTER TABLE `ticket_bookings` DISABLE KEYS */;
INSERT INTO `ticket_bookings` VALUES (1,4,5,'Gingelly Oil','kanakglobaltechnology@gmail.com',1,'wwww',NULL,'Pending','2025-07-30 12:28:15',NULL),(2,6,8,'Gingelly Oil','kanakglobaltechnology@gmail.com',2,'7777777777777',NULL,'Pending','2025-07-31 04:05:54',600.00);
/*!40000 ALTER TABLE `ticket_bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Prabhat Singh','software.admin@onehealthplatforms.com','123','07985136531','user','2025-07-22 12:00:48','2025-07-22 12:00:48'),(2,'Prabhat Singh new','prabhatsachan152@gmail.om','scrypt:32768:8:1$yV3W0xYKuvTuidAQ$89f5db94e9abb9087e4d6d744d32cd02e1795e84c2600bcbe9094f798a7d3c829c420caa25e27b6f410aca3163f791d33b760a5ffdc3a9adc0af2a9de642e95f','07985136531','user','2025-07-23 09:46:29','2025-07-26 05:43:59'),(5,'kanika','kanika@gmail.com','scrypt:32768:8:1$tTosIfdF0mI1atCy$514c72dfb0ac2a222008a16697cfc3e0c1a361b7440446e61b91d4991906aab79a101eeaa3adcebe8f864787ac10b771cce18610762a37a8c08246c733fb75a5','9878765678','user','2025-07-25 05:36:41','2025-07-29 13:56:25'),(6,'prabhat singh','pabhatsachan152@gmail.com','scrypt:32768:8:1$TzrDTn09SemG1msP$a04c4c40e2149be2db883aa8f2b2dff0fae36fe2c75fa27ae8f1064070b6faa05f2f723c055678b2c0935972f04e3cf3fc8a21bc7ecbe27f07c3136e347c26d4','7985136531','user','2025-07-25 10:27:49','2025-07-25 10:27:49'),(7,'prabhat singh','kanaksahan152@gmail.com','scrypt:32768:8:1$nI5GOrkzpgNfkb9w$52956f07eafc9f98bafd550a3b9e923bc00f9177c91e2e3864895d214c7cb3d622c4a61011341dc03a19ef4ba3c5c0f0b9a2bc9ca5c318da3ea708aa45619745','7080315064','user','2025-07-25 10:29:12','2025-07-25 10:29:12'),(8,'priya','priya@gmail.com','scrypt:32768:8:1$wBkIunzlEvazIp2h$00a40851496dd50e4422fd8d5f5f4b141643193522e6f7668ef0cf14c8c7f03d2202de7314b5256aff3bed41d5b15034756d86f64abe4d4f61f73028eb95a8b0','8765678765','admin','2025-07-25 10:30:26','2025-07-25 10:32:16'),(9,'sp','sp@gmail.com','scrypt:32768:8:1$aphfCV9tj4BgpprZ$2c9bda2a23b7e349c9f895662f974886796e46635693babe19b2fc71f046e90c9d21b2025b0db218ad60729a2c839d143933d6c5ce7f24c8da435b5fe27b6841','07985136531','user','2025-07-25 14:45:03','2025-07-26 05:03:48'),(10,'prabhay','raka@gmail.com','scrypt:32768:8:1$ySEyt2HnTuHl2Cam$b2e401e3fc44e2db19fc8892d96d34025a864c9827af44215e0d5479774c4f42b0f3ad4c7fc94dbef5af01e0bf6bf969891e3bfb4dd3c9e7582e8dd9f131d54f','7283929392','user','2025-07-26 11:24:21','2025-07-26 11:24:21');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-31 19:13:08
