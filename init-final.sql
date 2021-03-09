drop database if exists rezervacije_final;
create database rezervacije_final;
use rezervacije_final;

DROP TABLE IF EXISTS trgovina;
CREATE TABLE trgovina (
    id INT AUTO_INCREMENT,
    nazivTrgovine VARCHAR(100) NOT NULL,
    PRIMARY KEY(id),
    UNIQUE KEY(nazivTrgovine)
);

# Insert two store examples
INSERT INTO trgovina (nazivTrgovine)
VALUES	('Trgovina#1'),
		('Trgovina#2');

DROP TABLE IF EXISTS prava_pristupa;
CREATE TABLE prava_pristupa (
    id INT AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    PRIMARY KEY(id)
);

# Insert two prava_pristupa examples
INSERT INTO prava_pristupa (naziv)
VALUES	('Administrator'),
		('Vlasnik'),
        ('Obični korisnik');

DROP TABLE IF EXISTS korisnik;
CREATE TABLE korisnik (
    id INT AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    sifra VARCHAR(100) NOT NULL,
    prava_pristupa INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(prava_pristupa)
		REFERENCES prava_pristupa(id)
);

# Insert two korisnik examples
INSERT INTO korisnik (naziv, sifra, prava_pristupa)
VALUES	('Korisnik#1', 'Sifra#1', 2), # Vlasnik
		('Korisnik#2', 'Sifra#2', 3), # Obični korisnik
		('Korisnik#3', 'Sifra#3', 3); # Obični korisnik
        

DROP TABLE IF EXISTS naziv_svojstva;
CREATE TABLE naziv_svojstva (
    id INT AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    PRIMARY KEY(id)
);

# Insert examples
INSERT INTO naziv_svojstva (naziv)
VALUES	('Boja'),
		('Veličina'),
        ('Sastav');
        
DROP TABLE IF EXISTS vrijednost_svojstva;
CREATE TABLE vrijednost_svojstva (
    id INT AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    PRIMARY KEY(id)
);

# Insert examples
INSERT INTO vrijednost_svojstva (naziv)
VALUES	('Crvena'),
		('Plava'),
        ('Zelena'),
        ('Žuta'),
        ('Ljubičasta'),
        ('Narandžasta'),
        ('Ružičasta'),
        ('Grimizna'),
        ('Bijela'),
        ('Crna'),
        ('XS'),
        ('S'),
        ('M'),
        ('L'),
        ('XL'),
        ('XXL'),
        ('XXXL'),
		('Pamuk'),
		('Viskoza'),
		('Poliester'), 
        ('Saten'),
        ('Elastin'),
        ('Najlon');
        
DROP TABLE IF EXISTS svojstvo; #ne treba ova tablica
CREATE TABLE svojstvo (
	id INT  AUTO_INCREMENT,
    id_naziv_svojstva INT NOT NULL,
    id_vrijednost_svojstva INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_naziv_svojstva) 
		REFERENCES naziv_svojstva(id),
	FOREIGN KEY(id_vrijednost_svojstva) 
		REFERENCES vrijednost_svojstva(id)
);

# Insert examples
INSERT INTO svojstvo (id_naziv_svojstva, id_vrijednost_svojstva)
VALUES	(1, 1), 			# Boja:Crvena 	#1	 	
		(1, 2),				# Boja:Plava 	#2
        (1, 3),				# ... 
        (1, 4),				#		
        (1, 5),				#		
        (1, 6),				#	
        (1, 7),				#
        (1, 8),				#
        (1, 9),				#
        (1, 10),			# Boja:Crna 	#10
        (2, 11),			# Veličina:XS 	#11
        (2, 12),			# Veličina:S 	#12
        (2, 13),			# ...
        (2, 14),			#
        (2, 15),			#
        (2, 16),			#
        (2, 17),			# Veličina:XXXL #17
		(3, 18),			# Sastav:Pamuk 	#18
        (3, 19),			#
        (3, 20),			# ...
        (3, 21),			#
        (3, 22),			#
        (3, 23);			# Sastav:Najlon	#23

DROP TABLE IF EXISTS produkt;
CREATE TABLE produkt (
	id INT AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    PRIMARY KEY(id)
);

# Insert examples
INSERT INTO produkt (naziv)
VALUES	('Product#1'),
        ('Product#2'),
        ('Product#3'),
        ('Product#4');

DROP TABLE IF EXISTS proizvod;
CREATE TABLE proizvod (
    id INT AUTO_INCREMENT,
    trgovina_id INT NOT NULL,
    produkt_id INT NOT NULL,
	kolicina DEC(10 , 2 ) NOT NULL,
    cijena DEC(10 , 2 ) NOT NULL,
    PRIMARY KEY(id, trgovina_id),
    FOREIGN KEY(trgovina_id) 
		REFERENCES trgovina(id),
	FOREIGN KEY(produkt_id) 
		REFERENCES produkt(id)
);

# Insert examples
INSERT INTO proizvod (trgovina_id, produkt_id, kolicina, cijena)
VALUES	(1, 1, 100, 101),
		(1, 2, 200, 201),
        (1, 3, 300, 301),
        (2, 1, 100, 102),
		(2, 2, 200, 202),
        (2, 3, 300, 302);
        
DROP TABLE IF EXISTS svojstva_produkta;
CREATE TABLE svojstva_produkta (
	id INT AUTO_INCREMENT,
	trgovina_id INT NOT NULL,
    produkt_id INT NOT NULL,
    id_naziv_svojstva INT NOT NULL,
	id_vrijednost_svojstva INT NOT NULL,
    PRIMARY KEY(id,produkt_id,id_naziv_svojstva), #Ograničenje na jedan unos za jedno svojstvo
    FOREIGN KEY(trgovina_id) 
		REFERENCES trgovina(id),
 	FOREIGN KEY(produkt_id) 
		REFERENCES produkt(id),
	FOREIGN KEY(id_naziv_svojstva) 
		REFERENCES naziv_svojstva(id),
	FOREIGN KEY(id_vrijednost_svojstva) 
		REFERENCES vrijednost_svojstva(id)
);

# Insert examples
INSERT INTO svojstva_produkta (trgovina_id, produkt_id, id_naziv_svojstva, id_vrijednost_svojstva)
VALUES	(1, 1, 1, 1),
		(1, 1, 2, 13),
        (1, 2, 1, 2),
        (1, 2, 2, 14),
        (1, 3, 1, 3),
        (1, 3, 2, 15),
        (2, 1, 1, 1),
		(2, 1, 2, 13),
        (2, 2, 1, 2),
        (2, 2, 2, 14),
        (2, 3, 1, 3),
        (2, 3, 2, 15);

DROP TABLE IF EXISTS rezervacija_proizvoda;
CREATE TABLE rezervacija_proizvoda (
    id INT AUTO_INCREMENT,
    trgovina_id INT NOT NULL,
    produkt_id INT NOT NULL,
	kolicina DEC(10 , 2 ) NOT NULL,
    cijena DEC(10 , 2 ) NOT NULL,
    korisnik_id INT NOT NULL,
    datum_podizanja DATE NOT NULL,
    PRIMARY KEY(id, trgovina_id),
    FOREIGN KEY(trgovina_id) 
		REFERENCES trgovina(id),
	FOREIGN KEY(produkt_id) 
		REFERENCES produkt(id),
	FOREIGN KEY(korisnik_id) 
		REFERENCES korisnik(id)
);


CREATE VIEW vRezervacija (id, trgovina , produkt, kolicina, cijena, korisnik, datum_podizanja) 
AS
    SELECT 
        r.id AS id,
        r.trgovina_id AS trgovina,
        r.produkt_id AS produkt,
        r.kolicina AS kolicina,
        r.cijena AS cijena,
        r.korisnik_id AS korisnik,
        r.datum_podizanja AS datum_podizanja
    FROM
        rezervacija_proizvoda r;



/*------------------------------*/
DELIMITER $$
USE rezervacije_final$$
DROP PROCEDURE IF EXISTS sp_insert_vRezervacija$$
CREATE  PROCEDURE sp_insert_vRezervacija(	IN trgovina INT,  IN produkt INT,  IN kolicina DEC(10.2),  IN cijena DEC(10.2),  IN korisnik INT, IN datum_podizanja DATE, OUT isError INT)
BEGIN

	DECLARE exit handler for sqlexception
	BEGIN
		SELECT 'Error! SQLException and Rollback' AS Error;
        SET isError=1;
		ROLLBACK;
	END;
    
    DECLARE exit handler for sqlwarning
    BEGIN
		SELECT 'Warning! SQLException and Rollback' AS Error;
        SET isError=2;
		ROLLBACK; 
    END;

SET isError=0;

SET @kolicinaTotal = 0;

SELECT p.kolicina FROM proizvod p WHERE p.trgovina_id=trgovina AND p.produkt_id=produkt INTO @kolicinaTotal;

IF kolicina <= @kolicinaTotal AND datum_podizanja > CURDATE() AND korisnik <= 3 THEN
BEGIN 
	START TRANSACTION;
    
    
	UPDATE proizvod p
		SET kolicina = p.kolicina - kolicina
		WHERE p.trgovina_id=trgovina AND p.produkt_id=produkt;
        
   
	INSERT INTO vRezervacija (trgovina, produkt, kolicina, cijena, korisnik, datum_podizanja)
		VALUES (trgovina, produkt, kolicina, cijena, korisnik, datum_podizanja);
        
	COMMIT;
END;

ELSE
BEGIN
	IF kolicina > @kolicinaTotal THEN
		SELECT 'Error! Kolicina > KolicinaTotal' AS Error;
        SET isError=3;
	END IF;
    IF datum_podizanja <= CURDATE() THEN
		SELECT 'Error! datum_podizanja <= CURDATE()' AS Error;
        SET isError=4;
	END IF;    
    IF korisnik > 3 THEN
		SELECT 'Error! korisnik > 3' AS Error;
        SET isError=5;
	END IF;
END;
END IF;

END$$

DELIMITER ;

/*------------------------------*/

DELIMITER $$
USE rezervacije_final$$
DROP PROCEDURE IF EXISTS sp_create_update_proizvod$$
CREATE PROCEDURE sp_create_update_proizvod(	IN proizvod INT, IN trgovina INT,  IN produkt INT,  IN kolicina DEC(10.2),  IN cijena DEC(10.2),  IN korisnik INT,  OUT isError INT)
BEGIN

	DECLARE exit handler for sqlexception
	BEGIN
		SELECT 'Error! SQLException and Rollback' AS Error;
        SET isError=1;
		ROLLBACK;
	END;
    
    DECLARE exit handler for sqlwarning
    BEGIN
		SELECT 'Warning! SQLException and Rollback' AS Error;
        SET isError=2;
		ROLLBACK; 
    END;

SET isError=0;

SET @kolicinaTotal = 0;

SELECT p.kolicina FROM proizvod p WHERE p.trgovina_id=trgovina AND p.id=proizvod INTO @kolicinaTotal;
/*u jednoj trgovini moze biti vise proizvoda sa istim produktom*/
IF @kolicinaTotal IS NULL AND korisnik = 1 THEN
BEGIN 
	START TRANSACTION;
    
	INSERT INTO proizvod (trgovina, produkt, kolicina, cijena, korisnik)
		VALUES (trgovina, produkt, kolicina, cijena, korisnik);
        
	COMMIT;
END;
END IF;

IF @kolicinaTotal IS NOT NULL AND korisnik = 1 THEN
BEGIN 
	START TRANSACTION;
    
	UPDATE proizvod p
    SET p.trgovina=trgovina, 
		p.produkt=produkt, 
        p.kolicina= p.kolicina+kolicina, 
        p.cijena=cijena, 
        p.korisnik=korisnik
	WHERE p.trgovina_id=trgovina AND p.id=proizvod;
        
	COMMIT;
END;
END IF;

BEGIN
	IF korisnik > 1 THEN
		SELECT 'Error! korisnik > 1' AS Error;
        SET isError=3;
	END IF;
END;


END$$

DELIMITER ;
/*--------------------*/

DELIMITER $$
USE rezervacije_final$$
DROP PROCEDURE IF EXISTS sp_create_trgovina$$
CREATE PROCEDURE sp_create_trgovina(	IN nazivTrgovine varchar(100), IN korisnik INT,  OUT isError INT)
BEGIN

	DECLARE exit handler for sqlexception
	BEGIN
		SELECT 'Error! SQLException and Rollback' AS Error;
        SET isError=1;
		ROLLBACK;
	END;
    
    DECLARE exit handler for sqlwarning
    BEGIN
		SELECT 'Warning! SQLException and Rollback' AS Error;
        SET isError=2;
		ROLLBACK; 
    END;

SET isError=0;


IF korisnik = 1 THEN
BEGIN 
	START TRANSACTION;
    
	INSERT INTO trgovina (nazivTrgovine)
		VALUES (nazivTrgovine);
        
	COMMIT;
END;
END IF;

BEGIN
	IF korisnik > 1 THEN
		SELECT 'Error! korisnik > 1' AS Error;
        SET isError=3;
	END IF;
END;


END$$

DELIMITER ;

/*----------------------------*/
DELIMITER $$
USE rezervacije_final$$
DROP PROCEDURE IF EXISTS sp_insert_svojstva_produkta$$
CREATE PROCEDURE sp_insert_svojstva_produkta(IN trgovina_id INT, IN produkt_id INT, IN id_naziv_svojstva INT, IN id_vrijednost_svojstva INT, IN korisnik INT, OUT isError INT)
BEGIN

DECLARE exit handler for sqlexception
	BEGIN
		SELECT 'Error! SQLException and Rollback' AS Error;
        SET isError=1;
		ROLLBACK;
	END;
    
    DECLARE exit handler for sqlwarning
    BEGIN
		SELECT 'Warning! SQLException and Rollback' AS Error;
        SET isError=2;
		ROLLBACK; 
    END;

SET isError=0;


IF korisnik <= 2 THEN
BEGIN 
	START TRANSACTION;
    

	INSERT INTO svojstva_produkta (trgovina_id, produkt_id, id_naziv_svojstva, id_vrijednost_svojstva)
		VALUES	(trgovina_id, produkt_id, id_naziv_svojstva, id_vrijednost_svojstva);
        
	COMMIT;
END;
END IF;

BEGIN
	IF korisnik > 2 THEN
		SELECT 'Error! korisnik > 2' AS Error;
        SET isError=3;
	END IF;
END;

END$$

DELIMITER ;

/*----------------------------*/

# varijanta #2 korisnickih prava - direktno na DB ya Mysql 8.0
# GRANT Example - user "user" can only SELECT tables from rezervacije DB
DROP USER 'user'@'*';
CREATE USER 'user'@'*' IDENTIFIED BY 'P@ssW0rd01';
GRANT SELECT ON rezervacije_final.*  TO `user`@`*`;
# GRANT Example - user "owner" can SELECT, INSERT and UPDATE tables from rezervacije DB
DROP USER 'owner'@'*';
CREATE USER 'owner'@'*' IDENTIFIED BY 'P@ssW0rd02';
GRANT SELECT,INSERT,UPDATE ON rezervacije_final.*  TO `owner`@`*`;
FLUSH PRIVILEGES;