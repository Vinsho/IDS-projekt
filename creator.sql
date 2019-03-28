
-- TODO:
  
-- Fix zero cardinality everywhere, so not everywhere should be NOT NULL in attribute
-- Maybe sponsor name as primary key
-- Can player plays on its own? Like not belongs to any clan? -> Maybe adjust cardinality
-- Maybe add atribute information about tournament
-- Isnt date of birth redunant or just useless?
-- Why there is nationality in player?
-- Logo attribute is like ascii art? Or url to real image?

-- ? Isnt attribute skore_prehraneho useless?
-- ? Maybe delete tim_vyhral_zapas table and just add score to zapas table



DROP TABLE osoba CASCADE CONSTRAINTS;
DROP TABLE hra CASCADE CONSTRAINTS;
DROP TABLE klan CASCADE CONSTRAINTS;
DROP TABLE hrac CASCADE CONSTRAINTS;
DROP TABLE vybavenie CASCADE CONSTRAINTS;
DROP TABLE tim CASCADE CONSTRAINTS;
DROP TABLE turnaj CASCADE CONSTRAINTS;
DROP TABLE zapas CASCADE CONSTRAINTS;
DROP TABLE sponzor CASCADE CONSTRAINTS;

DROP TABLE hrac_hraje_za_tim CASCADE CONSTRAINTS;
DROP TABLE hrac_sa_zameriava_na_hru CASCADE CONSTRAINTS;
DROP TABLE klan_sa_zameriava_na_hru CASCADE CONSTRAINTS;
DROP TABLE hra_sa_hraje_na_turnaji CASCADE CONSTRAINTS;
DROP TABLE tim_sa_zucastni_turnaja CASCADE CONSTRAINTS;
DROP TABLE tim_sa_zucastni_zapasu CASCADE CONSTRAINTS;
DROP TABLE tim_vyhral_zapas CASCADE CONSTRAINTS;
DROP TABLE turnaj_sponzoruje_sponzor CASCADE CONSTRAINTS;


-------------------------------------
-- Tables
-------------------------------------

CREATE TABLE osoba(
  rodne_cislo Number NOT NULL PRIMARY KEY,
  meno VARCHAR2(50) NOT NULL,
  priezvisko VARCHAR2(50) NOT NULL,
  narodnost VARCHAR(50) NOT NULL,
  datum_narodenia Date NOT NULL
);

CREATE TABLE hra(
  id_hry NUMBER NOT NULL PRIMARY KEY,-- max osem ciferne cislo
  nazov VARCHAR2(50),
  zaner VARCHAR2(50),
  datum_vydania Date NOT NULL,
  herny_mod VARCHAR2(50),
  vydavatelstvo VARCHAR2(50),
  CONSTRAINT id_hry_has_8_digits CHECK (REGEXP_LIKE(id_hry,'^\d{1,8}$'))
);

CREATE TABLE klan(
  id_klanu NUMBER NOT NULL PRIMARY KEY,-- max osem ciferne cislo
  nazov VARCHAR2(50),
  narodnost VARCHAR2(50),
  hymna VARCHAR2(50),
  logo VARCHAR2(50),
  veduci NUMBER NOT NULL,
  CONSTRAINT klan_veduci_FK FOREIGN KEY (veduci) REFERENCES osoba(rodne_cislo),
  CONSTRAINT id_klanu_has_8_digits CHECK (REGEXP_LIKE(id_klanu,'^\d{1,8}$'))
);

CREATE TABLE hrac(
  rodne_cislo NUMBER NOT NULL PRIMARY KEY,
  prezyvka VARCHAR2(50) NOT NULL,
  klan Number NOT NULL,
  CONSTRAINT hrac_rodne_cislo_FK FOREIGN KEY (rodne_cislo) REFERENCES osoba(rodne_cislo),
  CONSTRAINT hrac_klan_FK FOREIGN KEY (klan) REFERENCES klan(id_klanu)
);

CREATE TABLE vybavenie(
  id_vybavenia NUMBER NOT NULL PRIMARY KEY,-- max osem ciferne cislo
  mys VARCHAR2(50),
  klavesnica VARCHAR2(50),
  gpu VARCHAR2(50),
  sluchadla VARCHAR2(50),
  vlastnik NUMBER NOT NULL,
  CONSTRAINT vybavenie_vlastnik_FK FOREIGN KEY (vlastnik) REFERENCES hrac(rodne_cislo),
  CONSTRAINT id_vybavenia_has_8_digits CHECK (REGEXP_LIKE(id_vybavenia,'^\d{1,8}$'))
);

CREATE TABLE tim(
  nazov_timu VARCHAR2(50) NOT NULL PRIMARY KEY
);

CREATE TABLE turnaj(
  id_turnaju NUMBER NOT NULL PRIMARY KEY,-- max osem ciferne cislo
  hlavna_cena VARCHAR2(50),
  vyherny_tim VARCHAR2(50),
  CONSTRAINT turnaj_vyherny_tim_FK FOREIGN KEY (vyherny_tim) REFERENCES tim(nazov_timu),
  CONSTRAINT id_turnaju_has_8_digits CHECK (REGEXP_LIKE(id_turnaju,'^\d{1,8}$'))
);

CREATE TABLE zapas(
  id_zapasu NUMBER NOT NULL PRIMARY KEY,-- max osem ciferne cislo
  trvanie_hry NUMBER NOT NULL, -- in seconds
  druh_zapasu VARCHAR2(50),
  v_ramci_turnaju NUMBER,
  CONSTRAINT zapas_turnaj_FK FOREIGN KEY (v_ramci_turnaju) REFERENCES turnaj(id_turnaju),
  CONSTRAINT id_zapasu_has_8_digits CHECK (REGEXP_LIKE(id_zapasu,'^\d{1,8}$'))
);

CREATE TABLE sponzor(
  id_sponzora NUMBER NOT NULL PRIMARY KEY,
  meno VARCHAR2(50) NOT NULL,
  typ VARCHAR2(7) NOT NULL
);

-------------------------------------
-- Many to many relation tables
-------------------------------------

CREATE TABLE hrac_hraje_za_tim(
  hrac NUMBER NOT NULL,
  nazov_timu VARCHAR2(50),
  CONSTRAINT hrac_hraje_za_tim_PK PRIMARY KEY (hrac, nazov_timu),
  CONSTRAINT hrac_hraje_za_tim_rodne_cislo_FK FOREIGN KEY (hrac) REFERENCES hrac(rodne_cislo),
  CONSTRAINT hrac_hraje_za_tim_nazov_timu_FK FOREIGN KEY (nazov_timu) REFERENCES tim(nazov_timu)
);

CREATE TABLE hrac_sa_zameriava_na_hru(
  hrac NUMBER NOT NULL,
  id_hry NUMBER NOT NULL,
  CONSTRAINT hrac_sa_zameriava_na_hru_PK PRIMARY KEY (hrac, id_hry),
  CONSTRAINT hrac_sa_zameriava_na_hru_rodne_cislo_FK FOREIGN KEY (hrac) REFERENCES hrac(rodne_cislo),
  CONSTRAINT hrac_sa_zameriava_na_hru_id_hry_FK FOREIGN KEY (id_hry) REFERENCES hra(id_hry)
);

CREATE TABLE klan_sa_zameriava_na_hru(
  id_klanu NUMBER NOT NULL,
  id_hry NUMBER NOT NULL,
  CONSTRAINT klan_sa_zameriava_na_hru_PK PRIMARY KEY (id_klanu, id_hry),
  CONSTRAINT klan_sa_zameriava_na_hru_rodne_cislo_FK FOREIGN KEY (id_klanu) REFERENCES klan(id_klanu),
  CONSTRAINT klan_sa_zameriava_na_hru_id_hry_FK FOREIGN KEY (id_hry) REFERENCES hra(id_hry)
);

CREATE TABLE hra_sa_hraje_na_turnaji(
  id_hry Number NOT NULL,
  id_turnaju Number NOT NULL,
  CONSTRAINT hra_sa_hraje_na_turnaji_PK PRIMARY KEY (id_hry, id_turnaju),
  CONSTRAINT hra_sa_hraje_na_turnaji_nazov_timu_FK FOREIGN KEY (id_hry) REFERENCES hra(id_hry),
  CONSTRAINT hra_sa_hraje_na_turnaji_id_turnaju_FK FOREIGN KEY (id_turnaju) REFERENCES turnaj(id_turnaju)
);

CREATE TABLE tim_sa_zucastni_turnaja(
  nazov_timu VARCHAR2(50) NOT NULL,
  id_turnaju Number NOT NULL,
  CONSTRAINT tim_sa_zucastni_turnaja_PK PRIMARY KEY (nazov_timu, id_turnaju),
  CONSTRAINT tim_sa_zucastni_turnaja_nazov_timu_FK FOREIGN KEY (nazov_timu) REFERENCES tim(nazov_timu),
  CONSTRAINT tim_sa_zucastni_turnaja_id_turnaju_FK FOREIGN KEY (id_turnaju) REFERENCES turnaj(id_turnaju)
);

CREATE TABLE tim_sa_zucastni_zapasu(
  nazov_timu VARCHAR2(50) NOT NULL,
  id_zapasu Number NOT NULL,
  CONSTRAINT tim_sa_zucastni_zapasu_PK PRIMARY KEY (nazov_timu, id_zapasu),
  CONSTRAINT tim_sa_zucastni_zapasu_nazov_timu_FK FOREIGN KEY (nazov_timu) REFERENCES tim(nazov_timu),
  CONSTRAINT tim_sa_zucastni_zapasu_id_zapasu_FK FOREIGN KEY (id_zapasu) REFERENCES zapas(id_zapasu)
);

CREATE TABLE tim_vyhral_zapas(
  nazov_timu VARCHAR2(50) NOT NULL,
  id_zapasu Number NOT NULL,
  skore_vyhercu Number,
  skore_prehraneho Number,
  CONSTRAINT tim_vyhral_zapas_PK PRIMARY KEY (nazov_timu, id_zapasu),
  CONSTRAINT tim_vyhral_zapas_nazov_timu_FK FOREIGN KEY (nazov_timu) REFERENCES tim(nazov_timu),
  CONSTRAINT tim_vyhral_zapas_id_zapasu_FK FOREIGN KEY (id_zapasu) REFERENCES zapas(id_zapasu)
);

CREATE TABLE turnaj_sponzoruje_sponzor(
  id_turnaju NUMBER NOT NULL,
  id_sponzora NUMBER NOT NULL,
  CONSTRAINT turnaj_sponzoruje_sponzor_PK PRIMARY KEY (id_turnaju, id_sponzora),
  CONSTRAINT turnaj_sponzoruje_sponzor_id_turnaju_FK FOREIGN KEY (id_turnaju) REFERENCES turnaj(id_turnaju),
  CONSTRAINT turnaj_sponzoruje_sponzor_id_sponzora_FK FOREIGN KEY (id_sponzora) REFERENCES sponzor(id_sponzora)
);

-------------------------------------
-- Insert sample data
-------------------------------------

INSERT INTO osoba VALUES (0156146848, 'Chai', 'Cameron', 'Slovak', TO_DATE('1990-03-01','yyyy-mm-dd'));
INSERT INTO osoba VALUES (9960285478, 'Canno', 'Boyer', 'Filipino', TO_DATE('1990-03-01','yyyy-mm-dd'));
INSERT INTO osoba VALUES (9959080054, 'Kayle', 'Wiley', 'German', TO_DATE('1990-03-01','yyyy-mm-dd'));
INSERT INTO osoba VALUES (9156288251, 'Rya', 'Nash', 'Australian', TO_DATE('1990-03-01','yyyy-mm-dd'));
INSERT INTO osoba VALUES (9152139172, 'Mia', 'Yang', 'Japanese', TO_DATE('1990-03-01','yyyy-mm-dd'));
INSERT INTO osoba VALUES (9559101959, 'Jordon', 'Hughes', 'Czech', TO_DATE('1990-03-01','yyyy-mm-dd'));
INSERT INTO osoba VALUES (0006160319, 'Roland', 'Archer', 'Australian', TO_DATE('1990-03-01','yyyy-mm-dd'));

INSERT INTO hra VALUES (000, 'Tekken', 'Figting', TO_DATE('1990-03-01','yyyy-mm-dd'), '1v1', 'Capcom');
INSERT INTO hra VALUES (001, 'Quake', 'First-person shooters', TO_DATE('1997-05-11','yyyy-mm-dd'), '5v5', 'Capcom');
INSERT INTO hra VALUES (002, 'Doom', 'First-person shooters', TO_DATE('2015-12-24','yyyy-mm-dd'), '2v2', 'Capcom');
INSERT INTO hra VALUES (003, 'Call of duty', 'First-person shooters', TO_DATE('1994-03-31','yyyy-mm-dd'), '1v1', 'Capcom');

INSERT INTO klan VALUES (100, 'Gray Rebels', 'Hunagrian', 'anthem1', 'logo1', 0156146848);
INSERT INTO klan VALUES (101, 'Comfortable Liquidators', 'Swedish', 'anthem2', 'logo2', 9960285478);
INSERT INTO klan VALUES (102, 'Imported Knights', 'Chinese', 'anthem3','logo3', 9959080054);
INSERT INTO klan VALUES (103, 'Creepy Exile', 'Anthemn', 'anthem4', 'logo4', 0006160319);

INSERT INTO hrac VALUES (0156146848, 'Cam', 100);
INSERT INTO hrac VALUES (9960285478, 'Boy', 100);
INSERT INTO hrac VALUES (9959080054, 'Wil', 100);
INSERT INTO hrac VALUES (9156288251, 'Nas', 101);
INSERT INTO hrac VALUES (9152139172, 'Yan', 101);
INSERT INTO hrac VALUES (9559101959, 'Hug', 102);

INSERT INTO vybavenie VALUES (200, 'A4Tech Bloody V7M', 'Dell KB-216','MSI Radeon RX 580','Yenkee YHP 3010 Hornet',0156146848);
INSERT INTO vybavenie VALUES (201, 'Logitech M185 ', 'Logitech K400','MSI Radeon RX 570','Sony 5A',0156146848);
INSERT INTO vybavenie VALUES (202, 'Lenovo N46', 'Razer Ornata Chroma','MSI Radeon RX 560','JBL 7',0156146848);
INSERT INTO vybavenie VALUES (203, 'Lenovo N55', 'Dell KB-216','MSI Radeon RX 550 ARMOR 8G','Senheiser MAX',9960285478);
INSERT INTO vybavenie VALUES (204, 'Lenovo N45', 'Dell KB522','NVIDIA GeForce 550m ','JBL T110',9959080054);
INSERT INTO vybavenie VALUES (205, 'Lenovo N12', 'A4tech Bloody B120','NVIDIA GeForce 1080','Sony 879 ',9156288251);
INSERT INTO vybavenie VALUES (206, 'Genius NX-7005', 'Genius KM-210','NVIDIA GeForce 970','Ear pods',9152139172);
INSERT INTO vybavenie VALUES (207, 'Genius NX-7005', 'Dell KB-216','NVIDIA GeForce 1050','Ear pods',9559101959);

INSERT INTO tim VALUES ('Shallow Desperado');
INSERT INTO tim VALUES ('Separate Assassins');
INSERT INTO tim VALUES ('Four Gangsters');
INSERT INTO tim VALUES ('Hateful Voltiac');

INSERT INTO turnaj VALUES (301, '5000€', 'Shallow Desperado');
INSERT INTO turnaj VALUES (302, '100€', 'Hateful Voltiac');
INSERT INTO turnaj VALUES (303, '2000€', 'Shallow Desperado');

INSERT INTO zapas VALUES (401, 45265, 'scrim', NULL);
INSERT INTO zapas VALUES (402, 45645, 'tournament', 301);
INSERT INTO zapas VALUES (403, 78789, 'tournament', 301);
INSERT INTO zapas VALUES (404, 123456, 'tournament', 302);
INSERT INTO zapas VALUES (405, 685122, 'tournament', 303);

INSERT INTO sponzor VALUES (500, 'Coca cola', 'main');
INSERT INTO sponzor VALUES (501, 'JBL', 'main');
INSERT INTO sponzor VALUES (502, 'Nvidia', 'main');
INSERT INTO sponzor VALUES (503, 'Dell', 'minor');


INSERT INTO hrac_hraje_za_tim VALUES (0156146848, 'Shallow Desperado');
INSERT INTO hrac_hraje_za_tim VALUES (9960285478, 'Shallow Desperado');
INSERT INTO hrac_hraje_za_tim VALUES (9959080054, 'Shallow Desperado');
INSERT INTO hrac_hraje_za_tim VALUES (9156288251, 'Separate Assassins');
INSERT INTO hrac_hraje_za_tim VALUES (9152139172, 'Four Gangsters');
INSERT INTO hrac_hraje_za_tim VALUES (9559101959, 'Hateful Voltiac');

INSERT INTO hrac_sa_zameriava_na_hru VALUES (0156146848, 000);
INSERT INTO hrac_sa_zameriava_na_hru VALUES (9960285478, 000);
INSERT INTO hrac_sa_zameriava_na_hru VALUES (9959080054, 001);
INSERT INTO hrac_sa_zameriava_na_hru VALUES (9156288251, 001);
INSERT INTO hrac_sa_zameriava_na_hru VALUES (9152139172, 002);
INSERT INTO hrac_sa_zameriava_na_hru VALUES (9559101959, 003);

INSERT INTO klan_sa_zameriava_na_hru VALUES (100, 000);
INSERT INTO klan_sa_zameriava_na_hru VALUES (101, 000);
INSERT INTO klan_sa_zameriava_na_hru VALUES (102, 002);
INSERT INTO klan_sa_zameriava_na_hru VALUES (103, 003);

INSERT INTO hra_sa_hraje_na_turnaji VALUES (000, 301);
INSERT INTO hra_sa_hraje_na_turnaji VALUES (001, 301);
INSERT INTO hra_sa_hraje_na_turnaji VALUES (002, 302);
INSERT INTO hra_sa_hraje_na_turnaji VALUES (002, 303);

INSERT INTO tim_sa_zucastni_turnaja VALUES ('Shallow Desperado', 301);
INSERT INTO tim_sa_zucastni_turnaja VALUES ('Four Gangsters', 301);
INSERT INTO tim_sa_zucastni_turnaja VALUES ('Hateful Voltiac', 301);
INSERT INTO tim_sa_zucastni_turnaja VALUES ('Hateful Voltiac', 302);
INSERT INTO tim_sa_zucastni_turnaja VALUES ('Four Gangsters', 302);
INSERT INTO tim_sa_zucastni_turnaja VALUES ('Separate Assassins', 303);
INSERT INTO tim_sa_zucastni_turnaja VALUES ('Shallow Desperado', 303);

INSERT INTO tim_sa_zucastni_zapasu VALUES ('Four Gangsters', 401);
INSERT INTO tim_sa_zucastni_zapasu VALUES ('Shallow Desperado', 401);
INSERT INTO tim_sa_zucastni_zapasu VALUES ('Shallow Desperado', 402);
INSERT INTO tim_sa_zucastni_zapasu VALUES ('Separate Assassins', 402);
INSERT INTO tim_sa_zucastni_zapasu VALUES ('Four Gangsters', 403);
INSERT INTO tim_sa_zucastni_zapasu VALUES ('Separate Assassins', 403);
INSERT INTO tim_sa_zucastni_zapasu VALUES ('Hateful Voltiac', 404);
INSERT INTO tim_sa_zucastni_zapasu VALUES ('Separate Assassins', 404);
INSERT INTO tim_sa_zucastni_zapasu VALUES ('Hateful Voltiac', 405);
INSERT INTO tim_sa_zucastni_zapasu VALUES ('Shallow Desperado', 405);

INSERT INTO tim_vyhral_zapas VALUES ('Four Gangsters', 401, 647, 123);
INSERT INTO tim_vyhral_zapas VALUES ('Shallow Desperado', 402, 988, 456);
INSERT INTO tim_vyhral_zapas VALUES ('Shallow Desperado', 403, 486, 54);
INSERT INTO tim_vyhral_zapas VALUES ('Hateful Voltiac', 404, 775, 56);
INSERT INTO tim_vyhral_zapas VALUES ('Shallow Desperado', 405, 74, 12);

INSERT INTO turnaj_sponzoruje_sponzor VALUES (301, 500);
INSERT INTO turnaj_sponzoruje_sponzor VALUES (301, 501);
INSERT INTO turnaj_sponzoruje_sponzor VALUES (301, 502);
INSERT INTO turnaj_sponzoruje_sponzor VALUES (302, 500);
