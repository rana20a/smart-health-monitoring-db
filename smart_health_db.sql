-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: health_monitoring_db
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `alert`
--

DROP TABLE IF EXISTS `alert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alert` (
  `alert_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `severity` enum('Low','Medium','High','Critical') NOT NULL,
  `alert_message` text,
  `alert_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('Open','Acknowledged','Resolved') DEFAULT 'Open',
  `resolved_time` datetime DEFAULT NULL,
  PRIMARY KEY (`alert_id`),
  KEY `patient_id` (`patient_id`),
  KEY `doctor_id` (`doctor_id`),
  KEY `idx_alert_severity` (`severity`,`status`),
  CONSTRAINT `alert_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`),
  CONSTRAINT `alert_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`doctor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert`
--

LOCK TABLES `alert` WRITE;
/*!40000 ALTER TABLE `alert` DISABLE KEYS */;
INSERT INTO `alert` VALUES (1,1,1,'Critical','Heart rate critically elevated at 125 bpm - Immediate attention required','2025-10-30 09:00:00','Open',NULL),(2,1,1,'Medium','Blood pressure elevated (145/92 mmHg)','2025-10-30 09:00:00','Acknowledged',NULL),(3,3,3,'Critical','Blood glucose level critically high at 230 mg/dL - Check insulin dosage','2025-10-30 13:00:00','Open',NULL),(4,4,4,'High','High fever detected (39.5°C) - Patient requires immediate assessment','2025-10-30 16:00:00','Acknowledged',NULL),(5,5,5,'Critical','Oxygen saturation dropped to 87% - Urgent respiratory intervention needed','2025-10-30 10:00:00','Resolved',NULL);
/*!40000 ALTER TABLE `alert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor`
--

DROP TABLE IF EXISTS `doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor` (
  `doctor_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `specialization` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `hospital_id` int DEFAULT NULL,
  `years_experience` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`doctor_id`),
  UNIQUE KEY `email` (`email`),
  KEY `hospital_id` (`hospital_id`),
  CONSTRAINT `doctor_ibfk_1` FOREIGN KEY (`hospital_id`) REFERENCES `hospital` (`hospital_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor`
--

LOCK TABLES `doctor` WRITE;
/*!40000 ALTER TABLE `doctor` DISABLE KEYS */;
INSERT INTO `doctor` VALUES (1,'Ahmed','AlSalem','Cardiology','0501234567','ahmed.alsalem@kfsh.med.sa',1,15,'2025-10-30 22:01:31'),(2,'Fatima','AlMutairi','Internal Medicine','0502345678','fatima.almutairi@kfsh.med.sa',1,10,'2025-10-30 22:01:31'),(3,'Mohammed','AlQahtani','Endocrinology','0503456789','mohammed.alqahtani@kfmc.med.sa',2,12,'2025-10-30 22:01:31'),(4,'Sarah','AlHarbi','Emergency Medicine','0504567890','sarah.alharbi@kfmc.med.sa',2,8,'2025-10-30 22:01:31'),(5,'Khalid','AlDosari','Cardiology','0505678901','khalid.aldosari@kamc.med.sa',3,20,'2025-10-30 22:01:31');
/*!40000 ALTER TABLE `doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `health_reading`
--

DROP TABLE IF EXISTS `health_reading`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `health_reading` (
  `reading_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `device_id` int NOT NULL,
  `reading_type` varchar(50) NOT NULL,
  `reading_value` decimal(10,2) NOT NULL,
  `unit` varchar(20) DEFAULT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('Normal','Warning','Critical') DEFAULT 'Normal',
  PRIMARY KEY (`reading_id`),
  KEY `device_id` (`device_id`),
  KEY `idx_patient_timestamp` (`patient_id`,`timestamp`),
  KEY `idx_reading_status` (`status`),
  CONSTRAINT `health_reading_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`),
  CONSTRAINT `health_reading_ibfk_2` FOREIGN KEY (`device_id`) REFERENCES `iot_device` (`device_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_reading`
--

LOCK TABLES `health_reading` WRITE;
/*!40000 ALTER TABLE `health_reading` DISABLE KEYS */;
INSERT INTO `health_reading` VALUES (1,1,1,'Heart Rate',75.00,'bpm','2025-10-30 08:00:00','Normal'),(2,1,1,'Heart Rate',102.00,'bpm','2025-10-30 08:30:00','Warning'),(3,1,1,'Heart Rate',125.00,'bpm','2025-10-30 09:00:00','Critical'),(4,1,1,'Heart Rate',95.00,'bpm','2025-10-30 10:00:00','Normal'),(5,1,2,'Blood Pressure Systolic',120.00,'mmHg','2025-10-30 08:00:00','Normal'),(6,1,2,'Blood Pressure Diastolic',80.00,'mmHg','2025-10-30 08:00:00','Normal'),(7,1,2,'Blood Pressure Systolic',145.00,'mmHg','2025-10-30 09:00:00','Warning'),(8,1,2,'Blood Pressure Diastolic',92.00,'mmHg','2025-10-30 09:00:00','Warning'),(9,2,1,'Heart Rate',72.00,'bpm','2025-10-30 08:00:00','Normal'),(10,2,1,'Heart Rate',68.00,'bpm','2025-10-30 12:00:00','Normal'),(11,2,2,'Blood Pressure Systolic',118.00,'mmHg','2025-10-30 08:00:00','Normal'),(12,2,2,'Blood Pressure Diastolic',78.00,'mmHg','2025-10-30 08:00:00','Normal'),(13,3,3,'Blood Glucose',95.00,'mg/dL','2025-10-30 07:00:00','Normal'),(14,3,3,'Blood Glucose',180.00,'mg/dL','2025-10-30 10:00:00','Warning'),(15,3,3,'Blood Glucose',230.00,'mg/dL','2025-10-30 13:00:00','Critical'),(16,3,3,'Blood Glucose',160.00,'mg/dL','2025-10-30 18:00:00','Warning'),(17,3,3,'Blood Glucose',110.00,'mg/dL','2025-10-30 22:00:00','Normal'),(18,4,4,'Temperature',37.20,'°C','2025-10-30 08:00:00','Normal'),(19,4,4,'Temperature',38.10,'°C','2025-10-30 12:00:00','Warning'),(20,4,4,'Temperature',39.50,'°C','2025-10-30 16:00:00','Critical'),(21,4,4,'Temperature',38.80,'°C','2025-10-30 20:00:00','Warning'),(22,4,4,'Temperature',37.50,'°C','2025-10-31 08:00:00','Normal'),(23,5,5,'Oxygen Saturation',96.00,'%','2025-10-30 08:00:00','Normal'),(24,5,5,'Oxygen Saturation',92.00,'%','2025-10-30 09:00:00','Warning'),(25,5,5,'Oxygen Saturation',87.00,'%','2025-10-30 10:00:00','Critical'),(26,5,5,'Oxygen Saturation',94.00,'%','2025-10-30 14:00:00','Normal'),(27,5,6,'Heart Rate',110.00,'bpm','2025-10-30 09:00:00','Warning'),(28,5,6,'Heart Rate',88.00,'bpm','2025-10-30 14:00:00','Normal'),(33,6,1,'Heart Rate',78.00,'bpm','2025-11-04 12:02:19','Normal');
/*!40000 ALTER TABLE `health_reading` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hospital`
--

DROP TABLE IF EXISTS `hospital`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hospital` (
  `hospital_id` int NOT NULL AUTO_INCREMENT,
  `hospital_name` varchar(100) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `bed_capacity` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`hospital_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hospital`
--

LOCK TABLES `hospital` WRITE;
/*!40000 ALTER TABLE `hospital` DISABLE KEYS */;
INSERT INTO `hospital` VALUES (1,'King Faisal Specialist Hospital','Takhasusi Street','Riyadh','011-4647272',500,'2025-10-30 22:01:31'),(2,'King Fahad Medical City','Al Olaya','Riyadh','011-2889999',800,'2025-10-30 22:01:31'),(3,'King Abdulaziz Medical City','National Guard','Riyadh','011-8011111',600,'2025-10-30 22:01:31');
/*!40000 ALTER TABLE `hospital` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iot_device`
--

DROP TABLE IF EXISTS `iot_device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `iot_device` (
  `device_id` int NOT NULL AUTO_INCREMENT,
  `device_type` varchar(100) NOT NULL,
  `model_number` varchar(50) DEFAULT NULL,
  `installation_date` date DEFAULT NULL,
  `status` enum('Active','Inactive','Maintenance') DEFAULT 'Active',
  `hospital_id` int DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`device_id`),
  KEY `hospital_id` (`hospital_id`),
  KEY `idx_device_status` (`status`,`device_type`),
  CONSTRAINT `iot_device_ibfk_1` FOREIGN KEY (`hospital_id`) REFERENCES `hospital` (`hospital_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iot_device`
--

LOCK TABLES `iot_device` WRITE;
/*!40000 ALTER TABLE `iot_device` DISABLE KEYS */;
INSERT INTO `iot_device` VALUES (1,'Heart Rate Monitor','HRM-2024-001','2024-01-15','Active',1,'ICU Room 101','2025-10-30 22:01:31'),(2,'Blood Pressure Monitor','BPM-2024-002','2024-01-15','Active',1,'Ward A-205','2025-10-30 22:01:31'),(3,'Glucose Monitor','GM-2024-003','2024-02-01','Active',2,'Diabetes Clinic','2025-10-30 22:01:31'),(4,'Temperature Sensor','TS-2024-004','2024-02-15','Active',2,'Emergency Room 3','2025-10-30 22:01:31'),(5,'Oxygen Saturation Monitor','OSM-2024-005','2024-03-01','Active',3,'ICU Room 205','2025-10-30 22:01:31'),(6,'Heart Rate Monitor','HRM-2024-006','2024-03-15','Active',3,'Cardiac Ward B','2025-10-30 22:01:31'),(7,'Blood Pressure Monitor','BPM-2024-007','2024-04-01','Maintenance',1,'Ward B-310','2025-10-30 22:01:31');
/*!40000 ALTER TABLE `iot_device` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medication`
--

DROP TABLE IF EXISTS `medication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medication` (
  `medication_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `medication_name` varchar(100) NOT NULL,
  `dosage` varchar(50) DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `prescribed_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`medication_id`),
  KEY `patient_id` (`patient_id`),
  KEY `prescribed_by` (`prescribed_by`),
  CONSTRAINT `medication_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`),
  CONSTRAINT `medication_ibfk_2` FOREIGN KEY (`prescribed_by`) REFERENCES `doctor` (`doctor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medication`
--

LOCK TABLES `medication` WRITE;
/*!40000 ALTER TABLE `medication` DISABLE KEYS */;
INSERT INTO `medication` VALUES (1,1,'Metoprolol','50mg','Twice daily','2025-10-01','2025-11-01',1,'2025-10-30 22:01:31'),(2,1,'Aspirin','81mg','Once daily','2025-10-01','2025-12-01',1,'2025-10-30 22:01:31'),(3,1,'Atorvastatin','20mg','Once daily at bedtime','2025-10-01','2025-12-01',1,'2025-10-30 22:01:31'),(4,3,'Metformin','500mg','Three times daily with meals','2025-10-20','2026-01-20',3,'2025-10-30 22:01:31'),(5,3,'Insulin Glargine','20 units','Once daily at bedtime','2025-10-20','2026-01-20',3,'2025-10-30 22:01:31'),(6,4,'Paracetamol','500mg','Every 6 hours as needed for fever','2025-10-25','2025-10-31',4,'2025-10-30 22:01:31'),(7,4,'Amoxicillin','500mg','Three times daily','2025-10-25','2025-11-02',4,'2025-10-30 22:01:31'),(8,5,'Oxygen Therapy','Supplemental 2-4 L/min','Continuous as needed','2025-10-28',NULL,5,'2025-10-30 22:01:31'),(9,5,'Salbutamol Inhaler','2 puffs','Every 4-6 hours','2025-10-28','2025-11-28',5,'2025-10-30 22:01:31');
/*!40000 ALTER TABLE `medication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `patient_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `admission_date` date DEFAULT NULL,
  `doctor_id` int DEFAULT NULL,
  `hospital_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`patient_id`),
  KEY `doctor_id` (`doctor_id`),
  KEY `hospital_id` (`hospital_id`),
  CONSTRAINT `patient_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`doctor_id`),
  CONSTRAINT `patient_ibfk_2` FOREIGN KEY (`hospital_id`) REFERENCES `hospital` (`hospital_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES (1,'Abdullah','AlShehri','1985-03-15','Male','O+','0551111111','abdullah.sh@gmail.com','Al Malaz, Riyadh','2025-10-01',1,1,'2025-10-30 22:01:31'),(2,'Noura','AlGhamdi','1990-07-22','Female','A+','0552222222','noura.gh@gmail.com','Al Hamra, Jeddah','2025-10-15',2,1,'2025-10-30 22:01:31'),(3,'Omar','AlOtaibi','1978-11-30','Male','B+','0553333333','omar.ot@gmail.com','Al Khobar, Dammam','2025-10-20',3,2,'2025-10-30 22:01:31'),(4,'Maha','AlTamimi','1995-05-10','Female','AB+','0554444444','maha.tm@gmail.com','Al Olaya, Riyadh','2025-10-25',4,2,'2025-10-30 22:01:31'),(5,'Fahad','AlZahrani','1982-09-18','Male','O-','0555555555','fahad.zh@gmail.com','Al Nakheel, Riyadh','2025-10-28',5,3,'2025-10-30 22:01:31'),(6,'Sara','AlAhmadi','1992-05-20','Female','B+','0559999999',NULL,NULL,'2025-11-04',1,1,'2025-11-04 09:02:05');
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-14 11:09:16
