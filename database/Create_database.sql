CREATE DATABASE  IF NOT EXISTS `gaming_tournament_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `gaming_tournament_db`;
-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: localhost    Database: gaming_tournament_db
-- ------------------------------------------------------
-- Server version	8.0.33

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
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_users` (
  `USER_ID` int NOT NULL AUTO_INCREMENT,
  `USERNAME` varchar(50) NOT NULL,
  `PASSWORD` varchar(100) NOT NULL,
  `CREATED_AT` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`USER_ID`),
  UNIQUE KEY `USERNAME` (`USERNAME`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_users`
--

LOCK TABLES `admin_users` WRITE;
/*!40000 ALTER TABLE `admin_users` DISABLE KEYS */;
INSERT INTO `admin_users` VALUES (1,'admin','admin123','2025-11-04 15:57:20');
/*!40000 ALTER TABLE `admin_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `games`
--

DROP TABLE IF EXISTS `games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `games` (
  `GAME_ID` int NOT NULL AUTO_INCREMENT,
  `GAME_NAME` varchar(100) NOT NULL,
  `GENRE` varchar(50) NOT NULL,
  `DEVELOPER` varchar(100) NOT NULL,
  `RELEASE_DATE` date NOT NULL,
  PRIMARY KEY (`GAME_ID`),
  CONSTRAINT `chk_game_name` CHECK ((`GAME_NAME` <> _utf8mb4'')),
  CONSTRAINT `chk_genre` CHECK ((`GENRE` <> _utf8mb4''))
) ENGINE=InnoDB AUTO_INCREMENT=1023 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `games`
--

LOCK TABLES `games` WRITE;
/*!40000 ALTER TABLE `games` DISABLE KEYS */;
INSERT INTO `games` VALUES (1001,'The Legend of Zelda: Breath of the Wild','Action-Adventure','Nintendo EPD','2017-03-03'),(1002,'God of War','Action-Adventure','Santa Monica Studio','2018-04-20'),(1003,'Red Dead Redemption 2','Action-Adventure','Rockstar Games','2018-10-26'),(1004,'The Witcher 3: Wild Hunt','RPG','CD Projekt Red','2015-05-19'),(1005,'Minecraft','Sandbox','Mojang Studios','2011-11-18'),(1006,'Fortnite','Battle Royale','Epic Games','2017-07-25'),(1007,'Grand Theft Auto V','Action-Adventure','Rockstar North','2013-09-17'),(1008,'Call of Duty: Modern Warfare','FPS','Infinity Ward','2019-10-25'),(1009,'Overwatch','FPS','Blizzard Entertainment','2016-05-24'),(1010,'Dark Souls III','Action RPG','FromSoftware','2016-04-12'),(1011,'Cyberpunk 2077','RPG','CD Projekt Red','2020-12-10'),(1012,'Elden Ring','Action RPG','FromSoftware','2022-02-25'),(1013,'Spider-Man','Action-Adventure','Insomniac Games','2018-09-07'),(1014,'Horizon Zero Dawn','Action RPG','Guerrilla Games','2017-02-28'),(1015,'Hades','Roguelike','Supergiant Games','2020-09-17'),(1016,'Among Us','Party','InnerSloth','2018-06-15'),(1017,'Fall Guys','Battle Royale','Mediatonic','2020-08-04'),(1018,'Valorant','FPS','Riot Games','2020-06-02'),(1019,'League of Legends','MOBA','Riot Games','2009-10-27'),(1020,'Stardew Valley','Simulation','ConcernedApe','2016-02-26'),(1022,'abc','Action','ABC','2000-01-01');
/*!40000 ALTER TABLE `games` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `participate`
--

DROP TABLE IF EXISTS `participate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `participate` (
  `TEAM_ID` int NOT NULL,
  `TK_ID` int NOT NULL,
  PRIMARY KEY (`TEAM_ID`,`TK_ID`),
  KEY `fk_partnership_tournament` (`TK_ID`),
  CONSTRAINT `fk_partnership_team` FOREIGN KEY (`TEAM_ID`) REFERENCES `team` (`TEAM_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_partnership_tournament` FOREIGN KEY (`TK_ID`) REFERENCES `tournaments` (`TK_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participate`
--

LOCK TABLES `participate` WRITE;
/*!40000 ALTER TABLE `participate` DISABLE KEYS */;
INSERT INTO `participate` VALUES (2001,4001),(2002,4001),(2003,4001),(2004,4001),(2005,4001),(2006,4001),(2007,4001),(2001,4002),(2002,4002),(2003,4002),(2004,4002),(2005,4002),(2006,4002),(2007,4002),(2001,4003),(2002,4003),(2003,4003),(2004,4003),(2005,4003),(2006,4003),(2007,4003),(2008,4004),(2009,4004),(2010,4004),(2011,4004),(2012,4004),(2013,4004),(2014,4004),(2008,4005),(2009,4005),(2010,4005),(2011,4005),(2012,4005),(2013,4005),(2014,4005),(2008,4006),(2009,4006),(2010,4006),(2011,4006),(2012,4006),(2013,4006),(2014,4006),(2022,4010),(2023,4010),(2024,4010),(2025,4010),(2026,4010),(2027,4011),(2028,4011),(2029,4013),(2030,4013),(2031,4013),(2032,4013),(2033,4013),(2036,4016),(2037,4016),(2038,4016),(2039,4016),(2040,4016),(2043,4019),(2044,4019),(2045,4019),(2046,4019),(2047,4019),(2050,4022),(2051,4022),(2052,4022),(2053,4022),(2054,4022),(2057,4025),(2058,4025),(2059,4025),(2060,4025),(2061,4025),(2064,4028),(2065,4028),(2066,4028),(2067,4028),(2068,4028),(2134,4058),(2135,4058),(2136,4058),(2137,4058),(2138,4058),(2139,4058),(2140,4058),(2134,4059),(2135,4059),(2136,4059),(2137,4059),(2138,4059),(2139,4059),(2140,4059),(2134,4060),(2135,4060),(2136,4060),(2137,4060),(2138,4060),(2139,4060),(2140,4060),(2144,5011),(2145,5011),(2146,5011);
/*!40000 ALTER TABLE `participate` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_participate_seed` AFTER INSERT ON `participate` FOR EACH ROW INSERT INTO tournament_stats (TK_ID, TEAM_ID)
VALUES (NEW.TK_ID, NEW.TEAM_ID)
ON DUPLICATE KEY UPDATE TEAM_ID = TEAM_ID */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `partnership`
--

DROP TABLE IF EXISTS `partnership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partnership` (
  `TEAM_ID` int NOT NULL,
  `ID` int NOT NULL,
  PRIMARY KEY (`TEAM_ID`,`ID`),
  KEY `fk_participates_sponsorship` (`ID`),
  CONSTRAINT `fk_participates_sponsorship` FOREIGN KEY (`ID`) REFERENCES `sponsorship` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_participates_team` FOREIGN KEY (`TEAM_ID`) REFERENCES `team` (`TEAM_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partnership`
--

LOCK TABLES `partnership` WRITE;
/*!40000 ALTER TABLE `partnership` DISABLE KEYS */;
INSERT INTO `partnership` VALUES (2001,3001),(2015,3002),(2029,3003),(2043,3004),(2057,3005),(2071,3006),(2085,3007),(2002,3008),(2016,3009),(2030,3010),(2044,3011),(2058,3012),(2072,3013),(2086,3014),(2003,3015),(2017,3016),(2031,3017),(2045,3018),(2059,3019),(2073,3020),(2087,3021),(2004,3022),(2018,3023),(2032,3024),(2046,3025),(2060,3026),(2074,3027),(2088,3028),(2005,3029),(2019,3030),(2033,3031),(2047,3032),(2061,3033),(2075,3034),(2089,3035),(2006,3036),(2020,3037),(2034,3038),(2048,3039),(2062,3040),(2076,3041),(2090,3042),(2007,3043),(2021,3044),(2035,3045),(2049,3046),(2063,3047),(2077,3048),(2091,3049),(2008,3050),(2022,3051),(2036,3052),(2050,3053),(2064,3054),(2078,3055),(2092,3056),(2009,3057),(2023,3058),(2037,3059),(2051,3060),(2065,3061),(2079,3062),(2093,3063),(2010,3064),(2024,3065),(2038,3066),(2052,3067),(2066,3068),(2080,3069),(2094,3070),(2011,3071),(2025,3072),(2039,3073),(2053,3074),(2067,3075),(2081,3076),(2095,3077),(2012,3078),(2026,3079),(2040,3080),(2054,3081),(2068,3082),(2082,3083),(2096,3084),(2013,3085),(2027,3086),(2041,3087),(2055,3088),(2069,3089),(2083,3090),(2097,3091),(2014,3092),(2028,3093),(2042,3094),(2056,3095),(2070,3096),(2084,3097),(2098,3098),(2099,3099),(2100,3100),(2101,3101),(2102,3102),(2103,3103),(2104,3104),(2105,3105),(2106,3106),(2107,3107),(2108,3108),(2109,3109),(2110,3110),(2111,3111),(2112,3112),(2113,3113),(2114,3114),(2115,3115),(2116,3116),(2117,3117),(2118,3118),(2119,3119),(2120,3120),(2121,3121),(2122,3122),(2123,3123),(2124,3124),(2125,3125),(2126,3126),(2127,3127),(2128,3128),(2129,3129),(2130,3130),(2131,3131),(2132,3132),(2133,3133),(2134,3134),(2135,3135),(2136,3136),(2137,3137),(2138,3138),(2139,3139),(2140,3140);
/*!40000 ALTER TABLE `partnership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sponsorship`
--

DROP TABLE IF EXISTS `sponsorship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sponsorship` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(100) NOT NULL,
  `INDUSTRY` varchar(50) NOT NULL,
  `AMOUNT` decimal(15,2) NOT NULL,
  `TEAM_ID` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `idx_sponsorship_team` (`TEAM_ID`),
  CONSTRAINT `fk_sponsorship_team` FOREIGN KEY (`TEAM_ID`) REFERENCES `team` (`TEAM_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_amount` CHECK ((`AMOUNT` > 0)),
  CONSTRAINT `chk_sponsor_name` CHECK ((`NAME` <> _utf8mb4''))
) ENGINE=InnoDB AUTO_INCREMENT=3145 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sponsorship`
--

LOCK TABLES `sponsorship` WRITE;
/*!40000 ALTER TABLE `sponsorship` DISABLE KEYS */;
INSERT INTO `sponsorship` VALUES (3001,'Nike','Sports Apparel',250000.00,2001),(3002,'Nike','Sports Apparel',260000.00,2015),(3003,'Nike','Sports Apparel',245000.00,2029),(3004,'Nike','Sports Apparel',255000.00,2043),(3005,'Nike','Sports Apparel',265000.00,2057),(3006,'Nike','Sports Apparel',240000.00,2071),(3007,'Nike','Sports Apparel',270000.00,2085),(3008,'Adidas','Sports Apparel',180000.00,2002),(3009,'Adidas','Sports Apparel',185000.00,2016),(3010,'Adidas','Sports Apparel',190000.00,2030),(3011,'Adidas','Sports Apparel',175000.00,2044),(3012,'Adidas','Sports Apparel',195000.00,2058),(3013,'Adidas','Sports Apparel',188000.00,2072),(3014,'Adidas','Sports Apparel',182000.00,2086),(3015,'Red Bull','Energy Drinks',320000.00,2003),(3016,'Red Bull','Energy Drinks',330000.00,2017),(3017,'Red Bull','Energy Drinks',325000.00,2031),(3018,'Red Bull','Energy Drinks',335000.00,2045),(3019,'Red Bull','Energy Drinks',315000.00,2059),(3020,'Red Bull','Energy Drinks',340000.00,2073),(3021,'Red Bull','Energy Drinks',328000.00,2087),(3022,'Monster Energy','Energy Drinks',290000.00,2004),(3023,'Monster Energy','Energy Drinks',295000.00,2018),(3024,'Monster Energy','Energy Drinks',300000.00,2032),(3025,'Monster Energy','Energy Drinks',285000.00,2046),(3026,'Monster Energy','Energy Drinks',305000.00,2060),(3027,'Monster Energy','Energy Drinks',298000.00,2074),(3028,'Monster Energy','Energy Drinks',292000.00,2088),(3029,'Intel','Technology',450000.00,2005),(3030,'Intel','Technology',460000.00,2019),(3031,'Intel','Technology',455000.00,2033),(3032,'Intel','Technology',465000.00,2047),(3033,'Intel','Technology',470000.00,2061),(3034,'Intel','Technology',448000.00,2075),(3035,'Intel','Technology',475000.00,2089),(3036,'AMD','Technology',380000.00,2006),(3037,'AMD','Technology',385000.00,2020),(3038,'AMD','Technology',390000.00,2034),(3039,'AMD','Technology',375000.00,2048),(3040,'AMD','Technology',395000.00,2062),(3041,'AMD','Technology',388000.00,2076),(3042,'AMD','Technology',382000.00,2090),(3043,'Logitech','Gaming Peripherals',220000.00,2007),(3044,'Logitech','Gaming Peripherals',225000.00,2021),(3045,'Logitech','Gaming Peripherals',230000.00,2035),(3046,'Logitech','Gaming Peripherals',215000.00,2049),(3047,'Logitech','Gaming Peripherals',235000.00,2063),(3048,'Logitech','Gaming Peripherals',228000.00,2077),(3049,'Logitech','Gaming Peripherals',222000.00,2091),(3050,'Razer','Gaming Peripherals',240000.00,2008),(3051,'Razer','Gaming Peripherals',245000.00,2022),(3052,'Razer','Gaming Peripherals',250000.00,2036),(3053,'Razer','Gaming Peripherals',235000.00,2050),(3054,'Razer','Gaming Peripherals',255000.00,2064),(3055,'Razer','Gaming Peripherals',248000.00,2078),(3056,'Razer','Gaming Peripherals',242000.00,2092),(3057,'HyperX','Gaming Peripherals',200000.00,2009),(3058,'HyperX','Gaming Peripherals',205000.00,2023),(3059,'HyperX','Gaming Peripherals',210000.00,2037),(3060,'HyperX','Gaming Peripherals',195000.00,2051),(3061,'HyperX','Gaming Peripherals',215000.00,2065),(3062,'HyperX','Gaming Peripherals',208000.00,2079),(3063,'HyperX','Gaming Peripherals',202000.00,2093),(3064,'SteelSeries','Gaming Peripherals',190000.00,2010),(3065,'SteelSeries','Gaming Peripherals',195000.00,2024),(3066,'SteelSeries','Gaming Peripherals',198000.00,2038),(3067,'SteelSeries','Gaming Peripherals',188000.00,2052),(3068,'SteelSeries','Gaming Peripherals',200000.00,2066),(3069,'SteelSeries','Gaming Peripherals',193000.00,2080),(3070,'SteelSeries','Gaming Peripherals',192000.00,2094),(3071,'Coca-Cola','Beverages',350000.00,2011),(3072,'Coca-Cola','Beverages',355000.00,2025),(3073,'Coca-Cola','Beverages',360000.00,2039),(3074,'Coca-Cola','Beverages',345000.00,2053),(3075,'Coca-Cola','Beverages',365000.00,2067),(3076,'Coca-Cola','Beverages',358000.00,2081),(3077,'Coca-Cola','Beverages',352000.00,2095),(3078,'Pepsi','Beverages',340000.00,2012),(3079,'Pepsi','Beverages',345000.00,2026),(3080,'Pepsi','Beverages',350000.00,2040),(3081,'Pepsi','Beverages',335000.00,2054),(3082,'Pepsi','Beverages',355000.00,2068),(3083,'Pepsi','Beverages',348000.00,2082),(3084,'Pepsi','Beverages',342000.00,2096),(3085,'Mountain Dew','Beverages',280000.00,2013),(3086,'Mountain Dew','Beverages',285000.00,2027),(3087,'Mountain Dew','Beverages',290000.00,2041),(3088,'Mountain Dew','Beverages',275000.00,2055),(3089,'Mountain Dew','Beverages',295000.00,2069),(3090,'Mountain Dew','Beverages',288000.00,2083),(3091,'Mountain Dew','Beverages',282000.00,2097),(3092,'Doritos','Snacks',175000.00,2014),(3093,'Doritos','Snacks',180000.00,2028),(3094,'Doritos','Snacks',185000.00,2042),(3095,'Doritos','Snacks',170000.00,2056),(3096,'Doritos','Snacks',190000.00,2070),(3097,'Doritos','Snacks',183000.00,2084),(3098,'Doritos','Snacks',177000.00,2098),(3099,'Pringles','Snacks',160000.00,2099),(3100,'Pringles','Snacks',165000.00,2113),(3101,'Pringles','Snacks',170000.00,2127),(3102,'Pringles','Snacks',155000.00,2106),(3103,'Pringles','Snacks',175000.00,2120),(3104,'Pringles','Snacks',168000.00,2134),(3105,'Pringles','Snacks',162000.00,2100),(3106,'McDonald\'s','Fast Food',400000.00,2101),(3107,'McDonald\'s','Fast Food',405000.00,2115),(3108,'McDonald\'s','Fast Food',410000.00,2129),(3109,'McDonald\'s','Fast Food',395000.00,2108),(3110,'McDonald\'s','Fast Food',415000.00,2122),(3111,'McDonald\'s','Fast Food',408000.00,2136),(3112,'McDonald\'s','Fast Food',402000.00,2102),(3113,'KFC','Fast Food',370000.00,2103),(3114,'KFC','Fast Food',375000.00,2117),(3115,'KFC','Fast Food',380000.00,2131),(3116,'KFC','Fast Food',365000.00,2110),(3117,'KFC','Fast Food',385000.00,2124),(3118,'KFC','Fast Food',378000.00,2138),(3119,'KFC','Fast Food',372000.00,2104),(3120,'Burger King','Fast Food',360000.00,2105),(3121,'Burger King','Fast Food',365000.00,2119),(3122,'Burger King','Fast Food',370000.00,2133),(3123,'Burger King','Fast Food',355000.00,2111),(3124,'Burger King','Fast Food',375000.00,2125),(3125,'Burger King','Fast Food',368000.00,2139),(3126,'Burger King','Fast Food',362000.00,2107),(3127,'Samsung','Electronics',500000.00,2112),(3128,'Samsung','Electronics',505000.00,2126),(3129,'Samsung','Electronics',510000.00,2140),(3130,'Samsung','Electronics',495000.00,2114),(3131,'Samsung','Electronics',515000.00,2128),(3132,'Samsung','Electronics',508000.00,2109),(3133,'Samsung','Electronics',502000.00,2116),(3134,'LG','Electronics',480000.00,2118),(3135,'LG','Electronics',485000.00,2132),(3136,'LG','Electronics',490000.00,2123),(3137,'LG','Electronics',475000.00,2130),(3138,'LG','Electronics',495000.00,2137),(3139,'LG','Electronics',488000.00,2121),(3140,'LG','Electronics',482000.00,2135),(3141,'Apple Corp','Technology',500000.00,2001),(3144,'Sponsorship_abc','ABC',123456.00,2144);
/*!40000 ALTER TABLE `sponsorship` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validate_sponsorship_before_insert` BEFORE INSERT ON `sponsorship` FOR EACH ROW BEGIN
    
    IF NEW.AMOUNT <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sponsorship amount must be greater than 0';
    END IF;
    
    
    IF NEW.AMOUNT > 10000000.00 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sponsorship amount cannot exceed 10,000,000';
    END IF;
    
    
    IF NEW.TEAM_ID NOT IN (SELECT TEAM_ID FROM team) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Team does not exist';
    END IF;
    
    
    IF NEW.NAME IS NULL OR TRIM(NEW.NAME) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sponsor name cannot be empty';
    END IF;
    
    
    IF NEW.INDUSTRY IS NULL OR TRIM(NEW.INDUSTRY) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Industry cannot be empty';
    END IF;
    
    
    IF (SELECT COUNT(*) FROM sponsorship WHERE NAME = NEW.NAME AND TEAM_ID = NEW.TEAM_ID) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This company already sponsors this team';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `stats`
--

DROP TABLE IF EXISTS `stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stats` (
  `TEAM_ID` int NOT NULL,
  `POINTS` int NOT NULL DEFAULT '0',
  `WINS` int NOT NULL DEFAULT '0',
  `LOSSES` int NOT NULL DEFAULT '0',
  `MATCH_PLAYED` int NOT NULL DEFAULT '0',
  `RANKING` int NOT NULL,
  PRIMARY KEY (`TEAM_ID`),
  CONSTRAINT `fk_stats_team` FOREIGN KEY (`TEAM_ID`) REFERENCES `team` (`TEAM_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_losses` CHECK ((`LOSSES` >= 0)),
  CONSTRAINT `chk_match_consistency` CHECK ((`MATCH_PLAYED` >= (`WINS` + `LOSSES`))),
  CONSTRAINT `chk_matches` CHECK ((`MATCH_PLAYED` >= 0)),
  CONSTRAINT `chk_points` CHECK ((`POINTS` >= 0)),
  CONSTRAINT `chk_ranking` CHECK ((`RANKING` > 0)),
  CONSTRAINT `chk_wins` CHECK ((`WINS` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stats`
--

LOCK TABLES `stats` WRITE;
/*!40000 ALTER TABLE `stats` DISABLE KEYS */;
INSERT INTO `stats` VALUES (2001,66,23,6,29,2),(2002,45,15,10,25,6),(2003,57,20,5,25,1),(2004,39,12,13,25,8),(2005,41,13,12,25,7),(2006,48,16,9,25,4),(2007,53,19,6,25,3),(2008,32,10,15,25,11),(2009,39,13,12,25,9),(2010,44,15,10,25,5),(2011,40,13,12,25,10),(2012,31,9,16,25,12),(2013,29,7,18,25,13),(2014,50,17,8,25,5),(2015,47,16,9,25,6),(2016,54,19,6,25,1),(2017,38,12,13,25,9),(2018,35,11,14,25,10),(2019,43,15,10,25,7),(2020,29,8,17,25,14),(2021,60,22,3,25,1),(2022,56,20,5,25,3),(2023,40,13,12,25,8),(2024,38,12,13,25,10),(2025,44,15,10,25,6),(2026,33,10,15,25,11),(2027,36,11,14,25,12),(2028,30,8,17,25,13),(2029,55,19,6,25,4),(2030,48,16,9,25,6),(2031,41,14,11,25,8),(2032,36,11,14,25,10),(2033,38,13,12,25,9),(2034,42,14,11,25,7),(2035,40,13,12,25,8),(2036,53,19,6,25,3),(2037,55,20,5,25,2),(2038,49,17,8,25,5),(2039,27,6,19,25,15),(2040,39,13,12,25,7),(2041,34,11,14,25,11),(2042,33,10,15,25,12),(2043,46,16,9,25,6),(2044,41,14,11,25,8),(2045,38,12,13,25,10),(2046,44,15,10,25,5),(2047,45,15,10,25,4),(2048,50,17,8,25,3),(2049,38,12,13,25,9),(2050,57,21,4,25,2),(2051,32,10,15,25,13),(2052,43,15,10,25,7),(2053,36,11,14,25,11),(2054,41,14,11,25,8),(2055,44,15,10,25,6),(2056,39,13,12,25,10),(2057,54,19,6,25,3),(2058,48,16,9,25,5),(2059,41,13,12,25,9),(2060,35,11,14,25,11),(2061,38,12,13,25,10),(2062,32,10,15,25,12),(2063,29,8,17,25,14),(2064,60,22,3,25,2),(2065,56,20,5,25,3),(2066,50,17,8,25,5),(2067,44,15,10,25,7),(2068,44,15,11,26,8),(2069,36,11,14,25,10),(2070,33,10,15,25,12),(2071,55,19,6,25,4),(2072,49,17,8,25,5),(2073,41,13,12,25,8),(2074,38,12,13,25,10),(2075,33,10,15,25,11),(2076,36,11,14,25,9),(2077,32,10,15,25,13),(2078,44,15,10,25,7),(2079,30,8,17,25,14),(2080,46,16,9,25,6),(2081,41,13,12,25,8),(2082,38,12,13,25,10),(2083,33,10,15,25,12),(2084,36,11,14,25,9),(2085,55,19,6,25,4),(2086,49,17,8,25,5),(2087,41,13,12,25,8),(2088,38,12,13,25,10),(2089,33,10,15,25,11),(2090,36,11,14,25,9),(2091,32,10,15,25,13),(2092,44,15,10,25,7),(2093,30,8,17,25,14),(2094,46,16,9,25,6),(2095,41,13,12,25,8),(2096,38,12,13,25,10),(2097,33,10,15,25,12),(2098,36,11,14,25,9),(2099,54,19,6,25,3),(2100,48,16,9,25,5),(2101,41,13,12,25,7),(2102,38,12,13,25,10),(2103,33,10,15,25,11),(2104,36,11,14,25,12),(2105,32,10,15,25,13),(2106,44,15,10,25,6),(2107,30,8,17,25,14),(2108,46,16,9,25,7),(2109,41,13,12,25,8),(2110,38,12,13,25,10),(2111,33,10,15,25,12),(2112,36,11,14,25,9),(2113,55,19,6,25,5),(2114,49,17,8,25,6),(2115,41,13,12,25,7),(2116,38,12,13,25,10),(2117,33,10,15,25,11),(2118,36,11,14,25,12),(2119,32,10,15,25,13),(2120,44,15,10,25,7),(2121,30,8,17,25,14),(2122,46,16,9,25,6),(2123,41,13,12,25,8),(2124,38,12,13,25,10),(2125,33,10,15,25,11),(2126,36,11,14,25,12),(2127,55,19,6,25,5),(2128,49,17,8,25,6),(2129,41,13,12,25,7),(2130,38,12,13,25,10),(2131,33,10,15,25,11),(2132,36,11,14,25,12),(2133,32,10,15,25,13),(2134,44,15,10,25,7),(2135,30,8,17,25,14),(2136,46,16,9,25,6),(2137,41,13,12,25,8),(2138,38,12,13,25,10),(2139,33,10,15,25,11),(2140,36,11,14,25,12);
/*!40000 ALTER TABLE `stats` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validate_stats_before_insert` BEFORE INSERT ON `stats` FOR EACH ROW BEGIN
    IF NEW.WINS < 0 OR NEW.LOSSES < 0 OR NEW.MATCH_PLAYED < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stats values cannot be negative';
    END IF;
    
    IF NEW.WINS + NEW.LOSSES > NEW.MATCH_PLAYED THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Wins + Losses cannot exceed Matches Played';
    END IF;
    
    IF NEW.POINTS < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Points cannot be negative';
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
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validate_stats_before_update` BEFORE UPDATE ON `stats` FOR EACH ROW BEGIN
    DECLARE error_message VARCHAR(255);
    
    
    IF NEW.WINS < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'WINS cannot be negative';
    END IF;
    
    IF NEW.LOSSES < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'LOSSES cannot be negative';
    END IF;
    
    IF NEW.MATCH_PLAYED < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'MATCH_PLAYED cannot be negative';
    END IF;
    
    IF NEW.POINTS < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'POINTS cannot be negative';
    END IF;
    
    IF NEW.RANKING < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'RANKING must be at least 1';
    END IF;
    
    
    IF NEW.WINS + NEW.LOSSES != NEW.MATCH_PLAYED THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'WINS + LOSSES must equal MATCH_PLAYED exactly';
    END IF;
    
    
    IF NEW.WINS > NEW.MATCH_PLAYED THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'WINS cannot exceed MATCH_PLAYED';
    END IF;
    
    
    IF NEW.LOSSES > NEW.MATCH_PLAYED THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'LOSSES cannot exceed MATCH_PLAYED';
    END IF;
    
    
    IF NEW.MATCH_PLAYED < OLD.MATCH_PLAYED THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'MATCH_PLAYED cannot decrease. Teams cannot "unplay" matches';
    END IF;
    
    
    IF NEW.WINS < OLD.WINS THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'WINS cannot decrease. Match history cannot be changed';
    END IF;
    
    
    IF NEW.LOSSES < OLD.LOSSES THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'LOSSES cannot decrease. Match history cannot be changed';
    END IF;
    
    
    IF NEW.POINTS < 0 OR NEW.POINTS > (NEW.MATCH_PLAYED * 10) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'POINTS must be between 0 and MATCH_PLAYED * 10';
    END IF;
    
    
    IF NEW.TEAM_ID NOT IN (SELECT TEAM_ID FROM team) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Team does not exist';
    END IF;
    
    
    IF NEW.RANKING < 1 OR NEW.RANKING > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'RANKING must be between 1 and 100';
    END IF;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `stream`
--

DROP TABLE IF EXISTS `stream`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stream` (
  `STREAM_ID` int NOT NULL AUTO_INCREMENT,
  `PLATFORM` varchar(50) NOT NULL,
  `URL` varchar(255) NOT NULL,
  `LANGUAGE` varchar(30) NOT NULL,
  `TK_ID` int NOT NULL,
  PRIMARY KEY (`STREAM_ID`),
  KEY `idx_stream_tournament` (`TK_ID`),
  CONSTRAINT `fk_stream_tournament` FOREIGN KEY (`TK_ID`) REFERENCES `tournaments` (`TK_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_language` CHECK ((`LANGUAGE` <> _utf8mb4'')),
  CONSTRAINT `chk_platform` CHECK ((`PLATFORM` <> _utf8mb4'')),
  CONSTRAINT `chk_url` CHECK ((`URL` <> _utf8mb4''))
) ENGINE=InnoDB AUTO_INCREMENT=5069 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stream`
--

LOCK TABLES `stream` WRITE;
/*!40000 ALTER TABLE `stream` DISABLE KEYS */;
INSERT INTO `stream` VALUES (5001,'Twitch','https://twitch.tv/hyrulecup','English',4001),(5002,'YouTube','https://youtube.com/divinebeasts','Japanese',4002),(5003,'Facebook Gaming','https://fb.gg/mastersword','French',4003),(5004,'Twitch','https://twitch.tv/spartanarena','Greek',4004),(5005,'YouTube','https://youtube.com/northernrunes','Swedish',4005),(5006,'Facebook Gaming','https://fb.gg/valhallachamp','English',4006),(5007,'Twitch','https://twitch.tv/westernlegends','English',4007),(5008,'YouTube','https://youtube.com/outlawshowdown','Spanish',4008),(5009,'Facebook Gaming','https://fb.gg/vanderlinde','English',4009),(5010,'Twitch','https://twitch.tv/whitewolf','Polish',4010),(5011,'YouTube','https://youtube.com/monsterslayer','German',4011),(5012,'Facebook Gaming','https://fb.gg/kaermorhen','Czech',4012),(5013,'Twitch','https://twitch.tv/blockbuilders','English',4013),(5014,'YouTube','https://youtube.com/redstonemasters','Hindi',4014),(5015,'Facebook Gaming','https://fb.gg/enderdragon','English',4015),(5016,'Twitch','https://twitch.tv/victoryroyale','English',4016),(5017,'YouTube','https://youtube.com/battlebusbash','Korean',4017),(5018,'Facebook Gaming','https://fb.gg/zeropoint','German',4018),(5019,'Twitch','https://twitch.tv/lossantos','English',4019),(5020,'YouTube','https://youtube.com/vinewoodinv','English',4020),(5021,'Facebook Gaming','https://fb.gg/pacificstd','Portuguese',4021),(5022,'Twitch','https://twitch.tv/warzonews','English',4022),(5023,'YouTube','https://youtube.com/taskforce141','English',4023),(5024,'Facebook Gaming','https://fb.gg/specialops','Arabic',4024),(5025,'Twitch','https://twitch.tv/overwatchopen','English',4025),(5026,'YouTube','https://youtube.com/talonstrike','Korean',4026),(5027,'Facebook Gaming','https://fb.gg/numbani','English',4027),(5028,'Twitch','https://twitch.tv/ashenones','Japanese',4028),(5029,'YouTube','https://youtube.com/cindercup','Irish',4029),(5030,'Facebook Gaming','https://fb.gg/lothric','Greek',4030),(5031,'Twitch','https://twitch.tv/nightcity','English',4031),(5032,'YouTube','https://youtube.com/afterlife','German',4032),(5033,'Facebook Gaming','https://fb.gg/netrunner','Korean',4033),(5034,'Twitch','https://twitch.tv/tarnishedtriumph','English',4034),(5035,'YouTube','https://youtube.com/goldenorder','Japanese',4035),(5036,'Facebook Gaming','https://fb.gg/haligtree','English',4036),(5037,'Twitch','https://twitch.tv/webwarriors','English',4037),(5038,'YouTube','https://youtube.com/manhattanswing','English',4038),(5039,'Facebook Gaming','https://fb.gg/venomcup','Spanish',4039),(5040,'Twitch','https://twitch.tv/norabraves','Dutch',4040),(5041,'YouTube','https://youtube.com/thunderjaw','Afrikaans',4041),(5042,'Facebook Gaming','https://fb.gg/zerodawn','Japanese',4042),(5043,'Twitch','https://twitch.tv/underworldtrials','Greek',4043),(5044,'YouTube','https://youtube.com/olympianmasters','Italian',4044),(5045,'Facebook Gaming','https://fb.gg/styxshowdown','English',4045),(5046,'Twitch','https://twitch.tv/skeldmystery','English',4046),(5047,'YouTube','https://youtube.com/impostorchallenge','German',4047),(5048,'Facebook Gaming','https://fb.gg/crewmatecup','Portuguese',4048),(5049,'Twitch','https://twitch.tv/beanbash','English',4049),(5050,'YouTube','https://youtube.com/slimeclimb','Japanese',4050),(5051,'Facebook Gaming','https://fb.gg/crownclash','English',4051),(5052,'Twitch','https://twitch.tv/radiantlegends','English',4052),(5053,'YouTube','https://youtube.com/spikedefenders','English',4053),(5054,'Facebook Gaming','https://fb.gg/viperstrike','Turkish',4054),(5055,'Twitch','https://twitch.tv/summonerselite','English',4055),(5056,'YouTube','https://youtube.com/baronbash','English',4056),(5057,'Facebook Gaming','https://fb.gg/worldsclash','Mandarin',4057),(5058,'Twitch','https://twitch.tv/stardropfestival','English',4058),(5059,'YouTube','https://youtube.com/pelicantown','English',4059),(5060,'Facebook Gaming','https://fb.gg/junimocup','Afrikaans',4060),(5068,'YouTube','https://youtube/abc','English',5011);
/*!40000 ALTER TABLE `stream` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team` (
  `TEAM_ID` int NOT NULL AUTO_INCREMENT,
  `TEAM_NAME` varchar(100) NOT NULL,
  `REGION` varchar(50) NOT NULL,
  `COACH` varchar(100) NOT NULL,
  `GAME_ID` int NOT NULL,
  PRIMARY KEY (`TEAM_ID`),
  KEY `idx_team_game` (`GAME_ID`),
  KEY `idx_team_name` (`TEAM_NAME`),
  CONSTRAINT `fk_team_game` FOREIGN KEY (`GAME_ID`) REFERENCES `games` (`GAME_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_region` CHECK ((`REGION` <> _utf8mb4'')),
  CONSTRAINT `chk_team_name` CHECK ((`TEAM_NAME` <> _utf8mb4''))
) ENGINE=InnoDB AUTO_INCREMENT=2147 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team`
--

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;
INSERT INTO `team` VALUES (2001,'Hyrule Champions','North America','Link Johnson',1001),(2002,'Divine Beasts','Europe','Zelda Smith',1001),(2003,'Sheikah Warriors','Asia','Impa Chen',1001),(2004,'Korok Seekers','South America','Hestu Rodriguez',1001),(2005,'Ganon Slayers','Oceania','Urbosa Lee',1001),(2006,'Calamity Fighters','Middle East','Daruk Ahmed',1001),(2007,'Master Sword Legends','Africa','Revali Okafor',1001),(2008,'Spartan Rage','North America','Kratos Anderson',1002),(2009,'Asgardian Fury','Europe','Thor Bjornson',1002),(2010,'Leviathan Axe','Asia','Atreus Kim',1002),(2011,'Valkyrie Hunters','South America','Freya Santos',1002),(2012,'Norse Legends','Oceania','Baldur Williams',1002),(2013,'Jotunheim Giants','Middle East','Mimir Hassan',1002),(2014,'Blades of Chaos','Africa','Brok Nkosi',1002),(2015,'Van der Linde Gang','North America','Dutch Thompson',1003),(2016,'Blackwater Outlaws','Europe','Arthur Morgan',1003),(2017,'Saint Denis Sharpshooters','Asia','John Marston',1003),(2018,'Valentine Gunslingers','South America','Sadie Adler',1003),(2019,'Rhodes Rangers','Oceania','Hosea Matthews',1003),(2020,'Strawberry Riders','Middle East','Charles Smith',1003),(2021,'Annesburg Bandits','Africa','Lenny Summers',1003),(2022,'White Wolf Pack','North America','Geralt Wilson',1004),(2023,'Wild Hunt Slayers','Europe','Ciri Kowalski',1004),(2024,'Kaer Morhen Warriors','Asia','Vesemir Tanaka',1004),(2025,'Temerian Eagles','South America','Triss Silva',1004),(2026,'Nilfgaardian Elite','Oceania','Yennefer Brown',1004),(2027,'Skellige Raiders','Middle East','Zoltan Abbas',1004),(2028,'Novigrad Mercenaries','Africa','Dandelion Mwangi',1004),(2029,'Block Builders','North America','Steve Davis',1005),(2030,'Creeper Squad','Europe','Alex Mueller',1005),(2031,'Diamond Miners','Asia','Notch Yamamoto',1005),(2032,'Redstone Engineers','South America','Herobrine Costa',1005),(2033,'Ender Dragons','Oceania','Skeleton Jones',1005),(2034,'Nether Warriors','Middle East','Zombie Khan',1005),(2035,'Village Defenders','Africa','Enderman Obi',1005),(2036,'Victory Royale','North America','Jonesy Parker',1006),(2037,'Storm Chasers','Europe','Ramirez Garcia',1006),(2038,'Build Masters','Asia','Drift Sato',1006),(2039,'Loot Legends','South America','Peely Martinez',1006),(2040,'Battle Bus Squad','Oceania','Catalyst Robinson',1006),(2041,'Tilted Titans','Middle East','Midas Rahman',1006),(2042,'Zero Point Heroes','Africa','Fishstick Diop',1006),(2043,'Los Santos Legends','North America','Michael Evans',1007),(2044,'Vinewood Kings','Europe','Trevor Schmidt',1007),(2045,'Grove Street Gamers','Asia','Franklin Wong',1007),(2046,'Blaine County Crew','South America','Lester Fernandez',1007),(2047,'Diamond Casino Elite','Oceania','Lamar Taylor',1007),(2048,'Pacific Standard','Middle East','Trevor Phillips',1007),(2049,'Sandy Shores Squad','Africa','Ron Jakowski',1007),(2050,'Task Force 141','North America','Captain Price',1008),(2051,'Shadow Company','Europe','Ghost Riley',1008),(2052,'Warzone Warriors','Asia','Soap MacTavish',1008),(2053,'Verdansk Veterans','South America','Gaz Garrick',1008),(2054,'Armistice Aces','Oceania','Alex Mitchell',1008),(2055,'Special Ops Elite','Middle East','Farah Karim',1008),(2056,'Tactical Titans','Africa','Nikolai Petrov',1008),(2057,'Overwatch Heroes','North America','Winston Clarke',1009),(2058,'Talon Strike','Europe','Reaper Morrison',1009),(2059,'Numbani Defenders','Asia','Genji Shimada',1009),(2060,'Ilios Champions','South America','Lucio Correia',1009),(2061,'Junkertown Raiders','Oceania','Junkrat Fawkes',1009),(2062,'Eichenwalde Knights','Middle East','Reinhardt Wilhelm',1009),(2063,'Hanamura Dragons','Africa','Hanzo Shimada',1009),(2064,'Ashen Ones','North America','Siegward Knight',1010),(2065,'Lords of Cinder','Europe','Gundyr Champion',1010),(2066,'Firelink Warriors','Asia','Anri Astora',1010),(2067,'Undead Legion','South America','Farron Watchers',1010),(2068,'Abyss Walkers','Oceania','Artorias Dark',1010),(2069,'Lothric Knights','Middle East','Vordt Boreal',1010),(2070,'Pontiff Slayers','Africa','Sulyvahn Irithyll',1010),(2071,'Night City Legends','North America','V Silverhand',1011),(2072,'Arasaka Elite','Europe','Johnny Eurodyne',1011),(2073,'Nomad Warriors','Asia','Panam Palmer',1011),(2074,'Corpo Assassins','South America','Judy Alvarez',1011),(2075,'Afterlife Mercs','Oceania','Jackie Welles',1011),(2076,'Netrunner Squad','Middle East','Takemura Goro',1011),(2077,'Street Kid Kings','Africa','River Ward',1011),(2078,'Tarnished Champions','North America','Melina Guide',1012),(2079,'Golden Order','Europe','Radagon Marika',1012),(2080,'Limgrave Legends','Asia','Godrick Grafted',1012),(2081,'Raya Lucaria','South America','Rennala Moon',1012),(2082,'Caelid Conquerors','Oceania','Radahn Starscourge',1012),(2083,'Leyndell Knights','Middle East','Morgott Omen',1012),(2084,'Haligtree Heroes','Africa','Malenia Blade',1012),(2085,'Web Slingers','North America','Peter Parker',1013),(2086,'Sinister Six Hunters','Europe','Miles Morales',1013),(2087,'Manhattan Heroes','Asia','Mary Jane',1013),(2088,'Oscorp Defenders','South America','Aunt May',1013),(2089,'Daily Bugle','Oceania','J Jonah Jameson',1013),(2090,'Avengers Tower','Middle East','Black Cat',1013),(2091,'Spider Force','Africa','Yuri Watanabe',1013),(2092,'Nora Braves','North America','Aloy Hunter',1014),(2093,'Machine Hunters','Europe','Rost Outcast',1014),(2094,'Carja Sunhawks','Asia','Erend Oseram',1014),(2095,'Eclipse Warriors','South America','Sylens Scholar',1014),(2096,'Banuk Shamans','Oceania','Varl Nora',1014),(2097,'Zero Dawn','Middle East','Teersa Matriarch',1014),(2098,'Thunderjaw Slayers','Africa','Nil Stalker',1014),(2099,'Underworld Legends','North America','Zagreus Prince',1015),(2100,'Olympian Champions','Europe','Achilles Hero',1015),(2101,'House of Hades','Asia','Megaera Fury',1015),(2102,'Elysium Warriors','South America','Thanatos Death',1015),(2103,'Tartarus Titans','Oceania','Nyx Night',1015),(2104,'Styx Survivors','Middle East','Dusa Gorgon',1015),(2105,'Chaos Incarnate','Africa','Cerberus Guard',1015),(2106,'Crewmate Alliance','North America','Red Sus',1016),(2107,'Impostor Elite','Europe','Blue Vent',1016),(2108,'Skeld Survivors','Asia','Green Task',1016),(2109,'Emergency Squad','South America','Purple Vote',1016),(2110,'Electrical Warriors','Oceania','Yellow Safe',1016),(2111,'Airlock Assassins','Middle East','Orange Report',1016),(2112,'Cafeteria Crew','Africa','Pink Clean',1016),(2113,'Bean Squad','North America','Stumble Guy',1017),(2114,'Crown Collectors','Europe','Fall Master',1017),(2115,'Hex Gone Heroes','Asia','Jump Showdown',1017),(2116,'Slime Climbers','South America','Dizzy Heights',1017),(2117,'Door Dash Legends','Oceania','Tip Toe Pro',1017),(2118,'Roll Out Kings','Middle East','Block Party',1017),(2119,'Royal Fumble','Africa','Tail Tag',1017),(2120,'Radiant Legends','North America','Brimstone Liam',1018),(2121,'Spike Defenders','Europe','Jett Storm',1018),(2122,'Phoenix Rising','Asia','Sage Healer',1018),(2123,'Viper Strike','South America','Sova Hunter',1018),(2124,'Omen Shadows','Oceania','Cypher Spy',1018),(2125,'Breach Force','Middle East','Reyna Empress',1018),(2126,'Chamber Elite','Africa','Killjoy Tech',1018),(2127,'Summoners Elite','North America','Faker Lee',1019),(2128,'Baron Slayers','Europe','Caps Rasmus',1019),(2129,'Dragon Champions','Asia','TheShy Cheng',1019),(2130,'Nexus Defenders','South America','Brtt Felipe',1019),(2131,'Pentakill Legends','Oceania','Raes Kim',1019),(2132,'Rift Masters','Middle East','Armut Ibrahim',1019),(2133,'Worlds Finalists','Africa','Shern Tan',1019),(2134,'Pelican Town Heroes','North America','Farmer John',1020),(2135,'Junimo Squad','Europe','Lewis Mayor',1020),(2136,'Stardrop Legends','Asia','Pierre Merchant',1020),(2137,'Ancient Seed','South America','Caroline Green',1020),(2138,'Community Center','Oceania','Robin Carpenter',1020),(2139,'Ginger Island','Middle East','Willy Fisher',1020),(2140,'Harvest Masters','Africa','Marnie Ranch',1020),(2144,'abc1','India','ABC',1022),(2145,'abc2','India','ABC',1022),(2146,'abc3','South Asia','ABC',1022);
/*!40000 ALTER TABLE `team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tournament_stats`
--

DROP TABLE IF EXISTS `tournament_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tournament_stats` (
  `TK_ID` int NOT NULL,
  `TEAM_ID` int NOT NULL,
  `WINS` int NOT NULL DEFAULT '0',
  `LOSSES` int NOT NULL DEFAULT '0',
  `POINTS` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`TK_ID`,`TEAM_ID`),
  KEY `TEAM_ID` (`TEAM_ID`),
  CONSTRAINT `tournament_stats_ibfk_1` FOREIGN KEY (`TK_ID`) REFERENCES `tournaments` (`TK_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tournament_stats_ibfk_2` FOREIGN KEY (`TEAM_ID`) REFERENCES `team` (`TEAM_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tournament_stats`
--

LOCK TABLES `tournament_stats` WRITE;
/*!40000 ALTER TABLE `tournament_stats` DISABLE KEYS */;
INSERT INTO `tournament_stats` VALUES (4001,2001,8,2,22),(4001,2002,5,4,15),(4001,2003,7,2,19),(4001,2004,4,5,13),(4001,2005,5,4,14),(4001,2006,6,3,16),(4001,2007,7,2,18),(4002,2001,8,2,22),(4002,2002,5,3,15),(4002,2003,7,2,19),(4002,2004,4,4,13),(4002,2005,4,4,14),(4002,2006,5,3,16),(4002,2007,6,2,18),(4003,2001,7,2,22),(4003,2002,5,3,15),(4003,2003,6,1,19),(4003,2004,4,4,13),(4003,2005,4,4,13),(4003,2006,5,3,16),(4003,2007,6,2,17),(4004,2008,4,5,11),(4004,2009,5,4,13),(4004,2010,5,4,15),(4004,2011,5,4,14),(4004,2012,3,6,11),(4004,2013,3,6,10),(4004,2014,6,3,17),(4005,2008,3,5,11),(4005,2009,4,4,13),(4005,2010,5,3,15),(4005,2011,4,4,13),(4005,2012,3,5,10),(4005,2013,2,6,10),(4005,2014,6,3,17),(4006,2008,3,5,10),(4006,2009,4,4,13),(4006,2010,5,3,14),(4006,2011,4,4,13),(4006,2012,3,5,10),(4006,2013,2,6,9),(4006,2014,5,2,16),(4010,2022,0,0,0),(4010,2023,0,0,0),(4010,2024,0,0,0),(4010,2025,0,0,0),(4010,2026,0,0,0),(4011,2027,0,0,0),(4011,2028,0,0,0),(4013,2029,0,0,0),(4013,2030,0,0,0),(4013,2031,0,0,0),(4013,2032,0,0,0),(4013,2033,0,0,0),(4016,2036,0,0,0),(4016,2037,0,0,0),(4016,2038,0,0,0),(4016,2039,0,0,0),(4016,2040,0,0,0),(4019,2043,0,0,0),(4019,2044,0,0,0),(4019,2045,0,0,0),(4019,2046,0,0,0),(4019,2047,0,0,0),(4022,2050,0,0,0),(4022,2051,0,0,0),(4022,2052,0,0,0),(4022,2053,0,0,0),(4022,2054,0,0,0),(4025,2057,0,0,0),(4025,2058,0,0,0),(4025,2059,0,0,0),(4025,2060,0,0,0),(4025,2061,0,0,0),(4028,2064,0,0,0),(4028,2065,0,0,0),(4028,2066,0,0,0),(4028,2067,0,0,0),(4028,2068,0,0,0),(4058,2134,5,4,15),(4058,2135,3,6,10),(4058,2136,6,3,16),(4058,2137,5,4,14),(4058,2138,4,5,13),(4058,2139,4,5,11),(4058,2140,4,5,12),(4059,2134,5,3,15),(4059,2135,3,6,10),(4059,2136,5,3,15),(4059,2137,4,4,14),(4059,2138,4,4,13),(4059,2139,3,5,11),(4059,2140,4,5,12),(4060,2134,5,3,14),(4060,2135,2,5,10),(4060,2136,5,3,15),(4060,2137,4,4,13),(4060,2138,4,4,12),(4060,2139,3,5,11),(4060,2140,3,4,12),(5011,2144,2,1,6),(5011,2145,1,1,3),(5011,2146,1,2,3);
/*!40000 ALTER TABLE `tournament_stats` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_update_tournament_standings_on_stats_change` AFTER UPDATE ON `tournament_stats` FOR EACH ROW BEGIN
    
    IF NEW.WINS >= 10 THEN
        UPDATE tournaments t
        SET t.STATUS = 'COMPLETED',
            t.WINNER_TEAM_ID = NEW.TEAM_ID
        WHERE t.TK_ID = NEW.TK_ID AND t.STATUS = 'ONGOING';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tournaments`
--

DROP TABLE IF EXISTS `tournaments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tournaments` (
  `TK_ID` int NOT NULL AUTO_INCREMENT,
  `TOURNAMENT_NAME` varchar(150) NOT NULL,
  `PRIZE_POOL` decimal(15,2) NOT NULL,
  `DURATION` varchar(50) NOT NULL,
  `LOCATION` varchar(100) NOT NULL,
  `GAME_ID` int NOT NULL,
  `STATUS` enum('UPCOMING','ONGOING','COMPLETED') DEFAULT 'UPCOMING',
  `WINNER_TEAM_ID` int DEFAULT NULL,
  PRIMARY KEY (`TK_ID`),
  KEY `idx_tournament_game` (`GAME_ID`),
  KEY `idx_tournament_name` (`TOURNAMENT_NAME`),
  KEY `fk_tournament_winner` (`WINNER_TEAM_ID`),
  CONSTRAINT `fk_tournament_game` FOREIGN KEY (`GAME_ID`) REFERENCES `games` (`GAME_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tournament_winner` FOREIGN KEY (`WINNER_TEAM_ID`) REFERENCES `team` (`TEAM_ID`),
  CONSTRAINT `chk_prize_pool` CHECK ((`PRIZE_POOL` > 0)),
  CONSTRAINT `chk_tournament_name` CHECK ((`TOURNAMENT_NAME` <> _utf8mb4''))
) ENGINE=InnoDB AUTO_INCREMENT=5012 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tournaments`
--

LOCK TABLES `tournaments` WRITE;
/*!40000 ALTER TABLE `tournaments` DISABLE KEYS */;
INSERT INTO `tournaments` VALUES (4001,'Hyrule Cup',50000.00,'5 days','Kyoto, Japan',1001,'COMPLETED',2001),(4002,'Divine Beasts Challenge',75000.00,'7 days','Los Angeles, USA',1001,'COMPLETED',2001),(4003,'Master Sword Invitational',60000.00,'4 days','Paris, France',1001,'COMPLETED',2001),(4004,'Spartan Arena',100000.00,'6 days','Athens, Greece',1002,'COMPLETED',2014),(4005,'Northern Runes Tournament',85000.00,'4 days','Stockholm, Sweden',1002,'COMPLETED',2014),(4006,'Valhalla Championship',120000.00,'8 days','Oslo, Norway',1002,'COMPLETED',2014),(4007,'Western Legends',200000.00,'7 days','Austin, USA',1003,'UPCOMING',NULL),(4008,'Outlaw Showdown',175000.00,'5 days','London, UK',1003,'UPCOMING',NULL),(4009,'Van der Linde Showdown',180000.00,'6 days','Melbourne, Australia',1003,'UPCOMING',NULL),(4010,'White Wolf Tournament',140000.00,'6 days','Warsaw, Poland',1004,'ONGOING',NULL),(4011,'Monster Slayer Cup',110000.00,'4 days','Berlin, Germany',1004,'ONGOING',NULL),(4012,'Kaer Morhen Trials',90000.00,'3 days','Prague, Czech Republic',1004,'UPCOMING',NULL),(4013,'Block Builders Bash',95000.00,'5 days','San Francisco, USA',1005,'ONGOING',NULL),(4014,'Redstone Masters',70000.00,'4 days','Mumbai, India',1005,'UPCOMING',NULL),(4015,'Ender Dragon Fight',85000.00,'6 days','Sydney, Australia',1005,'UPCOMING',NULL),(4016,'Victory Royale Open',180000.00,'7 days','New York, USA',1006,'ONGOING',NULL),(4017,'Battle Bus Bash',170000.00,'6 days','Seoul, South Korea',1006,'UPCOMING',NULL),(4018,'Zero Point Clash',160000.00,'5 days','Berlin, Germany',1006,'UPCOMING',NULL),(4019,'Los Santos Challenge',210000.00,'8 days','Las Vegas, USA',1007,'ONGOING',NULL),(4020,'Vinewood Invitational',195000.00,'6 days','London, UK',1007,'UPCOMING',NULL),(4021,'Pacific Standard Cup',200000.00,'7 days','Rio de Janeiro, Brazil',1007,'UPCOMING',NULL),(4022,'Warzone World Series',250000.00,'8 days','Los Angeles, USA',1008,'ONGOING',NULL),(4023,'Task Force 141 Cup',225000.00,'6 days','London, UK',1008,'UPCOMING',NULL),(4024,'Special Ops Challenge',215000.00,'4 days','Dubai, UAE',1008,'UPCOMING',NULL),(4025,'Overwatch Open',150000.00,'7 days','San Francisco, USA',1009,'ONGOING',NULL),(4026,'Talon Strike Cup',155000.00,'6 days','Seoul, South Korea',1009,'UPCOMING',NULL),(4027,'Numbani Invitational',145000.00,'4 days','London, UK',1009,'UPCOMING',NULL),(4028,'Ashen Ones Invitational',120000.00,'4 days','Tokyo, Japan',1010,'ONGOING',NULL),(4029,'Cinder Cup',140000.00,'7 days','Dublin, Ireland',1010,'UPCOMING',NULL),(4030,'Lothric Challenge',135000.00,'6 days','Athens, Greece',1010,'UPCOMING',NULL),(4031,'Night City Open',160000.00,'6 days','Los Angeles, USA',1011,'ONGOING',NULL),(4032,'Afterlife Masters',150000.00,'5 days','Berlin, Germany',1011,'UPCOMING',NULL),(4033,'Netrunner Clash',140000.00,'3 days','Seoul, South Korea',1011,'UPCOMING',NULL),(4034,'Tarnished Triumph',170000.00,'6 days','London, UK',1012,'ONGOING',NULL),(4035,'Golden Order Cup',165000.00,'4 days','Osaka, Japan',1012,'UPCOMING',NULL),(4036,'Haligtree Challenge',155000.00,'5 days','Sydney, Australia',1012,'UPCOMING',NULL),(4037,'Web Warriors Tournament',95000.00,'4 days','New York, USA',1013,'ONGOING',NULL),(4038,'Manhattan Swing',115000.00,'5 days','London, UK',1013,'UPCOMING',NULL),(4039,'Venom Cup',98000.00,'6 days','Buenos Aires, Argentina',1013,'UPCOMING',NULL),(4040,'Nora Braves Cup',133000.00,'5 days','Amsterdam, Netherlands',1014,'ONGOING',NULL),(4041,'Thunderjaw Bash',120000.00,'4 days','Cape Town, South Africa',1014,'UPCOMING',NULL),(4042,'Zero Dawn Invitational',145000.00,'6 days','Tokyo, Japan',1014,'UPCOMING',NULL),(4043,'Underworld Trials',98000.00,'3 days','Athens, Greece',1015,'ONGOING',NULL),(4044,'Olympian Masters',110000.00,'5 days','Rome, Italy',1015,'UPCOMING',NULL),(4045,'Styx Showdown',105000.00,'6 days','New York, USA',1015,'UPCOMING',NULL),(4046,'Skeld Mystery Tournament',60000.00,'3 days','San Francisco, USA',1016,'ONGOING',NULL),(4047,'Impostor Challenge',80000.00,'4 days','Berlin, Germany',1016,'UPCOMING',NULL),(4048,'Crewmate Cup',70000.00,'5 days','Rio de Janeiro, Brazil',1016,'UPCOMING',NULL),(4049,'Bean Bash',85000.00,'2 days','London, UK',1017,'ONGOING',NULL),(4050,'Slime Climb Challenge',93000.00,'3 days','Tokyo, Japan',1017,'UPCOMING',NULL),(4051,'Crown Clash',90000.00,'4 days','Sydney, Australia',1017,'UPCOMING',NULL),(4052,'Radiant Legends Cup',150000.00,'5 days','Seoul, South Korea',1018,'ONGOING',NULL),(4053,'Spike Defenders Showdown',130000.00,'6 days','London, UK',1018,'UPCOMING',NULL),(4054,'Viper Strike Invitational',120000.00,'4 days','Istanbul, Turkey',1018,'UPCOMING',NULL),(4055,'Summoners Elite Tournament',300000.00,'8 days','Berlin, Germany',1019,'ONGOING',NULL),(4056,'Baron Bash',280000.00,'7 days','London, UK',1019,'ONGOING',NULL),(4057,'Worlds Clash',400000.00,'10 days','Shanghai, China',1019,'UPCOMING',NULL),(4058,'Stardrop Festival',75000.00,'4 days','San Francisco, USA',1020,'COMPLETED',2136),(4059,'Pelican Town Bash',72000.00,'3 days','London, UK',1020,'COMPLETED',2134),(4060,'Junimo Cup',80000.00,'5 days','Cape Town, South Africa',1020,'COMPLETED',2136),(5001,'Grand Finals Championship',500000.00,'10 days','Tokyo, Japan',1001,'UPCOMING',NULL),(5011,'abc_Tournament',1234567.00,'6 days','India',1022,'COMPLETED',2144);
/*!40000 ALTER TABLE `tournaments` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validate_tournament_before_insert` BEFORE INSERT ON `tournaments` FOR EACH ROW BEGIN
    
    IF NEW.PRIZE_POOL < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Prize pool cannot be negative';
    END IF;
    
    
    IF NEW.DURATION IS NULL OR TRIM(NEW.DURATION) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duration cannot be empty';
    END IF;
    
    
    IF NEW.TOURNAMENT_NAME IS NULL OR TRIM(NEW.TOURNAMENT_NAME) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tournament name cannot be empty';
    END IF;
    
    
    IF NEW.STATUS NOT IN ('UPCOMING', 'ONGOING', 'COMPLETED') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid tournament status';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `v_tournament_standings`
--

DROP TABLE IF EXISTS `v_tournament_standings`;
/*!50001 DROP VIEW IF EXISTS `v_tournament_standings`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_tournament_standings` AS SELECT 
 1 AS `TK_ID`,
 1 AS `TEAM_ID`,
 1 AS `TEAM_NAME`,
 1 AS `POINTS`,
 1 AS `WINS`,
 1 AS `LOSSES`,
 1 AS `RANKING`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_tournament_winners`
--

DROP TABLE IF EXISTS `v_tournament_winners`;
/*!50001 DROP VIEW IF EXISTS `v_tournament_winners`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_tournament_winners` AS SELECT 
 1 AS `TK_ID`,
 1 AS `TEAM_ID`,
 1 AS `TEAM_NAME`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'gaming_tournament_db'
--

--
-- Dumping routines for database 'gaming_tournament_db'
--
/*!50003 DROP FUNCTION IF EXISTS `CalculateTournamentRanking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `CalculateTournamentRanking`(
    p_tournament_id INT,
    p_team_id INT
) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE v_ranking INT;
    
    SELECT COUNT(*) + 1 INTO v_ranking
    FROM tournament_stats ts
    WHERE ts.TK_ID = p_tournament_id
    AND (ts.POINTS > (SELECT POINTS FROM tournament_stats WHERE TK_ID = p_tournament_id AND TEAM_ID = p_team_id)
         OR (ts.POINTS = (SELECT POINTS FROM tournament_stats WHERE TK_ID = p_tournament_id AND TEAM_ID = p_team_id)
             AND ts.WINS > (SELECT WINS FROM tournament_stats WHERE TK_ID = p_tournament_id AND TEAM_ID = p_team_id)));
    
    RETURN COALESCE(v_ranking, 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calculate_win_percentage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_win_percentage`(p_team_id INT) RETURNS decimal(5,2)
    DETERMINISTIC
BEGIN
    DECLARE win_pct DECIMAL(5,2);
    
    SELECT (WINS / MATCH_PLAYED * 100) INTO win_pct
    FROM stats
    WHERE TEAM_ID = p_team_id
    LIMIT 1;  
    
    RETURN IFNULL(win_pct, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `count_participating_teams` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `count_participating_teams`(p_tk_id INT) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count
    FROM participate
    WHERE TK_ID = p_tk_id;
    RETURN COALESCE(v_count, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `count_teams_in_game` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `count_teams_in_game`(p_game_id INT) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE team_count INT;
    
    SELECT COUNT(*) INTO team_count
    FROM team
    WHERE GAME_ID = p_game_id;
    
    RETURN IFNULL(team_count, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_team_game_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_team_game_name`(p_team_id INT) RETURNS varchar(100) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE game_name VARCHAR(100);
    
    SELECT g.GAME_NAME INTO game_name
    FROM team t
    JOIN games g ON t.GAME_ID = g.GAME_ID
    WHERE t.TEAM_ID = p_team_id
    LIMIT 1;
    
    RETURN IFNULL(game_name, 'Unknown');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_total_sponsorship_for_team` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_total_sponsorship_for_team`(p_team_id INT) RETURNS decimal(15,2)
    READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(15,2);
    SELECT COALESCE(SUM(AMOUNT), 0) INTO v_total
    FROM sponsorship
    WHERE TEAM_ID = p_team_id;
    RETURN v_total;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_tournament_winner_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_tournament_winner_name`(p_tk_id INT) RETURNS varchar(100) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE v_winner VARCHAR(100);
    SELECT t.TEAM_NAME INTO v_winner
    FROM tournaments trn
    LEFT JOIN team t ON t.TEAM_ID = trn.WINNER_TEAM_ID
    WHERE trn.TK_ID = p_tk_id
    LIMIT 1;
    RETURN COALESCE(v_winner, 'TBD');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_teams_by_region` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_teams_by_region`(IN p_region VARCHAR(50))
BEGIN
    SELECT
        t.TEAM_ID,
        t.TEAM_NAME,
        t.REGION,
        t.COACH,
        g.GAME_NAME,
        IFNULL(s.POINTS, 0) AS POINTS,
        IFNULL(s.RANKING, 0) AS RANKING,
        IFNULL(ROUND((s.WINS / NULLIF(s.MATCH_PLAYED,0) * 100), 2), 0) as win_percentage
    FROM team t
    LEFT JOIN stats s ON t.TEAM_ID = s.TEAM_ID
    JOIN games g ON t.GAME_ID = g.GAME_ID
    WHERE TRIM(LOWER(t.REGION)) = TRIM(LOWER(p_region))
    ORDER BY POINTS DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_teams_count_by_region` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_teams_count_by_region`()
BEGIN
    SELECT 
        REGION,
        COUNT(*) as count
    FROM team
    GROUP BY REGION
    ORDER BY count DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_top_teams_analytics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_teams_analytics`(IN p_limit INT)
BEGIN
    SELECT 
        t.TEAM_NAME,
        s.POINTS,
        s.RANKING,
        s.WINS,
        s.LOSSES
    FROM team t
    JOIN stats s ON t.TEAM_ID = s.TEAM_ID
    ORDER BY s.POINTS DESC
    LIMIT p_limit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_top_teams_by_game` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_teams_by_game`(
    IN p_game_id INT,
    IN p_limit INT
)
BEGIN
    SELECT 
        t.TEAM_ID,
        t.TEAM_NAME,
        t.REGION,
        t.COACH,
        s.POINTS,
        s.WINS,
        s.LOSSES,
        s.MATCH_PLAYED,
        ROUND((s.WINS / s.MATCH_PLAYED * 100), 2) as win_percentage,
        s.RANKING,
        g.GAME_NAME
    FROM team t
    JOIN stats s ON t.TEAM_ID = s.TEAM_ID
    JOIN games g ON t.GAME_ID = g.GAME_ID
    WHERE t.GAME_ID = p_game_id
    ORDER BY s.POINTS DESC, s.RANKING ASC
    LIMIT p_limit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_tournaments_filtered` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tournaments_filtered`(IN p_status VARCHAR(20))
BEGIN
    IF p_status IN ('UPCOMING', 'ONGOING', 'COMPLETED') THEN
        SELECT
            t.TK_ID,
            t.TOURNAMENT_NAME,
            t.LOCATION,
            t.PRIZE_POOL,
            t.DURATION,
            t.GAME_ID,
            t.STATUS,
            t.WINNER_TEAM_ID,
            team.TEAM_NAME AS WINNER_NAME
        FROM tournaments t
        LEFT JOIN team ON team.TEAM_ID = t.WINNER_TEAM_ID
        WHERE t.STATUS = p_status
        ORDER BY FIELD(t.STATUS, 'ONGOING', 'UPCOMING', 'COMPLETED'), t.TK_ID DESC;
    ELSE
        
        SELECT
            t.TK_ID,
            t.TOURNAMENT_NAME,
            t.LOCATION,
            t.PRIZE_POOL,
            t.DURATION,
            t.GAME_ID,
            t.STATUS,
            t.WINNER_TEAM_ID,
            team.TEAM_NAME AS WINNER_NAME
        FROM tournaments t
        LEFT JOIN team ON team.TEAM_ID = t.WINNER_TEAM_ID
        ORDER BY FIELD(t.STATUS, 'ONGOING', 'UPCOMING', 'COMPLETED'), t.TK_ID DESC;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_tournament_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tournament_details`(
    IN p_tournament_id INT
)
BEGIN
    
    SELECT
        TK_ID,
        TOURNAMENT_NAME,
        PRIZE_POOL,
        DURATION,
        LOCATION,
        GAME_ID
    FROM tournaments
    WHERE TK_ID = p_tournament_id;

    
    
    SELECT
        tm.TEAM_ID,
        vts.TEAM_NAME,
        tm.REGION,
        vts.POINTS,
        vts.RANKING,
        vts.WINS,
        vts.LOSSES
    FROM participate p
    JOIN team tm ON p.TEAM_ID = tm.TEAM_ID
    JOIN v_tournament_standings vts ON vts.TEAM_NAME = tm.TEAM_NAME AND vts.TK_ID = p_tournament_id
    WHERE p.TK_ID = p_tournament_id
    ORDER BY vts.RANKING ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_tournament_streams` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tournament_streams`(
    IN p_tournament_id INT
)
BEGIN
    SELECT 
        s.STREAM_ID,
        s.PLATFORM,
        s.URL,
        s.LANGUAGE,
        t.TOURNAMENT_NAME,
        g.GAME_NAME
    FROM stream s
    JOIN tournaments t ON s.TK_ID = t.TK_ID
    JOIN games g ON t.GAME_ID = g.GAME_ID
    WHERE s.TK_ID = p_tournament_id
    ORDER BY s.PLATFORM;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RecordMatchAndUpdateStandings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `RecordMatchAndUpdateStandings`(
    IN p_tournament_id INT,
    IN p_winner_team_id INT,
    IN p_loser_team_id INT,
    IN p_points_awarded INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error recording match result';
    END;

    START TRANSACTION;

    
    INSERT IGNORE INTO tournament_stats (TK_ID, TEAM_ID, WINS, LOSSES, POINTS, MATCH_PLAYED)
    VALUES (p_tournament_id, p_winner_team_id, 0, 0, 0, 0);

    INSERT IGNORE INTO tournament_stats (TK_ID, TEAM_ID, WINS, LOSSES, POINTS, MATCH_PLAYED)
    VALUES (p_tournament_id, p_loser_team_id, 0, 0, 0, 0);

    
    UPDATE tournament_stats
    SET WINS = WINS + 1,
        POINTS = POINTS + p_points_awarded,
        MATCH_PLAYED = MATCH_PLAYED + 1
    WHERE TK_ID = p_tournament_id AND TEAM_ID = p_winner_team_id;

    
    UPDATE tournament_stats
    SET LOSSES = LOSSES + 1,
        MATCH_PLAYED = MATCH_PLAYED + 1
    WHERE TK_ID = p_tournament_id AND TEAM_ID = p_loser_team_id;

    
    
    

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_complete_tournament` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_complete_tournament`(IN p_tk_id INT)
BEGIN
  UPDATE tournaments t
  JOIN v_tournament_winners w ON w.TK_ID = p_tk_id
     SET t.WINNER_TEAM_ID = w.TEAM_ID,
         t.STATUS = 'COMPLETED'
   WHERE t.TK_ID = p_tk_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_tournament_standings`
--

/*!50001 DROP VIEW IF EXISTS `v_tournament_standings`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_tournament_standings` AS select `ts`.`TK_ID` AS `TK_ID`,`ts`.`TEAM_ID` AS `TEAM_ID`,`t`.`TEAM_NAME` AS `TEAM_NAME`,`ts`.`POINTS` AS `POINTS`,`ts`.`WINS` AS `WINS`,`ts`.`LOSSES` AS `LOSSES`,dense_rank() OVER (PARTITION BY `ts`.`TK_ID` ORDER BY `ts`.`POINTS` desc,`ts`.`WINS` desc,`t`.`TEAM_NAME` )  AS `RANKING` from (`tournament_stats` `ts` join `team` `t` on((`t`.`TEAM_ID` = `ts`.`TEAM_ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_tournament_winners`
--

/*!50001 DROP VIEW IF EXISTS `v_tournament_winners`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_tournament_winners` AS select `x`.`TK_ID` AS `TK_ID`,`x`.`TEAM_ID` AS `TEAM_ID`,`x`.`TEAM_NAME` AS `TEAM_NAME` from (select `s`.`TK_ID` AS `TK_ID`,`s`.`TEAM_ID` AS `TEAM_ID`,`s`.`TEAM_NAME` AS `TEAM_NAME`,`s`.`POINTS` AS `POINTS`,`s`.`WINS` AS `WINS`,`s`.`LOSSES` AS `LOSSES`,`s`.`RANKING` AS `RANKING`,row_number() OVER (PARTITION BY `s`.`TK_ID` ORDER BY `s`.`POINTS` desc,`s`.`WINS` desc,`s`.`TEAM_NAME` )  AS `rn` from `v_tournament_standings` `s`) `x` where (`x`.`rn` = 1) */;
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

-- Dump completed on 2025-11-09 22:53:30
