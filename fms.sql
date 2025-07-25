-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: fms
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Temporary view structure for view `all_maintenances`
--

DROP TABLE IF EXISTS `all_maintenances`;
/*!50001 DROP VIEW IF EXISTS `all_maintenances`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `all_maintenances` AS SELECT 
 1 AS `MaintenanceID`,
 1 AS `Date`,
 1 AS `VehicleID`,
 1 AS `VehiclePlate`,
 1 AS `Vehicle`,
 1 AS `OdometerReading`,
 1 AS `Description`,
 1 AS `Cost`,
 1 AS `PerformedBy`,
 1 AS `MaintenanceStatus`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `all_trips`
--

DROP TABLE IF EXISTS `all_trips`;
/*!50001 DROP VIEW IF EXISTS `all_trips`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `all_trips` AS SELECT 
 1 AS `TripID`,
 1 AS `DriverName`,
 1 AS `DriverID`,
 1 AS `DriverLicense`,
 1 AS `DriverPhone`,
 1 AS `VehicleID`,
 1 AS `VehiclePlate`,
 1 AS `Vehicle`,
 1 AS `StartTime`,
 1 AS `EndTime`,
 1 AS `OriginLocation`,
 1 AS `EndLocation`,
 1 AS `Distance`,
 1 AS `TripStatus`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `available_vehicles`
--

DROP TABLE IF EXISTS `available_vehicles`;
/*!50001 DROP VIEW IF EXISTS `available_vehicles`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `available_vehicles` AS SELECT 
 1 AS `VehicleID`,
 1 AS `PlateNumber`,
 1 AS `Make`,
 1 AS `Model`,
 1 AS `Year`,
 1 AS `VehicleStatus`,
 1 AS `OdometerReading`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `driver`
--

DROP TABLE IF EXISTS `driver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `driver` (
  `DriverID` int NOT NULL,
  `FirstName` varchar(30) NOT NULL,
  `LastName` varchar(30) NOT NULL,
  `LicenseNumber` varchar(20) NOT NULL,
  `Phone` varchar(20) NOT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `HireDate` date DEFAULT (curdate()),
  PRIMARY KEY (`DriverID`),
  UNIQUE KEY `LicenseNumber` (`LicenseNumber`),
  UNIQUE KEY `Phone` (`Phone`),
  CONSTRAINT `driver_chk_1` CHECK ((`Email` like _utf8mb4'%@%.%'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `driver`
--

LOCK TABLES `driver` WRITE;
/*!40000 ALTER TABLE `driver` DISABLE KEYS */;
INSERT INTO `driver` VALUES (-1,'Unknown','Driver','N/A','N/A','N/A@N/A.N/A','2025-06-28'),(1,'Ali','Hassan','LN001','0100000001','ali.hassan@example.com','2022-05-01'),(2,'Sara','Omar','LN002','0100000002','sara.omar@example.com','2021-11-15'),(3,'Khaled','Mahmoud','LN003','0100000003','khaled.m@example.com','2020-07-23'),(4,'Mona','Ahmed','LN004','0100000004','mona.ahmed@example.com','2023-01-05'),(5,'Hussein','Nabil','LN005','0100000005','h.nabil@example.com','2020-12-30'),(6,'Laila','Samir','LN006','0100000006','laila.samir@example.com','2019-09-09'),(7,'Youssef','Gamal','LN007','0100000007','y.gamal@example.com','2018-06-12'),(8,'Fatma','Adel','LN008','0100000008','fatma.adel@example.com','2024-02-01'),(9,'Tarek','Hassan','LN009','0100000009','t.hassan@example.com','2021-03-03'),(10,'Nour','Sami','LN010','0100000010','nour.sami@example.com','2023-07-07'),(11,'Hani','Ibrahim','LN011','0100000011','hani.ibrahim@example.com','2022-08-08'),(12,'Salma','Rami','LN012','0100000012','salma.rami@example.com','2020-10-10'),(13,'Mahmoud','Ashraf','LN013','0100000013','mahmoud.ashraf@example.com','2017-05-05'),(14,'Dina','Zaki','LN014','0100000014','dina.zaki@example.com','2024-04-14'),(15,'Omar','Khaled','LN015','0100000015','omar.khaled@example.com','2022-12-12'),(16,'Ashraf','Hassan','LN0016','01000000016','ashraf.hassan@example.com','2025-06-28'),(17,'Ahmad','Adel','LN0017','01092564876','ahmad@gmail.com','2025-07-14');
/*!40000 ALTER TABLE `driver` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_driver_delete` BEFORE DELETE ON `driver` FOR EACH ROW BEGIN
    UPDATE
        trip
    SET
        DriverID = -1
    WHERE
        DriverID = OLD.DriverID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `fuellog`
--

DROP TABLE IF EXISTS `fuellog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fuellog` (
  `FuelLogID` int NOT NULL AUTO_INCREMENT,
  `VehicleID` int NOT NULL,
  `Date` datetime DEFAULT (now()),
  `FuelType` enum('Gasoline','Diesel','Electric') DEFAULT NULL,
  `Quantity` float DEFAULT NULL,
  `Cost` decimal(10,2) NOT NULL,
  PRIMARY KEY (`FuelLogID`),
  KEY `fuellog_vehicle_idx` (`VehicleID`),
  CONSTRAINT `fuellog_ibfk_1` FOREIGN KEY (`VehicleID`) REFERENCES `vehicle` (`VehicleID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fuellog`
--

LOCK TABLES `fuellog` WRITE;
/*!40000 ALTER TABLE `fuellog` DISABLE KEYS */;
INSERT INTO `fuellog` VALUES (1,1,'2025-06-28 15:49:23','Gasoline',20,300.00),(2,2,'2025-06-28 15:49:23','Diesel',35.5,420.75),(3,3,'2025-06-28 15:49:23','Gasoline',25,375.00),(4,4,'2025-06-28 15:49:23','Diesel',30,360.00),(5,5,'2025-06-28 15:49:23','Electric',15,150.00),(6,6,'2025-06-28 15:49:23','Gasoline',40,600.00),(7,7,'2025-06-28 15:49:23','Diesel',10,120.00),(8,8,'2025-06-28 15:49:23','Electric',20,200.00),(9,9,'2025-06-28 15:49:23','Gasoline',30,450.00),(10,10,'2025-06-28 15:49:23','Diesel',22.5,270.00),(11,11,'2025-06-28 15:49:23','Gasoline',18,270.00),(12,12,'2025-06-28 15:49:23','Diesel',26,312.00),(13,13,'2025-06-28 15:49:23','Electric',12,120.00),(14,14,'2025-06-28 15:49:23','Gasoline',33.3,499.50),(15,15,'2025-06-28 15:49:23','Diesel',19,228.00),(16,1,'2025-07-05 10:30:00','Gasoline',30.5,457.50),(17,2,'2025-07-05 11:00:00','Diesel',28.2,338.40),(18,3,'2025-07-05 09:45:00','Gasoline',35,525.00),(19,4,'2025-07-05 14:20:00','Diesel',25.8,309.60),(20,5,'2025-07-05 16:00:00','Electric',18.5,185.00),(21,6,'2025-07-05 12:15:00','Gasoline',42.3,634.50),(22,7,'2025-07-05 08:30:00','Diesel',38.9,466.80),(23,8,'2025-07-05 17:45:00','Electric',22,220.00),(24,9,'2025-07-05 13:00:00','Gasoline',27.6,414.00),(25,10,'2025-07-05 10:00:00','Diesel',31.4,376.80),(26,1,'2025-07-12 14:00:00','Gasoline',38.2,573.00),(27,2,'2025-07-12 15:30:00','Diesel',41.5,498.00),(28,3,'2025-07-12 16:00:00','Gasoline',28.9,433.50),(29,4,'2025-07-12 13:45:00','Diesel',36.7,440.40),(30,5,'2025-07-12 12:00:00','Electric',25,250.00),(31,6,'2025-07-12 11:30:00','Gasoline',45.8,687.00),(32,7,'2025-07-12 09:00:00','Diesel',42.1,505.20),(33,8,'2025-07-12 18:00:00','Electric',28.5,285.00),(34,9,'2025-07-12 14:30:00','Gasoline',39.7,595.50),(35,10,'2025-07-12 16:45:00','Diesel',35.2,422.40),(36,11,'2025-07-12 10:15:00','Gasoline',33.4,501.00),(37,12,'2025-07-12 08:30:00','Diesel',37.8,453.60),(38,13,'2025-07-12 17:20:00','Electric',19.5,195.00),(39,14,'2025-07-12 15:00:00','Gasoline',41.2,618.00),(40,15,'2025-07-12 13:30:00','Diesel',29.6,355.20),(41,1,'2025-07-18 09:00:00','Gasoline',32.7,490.50),(42,2,'2025-07-18 10:30:00','Diesel',38.4,460.80),(43,3,'2025-07-18 11:45:00','Gasoline',30.2,453.00),(44,4,'2025-07-18 14:00:00','Diesel',33.5,402.00),(45,5,'2025-07-18 15:30:00','Electric',21.8,218.00),(46,6,'2025-07-18 08:15:00','Gasoline',48.3,724.50),(47,7,'2025-07-18 07:30:00','Diesel',35.7,428.40),(48,8,'2025-07-18 16:45:00','Electric',24.2,242.00),(49,9,'2025-07-18 12:00:00','Gasoline',36.1,541.50),(50,10,'2025-07-18 13:20:00','Diesel',40.8,489.60),(51,11,'2025-07-23 11:00:00','Gasoline',29.8,447.00),(52,12,'2025-07-23 09:30:00','Diesel',34.2,410.40),(53,13,'2025-07-23 14:15:00','Electric',16.7,167.00),(54,14,'2025-07-23 10:45:00','Gasoline',38.9,583.50),(55,15,'2025-07-23 12:30:00','Diesel',32.1,385.20),(56,1,'2025-07-28 08:00:00','Gasoline',35.4,531.00),(57,2,'2025-07-28 09:15:00','Diesel',43.2,518.40),(58,3,'2025-07-28 10:30:00','Gasoline',31.8,477.00),(59,4,'2025-07-28 11:45:00','Diesel',37.9,454.80),(60,5,'2025-07-28 13:00:00','Electric',26.3,263.00),(61,6,'2025-07-28 07:00:00','Gasoline',50.1,751.50),(62,7,'2025-07-28 06:30:00','Diesel',45.6,547.20),(63,8,'2025-07-28 14:15:00','Electric',30,300.00),(64,9,'2025-07-28 12:30:00','Gasoline',34.5,517.50),(65,10,'2025-07-28 15:00:00','Diesel',39.1,469.20),(66,11,'2025-07-28 16:00:00','Gasoline',27.3,409.50),(67,12,'2025-07-28 08:45:00','Diesel',40.5,486.00),(68,13,'2025-07-28 17:30:00','Electric',20.8,208.00),(69,14,'2025-07-28 13:45:00','Gasoline',44.7,670.50),(70,15,'2025-07-28 11:00:00','Diesel',36.4,436.80),(71,1,'2025-08-03 10:00:00','Gasoline',29.1,436.50),(72,2,'2025-08-03 11:30:00','Diesel',35.8,429.60),(73,3,'2025-08-03 12:45:00','Gasoline',33.2,498.00),(74,4,'2025-08-03 14:00:00','Diesel',31.4,376.80),(75,5,'2025-08-03 15:30:00','Electric',23.5,235.00),(76,6,'2025-08-03 09:00:00','Gasoline',46.9,703.50),(77,7,'2025-08-03 08:00:00','Diesel',40.2,482.40),(78,8,'2025-08-03 16:45:00','Electric',27.8,278.00),(79,9,'2025-08-03 13:15:00','Gasoline',37.4,561.00),(80,10,'2025-08-03 10:30:00','Diesel',44.3,531.60),(81,1,'2025-08-07 14:00:00','Gasoline',26.8,402.00),(82,2,'2025-08-07 15:30:00','Diesel',32.5,390.00),(83,3,'2025-08-07 16:00:00','Gasoline',28.4,426.00),(84,4,'2025-08-07 13:45:00','Diesel',35.1,421.20),(85,5,'2025-08-07 12:00:00','Electric',19.2,192.00),(86,6,'2025-08-07 11:30:00','Gasoline',41.6,624.00),(87,7,'2025-08-07 09:00:00','Diesel',38.3,459.60),(88,8,'2025-08-07 17:00:00','Electric',25.7,257.00),(89,9,'2025-08-07 14:30:00','Gasoline',30.9,463.50),(90,10,'2025-08-07 16:15:00','Diesel',36.7,440.40),(91,11,'2025-08-07 10:45:00','Gasoline',31.5,472.50),(92,12,'2025-08-07 08:30:00','Diesel',42.8,513.60),(93,13,'2025-08-07 17:45:00','Electric',17.4,174.00),(94,14,'2025-08-07 15:45:00','Gasoline',39.3,589.50),(95,15,'2025-08-07 13:00:00','Diesel',34.6,415.20);
/*!40000 ALTER TABLE `fuellog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location` (
  `LocationID` int NOT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `City` varchar(20) DEFAULT NULL,
  `Country` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`LocationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES (1,'12 Abbas St','Cairo','Egypt'),(2,'45 Tahrir Ave','Giza','Egypt'),(3,'78 Ramsis Rd','Cairo','Egypt'),(4,'101 October Blvd','6th October','Egypt'),(5,'200 AlNasr St','Nasr City','Egypt'),(6,'303 Zamalek St','Cairo','Egypt'),(7,'89 Maadi Ring Rd','Maadi','Egypt'),(8,'50 Dokki St','Giza','Egypt'),(9,'88 Al Mohandeseen','Giza','Egypt'),(10,'100 Suez Rd','Heliopolis','Egypt'),(11,'23 New Cairo','New Cairo','Egypt'),(12,'16 Rehab City','New Cairo','Egypt'),(13,'70 Shubra Rd','Cairo','Egypt'),(14,'31 Marina St','Alexandria','Egypt'),(15,'90 Coastal Rd','Marsa Matrouh','Egypt');
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenance`
--

DROP TABLE IF EXISTS `maintenance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance` (
  `MaintenanceID` int NOT NULL AUTO_INCREMENT,
  `VehicleID` int NOT NULL,
  `Description` text,
  `Date` datetime DEFAULT (now()),
  `Cost` decimal(10,2) NOT NULL,
  `PerformedBy` enum('Midas','Meineke Car Care Centers','Christian Brothers Automotive','AAMCO Transmissions','CARSTAR','Jiffy Lube','Firestone Complete Auto Care','Monro, Inc.','NTB','Big O Tires') DEFAULT NULL,
  `MaintenanceStatus` enum('Ongoing','Completed','Canceled') NOT NULL DEFAULT 'Ongoing',
  PRIMARY KEY (`MaintenanceID`),
  KEY `maintenance_vehicle_idx` (`VehicleID`),
  CONSTRAINT `maintenance_ibfk_1` FOREIGN KEY (`VehicleID`) REFERENCES `vehicle` (`VehicleID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance`
--

LOCK TABLES `maintenance` WRITE;
/*!40000 ALTER TABLE `maintenance` DISABLE KEYS */;
INSERT INTO `maintenance` VALUES (1,10,'Coolant flush','2025-06-28 15:54:45',300.00,'Jiffy Lube','Completed'),(2,11,'Alignment check','2025-06-28 15:54:45',250.00,'NTB','Completed'),(3,12,'Exhaust system inspection','2025-06-28 15:54:45',400.00,'Firestone Complete Auto Care','Completed'),(4,13,'Timing belt replacement','2025-06-28 15:54:45',1100.00,'Midas','Completed'),(5,14,'Fuel system cleaning','2025-06-28 15:54:45',350.00,'Meineke Car Care Centers','Completed'),(6,15,'Air conditioning repair','2025-06-28 15:54:45',650.00,'NTB','Completed'),(7,3,'Oil change and filter replacement','2025-01-10 09:30:00',49.99,'Jiffy Lube','Completed'),(8,3,'Tire rotation','2025-02-15 10:00:00',30.00,'Jiffy Lube','Completed'),(9,3,'Brake inspection','2025-03-20 14:45:00',35.50,'Jiffy Lube','Completed'),(10,7,'Battery replacement','2025-04-01 13:20:00',120.00,'Firestone Complete Auto Care','Completed'),(11,7,'AC service','2025-04-15 11:00:00',89.99,'Firestone Complete Auto Care','Completed'),(12,7,'Engine diagnostic','2025-05-02 09:00:00',75.00,'Firestone Complete Auto Care','Completed'),(13,12,'Suspension check','2025-03-05 15:00:00',60.00,'Midas','Completed'),(14,12,'Wheel alignment','2025-03-12 10:15:00',80.00,'Midas','Completed'),(15,12,'Muffler replacement','2025-03-20 12:00:00',150.00,'Midas','Completed'),(16,1,'Transmission service','2025-01-25 11:00:00',220.00,'AAMCO Transmissions','Completed'),(17,2,'Oil leak fix','2025-02-03 09:00:00',145.50,'Christian Brothers Automotive','Completed'),(18,4,'Brake pads replacement','2025-02-18 13:30:00',95.00,'Meineke Car Care Centers','Completed'),(19,5,'Coolant flush','2025-03-01 10:30:00',89.00,'Big O Tires','Completed'),(20,6,'Spark plug replacement','2025-03-08 14:00:00',65.75,'CARSTAR','Completed'),(21,8,'Fuel system cleaning','2025-03-22 09:45:00',99.99,'NTB','Completed'),(22,9,'Check engine light diagnosis','2025-04-02 11:15:00',50.00,'Jiffy Lube','Completed'),(23,10,'Timing belt replacement','2025-04-15 12:30:00',340.00,'Monro, Inc.','Completed'),(24,11,'Heater core replacement','2025-05-01 15:45:00',270.00,'Christian Brothers Automotive','Completed'),(25,13,'Power steering repair','2025-05-10 10:00:00',190.00,'Meineke Car Care Centers','Completed'),(26,14,'Air filter replacement','2025-05-12 08:30:00',25.00,'NTB','Completed'),(27,15,'Battery check','2025-05-20 14:30:00',40.00,'Big O Tires','Completed'),(28,1,'Brake fluid flush','2025-06-01 09:00:00',55.00,'Firestone Complete Auto Care','Completed'),(29,2,'Radiator replacement','2025-06-08 13:00:00',210.00,'AAMCO Transmissions','Completed'),(30,4,'Windshield wiper motor fix','2025-06-15 10:45:00',75.00,'CARSTAR','Completed'),(31,5,'Headlight restoration','2025-06-22 16:00:00',60.00,'Midas','Completed'),(32,6,'ABS light check','2025-07-01 11:20:00',40.00,'Monro, Inc.','Completed'),(33,8,'Tire replacement','2025-07-05 14:10:00',300.00,'Big O Tires','Completed'),(34,9,'Drive belt inspection','2025-07-10 12:00:00',65.00,'Meineke Car Care Centers','Completed'),(35,1,'Exhaust system inspection','2025-07-12 18:13:00',400.00,'Firestone Complete Auto Care','Completed'),(36,1,'Exhaust system inspection','2025-07-12 18:16:10',400.00,'Firestone Complete Auto Care','Completed'),(37,7,'Engine Fix','2025-07-14 17:30:31',600.00,'NTB','Completed'),(38,3,'Oil change','2025-07-14 17:31:26',50.00,'Christian Brothers Automotive','Completed'),(39,13,'Tires change','2025-07-14 17:33:10',100.00,'Big O Tires','Completed'),(40,4,'oil change','2025-07-15 07:26:50',50.00,'Midas','Completed'),(41,3,'oil change','2025-07-15 07:38:54',50.00,'Meineke Car Care Centers','Completed');
/*!40000 ALTER TABLE `maintenance` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_maintenance_insert` BEFORE INSERT ON `maintenance` FOR EACH ROW BEGIN    
    IF get_vehicle_status(NEW.VehicleID) = 'In Trip' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot assign Maintenance: Vehicle In Trip';
    END IF;

    IF get_vehicle_status(NEW.VehicleID) = 'In Maintenance' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot assign a new maintenance for the same vehicle while another one is Ongoing';
    END IF;

    IF get_vehicle_status(NEW.VehicleID) = 'Unavailable' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot assign Maintenance: Vehicle Unavailable';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_maintenance_insert` AFTER INSERT ON `maintenance` FOR EACH ROW BEGIN
    IF NEW.MaintenanceStatus = 'Ongoing' THEN
        UPDATE vehicle 
        SET VehicleStatus = 'In Maintenance'
        WHERE VehicleID = NEW.VehicleID;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_maintenance_update` AFTER UPDATE ON `maintenance` FOR EACH ROW BEGIN
    IF NEW.MaintenanceStatus = 'Completed' THEN
        UPDATE vehicle
        SET VehicleStatus = 'Available'
        WHERE VehicleID = NEW.VehicleID;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `ongoing_maintenances`
--

DROP TABLE IF EXISTS `ongoing_maintenances`;
/*!50001 DROP VIEW IF EXISTS `ongoing_maintenances`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `ongoing_maintenances` AS SELECT 
 1 AS `MaintenanceID`,
 1 AS `Date`,
 1 AS `VehicleID`,
 1 AS `VehiclePlate`,
 1 AS `Vehicle`,
 1 AS `OdometerReading`,
 1 AS `Description`,
 1 AS `Cost`,
 1 AS `PerformedBy`,
 1 AS `MaintenanceStatus`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `ongoing_trips`
--

DROP TABLE IF EXISTS `ongoing_trips`;
/*!50001 DROP VIEW IF EXISTS `ongoing_trips`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `ongoing_trips` AS SELECT 
 1 AS `TripID`,
 1 AS `DriverID`,
 1 AS `DriverName`,
 1 AS `DriverLicense`,
 1 AS `DriverPhone`,
 1 AS `VehicleID`,
 1 AS `VehiclePlate`,
 1 AS `Vehicle`,
 1 AS `StartTime`,
 1 AS `EndTime`,
 1 AS `OriginLocation`,
 1 AS `EndLocation`,
 1 AS `Distance`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `past_trips`
--

DROP TABLE IF EXISTS `past_trips`;
/*!50001 DROP VIEW IF EXISTS `past_trips`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `past_trips` AS SELECT 
 1 AS `TripID`,
 1 AS `DriverName`,
 1 AS `DriverID`,
 1 AS `DriverLicense`,
 1 AS `DriverPhone`,
 1 AS `VehicleID`,
 1 AS `VehiclePlate`,
 1 AS `Vehicle`,
 1 AS `StartTime`,
 1 AS `EndTime`,
 1 AS `OriginLocation`,
 1 AS `EndLocation`,
 1 AS `Distance`,
 1 AS `TripStatus`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `trip`
--

DROP TABLE IF EXISTS `trip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trip` (
  `TripID` int NOT NULL AUTO_INCREMENT,
  `DriverID` int NOT NULL,
  `VehicleID` int NOT NULL,
  `OriginLocationID` int DEFAULT NULL,
  `DestinationLocationID` int DEFAULT NULL,
  `StartTime` datetime DEFAULT (now()),
  `EndTime` datetime DEFAULT '9999-12-31 23:59:59',
  `Distance` float DEFAULT NULL,
  `TripStatus` enum('Ongoing','Completed','Canceled') NOT NULL DEFAULT 'Ongoing',
  PRIMARY KEY (`TripID`),
  KEY `OriginLocationID` (`OriginLocationID`),
  KEY `DestinationLocationID` (`DestinationLocationID`),
  KEY `trip_driver_idx` (`DriverID`),
  KEY `trip_vehicle_idx` (`VehicleID`),
  KEY `trip_day_idx` ((dayofmonth(`StartTime`))),
  CONSTRAINT `trip_ibfk_1` FOREIGN KEY (`DriverID`) REFERENCES `driver` (`DriverID`),
  CONSTRAINT `trip_ibfk_2` FOREIGN KEY (`VehicleID`) REFERENCES `vehicle` (`VehicleID`),
  CONSTRAINT `trip_ibfk_3` FOREIGN KEY (`OriginLocationID`) REFERENCES `location` (`LocationID`) ON DELETE SET NULL,
  CONSTRAINT `trip_ibfk_4` FOREIGN KEY (`DestinationLocationID`) REFERENCES `location` (`LocationID`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=228 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trip`
--

LOCK TABLES `trip` WRITE;
/*!40000 ALTER TABLE `trip` DISABLE KEYS */;
INSERT INTO `trip` VALUES (1,1,1,1,2,'2025-06-28 15:43:37','2025-06-28 17:48:36',8.5,'Completed'),(2,2,2,3,4,'2025-06-28 15:43:37','2025-06-28 17:48:36',12,'Completed'),(3,3,3,5,6,'2025-06-28 15:43:37','2025-06-28 17:48:36',25,'Completed'),(4,4,4,7,8,'2025-06-28 15:43:37','2025-06-28 18:06:01',3.3,'Completed'),(5,5,5,9,10,'2025-06-28 15:43:37','2025-06-28 18:06:01',45,'Completed'),(6,6,6,11,12,'2025-06-28 15:43:37','2025-06-28 18:06:01',19.7,'Completed'),(7,7,7,13,14,'2025-06-28 15:43:37','2025-06-28 18:06:01',50,'Completed'),(8,8,8,1,5,'2025-06-28 15:43:37','2025-07-12 18:40:16',15.3,'Completed'),(9,9,9,2,3,'2025-06-28 15:43:37','2025-06-28 18:06:01',7.2,'Completed'),(10,10,10,4,11,'2025-06-28 15:43:37','2025-07-12 18:40:16',28.4,'Canceled'),(11,11,11,6,7,'2025-06-28 15:43:37','2025-06-28 18:06:24',10,'Canceled'),(12,12,12,8,9,'2025-06-28 15:43:37','2025-06-28 18:06:24',14.9,'Canceled'),(45,1,12,1,2,'2025-07-09 10:34:41','2025-07-12 18:40:16',29.5,'Completed'),(46,2,5,3,4,'2025-07-09 10:35:03','2025-07-12 18:40:16',12,'Completed'),(47,3,7,5,6,'2025-07-09 10:35:15','2025-07-12 18:40:16',2,'Completed'),(54,4,2,7,8,'2025-07-09 10:36:35','2025-07-12 18:40:16',31.3,'Completed'),(55,5,1,9,10,'2025-07-09 10:36:46','2025-07-12 18:40:16',20,'Completed'),(56,6,6,11,12,'2025-07-09 10:36:54','2025-07-12 18:40:16',69.7,'Completed'),(57,7,4,13,14,'2025-07-09 10:37:18','2025-07-12 18:40:16',60,'Completed'),(58,8,10,1,15,'2025-07-09 10:38:34','2025-07-12 18:40:16',10.5,'Completed'),(59,9,3,2,3,'2025-07-09 10:38:40','2025-07-12 18:40:16',90.2,'Completed'),(60,1,1,3,7,'2025-07-09 17:46:41','2025-07-12 18:40:16',45.2,'Completed'),(61,2,2,1,9,'2025-07-09 17:46:41','2025-07-12 18:40:16',23.5,'Completed'),(62,3,3,3,7,'2025-07-09 17:46:41','2025-07-12 18:40:16',22.8,'Completed'),(63,4,4,8,14,'2025-07-09 17:46:41','2025-07-12 18:40:16',34.1,'Completed'),(64,5,5,2,9,'2025-07-09 17:46:41','2025-07-12 18:40:16',18.9,'Completed'),(65,6,6,10,4,'2025-07-09 17:46:41','2025-07-12 18:40:16',52.3,'Completed'),(66,7,7,11,6,'2025-07-09 17:46:41','2025-07-12 18:40:16',28.9,'Completed'),(67,8,8,13,1,'2025-07-09 17:46:41','2025-07-12 18:40:16',41.5,'Completed'),(68,9,9,7,14,'2025-07-09 17:46:41','2025-07-12 18:40:16',68.3,'Completed'),(69,10,10,14,8,'2025-07-09 17:46:41','2025-07-12 18:40:16',38.2,'Completed'),(70,11,11,4,11,'2025-07-09 17:46:41','2025-07-12 18:40:16',71.4,'Completed'),(71,12,12,9,2,'2025-07-09 17:46:41','2025-07-12 18:40:16',26.8,'Completed'),(72,13,3,6,10,'2025-07-09 17:46:55','2025-07-12 18:40:16',33.7,'Completed'),(73,14,7,15,5,'2025-07-09 17:46:55','2025-07-12 18:40:16',48.9,'Completed'),(74,15,2,8,13,'2025-07-09 17:46:55','2025-07-12 18:40:16',22.1,'Completed'),(75,16,9,1,4,'2025-07-09 17:46:55','2025-07-12 18:40:16',59.3,'Completed'),(76,1,5,12,7,'2025-07-09 17:46:55','2025-07-12 18:40:16',36.5,'Completed'),(77,3,11,3,7,'2025-07-09 17:46:55','2025-07-12 18:40:16',22.8,'Completed'),(78,5,1,9,6,'2025-07-09 17:46:55','2025-07-12 18:40:16',17.8,'Completed'),(79,7,8,2,11,'2025-07-09 17:46:55','2025-07-12 18:40:16',54.6,'Completed'),(80,9,4,10,15,'2025-07-09 17:46:55','2025-07-12 18:40:16',92.4,'Completed'),(81,11,12,5,8,'2025-07-09 17:46:55','2025-07-12 18:40:16',61.7,'Completed'),(82,13,6,14,1,'2025-07-09 17:46:55','2025-07-12 18:40:16',24.5,'Completed'),(83,15,10,7,12,'2025-07-09 17:46:55','2025-07-12 18:40:16',39.1,'Completed'),(84,2,8,4,9,'2025-07-09 17:47:17','2025-07-12 18:40:16',51.4,'Completed'),(85,4,1,11,1,'2025-07-09 17:47:17','2025-07-12 18:40:16',27.9,'Completed'),(86,6,5,10,15,'2025-07-09 17:47:17','2025-07-12 18:40:16',92.4,'Completed'),(87,8,12,6,2,'2025-07-09 17:47:17','2025-07-12 18:40:16',31.5,'Completed'),(88,10,3,13,7,'2025-07-09 17:47:17','2025-07-12 18:40:16',57.8,'Completed'),(89,12,7,1,14,'2025-07-09 17:47:17','2025-07-12 18:40:16',25.3,'Completed'),(90,14,9,8,5,'2025-07-09 17:47:17','2025-07-12 18:40:16',40.9,'Completed'),(91,16,2,12,4,'2025-07-09 17:47:17','2025-07-12 18:40:16',19.6,'Completed'),(92,1,11,3,15,'2025-07-09 17:47:17','2025-07-12 18:40:16',62.1,'Completed'),(93,3,4,9,11,'2025-07-09 17:47:17','2025-07-12 18:40:16',35.4,'Completed'),(94,5,6,2,8,'2025-07-09 17:47:17','2025-07-12 18:40:16',47.2,'Completed'),(95,7,10,14,6,'2025-07-09 17:47:17','2025-07-12 18:40:16',28.7,'Completed'),(96,9,2,10,1,'2025-07-09 17:47:36','2025-07-12 18:40:16',55.3,'Completed'),(97,11,7,5,13,'2025-07-09 17:47:36','2025-07-12 18:40:16',21.8,'Completed'),(98,13,12,8,3,'2025-07-09 17:47:36','2025-07-12 18:40:16',42.6,'Completed'),(99,15,4,15,9,'2025-07-09 17:47:36','2025-07-12 18:40:16',37.1,'Completed'),(100,2,9,6,14,'2025-07-09 17:47:36','2025-07-12 18:40:16',49.5,'Completed'),(101,4,3,11,2,'2025-07-09 17:47:36','2025-07-12 18:40:16',16.3,'Completed'),(102,6,8,1,5,'2025-07-09 17:47:36','2025-07-12 18:40:16',15.3,'Completed'),(103,8,5,7,4,'2025-07-09 17:47:36','2025-07-12 18:40:16',32.7,'Completed'),(104,10,1,13,10,'2025-07-09 17:47:36','2025-07-12 18:40:16',45.1,'Completed'),(105,12,11,6,10,'2025-07-09 17:47:36','2025-07-12 18:40:16',32.1,'Completed'),(106,14,6,9,15,'2025-07-09 17:47:36','2025-07-12 18:40:16',64.2,'Completed'),(107,16,10,2,9,'2025-07-09 17:47:36','2025-07-12 18:40:16',18.9,'Completed'),(108,1,7,14,8,'2025-07-09 17:47:46','2025-07-12 18:40:16',38.5,'Completed'),(109,3,2,4,11,'2025-07-09 17:47:46','2025-07-12 18:40:16',53.2,'Completed'),(110,5,9,10,3,'2025-07-09 17:47:46','2025-07-12 18:40:16',20.7,'Completed'),(111,7,1,7,14,'2025-07-09 17:47:46','2025-07-12 18:40:16',68.3,'Completed'),(112,9,12,15,7,'2025-07-09 17:47:46','2025-07-12 18:40:16',34.3,'Completed'),(113,11,5,2,9,'2025-07-09 17:47:46','2025-07-12 18:40:16',60.1,'Completed'),(114,13,8,11,1,'2025-07-09 17:47:46','2025-07-12 18:40:16',27.9,'Completed'),(115,15,3,5,14,'2025-07-09 17:47:46','2025-07-12 18:40:16',41.9,'Completed'),(116,2,10,8,12,'2025-07-09 17:47:46','2025-07-12 18:40:16',35.6,'Completed'),(117,4,6,4,11,'2025-07-09 17:47:46','2025-07-12 18:40:16',28.4,'Completed'),(118,6,11,1,10,'2025-07-09 17:47:46','2025-07-12 18:40:16',30.2,'Completed'),(119,8,4,8,12,'2025-07-09 17:47:46','2025-07-12 18:40:16',35.6,'Completed'),(120,10,9,3,5,'2025-07-09 17:47:54','2025-07-12 18:40:16',43.8,'Completed'),(121,12,2,9,14,'2025-07-09 17:47:54','2025-07-12 18:40:16',24.1,'Completed'),(122,14,7,12,6,'2025-07-09 17:47:54','2025-07-12 18:40:16',59.4,'Completed'),(123,16,1,4,8,'2025-07-09 17:47:54','2025-07-12 18:40:16',35.9,'Completed'),(124,1,8,15,2,'2025-07-09 17:47:54','2025-07-12 18:40:16',50.3,'Completed'),(125,3,12,10,11,'2025-07-09 17:47:54','2025-07-12 18:40:16',22.6,'Completed'),(126,5,3,7,1,'2025-07-09 17:47:54','2025-07-12 18:40:16',47.1,'Completed'),(127,7,5,13,9,'2025-07-09 17:47:54','2025-07-12 18:40:16',31.8,'Completed'),(128,9,11,6,10,'2025-07-09 17:47:54','2025-07-12 18:40:16',32.1,'Completed'),(129,11,4,2,15,'2025-07-09 17:47:54','2025-07-12 18:40:16',28.5,'Completed'),(130,13,10,8,7,'2025-07-09 17:47:54','2025-07-12 18:40:16',63.7,'Completed'),(131,15,6,14,12,'2025-07-09 17:47:54','2025-07-12 18:40:16',19.9,'Completed'),(132,1,1,1,5,'2025-07-15 08:00:00','2025-07-15 08:45:00',15.3,'Completed'),(133,2,2,3,7,'2025-07-15 08:15:00','2025-07-15 09:00:00',22.8,'Completed'),(134,3,3,1,5,'2025-07-15 09:00:00','2025-07-15 09:50:00',15.3,'Completed'),(135,4,4,8,12,'2025-07-15 09:30:00','2025-07-15 10:45:00',35.6,'Completed'),(136,5,5,3,7,'2025-07-15 10:00:00','2025-07-15 10:48:00',22.8,'Completed'),(137,6,6,14,15,'2025-07-15 10:30:00','2025-07-15 13:15:00',85.2,'Completed'),(138,7,7,2,9,'2025-07-15 11:00:00','2025-07-15 11:40:00',18.9,'Completed'),(139,8,8,8,12,'2025-07-15 11:15:00','2025-07-15 12:30:00',35.6,'Completed'),(140,9,9,4,11,'2025-07-15 12:00:00','2025-07-15 12:55:00',28.4,'Completed'),(141,10,10,1,5,'2025-07-15 13:00:00','2025-07-15 13:47:00',15.3,'Completed'),(151,1,1,1,5,'2025-07-15 08:00:00','2025-07-15 08:45:00',15.3,'Completed'),(152,2,2,3,7,'2025-07-15 08:15:00','2025-07-15 09:00:00',22.8,'Completed'),(153,3,3,1,5,'2025-07-15 09:00:00','2025-07-15 09:50:00',15.3,'Completed'),(154,4,4,8,12,'2025-07-15 09:30:00','2025-07-15 10:45:00',35.6,'Completed'),(155,5,5,3,7,'2025-07-15 10:00:00','2025-07-15 10:48:00',22.8,'Completed'),(156,6,6,14,15,'2025-07-15 10:30:00','2025-07-15 13:15:00',85.2,'Completed'),(157,7,7,2,9,'2025-07-15 11:00:00','2025-07-15 11:40:00',18.9,'Completed'),(158,8,8,8,12,'2025-07-15 11:15:00','2025-07-15 12:30:00',35.6,'Completed'),(159,9,9,4,11,'2025-07-15 12:00:00','2025-07-15 12:55:00',28.4,'Completed'),(160,10,10,1,5,'2025-07-15 13:00:00','2025-07-15 13:47:00',15.3,'Completed'),(179,11,11,6,10,'2025-07-20 07:30:00','2025-07-20 08:25:00',32.1,'Completed'),(180,12,12,2,9,'2025-07-20 08:00:00','2025-07-20 08:42:00',18.9,'Completed'),(181,13,13,13,1,'2025-07-20 09:00:00','2025-07-20 10:20:00',42.7,'Completed'),(182,14,14,6,10,'2025-07-20 10:00:00','2025-07-20 10:58:00',32.1,'Completed'),(183,15,15,4,11,'2025-07-20 11:00:00','2025-07-20 11:52:00',28.4,'Completed'),(184,16,1,5,8,'2025-07-20 12:00:00','2025-07-20 12:35:00',16.8,'Completed'),(185,1,2,13,1,'2025-07-20 13:00:00','2025-07-20 14:18:00',42.7,'Completed'),(186,2,3,11,3,'2025-07-20 14:00:00','2025-07-20 15:05:00',38.2,'Completed'),(187,3,4,5,8,'2025-07-20 15:00:00','2025-07-20 15:37:00',16.8,'Completed'),(188,4,5,7,14,'2025-07-25 06:00:00','2025-07-25 07:45:00',68.3,'Completed'),(189,5,6,9,2,'2025-07-25 07:00:00','2025-07-25 07:43:00',19.5,'Completed'),(190,6,7,11,3,'2025-07-25 08:00:00','2025-07-25 09:02:00',38.2,'Completed'),(191,7,8,7,14,'2025-07-25 09:00:00','2025-07-25 10:48:00',68.3,'Completed'),(192,8,9,10,15,'2025-07-25 10:00:00','2025-07-25 12:25:00',92.4,'Completed'),(193,9,10,9,2,'2025-07-25 11:00:00','2025-07-25 11:45:00',19.5,'Completed'),(194,10,11,12,4,'2025-07-25 12:00:00','2025-07-25 12:55:00',29.7,'Completed'),(195,11,12,3,6,'2025-07-25 13:00:00','2025-07-25 13:38:00',17.2,'Completed'),(196,12,13,10,15,'2025-07-25 14:00:00','2025-07-25 16:28:00',92.4,'Completed'),(197,13,14,12,4,'2025-07-25 15:00:00','2025-07-25 15:52:00',29.7,'Completed'),(198,14,15,1,8,'2025-08-01 08:30:00','2025-08-01 09:15:00',24.6,'Completed'),(199,15,1,3,6,'2025-08-01 09:00:00','2025-08-01 09:40:00',17.2,'Completed'),(200,16,2,5,12,'2025-08-01 10:00:00','2025-08-01 11:10:00',41.3,'Completed'),(201,1,3,1,8,'2025-08-01 11:00:00','2025-08-01 11:48:00',24.6,'Completed'),(202,2,4,7,13,'2025-08-01 12:00:00','2025-08-01 13:05:00',36.8,'Completed'),(203,3,5,5,12,'2025-08-01 13:00:00','2025-08-01 14:08:00',41.3,'Completed'),(204,4,6,9,11,'2025-08-01 14:00:00','2025-08-01 14:42:00',20.1,'Completed'),(205,5,7,7,13,'2025-08-01 15:00:00','2025-08-01 16:02:00',36.8,'Completed'),(206,6,8,2,10,'2025-08-01 16:00:00','2025-08-01 16:55:00',33.4,'Completed'),(207,7,9,9,11,'2025-08-01 17:00:00','2025-08-01 17:40:00',20.1,'Completed'),(208,8,10,4,15,'2025-08-05 07:00:00','2025-08-05 09:35:00',95.7,'Completed'),(209,9,11,2,10,'2025-08-05 08:00:00','2025-08-05 08:58:00',33.4,'Completed'),(210,10,12,6,8,'2025-08-05 09:00:00','2025-08-05 09:32:00',14.8,'Completed'),(211,11,13,4,15,'2025-08-05 10:00:00','2025-08-05 12:38:00',95.7,'Completed'),(212,12,14,11,1,'2025-08-05 11:00:00','2025-08-05 11:52:00',27.9,'Completed'),(213,13,15,6,8,'2025-08-05 12:00:00','2025-08-05 12:30:00',14.8,'Completed'),(214,14,1,13,5,'2025-08-05 13:00:00','2025-08-05 13:48:00',25.3,'Completed'),(215,15,2,11,1,'2025-08-05 14:00:00','2025-08-05 14:50:00',27.9,'Completed'),(216,16,3,8,14,'2025-08-05 15:00:00','2025-08-05 16:55:00',78.2,'Completed'),(217,1,4,13,5,'2025-08-05 16:00:00','2025-08-05 16:45:00',25.3,'Completed'),(218,17,1,2,12,'2025-07-14 16:16:58','2025-07-14 16:17:16',40,'Completed'),(219,17,2,1,3,'2025-07-14 16:18:28','2025-07-14 17:18:42',30,'Completed'),(220,15,13,7,11,'2025-07-14 17:31:57','2025-07-14 17:33:27',35,'Completed'),(221,2,11,5,9,'2025-07-14 17:41:48','2025-07-14 17:42:58',45,'Canceled'),(222,9,8,10,5,'2025-07-14 17:44:32','2025-07-14 19:33:35',33,'Completed'),(223,2,5,10,12,'2025-07-15 07:06:55','2025-07-15 07:10:58',22,'Completed'),(224,4,5,3,6,'2025-07-15 07:16:25','2025-07-15 07:17:44',23,'Completed'),(225,4,10,8,10,'2025-07-15 07:24:27','2025-07-15 07:25:27',34,'Completed'),(226,4,6,6,9,'2025-07-15 07:37:21','2025-07-15 07:38:08',30,'Completed'),(227,10,8,4,14,'2025-07-15 07:54:08','2025-07-15 07:54:41',20,'Completed');
/*!40000 ALTER TABLE `trip` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_trip_insert` BEFORE INSERT ON `trip` FOR EACH ROW BEGIN    
    -- Check if vehicle is in maintenance
    IF get_vehicle_status(NEW.VehicleID) = 'In Maintenance'
        THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot assign trip: Vehicle In Maintenance';
    END IF;

    -- Check if vehicle is already in a trip
    IF get_vehicle_status(NEW.VehicleID) = 'In Trip'
        THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot assign trip: Vehicle In Trip';
    END IF;

    IF get_vehicle_status(NEW.VehicleID) = 'Unavailable'
        THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot assign trip: Vehicle Unavailable';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_trip_insert` AFTER INSERT ON `trip` FOR EACH ROW BEGIN
    IF NEW.TripStatus = 'Ongoing' THEN
        UPDATE
            vehicle 
        SET
            VehicleStatus = 'In Trip'
        WHERE
            VehicleID = NEW.VehicleID;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_trip_update` BEFORE UPDATE ON `trip` FOR EACH ROW BEGIN
    IF NEW.TripStatus = 'Completed' OR NEW.TripStatus = 'Canceled' THEN
        -- Update the trip end time
        SET NEW.EndTime = CURRENT_TIMESTAMP;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_trip_update` AFTER UPDATE ON `trip` FOR EACH ROW BEGIN
    IF NEW.TripStatus = 'Completed' OR NEW.TripStatus = 'Canceled' THEN
        -- Update the vehicle status  
        UPDATE 
            vehicle
        SET
            VehicleStatus = 'Available'
        WHERE
            VehicleID = NEW.VehicleID;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `vehicle`
--

DROP TABLE IF EXISTS `vehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle` (
  `VehicleID` int NOT NULL,
  `PlateNumber` varchar(20) NOT NULL,
  `Make` varchar(20) NOT NULL,
  `Model` varchar(30) NOT NULL,
  `Year` int DEFAULT NULL,
  `VehicleStatus` enum('Available','In Maintenance','In Trip','Unavailable') NOT NULL DEFAULT 'Available',
  `OdometerReading` int DEFAULT NULL,
  PRIMARY KEY (`VehicleID`),
  UNIQUE KEY `PlateNumber` (`PlateNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle`
--

LOCK TABLES `vehicle` WRITE;
/*!40000 ALTER TABLE `vehicle` DISABLE KEYS */;
INSERT INTO `vehicle` VALUES (-1,'UNKNOWN','N/A','N/A',0,'Unavailable',0),(1,'ABC123','Toyota','Corolla',2019,'Unavailable',45000),(2,'DEF456','Honda','Civic',2018,'Unavailable',60000),(3,'GHI789','Hyundai','Elantra',2020,'Unavailable',30000),(4,'JKL012','Chevrolet','Spark',2021,'Available',15000),(5,'MNO345','Ford','Focus',2017,'Available',70000),(6,'PQR678','Nissan','Sentra',2022,'Available',20000),(7,'STU901','Kia','Rio',2019,'Available',42000),(8,'VWX234','Mazda','3',2020,'Available',35000),(9,'YZA567','BMW','X1',2021,'Available',18000),(10,'BCD890','Mercedes','A-Class',2022,'Available',12000),(11,'EFG123','Volkswagen','Golf',2019,'Available',39000),(12,'HIJ456','Renault','Clio',2018,'Available',55000),(13,'KLM789','Peugeot','208',2021,'Available',27000),(14,'NOP012','Skoda','Fabia',2020,'Available',34000),(15,'QRS345','Opel','Corsa',2023,'Available',9000);
/*!40000 ALTER TABLE `vehicle` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_vehicle_delete` BEFORE DELETE ON `vehicle` FOR EACH ROW BEGIN
    UPDATE
        trip
    SET
        VehicleID = -1
    WHERE
        VehicleID = OLD.VehicleID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `vehicles_in_maintenance`
--

DROP TABLE IF EXISTS `vehicles_in_maintenance`;
/*!50001 DROP VIEW IF EXISTS `vehicles_in_maintenance`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vehicles_in_maintenance` AS SELECT 
 1 AS `VehicleID`,
 1 AS `PlateNumber`,
 1 AS `Make`,
 1 AS `Model`,
 1 AS `Year`,
 1 AS `VehicleStatus`,
 1 AS `OdometerReading`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `violation`
--

DROP TABLE IF EXISTS `violation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `violation` (
  `ViolationID` int NOT NULL AUTO_INCREMENT,
  `VehicleID` int NOT NULL,
  `Date` datetime DEFAULT (now()),
  `Description` text,
  `PenaltyAmount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`ViolationID`),
  KEY `violation_vehicle_idx` (`VehicleID`),
  KEY `violation_day_idx` ((dayofmonth(`Date`))),
  CONSTRAINT `violation_ibfk_1` FOREIGN KEY (`VehicleID`) REFERENCES `vehicle` (`VehicleID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `violation`
--

LOCK TABLES `violation` WRITE;
/*!40000 ALTER TABLE `violation` DISABLE KEYS */;
INSERT INTO `violation` VALUES (1,1,'2025-06-28 15:56:33','Speeding in a residential area',500.00),(2,2,'2025-06-28 15:56:33','Illegal parking',250.00),(3,3,'2025-06-28 15:56:33','Running a red light',800.00),(4,4,'2025-06-28 15:56:33','No seat belt',150.00),(5,5,'2025-06-28 15:56:33','Expired registration',300.00),(6,6,'2025-06-28 15:56:33','Driving without insurance',1000.00),(7,7,'2025-06-28 15:56:33','Tinted windows',200.00),(8,8,'2025-06-28 15:56:33','Broken tail light',100.00),(9,9,'2025-06-28 15:56:33','Illegal U-turn',350.00),(10,10,'2025-06-28 15:56:33','Distracted driving',400.00),(11,11,'2025-06-28 15:56:33','Speeding',600.00),(12,12,'2025-06-28 15:56:33','Improper lane change',250.00),(13,13,'2025-06-28 15:56:33','Tailgating',300.00),(14,14,'2025-06-28 15:56:33','Failure to stop at stop sign',450.00),(15,15,'2025-06-28 15:56:33','Unlawful vehicle modification',700.00),(16,7,'2025-07-09 16:23:37','No seat belt',521.25),(17,7,'2025-07-09 17:46:44','Improper lane change',510.91),(18,7,'2025-07-09 17:46:41','No seat belt',450.84),(19,9,'2025-07-09 17:47:47','No seat belt',769.89),(20,1,'2025-07-09 17:46:43','Distracted driving',112.73),(21,3,'2025-07-09 11:44:55','Improper lane change',820.77),(22,5,'2025-07-09 17:01:08','Failure to yield',521.66),(23,9,'2025-07-09 17:47:37','Driving in restricted lane',442.18),(24,5,'2025-07-09 17:27:21','Illegal parking',283.88),(25,3,'2025-07-09 17:30:07','Failure to signal',617.96),(26,1,'2025-07-09 11:47:55','Illegal U-turn',666.19),(27,7,'2025-07-09 11:46:35','Expired registration',499.56),(28,1,'2025-07-09 11:10:38','Speeding',853.19),(29,9,'2025-07-09 17:46:43','Failure to yield',365.93),(30,5,'2025-07-09 10:51:02','Driving without insurance',984.43),(31,3,'2025-07-09 10:40:23','Reckless driving',786.22),(32,7,'2025-07-09 15:50:00','Tailgating',253.36),(33,2,'2025-07-09 16:22:18','Tinted windows',178.65),(34,4,'2025-07-09 11:34:15','Broken tail light',307.93),(35,6,'2025-07-09 11:00:22','Improper lane change',475.21),(36,8,'2025-07-09 14:09:01','Driving without insurance',899.00),(37,10,'2025-07-09 17:46:44','Speeding',742.14),(38,11,'2025-07-09 17:46:44','Tailgating',629.37),(39,12,'2025-07-09 17:46:44','No seat belt',312.25),(40,13,'2025-07-09 17:46:56','Expired registration',431.10),(41,14,'2025-07-09 17:46:56','Illegal U-turn',388.75),(42,15,'2025-07-09 17:46:56','Reckless driving',921.87),(43,6,'2025-07-09 17:25:32','Failure to stop at stop sign',579.22),(44,2,'2025-07-09 11:39:21','Speeding',684.00),(45,4,'2025-07-09 12:17:15','Distracted driving',248.91),(46,8,'2025-07-09 17:01:55','Failure to yield',345.76);
/*!40000 ALTER TABLE `violation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `violations_details`
--

DROP TABLE IF EXISTS `violations_details`;
/*!50001 DROP VIEW IF EXISTS `violations_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `violations_details` AS SELECT 
 1 AS `ViolationID`,
 1 AS `Date`,
 1 AS `Description`,
 1 AS `PenaltyAmount`,
 1 AS `VehicleID`,
 1 AS `VehiclePlate`,
 1 AS `DriverID`,
 1 AS `DriverLicense`,
 1 AS `DriverName`,
 1 AS `TripID`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `all_maintenances`
--

/*!50001 DROP VIEW IF EXISTS `all_maintenances`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `all_maintenances` AS select `m`.`MaintenanceID` AS `MaintenanceID`,`m`.`Date` AS `Date`,`v`.`VehicleID` AS `VehicleID`,`v`.`PlateNumber` AS `VehiclePlate`,concat(`v`.`Make`,', ',`v`.`Model`,' ',`v`.`Year`) AS `Vehicle`,`v`.`OdometerReading` AS `OdometerReading`,`m`.`Description` AS `Description`,`m`.`Cost` AS `Cost`,`m`.`PerformedBy` AS `PerformedBy`,`m`.`MaintenanceStatus` AS `MaintenanceStatus` from (`maintenance` `m` join `vehicle` `v` on((`m`.`VehicleID` = `v`.`VehicleID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `all_trips`
--

/*!50001 DROP VIEW IF EXISTS `all_trips`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `all_trips` AS select `t`.`TripID` AS `TripID`,concat(`d`.`FirstName`,' ',`d`.`LastName`) AS `DriverName`,`d`.`DriverID` AS `DriverID`,`d`.`LicenseNumber` AS `DriverLicense`,`d`.`Phone` AS `DriverPhone`,`v`.`VehicleID` AS `VehicleID`,`v`.`PlateNumber` AS `VehiclePlate`,concat(`v`.`Make`,', ',`v`.`Model`) AS `Vehicle`,`t`.`StartTime` AS `StartTime`,`t`.`EndTime` AS `EndTime`,concat(`origin`.`Address`,', ',`origin`.`City`) AS `OriginLocation`,concat(`destination`.`Address`,', ',`destination`.`City`) AS `EndLocation`,concat(`t`.`Distance`,' ','KM') AS `Distance`,`t`.`TripStatus` AS `TripStatus` from ((((`trip` `t` join `driver` `d` on((`t`.`DriverID` = `d`.`DriverID`))) join `vehicle` `v` on((`t`.`VehicleID` = `v`.`VehicleID`))) join `location` `origin` on((`t`.`OriginLocationID` = `origin`.`LocationID`))) join `location` `destination` on((`t`.`DestinationLocationID` = `destination`.`LocationID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `available_vehicles`
--

/*!50001 DROP VIEW IF EXISTS `available_vehicles`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `available_vehicles` AS select `vehicle`.`VehicleID` AS `VehicleID`,`vehicle`.`PlateNumber` AS `PlateNumber`,`vehicle`.`Make` AS `Make`,`vehicle`.`Model` AS `Model`,`vehicle`.`Year` AS `Year`,`vehicle`.`VehicleStatus` AS `VehicleStatus`,`vehicle`.`OdometerReading` AS `OdometerReading` from `vehicle` where (`vehicle`.`VehicleStatus` = 'Available') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ongoing_maintenances`
--

/*!50001 DROP VIEW IF EXISTS `ongoing_maintenances`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ongoing_maintenances` AS select `m`.`MaintenanceID` AS `MaintenanceID`,`m`.`Date` AS `Date`,`v`.`VehicleID` AS `VehicleID`,`v`.`PlateNumber` AS `VehiclePlate`,concat(`v`.`Make`,', ',`v`.`Model`,' ',`v`.`Year`) AS `Vehicle`,`v`.`OdometerReading` AS `OdometerReading`,`m`.`Description` AS `Description`,`m`.`Cost` AS `Cost`,`m`.`PerformedBy` AS `PerformedBy`,`m`.`MaintenanceStatus` AS `MaintenanceStatus` from (`maintenance` `m` join `vehicle` `v` on((`m`.`VehicleID` = `v`.`VehicleID`))) where (`m`.`MaintenanceStatus` = 'Ongoing') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ongoing_trips`
--

/*!50001 DROP VIEW IF EXISTS `ongoing_trips`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ongoing_trips` AS select `t`.`TripID` AS `TripID`,`d`.`DriverID` AS `DriverID`,concat(`d`.`FirstName`,' ',`d`.`LastName`) AS `DriverName`,`d`.`LicenseNumber` AS `DriverLicense`,`d`.`Phone` AS `DriverPhone`,`v`.`VehicleID` AS `VehicleID`,`v`.`PlateNumber` AS `VehiclePlate`,concat(`v`.`Make`,', ',`v`.`Model`) AS `Vehicle`,`t`.`StartTime` AS `StartTime`,`t`.`EndTime` AS `EndTime`,concat(`origin`.`Address`,', ',`origin`.`City`) AS `OriginLocation`,concat(`destination`.`Address`,', ',`destination`.`City`) AS `EndLocation`,concat(`t`.`Distance`,' ','KM') AS `Distance` from ((((`trip` `t` join `driver` `d` on((`t`.`DriverID` = `d`.`DriverID`))) join `vehicle` `v` on((`t`.`VehicleID` = `v`.`VehicleID`))) join `location` `origin` on((`t`.`OriginLocationID` = `origin`.`LocationID`))) join `location` `destination` on((`t`.`DestinationLocationID` = `destination`.`LocationID`))) where (`t`.`TripStatus` = 'Ongoing') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `past_trips`
--

/*!50001 DROP VIEW IF EXISTS `past_trips`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `past_trips` AS select `t`.`TripID` AS `TripID`,concat(`d`.`FirstName`,' ',`d`.`LastName`) AS `DriverName`,`d`.`DriverID` AS `DriverID`,`d`.`LicenseNumber` AS `DriverLicense`,`d`.`Phone` AS `DriverPhone`,`v`.`VehicleID` AS `VehicleID`,`v`.`PlateNumber` AS `VehiclePlate`,concat(`v`.`Make`,', ',`v`.`Model`) AS `Vehicle`,`t`.`StartTime` AS `StartTime`,`t`.`EndTime` AS `EndTime`,concat(`origin`.`Address`,', ',`origin`.`City`) AS `OriginLocation`,concat(`destination`.`Address`,', ',`destination`.`City`) AS `EndLocation`,concat(`t`.`Distance`,' ','KM') AS `Distance`,`t`.`TripStatus` AS `TripStatus` from ((((`trip` `t` join `driver` `d` on((`t`.`DriverID` = `d`.`DriverID`))) join `vehicle` `v` on((`t`.`VehicleID` = `v`.`VehicleID`))) join `location` `origin` on((`t`.`OriginLocationID` = `origin`.`LocationID`))) join `location` `destination` on((`t`.`DestinationLocationID` = `destination`.`LocationID`))) where (`t`.`TripStatus` <> 'Ongoing') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vehicles_in_maintenance`
--

/*!50001 DROP VIEW IF EXISTS `vehicles_in_maintenance`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vehicles_in_maintenance` AS select `vehicle`.`VehicleID` AS `VehicleID`,`vehicle`.`PlateNumber` AS `PlateNumber`,`vehicle`.`Make` AS `Make`,`vehicle`.`Model` AS `Model`,`vehicle`.`Year` AS `Year`,`vehicle`.`VehicleStatus` AS `VehicleStatus`,`vehicle`.`OdometerReading` AS `OdometerReading` from `vehicle` where (`vehicle`.`VehicleStatus` = 'In Maintenance') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `violations_details`
--

/*!50001 DROP VIEW IF EXISTS `violations_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `violations_details` AS select `v`.`ViolationID` AS `ViolationID`,`v`.`Date` AS `Date`,`v`.`Description` AS `Description`,`v`.`PenaltyAmount` AS `PenaltyAmount`,`t`.`VehicleID` AS `VehicleID`,`t`.`VehiclePlate` AS `VehiclePlate`,`t`.`DriverID` AS `DriverID`,`t`.`DriverLicense` AS `DriverLicense`,`t`.`DriverName` AS `DriverName`,`t`.`TripID` AS `TripID` from (`violation` `v` join `all_trips` `t` on((`v`.`VehicleID` = `t`.`VehicleID`))) where (`v`.`Date` between `t`.`StartTime` and `t`.`EndTime`) */;
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

-- Dump completed on 2025-07-15  8:36:10
