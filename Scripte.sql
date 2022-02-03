DROP TABLE IF EXISTS concerne;
DROP TABLE IF EXISTS varie_de;
DROP TABLE IF EXISTS contient;
DROP TABLE IF EXISTS estComposéDe;
DROP TABLE IF EXISTS Commande;
DROP TABLE IF EXISTS Adresse;
DROP TABLE IF EXISTS PanierUser;
DROP TABLE IF EXISTS Avis;
DROP TABLE IF EXISTS Utilisateur;
DROP TABLE IF EXISTS Produit;
DROP TABLE IF EXISTS Etat;
DROP TABLE IF EXISTS Fourniseur;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS Variations;
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

CREATE TABLE Variations(
   idVariation INT AUTO_INCREMENT,
   libelle TEXT,
   imageProduit VARCHAR(50),
   PRIMARY KEY(idVariation)
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

CREATE TABLE varie_de(
   idProduit INT,
   idVariation INT,
   Stock INT,
   PRIMARY KEY(idProduit, idVariation),
   CONSTRAINT fk_varie_de_Produit  FOREIGN KEY(idProduit) REFERENCES Produit(idProduit),
   CONSTRAINT fk_varie_de_Variations  FOREIGN KEY(idVariation) REFERENCES Variations(idVariation)
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
(NULL, "Admin"),
(NULL, "User");

LOAD DATA LOCAL INFILE '/home/bloodchild/Documents/GitHub/VillerotJustin/SAE3-4-5/DATASETS/Grades.csv' INTO TABLE Grade FIELDS TERMINATED BY ',';