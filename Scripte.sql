DROP TABLE IF EXISTS concerne;
DROP TABLE IF EXISTS contient;
DROP TABLE IF EXISTS estComposéDe;
DROP TABLE IF EXISTS Commande;
DROP TABLE IF EXISTS Adresse;
DROP TABLE IF EXISTS PanierUser;
DROP TABLE IF EXISTS Avis;
DROP TABLE IF EXISTS Utilisateur;
DROP TABLE IF EXISTS Variations;
DROP TABLE IF EXISTS Produit;
DROP TABLE IF EXISTS Etat;
DROP TABLE IF EXISTS Fourniseur;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS Kits;
DROP TABLE IF EXISTS TypeProduit;
DROP TABLE IF EXISTS Taille;
DROP TABLE IF EXISTS Grade;

CREATE TABLE Grade(
   idGrade INT AUTO_INCREMENT,
   Libelle VARCHAR(50),
   abreviation VARCHAR(5),
   PRIMARY KEY(idGrade)
);

CREATE TABLE Taille(
   idTaille INT AUTO_INCREMENT,
   LibelleTaille VARCHAR(30),
   PRIMARY KEY(idTaille)
);

CREATE TABLE TypeProduit(
   idType INT AUTO_INCREMENT,
   LibelleType VARCHAR(70),
   PRIMARY KEY(idType)
);

CREATE TABLE Kits(
   idKit INT AUTO_INCREMENT,
   LibelleKit VARCHAR(70),
   PrixKit DECIMAL(6,2),
   PRIMARY KEY(idKit)
);


CREATE TABLE Role(
   idRole INT AUTO_INCREMENT,
   libelleRole VARCHAR(50),
   PRIMARY KEY(idRole)
);

CREATE TABLE Fourniseur(
   idFourniseur INT AUTO_INCREMENT,
   libelleFourniseur VARCHAR(50),
   PRIMARY KEY(idFourniseur)
);

CREATE TABLE Etat(
   idEtat INT AUTO_INCREMENT,
   libelleEtat VARCHAR(50),
   PRIMARY KEY(idEtat)
);

CREATE TABLE Produit(
   idProduit INT AUTO_INCREMENT,
   LibelleProduit VARCHAR(90),
   Prix DECIMAL(6,2),
   Description TEXT,
   idFourniseur INT NOT NULL,
   idType INT NOT NULL,
   idTaille INT,
   idGrade INT,
   PRIMARY KEY(idProduit),
   CONSTRAINT fk_Produit_Fourniseur FOREIGN KEY(idFourniseur) REFERENCES Fourniseur(idFourniseur),
   CONSTRAINT fk_Produit_TypeProduit  FOREIGN KEY(idType) REFERENCES TypeProduit(idType),
   CONSTRAINT fk_Produit_Taille  FOREIGN KEY(idTaille) REFERENCES Taille(idTaille),
   CONSTRAINT fk_Produit_Grade  FOREIGN KEY(idGrade) REFERENCES Grade(idGrade)
);

CREATE TABLE Variations(
   idVariation INT AUTO_INCREMENT,
   libelle TEXT,
   imageProduit VARCHAR(255),
   Stock INT,
   idProduit INT,
   CONSTRAINT fk_Variations_Produit  FOREIGN KEY(idProduit) REFERENCES Produit(idProduit),
   PRIMARY KEY(idVariation)
);

CREATE TABLE Utilisateur(
   idUser INT AUTO_INCREMENT,
   username VARCHAR(255),
   password VARCHAR(255),
   email VARCHAR(255),
   est_actif SMALLINT,
   idRole INT NOT NULL,
   PRIMARY KEY(idUser),
   CONSTRAINT fk_Utilisateur_Role FOREIGN KEY(idRole) REFERENCES Role(idRole)
);

CREATE TABLE Avis(
   idAvis INT AUTO_INCREMENT,
   Note INT,
   commentaire TEXT,
   idProduit INT NOT NULL,
   idUser INT NOT NULL,
   PRIMARY KEY(idAvis),
   CONSTRAINT fk_Avis_Produit FOREIGN KEY(idProduit) REFERENCES Produit(idProduit),
   CONSTRAINT fk_Avis_Utilisateur FOREIGN KEY(idUser) REFERENCES Utilisateur(idUser)
);

CREATE TABLE PanierUser(
   idPanier INT AUTO_INCREMENT,
   idUser INT NOT NULL,
   PRIMARY KEY(idPanier),
   UNIQUE(idUser),
   CONSTRAINT fk_PanierUser_Utilisateur  FOREIGN KEY(idUser) REFERENCES Utilisateur(idUser)
);

CREATE TABLE Adresse(
   idAdresse INT AUTO_INCREMENT,
   adresse VARCHAR(50),
   code_postale INT,
   ville VARCHAR(50),
   idUser INT NOT NULL,
   PRIMARY KEY(idAdresse),
   CONSTRAINT fk_Adresse_Utilisateur  FOREIGN KEY(idUser) REFERENCES Utilisateur(idUser)
);

CREATE TABLE Commande(
   idCommande INT AUTO_INCREMENT,
   dateCommande DATE,
   idAdresse INT NOT NULL,
   idEtat INT NOT NULL,
   idUser INT NOT NULL,
   PRIMARY KEY(idCommande),
   CONSTRAINT fk_Commande_Adresse FOREIGN KEY(idAdresse) REFERENCES Adresse(idAdresse),
   CONSTRAINT fk_Commande_Etat FOREIGN KEY(idEtat) REFERENCES Etat(idEtat),
   CONSTRAINT fk_Commande_Utilisateur FOREIGN KEY(idUser) REFERENCES Utilisateur(idUser)
);

CREATE TABLE estComposéDe(
   idProduit INT,
   idKit INT,
   PRIMARY KEY(idProduit, idKit),
   CONSTRAINT fk_estComposéDe_Produit  FOREIGN KEY(idProduit) REFERENCES Produit(idProduit),
   CONSTRAINT fk_estComposéDe_Kits  FOREIGN KEY(idKit) REFERENCES Kits(idKit)
);

CREATE TABLE contient(
   idProduit INT,
   idPanier INT,
   quantite INT,
   PRIMARY KEY(idProduit, idPanier),
   CONSTRAINT fk_contient_Produit FOREIGN KEY(idProduit) REFERENCES Produit(idProduit),
   CONSTRAINT fk_contient_PanierUser FOREIGN KEY(idPanier) REFERENCES PanierUser(idPanier)
);

CREATE TABLE concerne(
   idProduit INT,
   idCommande INT,
   quantite INT,
   PRIMARY KEY(idProduit, idCommande),
   FOREIGN KEY(idProduit) REFERENCES Produit(idProduit),
   FOREIGN KEY(idCommande) REFERENCES Commande(idCommande)
);


INSERT INTO Role VALUES
(NULL, "ROLE_admin"),
(NULL, "ROLE_client");


LOAD DATA LOCAL INFILE './DATASETS/Grades.csv' INTO TABLE Grade FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INFILE './DATASETS/Taille.csv' INTO TABLE Taille FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INFILE './DATASETS/TypeProduits.csv' INTO TABLE TypeProduit FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INFILE './DATASETS/Fourniseur.csv' INTO TABLE Fourniseur FIELDS TERMINATED BY ',';

INSERT INTO Etat VALUES
(NULL, "En traitement"),
(NULL, "En preparation"),
(NULL, "Envoyer");

INSERT INTO Produit VALUES
(NULL, "BANDAI GU25268 GUNPLA RE DIJEH", 49.90, "BANDAI GU25268 GUNPLA RE 1/100 DIJEH Figurine articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément. DIJEH provient de Mobile Suit Gundam - Marque : Bandai - Série : Mobile Suit Gundam - Date de sortie : Juin 2015 - Taille de paquet / poids : 31.2 x 20.5 x 13.5 cm / 613g - Manuel d'instruction : Inclus Ajoutez ce REBORN à votre collection et restez connectés pour connaître les prochaines sorties !", 1, 1, 1, 7),
(NULL, "BANDAI GUN15930 GUNPLA BB SINANJU", 15.90, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.", 1, 1, 1, 7),
(NULL, "BANDAI GUN28742 GUNPLA BB GUNDAM ASTRAY SENGOKU", 12.00, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.", 1, 1, 1, 7),
(NULL, "BANDAI GUN60583 GUNPLA SD CROSS SILHOUETTE NIGHTINGALE", 19.90, "SD Gundam Cross Silhouette » est un nouveau Gunpla de Gundam SD série à travers lequel vous pouvez créer idéal proportions par combinaison de deux types de trames et armures pour une coiffure encore plus libre. Deux formes – un corps haut ou court – peuvent être recréés grâce à la « Super déformé (SD) Frame » et « Cross Silhouette (CS) Frame ». Vous pouvez également créer vos propres proportions préférées en combinant les deux cadres. En outre, la tête est créée pour être hautement détaillé et facile à assembler par le biais de codage unique à la série SD par couleur. Les modèles peuvent également être construits avec ou sans yeux à l’aide de pièces interchangeables.", 1, 1, 1, 7),
(NULL, "BANDAI GUN62935 GUNPLA SD CROSS SILHOUETTE PHENEX DESTR NARRATIVE", 15.90, "SD Gundam Cross Silhouette » est un nouveau Gunpla de Gundam SD série à travers lequel vous pouvez créer idéal proportions par combinaison de deux types de trames et armures pour une coiffure encore plus libre. Deux formes – un corps haut ou court – peuvent être recréés grâce à la « Super déformé (SD) Frame » et « Cross Silhouette (CS) Frame ». Vous pouvez également créer vos propres proportions préférées en combinant les deux cadres. En outre, la tête est créée pour être hautement détaillé et facile à assembler par le biais de codage unique à la série SD par couleur. Les modèles peuvent également être construits avec ou sans yeux à l’aide de pièces interchangeables.", 1, 1, 1, 7),
(NULL, "BANDAI GUN086 GUNDAM GUNPLA NG 1ST GUNDAM RX-78", 4.95, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.", 1, 1, 2, 1),
(NULL, "BANDAI GUN70677 HGBDR GUNDAM GP-RASE-TWO-TEN", 34.95, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.", 1, 1, 2, 2),
(NULL, "BANDAI GUN82697 GUNDAM GUNPLA HG 216 UNICORN GUNDAM 03 PHENEX DESTROY MODE GOLD", 59.90, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.", 1, 1, 2, 2),
(NULL, "BANDAI GUNPLA RG 1/144 ZETA MSZ-006 GUNDAM", 39.90, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.", 1, 1, 2, 3),
(NULL, "BANDAI GUNPLA RG 1/144 UNICORN GUNDAM", 49.90, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.", 1, 1, 2, 3),
(NULL, "BANDAI GUNPLA FULL MECHANICS BAEL GUNDAM", 39.90, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.", 1, 1, 3, 4),
(NULL, "BANDAI GUN57025 GUNPLA 1/100 FULL MECHANICS BARBATOS LUPUS REX SANS SOCLE", 39.90, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.", 1, 1, 3, 4),
(NULL, "BANDAI BAN82243 GUNPLA MG 00 QANT TRANS-AM MODE SPECIAL COATING", 129.90, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.", 1, 1, 3, 5),
(NULL, "BANDAI GUN16188 GUNPLA MG GUNDAM RX-0 BANSHEE TITANIUM", 159.00, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.", 1, 1, 3, 5),
(NULL, "BANDAI GUN73088 MGEX 1/100 GUNDAM UNICORN VER KA", 269.90, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit. BANDAI GUN73088 MGEX 1/100 GUNDAM UNICORN VER KA Quantité Ultra Limitée/ Frais de port Offert France", 1, 1, 3, 6),
(NULL, "BANDAI GUN55356 GUNPLA HIRM GUNDAM ASTRAY RED FRAME HI RES", 159.00, "Cet article est un kit plastique de qualité supérieure issu de l'univers Gundam. Le spectaculaire Gundam Astray Red de Gundam Seed est disponible en version haute résolution de Bandai! Cette bête dispose d'une armature intérieure et d'un traitement de surface complet pour lui donner une densité de texture et de profondeur accrue, tandis que la lame de l'arme Gerbera Straight est traitée avec une finition plaquée! Ajoutez ce superbe kit à votre collection maintenant! La combinaison a été une nouvelle fois repensée pour paraître plus robuste, et elle comprend un cadre intérieur entièrement assemblé ainsi que tout l’arsenal des armes: la Gerbera Straight, la Beam Rifle, le Shield, les Beam Sabers et 5 paires de mains interchangeables!", 1, 1, 3, 8),
(NULL, "BANDAI GUN66737 GUNPLA HIRM GUNDAM ASTRAY NOIR", 179.90, "Cet article est un kit plastique de qualité supérieure issu de l'univers Gundam. Le spectaculaire Gundam Astray Noir de Mobile Suit Gundam SEED Destiny Astray B est disponible en version haute résolution de Bandai! Cette bête dispose d'une armature intérieure et d'un traitement de surface complet pour lui donner une densité de texture et de profondeur accrue. Ajoutez ce superbe kit à votre collection maintenant! La combinaison a été une nouvelle fois repensée pour paraître plus robuste, et elle comprend un cadre intérieur entièrement assemblé ainsi que tout l’arsenal des armes.", 1, 1, 3, 8),
(NULL, "BANDAI GUNPLA MSM 1/48 ZAKU II GREEN GUNDAM", 99.00, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit. BANDAI GUNPLA MSM 1/48 ZAKU II GREEN GUNDAM", 1, 1, 5, 9),
(NULL, "BANDAI GUNPLA 1/48 MEGASIZE GUNDAM UNICORN", 109.00, "Maquette articulée à assembler sans colle ni peinture (optionnel). Serie: Gundam UC (Unicorn) Date de sortie: Août 2017 Taille/poids du paquet: 58.0 x 39.0 x 14.3 cm / 2120g Ajoutez ce Mega Size Model à votre collection et restez connectés pour connaître les prochaines sorties!", 1, 1, 5, 9),
(NULL, "BANDAI GUN16106 GUNPLA PG STRIKE ROUGE + SKYGRASPER", 219.90, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). BANDAI GUN16106 GUNPLA PG STRIKE ROUGE + SKYGRASPER", 1, 1, 4, 10),
(NULL, "BANDAI GUN82392 GUNPLA PG 1/60 GUNDAM EXIA KIT LED", 149.90, "GUNPLA PG 1/60 GUNDAM EXIA KIT LED provient de Gundam 00 (Double O) Système de montage SNAPFIT = ne nécessite ni colle, ni peinture. Kit Led fournie Produit présenté en boite cartonnée.", 1, 1, 4, 10),
(NULL, "1 PACK DECAL N°118 MG GM SNIPER GM COMMAND", 5.90, "1 PACK DECAL N°118 MG 1/100 GM SNIPER /GM COMMAND", 2, 2, NULL, NULL),
(NULL, "PACK DECAL N°111 RG 1/144 ASTRAY RED FRAME", 5.90, "1 PACK DECAL N°111 RG 1/144 ASTRAY RED FRAME", 2, 2, NULL, NULL),
(NULL, "BANDAI GUN81428 GUNPLA HGBC 1/144 SPINNING BLASTER", 9.95, "Maquette Gundam articulée à assembler sans colle ni peinture (optionnel). Socle de présentation disponible séparément, sauf indication contraire dans la description du produit.", 1, 2, NULL, NULL),
(NULL, "BANDAI ACTION BASE CUSTOMIZE SCENE BASE", 8.90, "Socle de présentation à assembler sans colle ni peinture (optionnel). Compatible 1/144.", 1, 2, NULL, NULL),
(NULL, "Bandai Tamashii Double Base Transparente", 20.00, "Accessoire PVC adaptable aux figurines et maquettes. Set de 2 bases transparentes pour figurine Bandaï. Idéal pour présenter en vitrine ou faire des dioramas ! vendu en window box", 1, 2, NULL, NULL),
(NULL, "BANDAI SPIRITS ENTRY NIPPER", 9.95, "BANDAI SPIRITS ENTRY NIPPER", 1, 3, NULL, NULL),
(NULL, "VALLEJO GUN58801 GUNPLA PRECISION 9PCS", 32.00, "Set pour le modeling plastic, modeling militaire et autre hobby d'application", 2, 3, NULL, NULL),
(NULL, "BANDAI GUNPLA MARKER REAL TOUCH 2 SET 6 GUNDAM", 19.00, "BANDAI GUNPLA MARKER REAL TOUCH 2 SET 6 GUNDAM Ces véritables marqueurs tactiles sont conçus pour résister aux intempéries. Avec eux, vous pouvez donner l'effet de taches et de bavures facilement avec une touche réaliste. La peinture à base d'eau est utilisée pour la sécurité. Cet ensemble est composé entièrement de marqueurs qui sont disponibles séparément, de sorte que vous pouvez les obtenir dans l'ensemble ou individuellement. Les marqueurs GM406, GM407, GM408, GM409, GM410 et le flouteur GM400 sont tous inclus!", 1, 3, NULL, NULL),
(NULL, "BANDAI GUNPLA MARKER SEED SET 6 GUNDAM", 20.90, "BANDAI GUNDAM MARKER SEED 6 PCS Voici un ensemble de couleurs conçu pour les variantes Impulse Gundam de la série Gundam Seed ! Toutes les couleurs de cet ensemble sont uniques: GM40 SEED Red GM41 SEED Yellow GM42 SEED White GM43 SEED Blue GM44 SEED Gray GM45 SEED Dark Blue", 1, 3, NULL, NULL),
(NULL, "CLEANING STATION WITH AIRBRUSH HOLDER", 16.00, "Pot de nettoyage à aérographe, verre avec couvercle en plastique, utilisé pour pulvériser l'aérographe. L'aérographe est inséré via l'ouverture du couvercle et est nettoyé en pulvérisant le nettoyant Vallejo Airbrush ou de l'eau dans le récipient.", 2, 3, NULL, NULL),
(NULL, "VALLEJO DIAMOND FILE SET (5) 100mm", 15.95, "Limes avec des copeaux de diamant synthétique, plus solides et plus rapides que les limes métalliques Taille 140 mm. L'ensemble comprend 5 profils: plat, carré, rond, demi-rond et triangulaire. pour des travaux de finition précis sur tous les matériaux.", 2, 3, NULL, NULL),
(NULL, "VALLEJO EXTRA FINE CURVED TWEEZERS", 5.95, "Pinces incurvées extra fines idéales pour atteindre les zones difficiles d'accès, pour prendre, tenir et placer de très petites pièces et composants avec une grande précision.", 2, 3, NULL, NULL),
(NULL, "VALLEJO MASKING TAPE 10mmX18m - TWIN PACK", 5.95, "Ruban de masquage pour modélisme et tous les projets miniatures. Pas de bavure de peinture ou de lignes de peinture hésitantes. Protection U.V. pour masquage en plein soleil. Emballage: 2 unités", 2, 3, NULL, NULL),
(NULL, "VALLEJO MASKING TAPE 1mmX18m - TWIN PACK", 2.50, "Ruban de masquage pour modélisme et tous les projets miniatures. Pas de bavure de peinture ou de lignes de peinture hésitantes. Protection U.V. pour masquage en plein soleil. Emballage: 2 unités", 2, 3, NULL, NULL),
(NULL, "VALLEJO Set of 3 Flexi Sanders Dual-Grit (80x30x6 mm)", 4.95, "Coarse (60/100): Effective material removal. Medium (240/400): Blending and smoothing. Fine (600/1000): Finishing and polishing.", 2, 3, NULL, NULL),
(NULL, "VALLEJO MECHA BOUTEILLE DE PEINTURE", 2.95, "Présenté en bouteilles de 17 ml./0,57 fl.oz avec pipette. Cet emballage empêche la peinture de s’évaporer et de sécher dans le récipient, de sorte qu’il peut être utilisé en quantité minimale et conservé pendant une longue période.", 2, 3, NULL, NULL),
(NULL, "VALLEJO 50012 MODEL AIR 71172 COLOR SET AND AIRBRUSH", 259.00, "VALLEJO 50012 MODEL AIR 71172 COLOR SET AND AIRBRUSH. Set Disponible sur Commande.", 2, 3, NULL, NULL),
(NULL, "FENGDA COMPRESSOR AS-18-3", 169.00, "FENGDA COMPRESSOR AS-18-3Oil-free piston compressor Ultra quiet Motor: 220-240V 50Hz /110-120V 60HZ Rotational speed: 1450 rpm/ 1700 rpm Auto-Stop at 4Bar; Auto Re-Start at 3bar Maximum pressure: 57 psi (4 BAR) 1/8 BSP Male outlet Air Delivery: 23 litres/min PCS/CTN: 6 Disponibilité sous 4 semaines.", 2, 3, NULL, NULL),
(NULL, "H & S AIRBRUSH EVOLUTION TWO IN ONE", 159.90, "De Harder & Steenbeck une nouvelle ligne d’Aérographe signée Vallejo, le leader mondial des peintures pour la modélisation et le wargame L'évolution 2 en 1 est une réussite parmi les pulvérisateurs de peinture: une structure solide, un excellent traitement et une double action douce ont fait de cet instrument l'un des aérographes les plus utilisés depuis son lancement. L'Evolution est un système d'alimentation par gravité disponible sous la forme d'un modèle 2 en 1, doté de deux jeux de buses de différentes tailles et permettant une conversion rapide et flexible de l'instrument pour tous les domaines d'application. Le 2 en 1 comprend un jeu de buses de 0,2 et 0,4 mm et deux tasses de 2 et 5 ml. Disponibilité sous 4 semaines.", 2, 3, NULL, NULL);


LOAD DATA LOCAL INFILE './DATASETS/Variations.csv' INTO TABLE Variations FIELDS TERMINATED BY ',';