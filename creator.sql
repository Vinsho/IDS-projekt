DROP TABLE Osoba CASCADE CONSTRAINTS;
DROP TABLE Hrac CASCADE CONSTRAINTS;
DROP TABLE Vybavenie CASCADE CONSTRAINTS;
DROP TABLE Hra CASCADE CONSTRAINTS;
DROP TABLE Turnaj CASCADE CONSTRAINTS;
DROP TABLE Zapas CASCADE CONSTRAINTS;
DROP TABLE Klan CASCADE CONSTRAINTS;
DROP TABLE Tim CASCADE CONSTRAINTS;
DROP TABLE Tim_vyhral_turnaj CASCADE CONSTRAINTS;
DROP TABLE Tim_vyhral_zapas CASCADE CONSTRAINTS;
DROP TABLE Tim_sa_zucastni_turnaja CASCADE CONSTRAINTS;
DROP TABLE Tim_sa_zucastni_zapasu CASCADE CONSTRAINTS;

CREATE TABLE Hra(
  ID_Hry NUMBER NOT NULL PRIMARY KEY,
  Nazov VARCHAR2(50),
  Zaner VARCHAR2(50),
  DatumVydania Date NOT NULL,
  HernyMod VARCHAR2(50),
  Vydavatelstvo VARCHAR2(50)

);
CREATE TABLE Vybavenie(
  ID_Vybavenia NUMBER NOT NULL PRIMARY KEY,
  Mys VARCHAR2(50),
  Klavesnica VARCHAR2(50),
  GPU VARCHAR2(50),
  Sluchadla VARCHAR2(50)
);

CREATE TABLE Klan(
  ID_Klanu NUMBER NOT NULL PRIMARY KEY,
  Nazov VARCHAR2(50),
  Narodnost VARCHAR2(50),
  Hymna VARCHAR2(50),
  Logo VARCHAR2(50),
  VodcaKlanu VARCHAR2(50),
  Hra Number NOT NULL,
  CONSTRAINT klan_hra_FK FOREIGN KEY (Hra) REFERENCES Hra
);

CREATE TABLE Tim(
  ID_Timu NUMBER NOT NULL PRIMARY KEY,
  NAZOV VARCHAR2(50) NOT NULL
);

CREATE TABLE Turnaj(
  "ID_Turnaju" NUMBER NOT NULL PRIMARY KEY,
  Hlavna_cena VARCHAR2(50)
--   TODO sponzori
);

CREATE TABLE Zapas(
  "ID_Zapasu" NUMBER NOT NULL PRIMARY KEY,
  Trvanie_hry NUMBER NOT NULL, -- in seconds
  Druh_zapasu VARCHAR2(50),
  Turnaj NUMBER NOT NULL,
  CONSTRAINT zapas_turnaj_FK FOREIGN KEY (Turnaj) REFERENCES Turnaj

);

CREATE TABLE Osoba(
RodneCislo Number NOT NULL PRIMARY KEY,
Meno VARCHAR2(50) NOT NULL,
Priezvisko VARCHAR2(50) NOT NULL,
Narodnost VARCHAR(50) NOT NULL,
DatumNarodenia Date NOT NULL
);



CREATE TABLE Hrac(
RodneCislo Number NOT NULL PRIMARY KEY,
Prezyvka VARCHAR2(50) NOT NULL,
Hra Number NOT NULL ,
Vybavenie Number NOT NULL ,
Klan Number NOT NULL ,
Tim Number NOT NULL ,
CONSTRAINT hrac_hra_FK FOREIGN KEY (Hra) REFERENCES Hra,
CONSTRAINT hrac_vybavenie_FK FOREIGN KEY (Vybavenie) REFERENCES Vybavenie,
CONSTRAINT hrac_klan_FK FOREIGN KEY (Klan) REFERENCES Klan,
CONSTRAINT hrac_tim_FK FOREIGN KEY (Tim) REFERENCES Tim
);

---------------------------------------------

CREATE TABLE Tim_sa_zucastni_turnaja(
  ID_timu Number NOT NULL,
  "ID_Turnaju" Number NOT NULL
);

CREATE TABLE Tim_sa_zucastni_zapasu(
  ID_timu Number NOT NULL,
  ID_Zapasu Number NOT NULL
);

CREATE TABLE Tim_vyhral_zapas(
  ID_Timu Number NOT NULL ,
  ID_Zapasu Number NOT NULL,
  skore_vyhercu Number,
  skore_prehraneho Number
);

CREATE TABLE Tim_vyhral_turnaj(
  ID_Timu Number NOT NULL ,
  "ID_Turnaju" Number NOT NULL
);


-------------------------------------


INSERT INTO Osoba VALUES (9804013750,'Jakub','Vins','Slovak',TO_DATE('1998-04-01','yyyy-mm-dd'));
INSERT INTO Hra VALUES (11111111,'DOTA2','MOBA',TO_DATE('2013-06-09','yyyy-mm-dd'),'','Valve');
INSERT INTO Vybavenie VALUES (11111111,'A4Tech Bloody V7M Ultra Core 2','Dell KB-216','MSI Radeon RX 580 ARMOR 8G','Yenkee YHP 3010 Hornet ');
INSERT INTO Klan VALUES (11111111,'Evil Geniuses','Medzinarodna','Everybody loves the sunshine','EG','Phillip Aram',11111111);
INSERT INTO Tim VALUES  (11111111,'Selpice_rulz');
INSERT INTO Tim VALUES  (22222222,'Fukusky');
INSERT INTO Turnaj VALUES (11111111,'Motorku');
INSERT INTO Zapas VALUES (11111111,1842,'Normal',11111111);
INSERT INTO Hrac VALUES (9804013750,'Vinso',11111111,11111111,11111111,11111111);
INSERT INTO Tim_sa_zucastni_zapasu VALUES (11111111,11111111);
INSERT INTO Tim_sa_zucastni_zapasu VALUES (22222222,11111111);
INSERT INTO Tim_vyhral_zapas VALUES (11111111,11111111,10,8);

