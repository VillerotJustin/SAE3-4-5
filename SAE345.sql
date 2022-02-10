-- MySQL dump 10.19  Distrib 10.3.32-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: SAE345
-- ------------------------------------------------------
-- Server version	10.3.32-MariaDB-0ubuntu0.20.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Adresse`
--

DROP TABLE IF EXISTS `Adresse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Adresse` (
  `idAdresse` int(11) NOT NULL AUTO_INCREMENT,
  `adresse` varchar(50) DEFAULT NULL,
  `code_postale` int(11) DEFAULT NULL,
  `ville` varchar(50) DEFAULT NULL,
  `idUser` int(11) NOT NULL,
  PRIMARY KEY (`idAdresse`),
  KEY `fk_Adresse_Utilisateur` (`idUser`),
  CONSTRAINT `fk_Adresse_Utilisateur` FOREIGN KEY (`idUser`) REFERENCES `Utilisateur` (`idUser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Adresse`
--

LOCK TABLES `Adresse` WRITE;
/*!40000 ALTER TABLE `Adresse` DISABLE KEYS */;
/*!40000 ALTER TABLE `Adresse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Avis`
--

DROP TABLE IF EXISTS `Avis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Avis` (
  `idAvis` int(11) NOT NULL AUTO_INCREMENT,
  `Note` int(11) DEFAULT NULL,
  `commentaire` text DEFAULT NULL,
  `idProduit` int(11) NOT NULL,
  `idUser` int(11) NOT NULL,
  PRIMARY KEY (`idAvis`),
  KEY `fk_Avis_Produit` (`idProduit`),
  KEY `fk_Avis_Utilisateur` (`idUser`),
  CONSTRAINT `fk_Avis_Produit` FOREIGN KEY (`idProduit`) REFERENCES `Produit` (`idProduit`),
  CONSTRAINT `fk_Avis_Utilisateur` FOREIGN KEY (`idUser`) REFERENCES `Utilisateur` (`idUser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Avis`
--

LOCK TABLES `Avis` WRITE;
/*!40000 ALTER TABLE `Avis` DISABLE KEYS */;
/*!40000 ALTER TABLE `Avis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Commande`
--

DROP TABLE IF EXISTS `Commande`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Commande` (
  `idCommande` int(11) NOT NULL AUTO_INCREMENT,
  `dateCommande` date DEFAULT NULL,
  `idAdresse` int(11) NOT NULL,
  `idEtat` int(11) NOT NULL,
  `idUser` int(11) NOT NULL,
  PRIMARY KEY (`idCommande`),
  KEY `fk_Commande_Adresse` (`idAdresse`),
  KEY `fk_Commande_Etat` (`idEtat`),
  KEY `fk_Commande_Utilisateur` (`idUser`),
  CONSTRAINT `fk_Commande_Adresse` FOREIGN KEY (`idAdresse`) REFERENCES `Adresse` (`idAdresse`),
  CONSTRAINT `fk_Commande_Etat` FOREIGN KEY (`idEtat`) REFERENCES `Etat` (`idEtat`),
  CONSTRAINT `fk_Commande_Utilisateur` FOREIGN KEY (`idUser`) REFERENCES `Utilisateur` (`idUser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Commande`
--

LOCK TABLES `Commande` WRITE;
/*!40000 ALTER TABLE `Commande` DISABLE KEYS */;
/*!40000 ALTER TABLE `Commande` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Etat`
--

DROP TABLE IF EXISTS `Etat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Etat` (
  `idEtat` int(11) NOT NULL AUTO_INCREMENT,
  `libelleEtat` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idEtat`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Etat`
--

LOCK TABLES `Etat` WRITE;
/*!40000 ALTER TABLE `Etat` DISABLE KEYS */;
INSERT INTO `Etat` VALUES (1,'En traitement'),
(2,'En preparation'),
(3,'Envoyer');
/*!40000 ALTER TABLE `Etat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Fourniseur`
--

DROP TABLE IF EXISTS `Fourniseur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Fourniseur` (
  `idFourniseur` int(11) NOT NULL AUTO_INCREMENT,
  `libelleFourniseur` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idFourniseur`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Fourniseur`
--

LOCK TABLES `Fourniseur` WRITE;
/*!40000 ALTER TABLE `Fourniseur` DISABLE KEYS */;
INSERT INTO `Fourniseur` VALUES (1,'Bandai'),
(2,'Vallejo');
/*!40000 ALTER TABLE `Fourniseur` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Grade`
--

DROP TABLE IF EXISTS `Grade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Grade` (
  `idGrade` int(11) NOT NULL AUTO_INCREMENT,
  `Libelle` varchar(50) DEFAULT NULL,
  `abreviation` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`idGrade`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Grade`
--

LOCK TABLES `Grade` WRITE;
/*!40000 ALTER TABLE `Grade` DISABLE KEYS */;
INSERT INTO `Grade` VALUES (1,' FIRST  GRADE ','FG'),
(2,' HIGH  GRADE ','HG'),
(3,' REAL  GRADE ','RG'),
(4,' FULL  MECHANICS ','FM'),
(5,' MASTER  GRADE ','MG'),
(6,' MASTER  GRADE  EXTREME ','MGEX'),
(7,' NO  GRADE  100 ','NG'),
(8,' HIGH  RESOLUTION  MODEL ','HIRM'),
(9,' MEGA  SIZE ','MSM'),
(10,' PERFECT  GRADE ','PG');
/*!40000 ALTER TABLE `Grade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Kits`
--

DROP TABLE IF EXISTS `Kits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Kits` (
  `idKit` int(11) NOT NULL AUTO_INCREMENT,
  `LibelleKit` varchar(70) DEFAULT NULL,
  `PrixKit` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`idKit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Kits`
--

LOCK TABLES `Kits` WRITE;
/*!40000 ALTER TABLE `Kits` DISABLE KEYS */;
/*!40000 ALTER TABLE `Kits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PanierUser`
--

DROP TABLE IF EXISTS `PanierUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PanierUser` (
  `idPanier` int(11) NOT NULL AUTO_INCREMENT,
  `idUser` int(11) NOT NULL,
  PRIMARY KEY (`idPanier`),
  UNIQUE KEY `idUser` (`idUser`),
  CONSTRAINT `fk_PanierUser_Utilisateur` FOREIGN KEY (`idUser`) REFERENCES `Utilisateur` (`idUser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PanierUser`
--

LOCK TABLES `PanierUser` WRITE;
/*!40000 ALTER TABLE `PanierUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `PanierUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Produit`
--

DROP TABLE IF EXISTS `Produit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Produit` (
  `idProduit` int(11) NOT NULL AUTO_INCREMENT,
  `LibelleProduit` varchar(90) DEFAULT NULL,
  `Prix` decimal(6,2) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `idFourniseur` int(11) NOT NULL,
  `idType` int(11) NOT NULL,
  `idTaille` int(11) DEFAULT NULL,
  `idGrade` int(11) DEFAULT NULL,
  PRIMARY KEY (`idProduit`),
  KEY `fk_Produit_Fourniseur` (`idFourniseur`),
  KEY `fk_Produit_TypeProduit` (`idType`),
  KEY `fk_Produit_Taille` (`idTaille`),
  KEY `fk_Produit_Grade` (`idGrade`),
  CONSTRAINT `fk_Produit_Fourniseur` FOREIGN KEY (`idFourniseur`) REFERENCES `Fourniseur` (`idFourniseur`),
  CONSTRAINT `fk_Produit_Grade` FOREIGN KEY (`idGrade`) REFERENCES `Grade` (`idGrade`),
  CONSTRAINT `fk_Produit_Taille` FOREIGN KEY (`idTaille`) REFERENCES `Taille` (`idTaille`),
  CONSTRAINT `fk_Produit_TypeProduit` FOREIGN KEY (`idType`) REFERENCES `TypeProduit` (`idType`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Produit`
--

LOCK TABLES `Produit` WRITE;
/*!40000 ALTER TABLE `Produit` DISABLE KEYS */;
INSERT INTO `Produit` VALUES (1,'BANDAI GU25268 GUNPLA RE DIJEH',49.90,'BANDAI GU25268 GUNPLA RE 1/100 DIJEH Figurine articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément. DIJEH provient de Mobile Suit Gundam - Marque : Bandai - Série : Mobile Suit Gundam - Date de sortie : Juin 2015 - Taille de paquet / poids : 31.2 x 20.5 x 13.5 cm / 613g - Manuel d\'instruction : Inclus Ajoutez ce REBORN à votre collection et restez connectés pour connaître les prochaines sorties !',1,1,1,7),
(2,'BANDAI GUN15930 GUNPLA BB SINANJU',15.90,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.',1,1,1,7),
(3,'BANDAI GUN28742 GUNPLA BB GUNDAM ASTRAY SENGOKU',12.00,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.',1,1,1,7),
(4,'BANDAI GUN60583 GUNPLA SD CROSS SILHOUETTE NIGHTINGALE',19.90,'SD Gundam Cross Silhouette » est un nouveau Gunpla de Gundam SD série à travers lequel vous pouvez créer idéal proportions par combinaison de deux types de trames et armures pour une coiffure encore plus libre. Deux formes – un corps haut ou court – peuvent être recréés grâce à la « Super déformé (SD) Frame » et « Cross Silhouette (CS) Frame ». Vous pouvez également créer vos propres proportions préférées en combinant les deux cadres. En outre, la tête est créée pour être hautement détaillé et facile à assembler par le biais de codage unique à la série SD par couleur. Les modèles peuvent également être construits avec ou sans yeux à l’aide de pièces interchangeables.',1,1,1,7),
(5,'BANDAI GUN62935 GUNPLA SD CROSS SILHOUETTE PHENEX DESTR NARRATIVE',15.90,'SD Gundam Cross Silhouette » est un nouveau Gunpla de Gundam SD série à travers lequel vous pouvez créer idéal proportions par combinaison de deux types de trames et armures pour une coiffure encore plus libre. Deux formes – un corps haut ou court – peuvent être recréés grâce à la « Super déformé (SD) Frame » et « Cross Silhouette (CS) Frame ». Vous pouvez également créer vos propres proportions préférées en combinant les deux cadres. En outre, la tête est créée pour être hautement détaillé et facile à assembler par le biais de codage unique à la série SD par couleur. Les modèles peuvent également être construits avec ou sans yeux à l’aide de pièces interchangeables.',1,1,1,7),
(6,'BANDAI GUN086 GUNDAM GUNPLA NG 1ST GUNDAM RX-78',4.95,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.',1,1,2,1),
(7,'BANDAI GUN70677 HGBDR GUNDAM GP-RASE-TWO-TEN',34.95,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.',1,1,2,2),
(8,'BANDAI GUN82697 GUNDAM GUNPLA HG 216 UNICORN GUNDAM 03 PHENEX DESTROY MODE GOLD',59.90,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.',1,1,2,2),
(9,'BANDAI GUNPLA RG 1/144 ZETA MSZ-006 GUNDAM',39.90,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.',1,1,2,3),
(10,'BANDAI GUNPLA RG 1/144 UNICORN GUNDAM',49.90,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.',1,1,2,3),
(11,'BANDAI GUNPLA FULL MECHANICS BAEL GUNDAM',39.90,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.',1,1,3,4),
(12,'BANDAI GUN57025 GUNPLA 1/100 FULL MECHANICS BARBATOS LUPUS REX SANS SOCLE',39.90,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.',1,1,3,4),
(13,'BANDAI BAN82243 GUNPLA MG 00 QANT TRANS-AM MODE SPECIAL COATING',129.90,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.',1,1,3,5),
(14,'BANDAI GUN16188 GUNPLA MG GUNDAM RX-0 BANSHEE TITANIUM',159.00,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.',1,1,3,5),
(15,'BANDAI GUN73088 MGEX 1/100 GUNDAM UNICORN VER KA',269.90,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit. BANDAI GUN73088 MGEX 1/100 GUNDAM UNICORN VER KA Quantité Ultra Limitée/ Frais de port Offert France',1,1,3,6),
(16,'BANDAI GUN55356 GUNPLA HIRM GUNDAM ASTRAY RED FRAME HI RES',159.00,'Cet article est un kit plastique de qualité supérieure issu de l\'univers Gundam. Le spectaculaire Gundam Astray Red de Gundam Seed est disponible en version haute résolution de Bandai! Cette bête dispose d\'une armature intérieure et d\'un traitement de surface complet pour lui donner une densité de texture et de profondeur accrue, tandis que la lame de l\'arme Gerbera Straight est traitée avec une finition plaquée! Ajoutez ce superbe kit à votre collection maintenant! La combinaison a été une nouvelle fois repensée pour paraître plus robuste, et elle comprend un cadre intérieur entièrement assemblé ainsi que tout l’arsenal des armes: la Gerbera Straight, la Beam Rifle, le Shield, les Beam Sabers et 5 paires de mains interchangeables!',1,1,3,8),
(17,'BANDAI GUN66737 GUNPLA HIRM GUNDAM ASTRAY NOIR',179.90,'Cet article est un kit plastique de qualité supérieure issu de l\'univers Gundam. Le spectaculaire Gundam Astray Noir de Mobile Suit Gundam SEED Destiny Astray B est disponible en version haute résolution de Bandai! Cette bête dispose d\'une armature intérieure et d\'un traitement de surface complet pour lui donner une densité de texture et de profondeur accrue. Ajoutez ce superbe kit à votre collection maintenant! La combinaison a été une nouvelle fois repensée pour paraître plus robuste, et elle comprend un cadre intérieur entièrement assemblé ainsi que tout l’arsenal des armes.',1,1,3,8),
(18,'BANDAI GUNPLA MSM 1/48 ZAKU II GREEN GUNDAM',99.00,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit. BANDAI GUNPLA MSM 1/48 ZAKU II GREEN GUNDAM',1,1,5,9),
(19,'BANDAI GUNPLA 1/48 MEGASIZE GUNDAM UNICORN',109.00,'Maquette articulée à assembler sans colle ni peinture (optionnel). Serie: Gundam UC (Unicorn) Date de sortie: Août 2017 Taille/poids du paquet: 58.0 x 39.0 x 14.3 cm / 2120g Ajoutez ce Mega Size Model à votre collection et restez connectés pour connaître les prochaines sorties!',1,1,5,9),
(20,'BANDAI GUN16106 GUNPLA PG STRIKE ROUGE + SKYGRASPER',219.90,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). BANDAI GUN16106 GUNPLA PG STRIKE ROUGE + SKYGRASPER',1,1,4,10),
(21,'BANDAI GUN82392 GUNPLA PG 1/60 GUNDAM EXIA KIT LED',149.90,'GUNPLA PG 1/60 GUNDAM EXIA KIT LED provient de Gundam 00 (Double O) Système de montage SNAPFIT = ne nécessite ni colle, ni peinture. Kit Led fournie Produit présenté en boite cartonnée.',1,1,4,10),
(22,'1 PACK DECAL N°118 MG GM SNIPER GM COMMAND',5.90,'1 PACK DECAL N°118 MG 1/100 GM SNIPER /GM COMMAND',2,2,NULL,NULL),
(23,'PACK DECAL N°111 RG 1/144 ASTRAY RED FRAME',5.90,'1 PACK DECAL N°111 RG 1/144 ASTRAY RED FRAME',2,2,NULL,NULL),
(24,'BANDAI GUN81428 GUNPLA HGBC 1/144 SPINNING BLASTER',9.95,'Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.',1,2,NULL,NULL),
(25,'BANDAI ACTION BASE CUSTOMIZE SCENE BASE',8.90,'Socle de présentation à assembler sans colle ni peinture (optionnel). Compatible 1/144.',1,2,NULL,NULL),
(26,'Bandai Tamashii Double Base Transparente',20.00,'Accessoire PVC adaptable aux figurines et maquettes. Set de 2 bases transparentes pour figurine Bandaï. Idéal pour présenter en vitrine ou faire des dioramas ! vendu en window box',1,2,NULL,NULL),
(27,'BANDAI SPIRITS ENTRY NIPPER',9.95,'BANDAI SPIRITS ENTRY NIPPER',1,3,NULL,NULL),
(28,'VALLEJO GUN58801 GUNPLA PRECISION 9PCS',32.00,'Set pour le modeling plastic, modeling militaire et autre hobby d\'application',2,3,NULL,NULL),
(29,'BANDAI GUNPLA MARKER REAL TOUCH 2 SET 6 GUNDAM',19.00,'BANDAI GUNPLA MARKER REAL TOUCH 2 SET 6 GUNDAM Ces véritables marqueurs tactiles sont conçus pour résister aux intempéries. Avec eux, vous pouvez donner l\'effet de taches et de bavures facilement avec une touche réaliste. La peinture à base d\'eau est utilisée pour la sécurité. Cet ensemble est composé entièrement de marqueurs qui sont disponibles séparément, de sorte que vous pouvez les obtenir dans l\'ensemble ou individuellement. Les marqueurs GM406, GM407, GM408, GM409, GM410 et le flouteur GM400 sont tous inclus!',1,3,NULL,NULL),
(30,'BANDAI GUNPLA MARKER SEED SET 6 GUNDAM',20.90,'BANDAI GUNDAM MARKER SEED 6 PCS Voici un ensemble de couleurs conçu pour les variantes Impulse Gundam de la série Gundam Seed ! Toutes les couleurs de cet ensemble sont uniques: GM40 SEED Red GM41 SEED Yellow GM42 SEED White GM43 SEED Blue GM44 SEED Gray GM45 SEED Dark Blue',1,3,NULL,NULL),
(31,'CLEANING STATION WITH AIRBRUSH HOLDER',16.00,'Pot de nettoyage à aérographe, verre avec couvercle en plastique, utilisé pour pulvériser l\'aérographe. L\'aérographe est inséré via l\'ouverture du couvercle et est nettoyé en pulvérisant le nettoyant Vallejo Airbrush ou de l\'eau dans le récipient.',2,3,NULL,NULL),
(32,'VALLEJO DIAMOND FILE SET (5) 100mm',15.95,'Limes avec des copeaux de diamant synthétique, plus solides et plus rapides que les limes métalliques Taille 140 mm. L\'ensemble comprend 5 profils: plat, carré, rond, demi-rond et triangulaire. pour des travaux de finition précis sur tous les matériaux.',2,3,NULL,NULL),
(33,'VALLEJO EXTRA FINE CURVED TWEEZERS',5.95,'Pinces incurvées extra fines idéales pour atteindre les zones difficiles d\'accès, pour prendre, tenir et placer de très petites pièces et composants avec une grande précision.',2,3,NULL,NULL),
(34,'VALLEJO MASKING TAPE 10mmX18m - TWIN PACK',5.95,'Ruban de masquage pour modélisme et tous les projets miniatures. Pas de bavure de peinture ou de lignes de peinture hésitantes. Protection U.V. pour masquage en plein soleil. Emballage: 2 unités',2,3,NULL,NULL),
(35,'VALLEJO MASKING TAPE 1mmX18m - TWIN PACK',2.50,'Ruban de masquage pour modélisme et tous les projets miniatures. Pas de bavure de peinture ou de lignes de peinture hésitantes. Protection U.V. pour masquage en plein soleil. Emballage: 2 unités',2,3,NULL,NULL),
(36,'VALLEJO Set of 3 Flexi Sanders Dual-Grit (80x30x6 mm)',4.95,'Coarse (60/100): Effective material removal. Medium (240/400): Blending and smoothing. Fine (600/1000): Finishing and polishing.',2,3,NULL,NULL),
(37,'VALLEJO MECHA BOUTEILLE DE PEINTURE',2.95,'Présenté en bouteilles de 17 ml./0,57 fl.oz avec pipette. Cet emballage empêche la peinture de s’évaporer et de sécher dans le récipient, de sorte qu’il peut être utilisé en quantité minimale et conservé pendant une longue période.',2,3,NULL,NULL),
(38,'VALLEJO 50012 MODEL AIR 71172 COLOR SET AND AIRBRUSH',259.00,'VALLEJO 50012 MODEL AIR 71172 COLOR SET AND AIRBRUSH. Set Disponible sur Commande.',2,3,NULL,NULL),
(39,'FENGDA COMPRESSOR AS-18-3',169.00,'FENGDA COMPRESSOR AS-18-3Oil-free piston compressor Ultra quiet Motor: 220-240V 50Hz /110-120V 60HZ Rotational speed: 1450 rpm/ 1700 rpm Auto-Stop at 4Bar; Auto Re-Start at 3bar Maximum pressure: 57 psi (4 BAR) 1/8 BSP Male outlet Air Delivery: 23 litres/min PCS/CTN: 6 Disponibilité sous 4 semaines.',2,3,NULL,NULL),
(40,'H & S AIRBRUSH EVOLUTION TWO IN ONE',159.90,'De Harder & Steenbeck une nouvelle ligne d’Aérographe signée Vallejo, le leader mondial des peintures pour la modélisation et le wargame L\'évolution 2 en 1 est une réussite parmi les pulvérisateurs de peinture: une structure solide, un excellent traitement et une double action douce ont fait de cet instrument l\'un des aérographes les plus utilisés depuis son lancement. L\'Evolution est un système d\'alimentation par gravité disponible sous la forme d\'un modèle 2 en 1, doté de deux jeux de buses de différentes tailles et permettant une conversion rapide et flexible de l\'instrument pour tous les domaines d\'application. Le 2 en 1 comprend un jeu de buses de 0,2 et 0,4 mm et deux tasses de 2 et 5 ml. Disponibilité sous 4 semaines.',2,3,NULL,NULL);
/*!40000 ALTER TABLE `Produit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Role`
--

DROP TABLE IF EXISTS `Role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Role` (
  `idRole` int(11) NOT NULL AUTO_INCREMENT,
  `libelleRole` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idRole`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Role`
--

LOCK TABLES `Role` WRITE;
/*!40000 ALTER TABLE `Role` DISABLE KEYS */;
INSERT INTO `Role` VALUES (1,'ROLE_admin'),
(2,'ROLE_client');
/*!40000 ALTER TABLE `Role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Taille`
--

DROP TABLE IF EXISTS `Taille`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Taille` (
  `idTaille` int(11) NOT NULL AUTO_INCREMENT,
  `LibelleTaille` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`idTaille`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Taille`
--

LOCK TABLES `Taille` WRITE;
/*!40000 ALTER TABLE `Taille` DISABLE KEYS */;
INSERT INTO `Taille` VALUES (1,'SUPER-DEFORMED'),
(2,'1/144'),
(3,'1/100'),
(4,'1/60'),
(5,'1/48');
/*!40000 ALTER TABLE `Taille` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TypeProduit`
--

DROP TABLE IF EXISTS `TypeProduit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TypeProduit` (
  `idType` int(11) NOT NULL AUTO_INCREMENT,
  `LibelleType` varchar(70) DEFAULT NULL,
  PRIMARY KEY (`idType`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TypeProduit`
--

LOCK TABLES `TypeProduit` WRITE;
/*!40000 ALTER TABLE `TypeProduit` DISABLE KEYS */;
INSERT INTO `TypeProduit` VALUES (1,'Gundam'),
(2,'Accesoire'),
(3,'Outils');
/*!40000 ALTER TABLE `TypeProduit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Utilisateur`
--

DROP TABLE IF EXISTS `Utilisateur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Utilisateur` (
  `idUser` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `est_actif` smallint(6) DEFAULT NULL,
  `idRole` int(11) NOT NULL,
  PRIMARY KEY (`idUser`),
  KEY `fk_Utilisateur_Role` (`idRole`),
  CONSTRAINT `fk_Utilisateur_Role` FOREIGN KEY (`idRole`) REFERENCES `Role` (`idRole`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Utilisateur`
--

LOCK TABLES `Utilisateur` WRITE;
/*!40000 ALTER TABLE `Utilisateur` DISABLE KEYS */;
INSERT INTO Utilisateur(idUser, username, password, email, est_actif, idRole) VALUES
(NULL,  'admin', 'sha256$pBGlZy6UukyHBFDH$2f089c1d26f2741b68c9218a68bfe2e25dbb069c27868a027dad03bcb3d7f69a','admin@admin.fr', 1, 1),
(NULL,  'client', 'sha256$Q1HFT4TKRqnMhlTj$cf3c84ea646430c98d4877769c7c5d2cce1edd10c7eccd2c1f9d6114b74b81c4','client@client.fr', 1, 2),
(NULL,  'client2', 'sha256$ayiON3nJITfetaS8$0e039802d6fac2222e264f5a1e2b94b347501d040d71cfa4264cad6067cf5cf3', 'client2@client2.fr', 1,2);
/*!40000 ALTER TABLE `Utilisateur` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Variations`
--

DROP TABLE IF EXISTS `Variations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Variations` (
  `idVariation` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` text DEFAULT NULL,
  `imageProduit` varchar(255) DEFAULT NULL,
  `Stock` int(11) DEFAULT NULL,
  `idProduit` int(11) DEFAULT NULL,
  PRIMARY KEY (`idVariation`),
  KEY `fk_Variations_Produit` (`idProduit`),
  CONSTRAINT `fk_Variations_Produit` FOREIGN KEY (`idProduit`) REFERENCES `Produit` (`idProduit`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Variations`
--

LOCK TABLES `Variations` WRITE;
/*!40000 ALTER TABLE `Variations` DISABLE KEYS */;
INSERT INTO `Variations` VALUES 
(1,'','BANDAI_GU25268_GUNPLA_RE_1-100_DIJEH.png',4,1),
(2,'','BANDAI_GUN15930_GUNPLA_BB_SINANJU.png',5,2),
(3,'','BANDAI_GUN28742_GUNPLA_BB_GUNDAM_ASTRAY_SENGOKU.png',9,3),
(4,'','BANDAI_GUN60583_GUNPLA_SD_CROSS_SILHOUETTE_NIGHTINGALE.png',2,4),
(5,'','BANDAI_GUN62935_GUNPLA_SD_CROSS_SILHOUETTE_PHENEX_DESTR_NARRATIVE.png',8,5),
(6,'','BANDAI_GUN086_GUNDAM_GUNPLA_NG_1-144_GUNDAM_RX-78.png',3,6),
(7,'','BANDAi_GUN70677_HGBDR_1-144_GUNDAM_GP-RASE-TWO-TEN.png',4,7),
(8,'','BANDAI_GUN82697_GUNDAM_GUNPLA_HG_1-144_216_UNICORN_GUNDAM_03_PHENEX_DESTROY_MODE_GOLD.png',9,8),
(9,'','BANDAI_GUNPLA_RG_1-144_ZETA_MSZ-006_GUNDAM.png',3,9),
(10,'','BANDAI_GUNPLA_RG_1-144_UNICORN_GUNDAM.png',4,10),
(11,'','BANDAI_GUNPLA_1-100_FULL_MECHANICS_BAEL_GUNDAM.png',9,11),
(12,'','BANDAI_GUN57025_GUNPLA_1-100_FULL_MECHANICS_BARBATOS_LUPUS_REX_SANS_SOCLE.png',3,12),
(13,'','BANDAI_BAN82243_GUNPLA_MG.png',5,13),
(14,'','BANDAI_GUN16188_GUNPLA_MG.png',9,14),
(15,'','BANDAI_GUN73088_MGEX_1-100.png',3,15),
(16,'','BANDAI_GUN55356_GUNPLA_HIRM_1-1OO.png',2,16),
(17,'','BANDAI_GUN66737_GUNPLA_HIRM_1-100.png',9,17),
(18,'','BANDAI_GUNPLA_MSM_ZAKU_II_GREEN_GUNDAM.png',3,18),
(19,'','BANDAI_GUNPLA_MEGASIZE_GUNDAM_UNICORN.png',9,19),
(20,'','BANDAI_GUN16106_GUNPLA_PG.png',3,20),
(21,'','BANDAI_GUN82392_GUNPLA_PG.png',5,21),
(22,'','PACK_DECAL_118.png',9,22),
(23,'','PACK_DECAL_111.png',3,23),
(24,'','BANDAI_GUN81428.png',5,24),
(25,'','BANDAI_ACTION_BASE_CUSTOMIZE_SCENE_BASE.png',9,25),
(26,'','Bandai_Tamashii_Double_Base_Transparente.png',3,26),
(27,' Red ','BANDAI_SPIRITS_ENTRY_NIPPER_RED.png',8,27),
(28,' Blue ','BANDAI_SPIRITS_ENTRY_NIPPER_BLUE.png',6,27),
(29,' White ','BANDAI_SPIRITS_ENTRY_NIPPER_WHITE.png',1,27),
(30,'','VALLEJO_GUN58801.png',9,28),
(31,'','BANDAI_GUNPLA_MARKER_REAL_TOUCH_2_SET_6_GUNDAM.png',3,29),
(32,'','BANDAI_GUNPLA_MARKER_SEED_SET_6_GUNDAM.png',2,30),
(33,'','CLEANING_STATION_WITH_AIRBRUSH_HOLDER.png',9,31),
(34,'','VALLEJO_DIAMOND_FILE_SET.png',21,32),
(35,'','VALLEJO_EXTRA_FINE_CURVED_TWEEZERS.png',0,33),
(36,'','VALLEJO_MASKING_TAPE_10mmX18m.png',9,34),
(37,'','VALLEJO_MASKING_TAPE_1mmX18m.png',0,35),
(38,'','VALLEJO_Flexi_Sanders_Dual-Grit.png',8,36),
(39,' Old  Gold ','VALLEJO_MECHA_69_060_Old_Gold.png',6,37),
(40,' Copper ','VALLEJO_MECHA_69_061_Copper.png',0,37),
(41,' Bronze ','VALLEJO_MECHA_69_062_Bronze.png',8,37),
(42,' Steel ','VALLEJO_MECHA_69_063_Steel.png',2,37),
(43,' Light  steel ','VALLEJO_MECHA_69_064_Light_Steel.png',25,37),
(44,' Dark  Steel ','VALLEJO_MECHA_69_064_Dark_Steel.png',8,37),
(45,' Mecha  Matt ','VALLEJO_MECHA_69_702_Mecha_Matt_Varnish.png',0,37),
(46,' Ivory ','VALLEJO_MECHA_APRIMER_70_643_Ivory.png',8,37),
(47,' Pure  White ','VALLEJO_MECHA_69_001_Pure_White.png',30,37),
(48,'','VALLEJO_50012_MODEL_AIR_71172_COLOR_SET_AND_AIRBRUSH.png',7,38),
(49,'','FENGDA_COMPRESSOR_AS-18-3.png',0,39),
(50,'','H_S_AIRBRUSH_EVOLUTION_TWO_IN_ONE.png',8,40);
/*!40000 ALTER TABLE `Variations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `concerne`
--

DROP TABLE IF EXISTS `concerne`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `concerne` (
  `idProduit` int(11) NOT NULL,
  `idCommande` int(11) NOT NULL,
  `quantite` int(11) DEFAULT NULL,
  PRIMARY KEY (`idProduit`,`idCommande`),
  KEY `idCommande` (`idCommande`),
  CONSTRAINT `concerne_ibfk_1` FOREIGN KEY (`idProduit`) REFERENCES `Produit` (`idProduit`),
  CONSTRAINT `concerne_ibfk_2` FOREIGN KEY (`idCommande`) REFERENCES `Commande` (`idCommande`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `concerne`
--

LOCK TABLES `concerne` WRITE;
/*!40000 ALTER TABLE `concerne` DISABLE KEYS */;
/*!40000 ALTER TABLE `concerne` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contient`
--

DROP TABLE IF EXISTS `contient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contient` (
  `idProduit` int(11) NOT NULL,
  `idPanier` int(11) NOT NULL,
  `quantite` int(11) DEFAULT NULL,
  PRIMARY KEY (`idProduit`,`idPanier`),
  KEY `fk_contient_PanierUser` (`idPanier`),
  CONSTRAINT `fk_contient_PanierUser` FOREIGN KEY (`idPanier`) REFERENCES `PanierUser` (`idPanier`),
  CONSTRAINT `fk_contient_Produit` FOREIGN KEY (`idProduit`) REFERENCES `Produit` (`idProduit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contient`
--

LOCK TABLES `contient` WRITE;
/*!40000 ALTER TABLE `contient` DISABLE KEYS */;
/*!40000 ALTER TABLE `contient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estComposéDe`
--

DROP TABLE IF EXISTS `estComposéDe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `estComposéDe` (
  `idProduit` int(11) NOT NULL,
  `idKit` int(11) NOT NULL,
  PRIMARY KEY (`idProduit`,`idKit`),
  KEY `fk_estComposéDe_Kits` (`idKit`),
  CONSTRAINT `fk_estComposéDe_Kits` FOREIGN KEY (`idKit`) REFERENCES `Kits` (`idKit`),
  CONSTRAINT `fk_estComposéDe_Produit` FOREIGN KEY (`idProduit`) REFERENCES `Produit` (`idProduit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estComposéDe`
--

LOCK TABLES `estComposéDe` WRITE;
/*!40000 ALTER TABLE `estComposéDe` DISABLE KEYS */;
/*!40000 ALTER TABLE `estComposéDe` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-02-07  8:27:13
