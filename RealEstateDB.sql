-- -*- mode: sql; sql-product: oracle; -*-
--4 

CREATE TABLE ADRESE(
    ID_ADRESA NUMBER(10) PRIMARY KEY,
    STRADA VARCHAR2(50) NOT NULL,
    NR NUMBER(10) NOT NULL,
    BLOC VARCHAR2(10),
    SCARA VARCHAR2(10),
    APARTAMENT NUMBER(10),
    SECTOR NUMBER(1) NOT NULL,
    CARTIER VARCHAR2(50) NOT NULL
);


------------------------------------------------------------------------
CREATE TABLE PROPRIETARI(
    ID_PROPRIETAR NUMBER(10) PRIMARY KEY,
    NUME VARCHAR2(50) NOT NULL,
    PRENUME VARCHAR2(50) NOT NULL,
    ID_ADRESA NUMBER(10) NOT NULL,
    TELEFON NUMBER(10) NOT NULL,
    EMAIL VARCHAR2(50),
    CONSTRAINT FK_ADRESA_PROPRIETAR FOREIGN KEY(ID_ADRESA)
        REFERENCES ADRESE(ID_ADRESA) ON DELETE CASCADE
);

------------------------------------------------------------------------

CREATE TABLE PROPRIETATI(
    ID_PROPRIETATE NUMBER(10) PRIMARY KEY,
    TIP_CONSTRUCTIE VARCHAR2(50) CHECK (TIP_CONSTRUCTIE IN ('CASA', 'APARTAMENT')),
    TIP_OFERTA VARCHAR2(50) CHECK (TIP_OFERTA IN ('VANZARE', 'INCHIRIERE')),
    PRET NUMBER(10) NOT NULL,
    NR_CAMERE NUMBER(3) NOT NULL,
    SUPRAFATA_CONSTRUITA NUMBER(10) NOT NULL,
    AN_CONSTRUCTIE NUMBER(4) NOT NULL,
    ID_ADRESA NUMBER(10) NOT NULL,
    CONSTRAINT FK_ADRESA_PROPRIETATE FOREIGN KEY(ID_ADRESA)
        REFERENCES ADRESE(ID_ADRESA) ON DELETE CASCADE
);

ALTER TABLE PROPRIETATI
ADD CONSTRAINT UNIQUE_ID_ADRESA UNIQUE (ID_ADRESA);


------------------------------------------------------------------------
CREATE TABLE PROPRIETARI_PROPRIETATE (
    ID_PROPRIETAR NUMBER(10),
    ID_PROPRIETATE NUMBER,
    PRIMARY KEY (ID_PROPRIETAR, ID_PROPRIETATE),
    CONSTRAINT fk_proprietar
        FOREIGN KEY (ID_PROPRIETAR)
        REFERENCES PROPRIETARI(ID_PROPRIETAR)
        ON DELETE CASCADE,
    CONSTRAINT fk_proprietate
        FOREIGN KEY (ID_PROPRIETATE)
        REFERENCES PROPRIETATI(ID_PROPRIETATE)
        ON DELETE CASCADE
);


------------------------------------------------------------------------

CREATE TABLE CASE (
    ID_CASA NUMBER(10) PRIMARY KEY,
    ID_PROPRIETATE NUMBER(10) NOT NULL,
    NR_ETAJE NUMBER(3) NOT NULL,
    SUPRAFATA_TEREN NUMBER(10),
    SUPRAFATA_CURTE NUMBER(10),
    CONSTRAINT FK_PROPRIETATE_CASA FOREIGN KEY(ID_PROPRIETATE)
        REFERENCES PROPRIETATI(ID_PROPRIETATE) ON DELETE CASCADE
);

ALTER TABLE CASE ADD CONSTRAINT UNIQUE_ID_PROPRIETATE UNIQUE (ID_PROPRIETATE);


------------------------------------------------------------------------

CREATE TABLE APARTAMENTE (
    ID_APARTAMENT NUMBER(10) PRIMARY KEY,
    ID_PROPRIETATE NUMBER(10) NOT NULL,
    TIP_IMOBIL VARCHAR2(50) CHECK (TIP_IMOBIL IN ('BLOC', 'VILA')),
    ETAJ NUMBER(3) NOT NULL,
    NR_ETAJE_IMOBIL NUMBER(3) NOT NULL,
    LIFT NUMBER(1) NOT NULL,
    CONSTRAINT FK_PROPRIETATE_APARTAMENT FOREIGN KEY(ID_PROPRIETATE)
        REFERENCES PROPRIETATI(ID_PROPRIETATE) ON DELETE CASCADE
);
ALTER TABLE APARTAMENTE ADD CONSTRAINT UNIQUE_ID_PROPRIETATE_APARTAMENT UNIQUE (ID_PROPRIETATE);


------------------------------------------------------------------------
CREATE TABLE DETALII_PROPRIETATI(
    ID_DETALII NUMBER(10) PRIMARY KEY,
    ID_PROPRIETATE NUMBER(10),
    STRADALA VARCHAR(2) CHECK (STRADALA IN ('DA', 'NU')),
    GEAM_BAIE VARCHAR(2) CHECK (GEAM_BAIE IN ('DA', 'NU')),
    MOBILATA VARCHAR(2) CHECK (MOBILATA IN ('DA', 'NU')),
    NR_BAI NUMBER(3) DEFAULT 1 NOT NULL,
    TIP_BALCON VARCHAR(50) CHECK (TIP_BALCON IN ('INCHIS', 'DECHIS', 'NU')),
    COMPARTIMENTARE VARCHAR(50) CHECK (COMPARTIMENTARE IN ('DECOMANDAT', 'SEMIDECOMANDAT', 'NEDECOMANDAT')),
    STRUCTURA_REZISTENTA VARCHAR(50) CHECK (STRUCTURA_REZISTENTA IN ('BETON', 'CARAMIDA', 'BLOCURI')),
    CONSTRAINT FK_PROPRIETATE_DETALII FOREIGN KEY(ID_PROPRIETATE)
        REFERENCES PROPRIETATI(ID_PROPRIETATE) ON DELETE CASCADE
);

ALTER TABLE DETALII_PROPRIETATI ADD CONSTRAINT UNIQUE_ID_PROPRIETATE_DETALII UNIQUE (ID_PROPRIETATE);


------------------------------------------------------------------------
CREATE TABLE CLIENTI
(
    ID_CLIENT NUMBER(10) PRIMARY KEY,
    NUME VARCHAR2(50) NOT NULL,
    PRENUME VARCHAR2(50) NOT NULL,
    TELEFON NUMBER(10) NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL
);

------------------------------------------------------------------------
CREATE TABLE AGENTI(
    ID_AGENT NUMBER(10) PRIMARY KEY,
    NUME VARCHAR2(50) NOT NULL,
    PRENUME VARCHAR2(50) NOT NULL,
    ID_ADRESA NUMBER(10) NOT NULL,
    TELEFON NUMBER(10) NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL,
    CONSTRAINT FK_ADRESA_AGENT FOREIGN KEY(ID_ADRESA)
        REFERENCES ADRESE(ID_ADRESA) ON DELETE CASCADE
);
------------------------------------------------------------------------

CREATE TABLE CHIRIASI_PROPRIETATE(
    ID_CHIRIAS NUMBER(10),
    ID_PROPRIETATE NUMBER(10),
    PRIMARY KEY (ID_CHIRIAS, ID_PROPRIETATE),
    CONSTRAINT FK_CHIRIAS
        FOREIGN KEY (ID_CHIRIAS)
        REFERENCES CLIENTI(ID_CLIENT)
        ON DELETE CASCADE,
    CONSTRAINT FK_PROPRIETATE_INCHIRIATA
        FOREIGN KEY (ID_PROPRIETATE)
        REFERENCES PROPRIETATI(ID_PROPRIETATE)
        ON DELETE CASCADE
);
-----------------------------------------------------------------------

CREATE TABLE CUMPARATORI_PROPRIETATE(
    ID_CUMPARATOR NUMBER(10),
    ID_PROPRIETATE NUMBER(10),
    PRIMARY KEY (ID_CUMPARATOR, ID_PROPRIETATE),
    CONSTRAINT FK_CUMPARATOR
        FOREIGN KEY (ID_CUMPARATOR)
        REFERENCES CLIENTI(ID_CLIENT)
        ON DELETE CASCADE,
    CONSTRAINT FK_PROPRIETATE_CUMPARATA
        FOREIGN KEY (ID_PROPRIETATE)
        REFERENCES PROPRIETATI(ID_PROPRIETATE)
        ON DELETE CASCADE
);

------------------------------------------------------------------------
CREATE TABLE ACORDURI_INCHIRIERE(
    ID_ACORD NUMBER(10) PRIMARY KEY,
    ID_PROPRIETATE NUMBER(10) NOT NULL,
    ID_AGENT NUMBER(10) NOT NULL,
    DATA_ACORD DATE NOT NULL,
    CONSTRAINT FK_AGENT_ACORD FOREIGN KEY(ID_AGENT)
        REFERENCES AGENTI(ID_AGENT) ON DELETE CASCADE
);

ALTER TABLE ACORDURI_INCHIRIERE
ADD CONSTRAINT FK_PROPRIETATE_ACORD_INCHIRIERE
FOREIGN KEY (ID_PROPRIETATE)
REFERENCES PROPRIETATI(ID_PROPRIETATE);



-------------------------------------------------------

CREATE SEQUENCE SEQ_CONTRACTE_VANZARE_CUMPARARE_ID
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE CONTRACTE_VANZARE_CUMPARARE(
    ID_ACORD NUMBER(10) DEFAULT SEQ_CONTRACTE_VANZARE_CUMPARARE_ID.NEXTVAL PRIMARY KEY,
    ID_PROPRIETATE NUMBER(10) NOT NULL,
    ID_AGENT NUMBER(10) NOT NULL,
    DATA_CONTRACT DATE NOT NULL,
    COMISION_AGENT NUMBER(2) NOT NULL,
    CONSTRAINT FK_PROPRIETATE_VANDUTA
        FOREIGN KEY (ID_PROPRIETATE)
        REFERENCES PROPRIETATI(ID_PROPRIETATE),
    CONSTRAINT FK_AGENT_VANZARE
        FOREIGN KEY (ID_AGENT)
        REFERENCES AGENTI(ID_AGENT)
);

----------------------------------------------------------------
CREATE SEQUENCE SEQ_VIZIONARI_ID
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE VIZIONARI(
    ID_VIZIONARE NUMBER(10) DEFAULT SEQ_VIZIONARI_ID.NEXTVAL PRIMARY KEY,
    ID_PROPRIETATE NUMBER(10) NOT NULL,
    ID_AGENT NUMBER(10) NOT NULL,
    ID_CLIENT NUMBER(10) NOT NULL,
    DATA_VIZIONARE DATE NOT NULL,
    CONSTRAINT FK_PROPRIETATE_VIZIONARE FOREIGN KEY(ID_PROPRIETATE)
        REFERENCES PROPRIETATI(ID_PROPRIETATE) ON DELETE CASCADE,
    CONSTRAINT FK_AGENT_VIZIONARE FOREIGN KEY(ID_AGENT)
        REFERENCES AGENTI(ID_AGENT) ON DELETE CASCADE,
    CONSTRAINT FK_CLIENT_VIZIONARE FOREIGN KEY(ID_CLIENT)
        REFERENCES CLIENTI(ID_CLIENT) ON DELETE CASCADE
);

--------------------------------------------------------------

-- 5

INSERT INTO ADRESE VALUES (1, 'Bulevardul Unirii', 10, 'V1', 'S1', 1, 1, 'Centru');
INSERT INTO ADRESE VALUES (2, 'Calea Victoriei', 20, 'B2', 'S2', 2, 2, 'Centru');
INSERT INTO ADRESE VALUES (3, 'Soseaua Libertatii', 30, 'A7', 'S3', 3, 3, 'Berceni');
INSERT INTO ADRESE (ID_ADRESA, STRADA, NR, SECTOR, CARTIER) VALUES (4, 'Splaiul Independentei', 40, 4, 'Cotroceni');
INSERT INTO ADRESE VALUES (5, 'Calea Plevnei', 50, 'V5', 'S5', 5, 5, 'Vitan');
INSERT INTO ADRESE VALUES (6, 'Strada Progresului', 60, 'B6', 'S6', 6, 1, 'Berceni');
INSERT INTO ADRESE VALUES (7, 'Strada Pacii', 70, 'B7', 'S7', 7, 2, 'Baneasa');
INSERT INTO ADRESE VALUES (8, 'Aleea Eroilor', 80, 'B8', 'S8', 8, 2, 'Pantelimon');
INSERT INTO ADRESE VALUES (9, 'Strada Luptei', 90, 'C14', 'S9', 9, 4, 'Vitan');
INSERT INTO ADRESE VALUES (10, 'Strada Muncii', 100, 'B10', 'S10', 10, 5, 'Crangasi');
INSERT INTO ADRESE VALUES (11, 'Strada Sperantei', 110, 'D4', 'S11', 11, 1, 'Tei');
INSERT INTO ADRESE (ID_ADRESA, STRADA, NR, SECTOR, CARTIER) VALUES (12, 'Strada Paris', 120, 2, 'Dorobanti');
INSERT INTO ADRESE VALUES (13, 'Strada Trecutului', 130, 'V13', 'S13', 13, 5, 'Drumul Taberei');
INSERT INTO ADRESE VALUES (14, 'Strada Prezentului', 140, 'B14', 'S14', 14, 2, 'Obor');
INSERT INTO ADRESE VALUES (15, 'Aleea Avrig ', 150, 'B15', 'D5', 15, 2, 'Obor');
INSERT INTO ADRESE (ID_ADRESA, STRADA, NR, SECTOR, CARTIER) VALUES (16, 'Strada Ankara', 160, 2, 'Dorobanti');
INSERT INTO ADRESE (ID_ADRESA, STRADA, NR, SECTOR, CARTIER) VALUES (17, 'Intrarea Camil Petrescu', 170, 2, 'Dorobanti');
INSERT INTO ADRESE (ID_ADRESA, STRADA, NR, APARTAMENT, SECTOR, CARTIER) VALUES (18, 'Strada Lipscani', 180,  18, 4, 'Centru');
INSERT INTO ADRESE VALUES (19, 'Bulevardul Timisoara', 190, 'B19', 'S19', 19, 4, 'Centru');
INSERT INTO ADRESE VALUES (20, 'Calea Dorobanti', 200, 'B20', 'S20', 20, 2, 'Dorobanti');
INSERT INTO ADRESE VALUES (21, 'Strada Mihai Eminescu', 210, 'B21', 'S21', 21, 2, 'Cartierul Armenesc');
INSERT INTO ADRESE VALUES (22, 'Strada Ion Creanga', 220, 'B22', 'S22', 22, 2, 'Cartierul Armenesc');
INSERT INTO ADRESE VALUES (23, 'Strada Vasile Alecsandri', 230, 'B23', 'S23', 23, 2, 'Cartierul Armenesc');

---------------------------------------------------------------------------------------

INSERT INTO PROPRIETARI VALUES (1, 'Giurgiuveanu', 'Costache', 1, 0727393888, 'ggkosty@yahoo.com');
INSERT INTO PROPRIETARI VALUES (2, 'Lipan', 'Nechifor',    2, 0314728383,    'transhumantul@hotmail.com');
INSERT INTO PROPRIETARI VALUES (3, 'Gheorghidiu', 'Ela', 3, 0794222711,    'elamanuela@gmail.com');
INSERT INTO PROPRIETARI VALUES (4, 'Stanescu', 'Elena', 4, 0722000004, 'elenast@gmail.com');
INSERT INTO PROPRIETARI VALUES (5, 'Georgescu', 'Adrian', 3, 0722000005, 'adiangege@hotmail.com');
INSERT INTO PROPRIETARI (ID_PROPRIETAR, NUME, PRENUME, ID_ADRESA, TELEFON) VALUES (6, 'Mihai', 'Gabriel', 2, 0722000008);
INSERT INTO PROPRIETARI (ID_PROPRIETAR, NUME, PRENUME, ID_ADRESA, TELEFON) VALUES (7, 'Dumitru', 'Ioana', 5, 0722000009);
INSERT INTO PROPRIETARI (ID_PROPRIETAR, NUME, PRENUME, ID_ADRESA, TELEFON) VALUES (8, 'Pop', 'Andrei', 6, 0722000010);

-------------------------------------------------------------------

INSERT INTO PROPRIETATI VALUES (1, 'CASA', 'INCHIRIERE', 2000, 12, 100, 1903, 12);
INSERT INTO PROPRIETATI VALUES (2, 'CASA', 'VANZARE', 200000, 4, 200, 1922, 4);
INSERT INTO PROPRIETATI VALUES (3, 'CASA', 'VANZARE', 300000, 5, 300, 1930, 16);
INSERT INTO PROPRIETATI VALUES (4, 'APARTAMENT', 'VANZARE', 150000, 6, 400, 2003, 8);
INSERT INTO PROPRIETATI VALUES (5, 'APARTAMENT', 'VANZARE', 50000, 1, 500, 1994, 19);
INSERT INTO PROPRIETATI VALUES (6, 'APARTAMENT', 'INCHIRIERE', 1000, 2, 50, 2005, 18);
INSERT INTO PROPRIETATI VALUES (7, 'CASA', 'INCHIRIERE', 2500, 3, 60, 2006, 17);
INSERT INTO PROPRIETATI VALUES (8, 'APARTAMENT', 'INCHIRIERE', 300, 3, 70, 1987, 11);
INSERT INTO PROPRIETATI VALUES (9, 'APARTAMENT', 'VANZARE', 95000, 4, 80, 1970, 9);
INSERT INTO PROPRIETATI VALUES (10, 'APARTAMENT', 'INCHIRIERE', 500, 4, 90, 2009, 10);
INSERT INTO PROPRIETATI VALUES (11, 'CASA', 'VANZARE', 400000, 5, 100, 2010, 21);

---------------------------------------------

INSERT INTO PROPRIETARI_PROPRIETATE VALUES (3, 3);
INSERT INTO PROPRIETARI_PROPRIETATE VALUES (5, 3);
INSERT INTO PROPRIETARI_PROPRIETATE VALUES (1, 1);
INSERT INTO PROPRIETARI_PROPRIETATE VALUES (1, 10);
INSERT INTO PROPRIETARI_PROPRIETATE VALUES (5, 2);
INSERT INTO PROPRIETARI_PROPRIETATE VALUES (2, 6);
INSERT INTO PROPRIETARI_PROPRIETATE VALUES (8, 7);
INSERT INTO PROPRIETARI_PROPRIETATE VALUES (8, 8);
INSERT INTO PROPRIETARI_PROPRIETATE VALUES (7, 4);
INSERT INTO PROPRIETARI_PROPRIETATE VALUES (6, 5);
INSERT INTO PROPRIETARI_PROPRIETATE VALUES (4, 6);
INSERT INTO PROPRIETARI_PROPRIETATE VALUES (4, 9);
INSERT INTO PROPRIETARI_PROPRIETATE VALUES (2, 10);
INSERT INTO PROPRIETARI_PROPRIETATE VALUES (1, 11);


------------------------------------------------------------------------

INSERT INTO CASE VALUES (1, 2, 2, 100, 50);
INSERT INTO CASE VALUES (2, 3, 3, 200, 100);
INSERT INTO CASE VALUES (3, 7, 1, 60, 30);
INSERT INTO CASE VALUES (4, 1, 2, 80, 40);
INSERT INTO CASE VALUES (5, 11, 3, 100, 50);

----------------------------------------------------------------------------

INSERT INTO APARTAMENTE VALUES (1, 5, 'BLOC', 1, 10, 1);
INSERT INTO APARTAMENTE VALUES (2, 6, 'BLOC', 2, 10, 1);
INSERT INTO APARTAMENTE VALUES (3, 8, 'BLOC', 3, 10, 1);
INSERT INTO APARTAMENTE VALUES (4, 9, 'BLOC', 4, 10, 1);
INSERT INTO APARTAMENTE VALUES (5, 10, 'BLOC', 5, 10, 1);
INSERT INTO APARTAMENTE VALUES (6, 4, 'BLOC', 6, 10, 1);

-----------------------------------------------------------------------------

INSERT INTO DETALII_PROPRIETATI VALUES (1, 1, 'NU', 'DA', 'DA', 2, 'INCHIS', 'DECOMANDAT', 'BETON');
INSERT INTO DETALII_PROPRIETATI VALUES (2, 2, 'NU', 'DA', 'NU', 3, 'DECHIS', 'SEMIDECOMANDAT', 'CARAMIDA');
INSERT INTO DETALII_PROPRIETATI VALUES (3, 3, 'NU', 'DA', 'NU', 4, 'INCHIS', 'NEDECOMANDAT', 'BLOCURI');
INSERT INTO DETALII_PROPRIETATI VALUES (4, 4, 'DA', 'NU', 'DA', 5, 'DECHIS', 'DECOMANDAT', 'BETON');
INSERT INTO DETALII_PROPRIETATI VALUES (5, 5, 'NU', 'DA', 'NU', 6, 'INCHIS', 'SEMIDECOMANDAT', 'CARAMIDA');
INSERT INTO DETALII_PROPRIETATI VALUES (6, 6, 'DA', 'NU', 'DA', 7, 'DECHIS', 'NEDECOMANDAT', 'BLOCURI');
INSERT INTO DETALII_PROPRIETATI VALUES (7, 7, 'NU', 'NU', 'DA', 8, 'INCHIS', 'DECOMANDAT', 'BETON');
INSERT INTO DETALII_PROPRIETATI VALUES (8, 8, 'DA', 'DA', 'NU', 9, 'DECHIS', 'SEMIDECOMANDAT', 'CARAMIDA');
INSERT INTO DETALII_PROPRIETATI VALUES (9, 9, 'DA', 'NU', 'DA', 10, 'INCHIS', 'NEDECOMANDAT', 'BLOCURI');
INSERT INTO DETALII_PROPRIETATI VALUES (10, 10, 'NU', 'DA', 'DA', 11, 'DECHIS', 'DECOMANDAT', 'BETON');
INSERT INTO DETALII_PROPRIETATI VALUES (11, 11, 'DA', 'DA', 'NU', 12, 'INCHIS', 'SEMIDECOMANDAT', 'CARAMIDA');

------------------------------------------------------------------------------------

INSERT INTO CLIENTI VALUES (1, 'Anton', 'Ion', 0772103501, 'ionanton@yahoo.com');
INSERT INTO CLIENTI VALUES (2, 'Pop', 'Maria', 0732470082, 'marypop@ymail.com');
INSERT INTO CLIENTI VALUES (3, 'Ionascu', 'Vasile', 0728000379, 'ionescuv58@yahoo.com');
INSERT INTO CLIENTI VALUES (4, 'Vasilescu', 'Andreea', 0792567004, 'andyvasy98@gmail.com');
INSERT INTO CLIENTI VALUES (5, 'Apetrei', 'Mihai', 0712001195, 'mickeyaptr@s.unibuc.ro');
INSERT INTO CLIENTI VALUES (6, 'Dumitrescu', 'Eliza', 0744005506, 'lizthemuse@gmail.com');
INSERT INTO CLIENTI VALUES (7, 'Stoica', 'Cristina', 0771012307, 'crisstoica@hotmail.com');
INSERT INTO CLIENTI VALUES (8, 'Gabescu', 'Gabi', 07888939222, 'papigabi@gmail.com');
INSERT INTO CLIENTI VALUES (9, 'Mihaiescu', 'Dorina', 0722812345, 'didimihi@yahoo.com');
INSERT INTO CLIENTI VALUES (10, 'Demetrescu', 'Oana', 072543219, 'oana_demetrescu@hotmail.com');
INSERT INTO CLIENTI VALUES (11, 'Popovici', 'Alexandru', 0722837510, 'alexppv@gmail.com');
INSERT INTO CLIENTI VALUES (12, 'Serea', 'Bogdan', 0722099128, 'bobbys@gmail.com');
INSERT INTO CLIENTI VALUES (13, 'Badescu', 'Anca', 0783272881, 'badeasca@gmail.com');
INSERT INTO CLIENTI VALUES (14, 'Silvestru', 'Iulian', 07227883349, 'iulysylvie@hotmail.com');

----------------------------------------------------------------------------------------------------

INSERT INTO AGENTI VALUES (1, 'Stan', 'Radu', 7, 0712345678, 'radu_stan@gmail.com');
INSERT INTO AGENTI VALUES (2, 'Ivan', 'Mara', 13, 0787654321, 'mara_ivan@yahoo.com');
INSERT INTO AGENTI VALUES (3, 'George', 'Andrei', 14, 0711223344, 'andrei_george@gmail.com');
INSERT INTO AGENTI VALUES (4, 'Diaconu', 'Florentina', 15, 0755667788, 'florentina_diaconu@yahoo.com');
INSERT INTO AGENTI VALUES (5, 'Vasilescu', 'Marian', 20, 0701020304, 'marian_vasilescu@gmail.com');
INSERT INTO AGENTI VALUES (6, 'Ivan', 'George', 13, 0787654322, 'george_ivan@yahoo.com');
INSERT INTO AGENTI VALUES (7, 'Antonescu', 'Andrei', 14, 0711223345, 'andrei_antonescu@gmail.com');

--------------------------------------------------------------------------------------------------

INSERT INTO CHIRIASI_PROPRIETATE VALUES (1, 1);
INSERT INTO CHIRIASI_PROPRIETATE VALUES (1, 7);
INSERT INTO CHIRIASI_PROPRIETATE VALUES (2, 6);
INSERT INTO CHIRIASI_PROPRIETATE VALUES (3, 1);
INSERT INTO CHIRIASI_PROPRIETATE VALUES (4, 6);
INSERT INTO CHIRIASI_PROPRIETATE VALUES (5, 8);
INSERT INTO CHIRIASI_PROPRIETATE VALUES (6, 10);
INSERT INTO CHIRIASI_PROPRIETATE VALUES (7, 7);
INSERT INTO CHIRIASI_PROPRIETATE VALUES (8, 7);
INSERT INTO CHIRIASI_PROPRIETATE VALUES (8, 1);


-----------------------------------------------------------------------------------------

INSERT INTO ACORDURI_INCHIRIERE VALUES (1, 1, 1, TO_DATE('07-01-2022', 'DD-MM-YYYY'));
INSERT INTO ACORDURI_INCHIRIERE VALUES (2, 6, 2, TO_DATE('02-07-2022', 'DD-MM-YYYY'));
INSERT INTO ACORDURI_INCHIRIERE VALUES (3, 7, 3, TO_DATE('14-02-2023', 'DD-MM-YYYY'));
INSERT INTO ACORDURI_INCHIRIERE VALUES (4, 8, 1, TO_DATE('21-11-2023', 'DD-MM-YYYY'));
INSERT INTO ACORDURI_INCHIRIERE VALUES (5, 10, 2, TO_DATE('07-06-2024', 'DD-MM-YYYY'));


---------------------------------------------------------------------------------------------

INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (1, 1, 1, TO_DATE('07-01-2022', 'DD-MM-YYYY'));
INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (6, 2, 2, TO_DATE('02-07-2022', 'DD-MM-YYYY'));
INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (7, 3, 3, TO_DATE('14-02-2023', 'DD-MM-YYYY'));
INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (8, 1, 4, TO_DATE('21-11-2023', 'DD-MM-YYYY'));
INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (10, 2, 5, TO_DATE('07-06-2024', 'DD-MM-YYYY'));
INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (2, 1, 6, TO_DATE('17-11-2022', 'DD-MM-YYYY'));
INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (3, 2, 7, TO_DATE('10-04-2023', 'DD-MM-YYYY'));
INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (4, 3, 8, TO_DATE('22-07-2023', 'DD-MM-YYYY'));
INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (5, 4, 9, TO_DATE('01-11-2023', 'DD-MM-YYYY'));
INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (1, 5, 10, TO_DATE('22-03-2024', 'DD-MM-YYYY'));
INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (2, 1, 11, TO_DATE('17-11-2022', 'DD-MM-YYYY'));
INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (3, 2, 12, TO_DATE('10-04-2023', 'DD-MM-YYYY'));
INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (4, 3, 13, TO_DATE('22-07-2023', 'DD-MM-YYYY'));
INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (5, 4, 14, TO_DATE('01-11-2023', 'DD-MM-YYYY'));
INSERT INTO VIZIONARI (ID_PROPRIETATE, ID_AGENT, ID_CLIENT, DATA_VIZIONARE) VALUES (1, 5, 1, TO_DATE('22-03-2024', 'DD-MM-YYYY'));

---------------------------------------------------------------------------------------------------------------

INSERT INTO CUMPARATORI_PROPRIETATE VALUES (9, 2);
INSERT INTO CUMPARATORI_PROPRIETATE VALUES (10, 9);
INSERT INTO CUMPARATORI_PROPRIETATE VALUES (10, 2);
INSERT INTO CUMPARATORI_PROPRIETATE VALUES (10, 3);
INSERT INTO CUMPARATORI_PROPRIETATE VALUES (11, 4);
INSERT INTO CUMPARATORI_PROPRIETATE VALUES (12, 4);
INSERT INTO CUMPARATORI_PROPRIETATE VALUES (12, 5);
INSERT INTO CUMPARATORI_PROPRIETATE VALUES (13, 9);
INSERT INTO CUMPARATORI_PROPRIETATE VALUES (13, 5);
INSERT INTO CUMPARATORI_PROPRIETATE VALUES (14, 5);
INSERT INTO CUMPARATORI_PROPRIETATE VALUES (14, 3);

----------------------------------------------------------------------------------------------------------------

INSERT INTO CONTRACTE_VANZARE_CUMPARARE (ID_PROPRIETATE, ID_AGENT, DATA_CONTRACT, COMISION_AGENT) VALUES (2, 1, TO_DATE('17-11-2022', 'DD-MM-YYYY'), 2);
INSERT INTO CONTRACTE_VANZARE_CUMPARARE (ID_PROPRIETATE, ID_AGENT, DATA_CONTRACT, COMISION_AGENT) VALUES (3, 2, TO_DATE('10-04-2023', 'DD-MM-YYYY'), 3);
INSERT INTO CONTRACTE_VANZARE_CUMPARARE (ID_PROPRIETATE, ID_AGENT, DATA_CONTRACT, COMISION_AGENT) VALUES (4, 3, TO_DATE('22-07-2023', 'DD-MM-YYYY'), 4);
INSERT INTO CONTRACTE_VANZARE_CUMPARARE (ID_PROPRIETATE, ID_AGENT, DATA_CONTRACT, COMISION_AGENT) VALUES (5, 4, TO_DATE('01-11-2023', 'DD-MM-YYYY'), 5);
INSERT INTO CONTRACTE_VANZARE_CUMPARARE (ID_PROPRIETATE, ID_AGENT, DATA_CONTRACT, COMISION_AGENT) VALUES (1, 5, TO_DATE('22-03-2024', 'DD-MM-YYYY'), 6);
INSERT INTO CONTRACTE_VANZARE_CUMPARARE (ID_PROPRIETATE, ID_AGENT, DATA_CONTRACT, COMISION_AGENT) VALUES (2, 2, TO_DATE('22-03-2024', 'DD-MM-YYYY'), 6);
INSERT INTO CONTRACTE_VANZARE_CUMPARARE (ID_PROPRIETATE, ID_AGENT, DATA_CONTRACT, COMISION_AGENT) VALUES (2, 6, TO_DATE('22-03-2025', 'DD-MM-YYYY'), 7);




-- 6

-- Dandu-se o lista cu pretul mediu pe mp in Cluj, Timisoara, Constanta, Iasi si Craiova,
-- sa se afiseze numarul de apartamente din Bucuresti cu pretul pe mp mai mic, apoi lista acestora.

CREATE OR REPLACE PROCEDURE Comparare_preturi 
IS 
    TYPE tab_ind IS TABLE OF PROPRIETATI%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE vector IS VARRAY(5) OF NUMBER; 
    TYPE tab_imb IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;

   
    orase tab_imb;
    preturi_orase vector := vector(3000, 200, 500, 100, 1000); 
    rezultate tab_ind; 
    v_nr INTEGER := 0; 
    pret_mediu NUMBER;
BEGIN   
    orase(1) := 'Cluj';
    orase(2) := 'Timisoara';
    orase(3) := 'Constanta';
    orase(4) := 'Iasi';
    orase(5) := 'Craiova';

    FOR i IN 1..preturi_orase.COUNT LOOP
       
        pret_mediu := preturi_orase(i);
        v_nr := 0;
        rezultate.DELETE;
      
        FOR c IN (
            SELECT p.*
            FROM PROPRIETATI p
            WHERE p.TIP_CONSTRUCTIE = 'APARTAMENT' AND p.TIP_OFERTA = 'VANZARE'
              AND (p.PRET / p.SUPRAFATA_CONSTRUITA) < pret_mediu
        ) LOOP
            v_nr := v_nr + 1;
            rezultate(v_nr) := c; 
        END LOOP;

        
        DBMS_OUTPUT.PUT_LINE('Pentru ' || orase(i) || ', avand pretul mediu ' || pret_mediu || 
                             ', numarul de apartamente de vanzare in Bucuresti cu pretul pe mp mai mic este: ' || v_nr);

        FOR j IN 1..v_nr LOOP
            DBMS_OUTPUT.PUT_LINE('                  - Apartament ID: ' || rezultate(j).ID_PROPRIETATE || 
                                 ', Pret: ' || rezultate(j).PRET || 
                                 ', Suprafata construita: ' || rezultate(j).SUPRAFATA_CONSTRUITA);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
END Comparare_preturi;
/


BEGIN 
    Comparare_preturi;
END;
/

--7

-- Sa se afiseze toti proprietarii care au adresa de e-mail si sa se afle imobilul cel mai spatios a fiecaruia.
-- Daca un proprietar detine mai multe imobile cu suprafata maxima, se vor afisa toate.
-- Sa se verifice daca fiecare imobil a fost vizionat de cineva. Daca da, sa se afiseze lista clientilor, altfel 
-- sa se afiseze un mesaj corespunzator.


CREATE OR REPLACE PROCEDURE Afisare_Proprietari_Proprietati
IS
   
    CURSOR cursor_proprietari IS
        SELECT ID_PROPRIETAR, PRENUME, NUME
        FROM PROPRIETARI
        WHERE EMAIL IS NOT NULL; -- retinem proprietarii cu email

    
    CURSOR cursor_proprietati_proprietar(p_id_proprietar NUMBER) IS
        SELECT p.ID_PROPRIETATE, p.TIP_CONSTRUCTIE, p.NR_CAMERE, p.SUPRAFATA_CONSTRUITA, p.PRET,
               CURSOR( -- cursor imbricat
                   SELECT c.PRENUME, c.NUME
                   FROM VIZIONARI v
                   JOIN CLIENTI c ON c.ID_CLIENT = v.ID_CLIENT
                   WHERE v.ID_PROPRIETATE = p.ID_PROPRIETATE
               ) AS clienti_ref_cursor
        FROM PROPRIETATI p
        JOIN PROPRIETARI_PROPRIETATE pp ON p.ID_PROPRIETATE = pp.ID_PROPRIETATE
        WHERE pp.ID_PROPRIETAR = p_id_proprietar
          AND p.SUPRAFATA_CONSTRUITA = (
              SELECT MAX(SUPRAFATA_CONSTRUITA)
              FROM PROPRIETATI p2
              JOIN PROPRIETARI_PROPRIETATE pp2 ON p2.ID_PROPRIETATE = pp2.ID_PROPRIETATE
              WHERE pp2.ID_PROPRIETAR = p_id_proprietar
          );

    
    v_id_proprietar NUMBER;
    v_prenume_proprietar VARCHAR2(50);
    v_nume_proprietar VARCHAR2(50);

    v_id_proprietate NUMBER;
    v_tip_constructie VARCHAR2(50);
    v_nr_camere NUMBER;
    v_suprafata NUMBER;
    v_pret NUMBER;
    v_clienti_ref_cursor SYS_REFCURSOR;

    v_prenume_client VARCHAR2(50);
    v_nume_client VARCHAR2(50);
BEGIN
    
    OPEN cursor_proprietari;
    LOOP
        FETCH cursor_proprietari INTO v_id_proprietar, v_prenume_proprietar, v_nume_proprietar;
        EXIT WHEN cursor_proprietari%NOTFOUND; 
        
        -- afisam fiecare proprietar
        DBMS_OUTPUT.PUT_LINE('Proprietar: ' || v_prenume_proprietar || ' ' || v_nume_proprietar);

     
        OPEN cursor_proprietati_proprietar(v_id_proprietar);
        LOOP
            FETCH cursor_proprietati_proprietar INTO v_id_proprietate, v_tip_constructie, v_nr_camere, v_suprafata, v_pret, v_clienti_ref_cursor;
            EXIT WHEN cursor_proprietati_proprietar%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE('  Cea mai spatioasa proprietate:'); -- afisam detaliile proprietatii
            DBMS_OUTPUT.PUT_LINE('    Tip: ' || v_tip_constructie || 
                                 ', Camere: ' || v_nr_camere || 
                                 ', Suprafata: ' || v_suprafata || 
                                 ' mp, Pret: ' || v_pret );

            FETCH v_clienti_ref_cursor INTO v_prenume_client, v_nume_client; -- afisam lista clientilor
            IF v_clienti_ref_cursor%FOUND THEN
                DBMS_OUTPUT.PUT_LINE('    A fost vizionata de urmatorii clienti:');
                LOOP
                    DBMS_OUTPUT.PUT_LINE('      - ' || v_prenume_client || ' ' || v_nume_client);
                    FETCH v_clienti_ref_cursor INTO v_prenume_client, v_nume_client;
                    EXIT WHEN v_clienti_ref_cursor%NOTFOUND;
                END LOOP;
            ELSE
                DBMS_OUTPUT.PUT_LINE('    Proprietatea nu a fost vizionata de nimeni.');
            END IF;
            
            CLOSE v_clienti_ref_cursor;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('');
        CLOSE cursor_proprietati_proprietar;
    END LOOP;

    CLOSE cursor_proprietari;
END Afisare_Proprietari_Proprietati;
/

BEGIN
   Afisare_Proprietari_Proprietati;
END;
/

--------------------------------------



--8

-- Sa se calculeze veniturile totale ale unui agent. Pentru o vanzare, pimeste un procent stabilit in
-- contractul de vanzare-cumparare, iar daca proprietatea este si mobilata, suma primita se dubleaza



CREATE OR REPLACE FUNCTION Suma_Comisioane_Agent(nume_agent in AGENTI.NUME%TYPE) 
RETURN NUMBER
IS
    
    v_suma_comisioane NUMBER := 0;
  
    v_comision_procent NUMBER;
    v_pret_proprietate NUMBER;
    v_comision_proprietate NUMBER;
    v_mobilata detalii_proprietati.mobilata%TYPE;
    
    CURSOR c IS SELECT id_agent, nume FROM agenti;
    
    v_id agenti.id_agent%TYPE;
    v_nume agenti.nume%TYPE;
    v_nr_agenti NUMBER := 0;

    FARA_VANZARI EXCEPTION;
    
BEGIN

    OPEN c; -- parcurgem agentii din baza de date si verificam daca exista un singur agent cu numele dat
    LOOP
        FETCH c INTO v_id, v_nume; 
        EXIT WHEN c%notfound;
        if v_nume = nume_agent THEN 
            v_nr_agenti := v_nr_agenti + 1;
        END IF;
    END LOOP;
    CLOSE c;
    
    IF v_nr_agenti = 0 THEN
        RAISE NO_DATA_FOUND;
    ELSIF v_nr_agenti >=2 THEN
        RAISE TOO_MANY_ROWS;
    END IF;
    
    open c;
    LOOP
        FETCH c into v_id, v_nume;
        EXIT WHEN c%notfound;
        if v_nume = nume_agent then
            EXIT;
        END IF;
    END LOOP;
    CLOSE c;
    
    -- parcurgem contractele agentului, extragem comisionul, ii calculam valoarea si il adaugam sumei
    FOR c2 IN (
        SELECT cv.COMISION_AGENT, p.PRET, d.MOBILATA
        FROM CONTRACTE_VANZARE_CUMPARARE cv
        JOIN PROPRIETATI p ON cv.ID_PROPRIETATE = p.ID_PROPRIETATE
        JOIN DETALII_PROPRIETATI d on p.ID_PROPRIETATE = d.ID_PROPRIETATE
        WHERE cv.ID_AGENT = v_id
    ) LOOP

        v_comision_procent := c2.COMISION_AGENT;
        v_pret_proprietate := c2.PRET;
        v_mobilata := c2.MOBILATA;
        
        v_comision_proprietate := (v_comision_procent / 100) * v_pret_proprietate;
        if v_mobilata = 'DA' then 
            v_comision_proprietate := v_comision_proprietate * 2; -- dublam valoarea daca imobilul e mobilat
        end if;


        v_suma_comisioane := v_suma_comisioane + v_comision_proprietate;
        DBMS_OUTPUT.PUT_LINE('Comision Proprietate: ' || v_comision_proprietate);
    END LOOP;


    IF v_suma_comisioane = 0 THEN
        RAISE FARA_VANZARI; 

    END IF;
    
    RETURN ROUND(v_suma_comisioane, 2); -- returnam suma comisioanelor incasate

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare: Agentul nu exista in baza de date.');      
    WHEN TOO_MANY_ROWS THEN      
        RAISE_APPLICATION_ERROR(-20002, 'Eroare: Exista mai multi agenti cu acest nume in baza de date.');
    WHEN FARA_VANZARI THEN
        DBMS_OUTPUT.PUT_LINE('Agentul nu a vandut niciun imobil.');  
        RETURN 0;
    WHEN OTHERS THEN      
        RAISE_APPLICATION_ERROR(-20004, 'Eroare neasteptata: ' || SQLERRM);
END Suma_Comisioane_Agent;
/


DECLARE
    suma_comisioane NUMBER(10, 2);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Comisioane obtinute de acest agent:');
    suma_comisioane := Suma_Comisioane_Agent('Stan'); -- caz ok
    DBMS_OUTPUT.PUT_LINE('Suma totala a comisioanelor pentru agent este: ' || TO_CHAR(suma_comisioane, '999,999.99'));
END;
/

DECLARE
    suma_comisioane NUMBER(10, 2);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Comisioane obtinute de acest agent:');
    suma_comisioane := Suma_Comisioane_Agent('Antonescu'); -- caz fara vanzari
    DBMS_OUTPUT.PUT_LINE('Suma totala a comisioanelor pentru agent este: ' || TO_CHAR(suma_comisioane, '999,999.99'));
END;
/

DECLARE
    suma_comisioane NUMBER(10, 2);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Comisioane obtinute de acest agent:');
    suma_comisioane := Suma_Comisioane_Agent('Andreescu'); -- caz agent inexistent
    DBMS_OUTPUT.PUT_LINE('Suma totala a comisioanelor pentru agent este: ' || TO_CHAR(suma_comisioane, '999,999.99'));
END;
/

DECLARE
    suma_comisioane NUMBER(10, 2);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Comisioane obtinute de acest agent:');
    suma_comisioane := Suma_Comisioane_Agent('Ivan'); -- caz mai multi cu acelasi nume
    DBMS_OUTPUT.PUT_LINE('Suma totala a comisioanelor pentru agent este: ' || TO_CHAR(suma_comisioane, '999,999.99'));
END;
/


  
----------------------------------------------------------------------------------------------

--Pentru un proprietar si un tip de oferta primite ca parametrii, sa se afiseze 
-- toate proprietatile de tip casa detinute de acel proprietar care au respectivul tip de oferta, 
-- impreuna cu detalii despre suprafata construita, suprafata curtii, cartierul in care 
-- se afla si daca sunt stradale sau nu


--9
CREATE OR REPLACE PROCEDURE Case_proprietar(
    id_prop IN PROPRIETARI.ID_PROPRIETAR%TYPE,
    tip_oferta IN PROPRIETATI.TIP_OFERTA%TYPE
)

IS
  
    v_id_prop PROPRIETARI.ID_PROPRIETAR%TYPE;
    v_oferta PROPRIETATI.TIP_OFERTA%TYPE; 
    v_nr NUMBER := 0;
    v_gasit BOOLEAN := FALSE;
    
    CURSOR c_proprietari IS SELECT ID_PROPRIETAR FROM PROPRIETARI;
    -- exceptii proprii
    FARA_CASE EXCEPTION;
    OFERTA_INVALIDA EXCEPTION;
    
BEGIN
    
    OPEN c_proprietari; -- verificam daca id-ul primit ca param se afla in baza de date
    LOOP
        FETCH c_proprietari INTO v_id_prop;
        EXIT WHEN c_proprietari%NOTFOUND;
        IF v_id_prop = id_prop THEN
            v_gasit := TRUE; 
            EXIT;
        END IF;
        
    END LOOP;
    
    IF v_gasit = FALSE THEN
        RAISE NO_DATA_FOUND;
    END IF;
    
    
    v_oferta := tip_oferta;
    
    IF V_OFERTA <> 'VANZARE' AND V_OFERTA <> 'INCHIRIERE' THEN 
        RAISE OFERTA_INVALIDA;
    END IF;
    
    v_nr :=0;  
    
    -- parcurgem casele cu proprietatile cerute si le afisam
    FOR proprietate IN (  SELECT p.ID_PROPRIETATE, p.SUPRAFATA_CONSTRUITA, c.SUPRAFATA_CURTE, a.CARTIER, d.STRADALA
                FROM PROPRIETATI p
                JOIN PROPRIETARI_PROPRIETATE pp ON p.ID_PROPRIETATE = pp.ID_PROPRIETATE
                JOIN ADRESE a ON p.ID_ADRESA = a.ID_ADRESA
                JOIN CASE c ON p.ID_PROPRIETATE = c.ID_PROPRIETATE
                JOIN DETALII_PROPRIETATI d ON P.ID_PROPRIETATE = d.ID_PROPRIETATE
                WHERE 
                    pp.ID_PROPRIETAR = v_id_prop
                    AND p.TIP_OFERTA = v_oferta) 
        LOOP
            DBMS_OUTPUT.PUT_LINE(' - ID: ' || proprietate.ID_PROPRIETATE || 
                            ', Suprafata construita: ' || proprietate.SUPRAFATA_CONSTRUITA || ' mp ' ||
                          ', suprafata curte: ' || proprietate.SUPRAFATA_CURTE || 
                         ' mp, cartier: ' || proprietate.CARTIER || ', stradala: '|| proprietate.STRADALA);
                         
            v_nr := v_nr + 1;
        END LOOP;
 
        IF v_nr = 0 THEN -- verificam daca s-au gasit casele dorite
            RAISE FARA_CASE;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare: Proprietarul nu exista in baza de date.'); 
    WHEN OFERTA_INVALIDA THEN
        RAISE_APPLICATION_ERROR(-20001, 'Tip de oferta invalid!');
    WHEN FARA_CASE THEN
        DBMS_OUTPUT.PUT_LINE('Eroare: Proprietarul nu detine case in regim de ' || tip_oferta || '.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare neasteptata: ' || SQLERRM);


END Case_Proprietar;
/


BEGIN 
    Case_Proprietar(5, 'VANZARE'); -- caz ok
END;
/

BEGIN 
    Case_Proprietar(1, 'INCHIRIERE'); -- caz ok
END;
/

BEGIN 
    Case_Proprietar(1, 'VANZARE'); -- caz ok
END;
/

BEGIN 
    Case_Proprietar(6, 'VANZARE'); -- caz proprietar fara case in acest regim
END;
/

BEGIN 
    Case_Proprietar(20, 'VANZARE'); -- caz proprietar inexistent
END;
/

BEGIN 
    Case_Proprietar(2, 'IMPRUMUT'); -- caz oferta invalida
END;
/


------------------------------------------------------------------------------------------------

-- 10
-- Se defineste un trigger lmd la nivel de comanda pt tabelul ACORDURI_INCHIRIERE, astfel incat: 
-- inserarea unei proprietati sa nu fi permisa sambata si duminica, 
-- updatarea unei proprietati sa nu fie permisa in afara orelor de  program(8:00 - 16:00)
-- si stergerea unei proprietati sa nu fie permisa

CREATE OR REPLACE TRIGGER trigger_verif_acorduri
BEFORE INSERT OR UPDATE OR DELETE ON ACORDURI_INCHIRIERE
BEGIN

    IF INSERTING THEN
     IF to_char(SYSDATE,'D') = '1' OR to_char(SYSDATE,'D') = '6' OR to_char(SYSDATE,'D') = '7' then
            RAISE_APPLICATION_ERROR(-20011, 'Nu pot fi adaugate acorduri de inchiriere in weekend (vineri, sambata, duminica)!');
        END IF;
    END IF;

    IF UPDATING THEN
        IF to_char(CURRENT_TIMESTAMP,'HH24') NOT BETWEEN 8 AND 16 THEN
            RAISE_APPLICATION_ERROR(-20012, 'Actualizarea acordurilor este permisa doar in timpul programului de lucru (8:00-16:00)!');
        END IF;
    END IF;

    IF DELETING THEN
        RAISE_APPLICATION_ERROR(-20013, 'Nu pot fi șterse acorduri!');
    END IF;
END;
/

INSERT INTO ACORDURI_INCHIRIERE VALUES (12, 1, 1, TO_DATE('07-01-2025', 'DD-MM-YYYY')); -- azi este weekend - vineri(10 ianuarie)

UPDATE ACORDURI_INCHIRIERE
SET ID_AGENT = 3
WHERE ID_ACORD = 1; -- este trecut de ora 16


SELECT TO_CHAR(SYSDATE) FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'D') FROM DUAL;
SELECT TO_CHAR(CURRENT_TIMESTAMP,'HH24') FROM DUAL;

DROP TRIGGER trigger_verif_acorduri;
--------------------------------------------------------------

-- 11

-- Se  defineste un trigger la nivel de linie pt tabelul proprietati. 
-- La fiecare Insert sa se verifice daca proprietatea este deja in tabel si daca
-- pretul pe care il adaug este pozitiv. La fiecare Update se va verifice daca 
-- proprietatea nu isi modifica adresa, daca pretul nou nu este negativ si daca 
-- pretul nou nu a avut o crestere mai mare decat 50% . Daca da, sa se inregistreze 
-- pretul vechi si pretul nou intr-un tabel auxiliar. 


CREATE SEQUENCE SEQ_PROPRIETATE
  START WITH 1
  INCREMENT BY 1;


CREATE TABLE EROARE_UPDATE_PROPRIETATE ( -- in el vom retine scumpirile de peste 50%
    id_er NUMBER PRIMARY KEY,
    pret_vechi NUMBER,
    pret_nou NUMBER
);

CREATE OR REPLACE VIEW view_proprietati AS
SELECT * FROM PROPRIETATI; 


CREATE OR REPLACE TRIGGER TRIGGER_PROPRIETATE
INSTEAD OF INSERT OR UPDATE ON view_proprietati
FOR EACH ROW
DECLARE

    v_pret_vechi VIEW_PROPRIETATI.PRET%TYPE;
    v_pret_nou VIEW_PROPRIETATI.PRET%TYPE;
    
    TYPE T_IMB IS TABLE OF PROPRIETATI.ID_PROPRIETATE%TYPE;
    V_ID T_IMB := T_IMB(); -- ca sa calculez nr elem cu un id_specific
BEGIN
    
    SELECT ID_PROPRIETATE BULK COLLECT INTO V_ID
    FROM PROPRIETATI WHERE ID_PROPRIETATE = :NEW.ID_PROPRIETATE;
    
    IF INSERTING THEN
        -- Verificam daca proprietatea exista deja în tabel
        
        IF v_id.COUNT > 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Proprietatea exista deja in baza de date.');
        END IF;

        -- Verificam daca pretul este pozitiv
        IF :NEW.pret <= 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Pretul trebuie sa fie pozitiv.');
        END IF;
        
        INSERT INTO proprietati
        VALUES (:NEW.id_proprietate, :NEW.tip_constructie, :NEW.tip_oferta, :NEW.pret, :NEW.nr_camere, :NEW.suprafata_construita, :NEW.an_constructie, :NEW.id_adresa);   -- daca totul e ok, inseram 
                                                                                                                                                                        -- va aparea si in view
    END IF;
    
    IF UPDATING THEN
    
        -- Verificam daca adresa a fost schimbata pentru a nu atribui ID-ul altei proprietati
        IF :NEW.id_adresa <> :OLD.id_adresa THEN
            RAISE_APPLICATION_ERROR(-20004, 'ID-ul adresei nu poate fi schimbat (pentru a preveni schimbarea sa cu adresa altei proprietati). ');
        END IF;
        
        -- Verificam daca pretul nou nu este negativ
        v_pret_nou := :NEW.pret;
        IF v_pret_nou < 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Pretul nu poate fi negativ.');
        END IF;

        -- Verificam daca pretul nu a crescut mai mult de 50%
        v_pret_vechi := :OLD.pret;
        IF v_pret_nou > (v_pret_vechi + (0.5 * v_pret_vechi)) THEN
            -- Înregistram într-un tabel auxiliar
            INSERT INTO EROARE_UPDATE_PROPRIETATE
            VALUES (seq_proprietate.NEXTVAL, v_pret_vechi, v_pret_nou);
        END IF;
        
        UPDATE proprietati
        SET id_adresa = :NEW.id_adresa, pret = :NEW.pret
        WHERE id_proprietate = :OLD.id_proprietate; -- modificarea se va vedea si in view

    END IF;
END;
/

INSERT INTO VIEW_PROPRIETATI VALUES (12, 'CASA', 'INCHIRIERE', 2500, 2, 200, 1933, 20); -- e ok

INSERT INTO VIEW_PROPRIETATI VALUES (15, 'CASA', 'INCHIRIERE', -2500, 2, 200, 1933, 21); -- pret negativ!


UPDATE VIEW_PROPRIETATI 
SET ID_ADRESA = 12
WHERE ID_PROPRIETATE = 2; -- adresa nu se poate modif

UPDATE VIEW_PROPRIETATI 
SET PRET = PRET - 3000
WHERE ID_PROPRIETATE = 1; -- pret negativ!

UPDATE VIEW_PROPRIETATI
SET PRET = PRET + 300
WHERE ID_PROPRIETATE = 1; -- e ok

UPDATE VIEW_PROPRIETATI
SET PRET = PRET + 3000
WHERE ID_PROPRIETATE = 8; -- creste cu peste 50%

SELECT * FROM EROARE_UPDATE_PROPRIETATE;

SELECT *  FROM view_proprietati;

UPDATE view_proprietati 
SET PRET = PRET + 10000; -- modifica toate liniile

SELECT *  FROM view_proprietati;

DROP TRIGGER trigger_proprietate;

-----------------------------------------------------------------------------------------
-- 12

-- Sa se introduca datele despre evenimentul produs intr-un tabel auxiliar 
-- la fiecare Create, Alter sau Drop (tipul si numele obiectului afectat, 
-- comanda, userul, ora).


CREATE SEQUENCE seq_ev
     START WITH 1
     INCREMENT BY 1;
     
drop sequence seq_ev;

CREATE TABLE DATE_EVENIMENT ( -- tabelul auxiliar
	ID_EV NUMBER PRIMARY KEY,
	TIP_OBIECT VARCHAR2(100),
	NUME_OBIECT VARCHAR2(100),
	COMANDA VARCHAR2(100),
	TIMP TIMESTAMP,
	UTILIZATOR VARCHAR2(100)
);


CREATE OR REPLACE TRIGGER trigger_eveniment
AFTER CREATE OR ALTER OR DROP ON SCHEMA -- evenimentele
BEGIN
	INSERT INTO date_eveniment (ID_EV,TIP_OBIECT,NUME_OBIECT,COMANDA,TIMP,UTILIZATOR) 
    VALUES (SEQ_EV.NEXTVAL,ORA_DICT_OBJ_TYPE,ORA_DICT_OBJ_NAME,
            ORA_SYSEVENT,SYSTIMESTAMP,SYS_CONTEXT('USERENV', 'SESSION_USER'));
END;
/

CREATE SEQUENCE SEQ_CLIENTI
     START WITH 1
     INCREMENT BY 1;

CREATE TABLE CLIENTI_FIDELI ( 
	ID_CLIENT NUMBER PRIMARY KEY,
	NUME_CLIENT VARCHAR(50),
    PRENUME_CLIENT VARCHAR(50)
);

ALTER TABLE CLIENTI_FIDELI
ADD (EMAIL VARCHAR(50));

DROP SEQUENCE SEQ_CLIENTI;
DROP TABLE CLIENTI_FIDELI;

drop trigger trigger_eveniment;

-- secventa si tabelul nou create, modificarea tabelului, si stergerea
--secventei si a tablelului vor aparea in DATE_EVENIMENT

select * from DATE_EVENIMENT;
