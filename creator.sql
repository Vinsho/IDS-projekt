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
DROP TABLE Hlavni_sponzori CASCADE CONSTRAINTS;
DROP TABLE Vedlajsi_sponzori CASCADE CONSTRAINTS;

CREATE TABLE Osoba(
  RodneCislo Number NOT NULL PRIMARY KEY,
  Meno VARCHAR2(50) NOT NULL,
  Priezvisko VARCHAR2(50) NOT NULL,
  Narodnost VARCHAR(50) NOT NULL,
  DatumNarodenia Date NOT NULL
);

CREATE TABLE Hra(
  ID_Hry NUMBER NOT NULL PRIMARY KEY,-- max osem ciferne cislo
  Nazov VARCHAR2(50),
  Zaner VARCHAR2(50),
  DatumVydania Date NOT NULL,
  HernyMod VARCHAR2(50),
  Vydavatelstvo VARCHAR2(50),
  CONSTRAINT id_hry_has_8_digits CHECK (REGEXP_LIKE(ID_Hry,'^\d{8}$'))
);
CREATE TABLE Vybavenie(
  ID_Vybavenia NUMBER NOT NULL PRIMARY KEY,-- max osem ciferne cislo
  Mys VARCHAR2(50),
  Klavesnica VARCHAR2(50),
  GPU VARCHAR2(50),
  Sluchadla VARCHAR2(50),
  CONSTRAINT id_vybavenia_has_8_digits CHECK (REGEXP_LIKE(ID_Vybavenia,'^\d{8}$'))

);

CREATE TABLE Klan(
  ID_Klanu NUMBER NOT NULL PRIMARY KEY,-- max osem ciferne cislo
  Nazov VARCHAR2(50),
  Narodnost VARCHAR2(50),
  Hymna VARCHAR2(50),
  Logo VARCHAR2(50),
  Hra Number NOT NULL,
  Osoba NUMBER NOT NULL,
  CONSTRAINT klan_osoba_FK FOREIGN KEY (Osoba) REFERENCES Osoba,
  CONSTRAINT klan_hra_FK FOREIGN KEY (Hra) REFERENCES Hra,
  CONSTRAINT id_klanu_has_8_digits CHECK (REGEXP_LIKE(ID_Klanu,'^\d{8}$'))
);

CREATE TABLE Tim(
  Nazov_Timu VARCHAR2(50) NOT NULL PRIMARY KEY
);

CREATE TABLE Turnaj(
  "ID_Turnaju" NUMBER NOT NULL PRIMARY KEY,-- max osem ciferne cislo
  Hlavna_cena VARCHAR2(50),
  CONSTRAINT id_turnaju_has_8_digits CHECK (REGEXP_LIKE("ID_Turnaju",'^\d{8}$'))
);

CREATE TABLE Zapas(
  "ID_Zapasu" NUMBER NOT NULL PRIMARY KEY,-- max osem ciferne cislo
  Trvanie_hry NUMBER NOT NULL, -- in seconds
  Druh_zapasu VARCHAR2(50),
  Turnaj NUMBER NOT NULL,
  CONSTRAINT zapas_turnaj_FK FOREIGN KEY (Turnaj) REFERENCES Turnaj,
  CONSTRAINT id_zapasu_has_8_digits CHECK (REGEXP_LIKE("ID_Zapasu",'^\d{8}$'))

);

CREATE TABLE Hrac(
Prezyvka VARCHAR2(50) NOT NULL,
Hra Number NOT NULL ,
Vybavenie Number NOT NULL ,
Klan Number NOT NULL ,
Nazov_Timu VARCHAR2(50) NOT NULL ,
Osoba NUMBER NOT NULL,
CONSTRAINT hrac_osoba_FK FOREIGN KEY (Osoba) REFERENCES Osoba,
CONSTRAINT hrac_hra_FK FOREIGN KEY (Hra) REFERENCES Hra,
CONSTRAINT hrac_vybavenie_FK FOREIGN KEY (Vybavenie) REFERENCES Vybavenie,
CONSTRAINT hrac_klan_FK FOREIGN KEY (Klan) REFERENCES Klan,
CONSTRAINT hrac_tim_FK FOREIGN KEY (Nazov_Timu) REFERENCES Tim
);

---------------------------------------------

CREATE TABLE Tim_sa_zucastni_turnaja(
  Nazov_Timu VARCHAR2(50) NOT NULL,
  "ID_Turnaju" Number NOT NULL,
  CONSTRAINT tim_sa_zucastni_turnaju_FK FOREIGN KEY (Nazov_Timu) REFERENCES Tim,
  CONSTRAINT zucastni_turnaju_FK FOREIGN KEY ("ID_Turnaju") REFERENCES Turnaj
);

CREATE TABLE Tim_sa_zucastni_zapasu(
  Nazov_Timu VARCHAR2(50) NOT NULL,
  ID_Zapasu Number NOT NULL,
  CONSTRAINT tim_sa_zucastni_zapasu_FK FOREIGN KEY (Nazov_Timu) REFERENCES Tim,
  CONSTRAINT zucastni_zapasu_FK FOREIGN KEY (ID_Zapasu) REFERENCES Zapas
);

CREATE TABLE Tim_vyhral_zapas(
  Nazov_Timu VARCHAR2(50) NOT NULL ,
  ID_Zapasu Number NOT NULL,
  skore_vyhercu Number,
  skore_prehraneho Number,
  CONSTRAINT tim_vyhral_zapas_FK FOREIGN KEY (Nazov_Timu) REFERENCES Tim,
  CONSTRAINT vyhral_zapas_FK FOREIGN KEY (ID_Zapasu) REFERENCES Zapas

);

CREATE TABLE Tim_vyhral_turnaj(
  Nazov_Timu VARCHAR2(50) NOT NULL ,
  "ID_Turnaju" Number NOT NULL,
  CONSTRAINT tim_vyhral_turnaj_FK FOREIGN KEY (Nazov_Timu) REFERENCES Tim,
  CONSTRAINT vyhral_turnaj_FK FOREIGN KEY ("ID_Turnaju") REFERENCES Turnaj
);

CREATE TABLE Hlavni_sponzori(
  hlavny_sponzor VARCHAR2(50) NOT NULL,
  "ID_Turnaju" Number NOT NULL,
  CONSTRAINT hlavny_sponzor_turnaju_FK FOREIGN KEY ("ID_Turnaju") REFERENCES Turnaj
);

CREATE TABLE Vedlajsi_sponzori(
  vedlajsi_sponzor VARCHAR2(50) NOT NULL,
  "ID_Turnaju" Number NOT NULL,
  CONSTRAINT vedlajsi_sponzor_turnaju_FK FOREIGN KEY ("ID_Turnaju") REFERENCES Turnaj
);

-------------------------------------

INSERT INTO Osoba VALUES (9003015262,'Philip','Aram','American',TO_DATE('1990-03-01','yyyy-mm-dd'));
INSERT INTO Osoba VALUES (9804013750,'Jakub','Vins','Slovak',TO_DATE('1998-04-01','yyyy-mm-dd'));
INSERT INTO Hra VALUES (11111111,'DOTA2','MOBA',TO_DATE('2013-06-09','yyyy-mm-dd'),'','Valve');
INSERT INTO Vybavenie VALUES (11111111,'A4Tech Bloody V7M Ultra Core 2','Dell KB-216','MSI Radeon RX 580 ARMOR 8G','Yenkee YHP 3010 Hornet ');
INSERT INTO Klan VALUES (11111111,'Evil Geniuses','Medzinarodna','Everybody loves the sunshine','EG',11111111,9003015262);
INSERT INTO Tim VALUES  ('Selpice rulz');
INSERT INTO Tim VALUES  ('Fukusky');
INSERT INTO Turnaj VALUES (11111111,'Motorku');
INSERT INTO Zapas VALUES (11111111,1842,'Normal',11111111);
INSERT INTO Hrac VALUES ('Vinso',11111111,11111111,11111111,'Selpice rulz',9804013750);
INSERT INTO Tim_sa_zucastni_zapasu VALUES ('Selpice rulz',11111111);
INSERT INTO Tim_sa_zucastni_zapasu VALUES ('Fukusky',11111111);
INSERT INTO Tim_vyhral_zapas VALUES ('Selpice rulz',11111111,10,8);
INSERT INTO Hlavni_sponzori VALUES ('Steel Series',11111111);

