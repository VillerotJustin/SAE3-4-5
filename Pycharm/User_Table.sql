CREATE TABLE Grade(
   idGrade INT AUTO INCREMENT,
   Libelle VARCHAR(50),
   abreviation VARCHAR(5),
   PRIMARY KEY(idGrade)
);

CREATE TABLE Taille(
   idTaille INT AUTO INCREMENT,
   LibelleTaille VARCHAR(30),
   PRIMARY KEY(idTaille)
);

CREATE TABLE TypeProduit(
   idType INT AUTO INCREMENT,
   LibelleType VARCHAR(70),
   PRIMARY KEY(idType)
);

CREATE TABLE Kits(
   idKit INT AUTO INCREMENT,
   LibelleKit VARCHAR(70),
   PrixKit DECIMAL(6,2),
   PRIMARY KEY(idKit)
);

CREATE TABLE Avis(
   idAvis INT AUTO INCREMENT,
   Note BYTE,
   commentaire TEXT,
   PRIMARY KEY(idAvis)
);

CREATE TABLE Variations(
   idVariation INT AUTO INCREMENT,
   libelle TEXT,
   PRIMARY KEY(idVariation)
);

CREATE TABLE Role(
   idRole INT AUTO INCREMENT,
   libelleRole VARCHAR(50),
   PRIMARY KEY(idRole)
);

CREATE TABLE Fourniseur(
   idFourniseur INT AUTO INCREMENT,
   libelleFourniseur VARCHAR(50),
   PRIMARY KEY(idFourniseur)
);

CREATE TABLE Etat(
   idEtat INT AUTO INCREMENT,
   libelleEtat VARCHAR(50),
   PRIMARY KEY(idEtat)
);

CREATE TABLE Produit(
   idProduit INT AUTO INCREMENT,
   LibelleProduit VARCHAR(90),
   Prix DECIMAL(6,2),
   ImageProduit VARCHAR(35),
   Stock SMALLINT,
   Description TEXT,
   idFourniseur INT NOT NULL,
   idType INT NOT NULL,
   idTaille INT,
   idGrade INT,
   PRIMARY KEY(idProduit),
   FOREIGN KEY(idFourniseur) REFERENCES Fourniseur(idFourniseur),
   FOREIGN KEY(idType) REFERENCES TypeProduit(idType),
   FOREIGN KEY(idTaille) REFERENCES Taille(idTaille),
   FOREIGN KEY(idGrade) REFERENCES Grade(idGrade)
);

CREATE TABLE Utilisateur(
   idUser INT AUTO INCREMENT,
   username VARCHAR(255),
   pseudo VARCHAR(255),
   password VARCHAR(255),
   email VARCHAR(255),
   role VARCHAR(255),
   est_actif SMALLINT,
   idRole INT NOT NULL,
   PRIMARY KEY(idUser),
   FOREIGN KEY(idRole) REFERENCES Role(idRole)
);

CREATE TABLE PanierUser(
   idPanier INT AUTO INCREMENT,
   idUser INT NOT NULL,
   PRIMARY KEY(idPanier),
   UNIQUE(idUser),
   FOREIGN KEY(idUser) REFERENCES Utilisateur(idUser)
);

CREATE TABLE Adresse(
   idAdresse INT AUTO INCREMENT,
   adresse VARCHAR(50),
   code_postale INT,
   ville VARCHAR(50),
   idUser INT NOT NULL,
   PRIMARY KEY(idAdresse),
   FOREIGN KEY(idUser) REFERENCES Utilisateur(idUser)
);

CREATE TABLE Commande(
   idCommande INT AUTO INCREMENT,
   dateCommande DATE,
   idAdresse INT NOT NULL,
   idEtat INT NOT NULL,
   idUser INT NOT NULL,
   PRIMARY KEY(idCommande),
   FOREIGN KEY(idAdresse) REFERENCES Adresse(idAdresse),
   FOREIGN KEY(idEtat) REFERENCES Etat(idEtat),
   FOREIGN KEY(idUser) REFERENCES Utilisateur(idUser)
);

CREATE TABLE estComposéDe(
   idProduit INT,
   idKit INT,
   PRIMARY KEY(idProduit, idKit),
   FOREIGN KEY(idProduit) REFERENCES Produit(idProduit),
   FOREIGN KEY(idKit) REFERENCES Kits(idKit)
);

CREATE TABLE contient(
   idProduit INT,
   idPanier INT,
   quantite BYTE,
   PRIMARY KEY(idProduit, idPanier),
   FOREIGN KEY(idProduit) REFERENCES Produit(idProduit),
   FOREIGN KEY(idPanier) REFERENCES PanierUser(idPanier)
);

CREATE TABLE donner(
   idUser INT,
   idAvis INT,
   PRIMARY KEY(idUser, idAvis),
   FOREIGN KEY(idUser) REFERENCES Utilisateur(idUser),
   FOREIGN KEY(idAvis) REFERENCES Avis(idAvis)
);

CREATE TABLE estNoté(
   idProduit INT,
   idAvis INT,
   PRIMARY KEY(idProduit, idAvis),
   FOREIGN KEY(idProduit) REFERENCES Produit(idProduit),
   FOREIGN KEY(idAvis) REFERENCES Avis(idAvis)
);

CREATE TABLE varie_de(
   idProduit INT,
   idVariation INT,
   PRIMARY KEY(idProduit, idVariation),
   FOREIGN KEY(idProduit) REFERENCES Produit(idProduit),
   FOREIGN KEY(idVariation) REFERENCES Variations(idVariation)
);
