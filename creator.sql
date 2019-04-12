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
DROP TABLE turnaj_sponzoruje_sponzor CASCADE CONSTRAINTS;
DROP TABLE zapas_sa_hraje_na_turnaji CASCADE CONSTRAINTS;


-------------------------------------
-- Tabulky
-------------------------------------

CREATE TABLE osoba(
  rodne_cislo Number NOT NULL PRIMARY KEY,
  meno VARCHAR2(50) NOT NULL,
  priezvisko VARCHAR2(50) NOT NULL,
  narodnost VARCHAR(50) NOT NULL,
  datum_narodenia Date NOT NULL,
  mail VARCHAR(50) NOT NULL,
  prihlaseny_na_odber_noviniek NUMBER(1)
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
  hymna VARCHAR2(50),
  logo VARCHAR2(255),
  veduci NUMBER NOT NULL,
  CONSTRAINT klan_veduci_FK FOREIGN KEY (veduci) REFERENCES osoba(rodne_cislo),
  CONSTRAINT id_klanu_has_8_digits CHECK (REGEXP_LIKE(id_klanu,'^\d{1,8}$'))
);

CREATE TABLE hrac(
  rodne_cislo NUMBER NOT NULL PRIMARY KEY,
  prezyvka VARCHAR2(50) NOT NULL,
  klan NUMBER,
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
  datum_konania Date NOT NULL,
  vyherny_tim VARCHAR2(50),
  CONSTRAINT turnaj_vyherny_tim_FK FOREIGN KEY (vyherny_tim) REFERENCES tim(nazov_timu),
  CONSTRAINT id_turnaju_has_8_digits CHECK (REGEXP_LIKE(id_turnaju,'^\d{1,8}$'))
);

CREATE TABLE zapas(
  id_zapasu NUMBER NOT NULL PRIMARY KEY,-- max osem ciferne cislo
  trvanie_hry NUMBER NOT NULL, -- in seconds
  druh_zapasu VARCHAR2(50),
  vyherny_tim VARCHAR2(50),
  skore_vyhercu NUMBER NOT NULL,
  skore_prehraneho NUMBER NOT NULL,
  CONSTRAINT zapas_vyherny_tim_FK FOREIGN KEY (vyherny_tim) REFERENCES tim(nazov_timu),
  CONSTRAINT id_zapasu_has_8_digits CHECK (REGEXP_LIKE(id_zapasu,'^\d{1,8}$'))
);

CREATE TABLE sponzor(
  id_sponzora NUMBER NOT NULL PRIMARY KEY,
  meno VARCHAR2(50) NOT NULL,
  typ VARCHAR2(7) NOT NULL
);

-------------------------------------
-- * to * vztahy
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

CREATE TABLE turnaj_sponzoruje_sponzor(
  id_turnaju NUMBER NOT NULL,
  id_sponzora NUMBER NOT NULL,
  CONSTRAINT turnaj_sponzoruje_sponzor_PK PRIMARY KEY (id_turnaju, id_sponzora),
  CONSTRAINT turnaj_sponzoruje_sponzor_id_turnaju_FK FOREIGN KEY (id_turnaju) REFERENCES turnaj(id_turnaju),
  CONSTRAINT turnaj_sponzoruje_sponzor_id_sponzora_FK FOREIGN KEY (id_sponzora) REFERENCES sponzor(id_sponzora)
);

CREATE TABLE zapas_sa_hraje_na_turnaji(
    id_turnaju NUMBER NOT NULL,
    id_zapasu Number NOT NULL,
    CONSTRAINT zapas_sa_hraje_na_turnaji_PK PRIMARY KEY (id_turnaju, id_zapasu),
    CONSTRAINT zapas_sa_hraje_na_turnaji_id_zapasu_FK FOREIGN KEY (id_zapasu) REFERENCES zapas(id_zapasu),
    CONSTRAINT zapas_sa_hraje_na_turnaji_id_turnaju_FK FOREIGN KEY (id_turnaju) REFERENCES turnaj(id_turnaju)

);
-------------------------------------
-- Vlozenie testovacich udajov
-------------------------------------

INSERT INTO OSOBA VALUES (0156146848, 'Chai', 'Cameron', 'Slovak', TO_DATE('1990-03-01','yyyy-mm-dd'), 'cam@gmail.com', 1);
INSERT INTO osoba VALUES (9960285478, 'Canno', 'Boyer', 'Filipino', TO_DATE('1990-03-01','yyyy-mm-dd'), 'boy@gmail.com', 1);
INSERT INTO osoba VALUES (9959080054, 'Kayle', 'Wiley', 'German', TO_DATE('1990-03-01','yyyy-mm-dd'), 'wil@gmail.com', 1);
INSERT INTO osoba VALUES (9156288251, 'Rya', 'Nash', 'Australian', TO_DATE('1990-03-01','yyyy-mm-dd'), 'nas@gmail.com', 1);
INSERT INTO osoba VALUES (9152139172, 'Mia', 'Yang', 'Japanese', TO_DATE('1990-03-01','yyyy-mm-dd'), 'yan@gmail.com', 0);
INSERT INTO osoba VALUES (9559101959, 'Jordon', 'Hughes', 'Czech', TO_DATE('1990-03-01','yyyy-mm-dd'), 'hug@gmail.com', 0);
INSERT INTO osoba VALUES (0006160319, 'Roland', 'Archer', 'Australian', TO_DATE('1990-03-01','yyyy-mm-dd'), 'arch@gmail.com', 0);

INSERT INTO hra VALUES (000, 'Tekken', 'Fighting', TO_DATE('1990-03-01','yyyy-mm-dd'), '1v1', 'Capcom');
INSERT INTO hra VALUES (001, 'Quake', 'First-person shooters', TO_DATE('1997-05-11','yyyy-mm-dd'), '5v5', 'Capcom');
INSERT INTO hra VALUES (002, 'Doom', 'First-person shooters', TO_DATE('2015-12-24','yyyy-mm-dd'), '2v2', 'Capcom');
INSERT INTO hra VALUES (003, 'Call of duty', 'First-person shooters', TO_DATE('1994-03-31','yyyy-mm-dd'), '1v1', 'Capcom');

INSERT INTO klan VALUES (100, 'Gray Rebels', 'anthem1...', '~/images/logo1.jpg', 0156146848);
INSERT INTO klan VALUES (101, 'Comfortable Liquidators', 'anthem2...', '~/images/logo2.jpg', 9960285478);
INSERT INTO klan VALUES (102, 'Imported Knights', 'anthem3...','~/images/logo3.jpg', 9959080054);
INSERT INTO klan VALUES (103, 'Creepy Exile', 'anthem4...', '~/images/logo4.jpg', 0006160319);

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

INSERT INTO tim VALUES ('Shallow Desperado');
INSERT INTO tim VALUES ('Separate Assassins');
INSERT INTO tim VALUES ('Four Gangsters');
INSERT INTO tim VALUES ('Hateful Voltiac');

INSERT INTO turnaj VALUES (301, '5000€', TO_DATE('2019-05-01','yyyy-mm-dd'), 'Shallow Desperado');
INSERT INTO turnaj VALUES (302, '100€', TO_DATE('2019-06-11','yyyy-mm-dd'),'Hateful Voltiac');
INSERT INTO turnaj VALUES (303, '2000€', TO_DATE('2019-06-25','yyyy-mm-dd'),'Shallow Desperado');

INSERT INTO zapas VALUES (401, 45265, 'scrim', 'Four Gangsters', 647, 123);
INSERT INTO zapas VALUES (402, 45645, 'tournament', 'Shallow Desperado', 988, 456);
INSERT INTO zapas VALUES (403, 78789, 'tournament',  'Shallow Desperado', 486, 54);
INSERT INTO zapas VALUES (404, 123456, 'tournament',  'Hateful Voltiac', 775, 56);
INSERT INTO zapas VALUES (405, 685122, 'tournament',  'Shallow Desperado', 74, 12);

INSERT INTO sponzor VALUES (500, 'Coca cola', 'main');
INSERT INTO sponzor VALUES (501, 'JBL', 'main');
INSERT INTO sponzor VALUES (502, 'Nvidia', 'main');

INSERT INTO hrac_hraje_za_tim VALUES (0156146848, 'Shallow Desperado');
INSERT INTO hrac_hraje_za_tim VALUES (0156146848, 'Separate Assassins');
INSERT INTO hrac_hraje_za_tim VALUES (0156146848, 'Four Gangsters');
INSERT INTO hrac_hraje_za_tim VALUES (9960285478, 'Shallow Desperado');
INSERT INTO hrac_hraje_za_tim VALUES (9959080054, 'Shallow Desperado');
INSERT INTO hrac_hraje_za_tim VALUES (9156288251, 'Separate Assassins');
INSERT INTO hrac_hraje_za_tim VALUES (9152139172, 'Hateful Voltiac');

INSERT INTO hrac_sa_zameriava_na_hru VALUES (0156146848, 000);
INSERT INTO hrac_sa_zameriava_na_hru VALUES (9960285478, 000);
INSERT INTO hrac_sa_zameriava_na_hru VALUES (9959080054, 001);
INSERT INTO hrac_sa_zameriava_na_hru VALUES (9156288251, 002);
INSERT INTO hrac_sa_zameriava_na_hru VALUES (9152139172, 001);
INSERT INTO hrac_sa_zameriava_na_hru VALUES (9559101959, 001);
INSERT INTO hrac_sa_zameriava_na_hru VALUES (9559101959, 002);
INSERT INTO hrac_sa_zameriava_na_hru VALUES (9559101959, 003);

INSERT INTO klan_sa_zameriava_na_hru VALUES (100, 000);
INSERT INTO klan_sa_zameriava_na_hru VALUES (101, 000);
INSERT INTO klan_sa_zameriava_na_hru VALUES (101, 001);
INSERT INTO klan_sa_zameriava_na_hru VALUES (101, 002);
INSERT INTO klan_sa_zameriava_na_hru VALUES (102, 002);
INSERT INTO klan_sa_zameriava_na_hru VALUES (103, 002);

INSERT INTO hra_sa_hraje_na_turnaji VALUES (000, 301);
INSERT INTO hra_sa_hraje_na_turnaji VALUES (000, 302);
INSERT INTO hra_sa_hraje_na_turnaji VALUES (000, 303);
INSERT INTO hra_sa_hraje_na_turnaji VALUES (001, 302);
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

INSERT INTO turnaj_sponzoruje_sponzor VALUES (301, 500);
INSERT INTO turnaj_sponzoruje_sponzor VALUES (301, 501);
INSERT INTO turnaj_sponzoruje_sponzor VALUES (301, 502);
INSERT INTO turnaj_sponzoruje_sponzor VALUES (302, 500);

INSERT INTO zapas_sa_hraje_na_turnaji VALUES (301,402);
INSERT INTO zapas_sa_hraje_na_turnaji VALUES (301,403);
INSERT INTO zapas_sa_hraje_na_turnaji VALUES (302,404);
INSERT INTO zapas_sa_hraje_na_turnaji VALUES (303,405);


------------------------------------------------------------------------------
--Select dotazy
------------------------------------------------------------------------------
--Spojenie 2 tabuliek 2x
------------------------------------------------------------------------------
--Vypis Nazvu,Zanru hry na ktoru sa zameriava hrac s rodnym cislom 9960285478

SELECT nazov, zaner
FROM hra H NATURAL JOIN hrac_sa_zameriava_na_hru
WHERE hrac_sa_zameriava_na_hru.hrac = 9960285478;

--Vypis zapasov, ktorych sa zucastni tim Shallow Desperado

SELECT id_zapasu,trvanie_hry,druh_zapasu
FROM zapas Z NATURAL JOIN tim_sa_zucastni_zapasu
WHERE tim_sa_zucastni_zapasu.nazov_timu='Shallow Desperado';

------------------------------------------------------------------------------
--Spojenie 3 tabuliek
------------------------------------------------------------------------------
--Vypis hlavnej ceny, nazvu hry a vitazneho timu turnaja

SELECT hlavna_cena, nazov, nazov_timu
from tim_sa_zucastni_turnaja t NATURAL JOIN turnaj tu NATURAL JOIN hra h NATURAL JOIN hra_sa_hraje_na_turnaji
WHERE id_turnaju = 301 and vyherny_tim=nazov_timu;

------------------------------------------------------------------------------
--Dotazy s klauzulou GROUP BY a agregacnou funkciou 2x
------------------------------------------------------------------------------
--Vypis nazvu timu a pocet hracov za tim

SELECT nazov_timu, count(h_t.hrac)
FROM hrac_hraje_za_tim h_t NATURAL JOIN tim
GROUP BY nazov_timu;

--Vypis ID turnaju a dlzka najdlhsieho zapasu

SELECT id_turnaju, max(z.trvanie_hry)
FROM turnaj NATURAL JOIN zapas z NATURAL JOIN zapas_sa_hraje_na_turnaji
GROUP BY id_turnaju;

------------------------------------------------------------------------------
--Select s exists
------------------------------------------------------------------------------
--Vypise informacie o klanoch ktore sa nezameriavaju na hru s id 000

SELECT *
FROM klan
WHERE NOT EXISTS(
    SELECT *
    FROM klan_sa_zameriava_na_hru
    WHERE klan_sa_zameriava_na_hru.id_klanu = klan.id_klanu and klan_sa_zameriava_na_hru.id_hry = 000
    );

------------------------------------------------------------------------------
--Select s vnorenym in
------------------------------------------------------------------------------
--Vypise informacie o hracovi ktory ma mysku A4Tech Bloody V7M

SELECT *
FROM osoba NATURAL JOIN hrac
WHERE rodne_cislo IN
      (
          SELECT rodne_cislo
          FROM vybavenie
          WHERE mys = 'A4Tech Bloody V7M' and rodne_cislo=vlastnik
          );