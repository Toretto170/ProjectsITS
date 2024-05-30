/*
------------------------------------------------------------------
------------------------------------------------------------------
                         ROI PROJECT
			     (Versione 2.0 del 04/05/2023)
 SCRIPT SQL PER LA CREAZIONE DELLE TABELLE ED INSERIMENTO RECORD
                       (By Davide Roi)
------------------------------------------------------------------
------------------------------------------------------------------
*/

/*
------------------------------------------------------------------
 Creazione della tabella: ft_azienda
------------------------------------------------------------------
*/ 
CREATE TABLE ft_azienda (
    id_azienda SERIAL NOT NULL,
    ragione_sociale VARCHAR(255) NOT NULL,
    indirizzo VARCHAR(255) NOT NULL,
    settore VARCHAR(255),
    anno_fondazione INTEGER,
    descrizione TEXT,
    sito_web VARCHAR(255),
	dt_update timestamp DEFAULT now(),
    CONSTRAINT const_ft_azienda_pk PRIMARY KEY (id_azienda),
    CONSTRAINT const_ft_azienda_unique UNIQUE (ragione_sociale,indirizzo)
);

/*
------------------------------------------------------------------
 Creazione della tabella: dm_categoria
------------------------------------------------------------------
*/ 
CREATE TABLE dm_categoria (
    id_categoria SERIAL NOT NULL,
    nome VARCHAR(255),
    codice VARCHAR(100),
	dt_update timestamp DEFAULT now(),
    CONSTRAINT const_dm_categoria_pk PRIMARY KEY (id_categoria),
    CONSTRAINT const_ft_dm_categoria_unique UNIQUE (nome)
);

/*
------------------------------------------------------------------
 Creazione della tabella: ft_prodotto
------------------------------------------------------------------
*/ 
CREATE TABLE ft_prodotto (
    id_prodotto SERIAL NOT NULL,
    nome VARCHAR(255),
    descrizione TEXT,
    prezzo DECIMAL(10,2),
    id_azienda INTEGER,
    id_categoria INTEGER,
    valutazione_media DECIMAL(3,2),
    tipologia VARCHAR(100),
	dt_update timestamp DEFAULT now(),
    CONSTRAINT const_ft_prodotto_pk PRIMARY KEY (id_prodotto)
    --,CONSTRAINT const_ft_prodotto_fk1 FOREIGN KEY (id_azienda)  REFERENCES ft_azienda(id_azienda),
    --CONSTRAINT const_ft_prodotto_fk2 FOREIGN KEY (id_categoria)  REFERENCES dm_categoria(id_categoria)
);

/*
------------------------------------------------------------------
 Creazione della tabella: ft_cliente
------------------------------------------------------------------
*/ 
CREATE TABLE ft_cliente (
    id_cliente SERIAL NOT NULL,
    nome VARCHAR(255),
    cognome VARCHAR(255),
    indirizzo VARCHAR(255),
    email VARCHAR(255),
    numero_telefono VARCHAR(20),
    data_nascita DATE,
    professione VARCHAR(255),
	dt_update timestamp DEFAULT now(),
    CONSTRAINT const_ft_cliente_pk PRIMARY KEY (id_cliente),
    CONSTRAINT const_ft_cliente_unique UNIQUE (nome, cognome, data_nascita)
);

/*
------------------------------------------------------------------
 Creazione della tabella: ft_transazione
------------------------------------------------------------------
*/ 
CREATE TABLE ft_transazione (
    id_transazione SERIAL NOT NULL,
    data_transazione DATE,
    importo DECIMAL(10,2),
    id_cliente INTEGER,
    id_prodotto INTEGER,
    metodo_pagamento VARCHAR(255),
    stato_transazione VARCHAR(255),
	dt_update timestamp DEFAULT now(),
    CONSTRAINT const_ft_transazione_pk PRIMARY KEY (id_transazione)
    --,CONSTRAINT const_ft_transazione_fk1 FOREIGN KEY (id_cliente)  REFERENCES ft_cliente(id_cliente),
    --CONSTRAINT const_ft_transazione_fk2 FOREIGN KEY (id_prodotto)  REFERENCES ft_prodotto(id_prodotto)
);

/*
------------------------------------------------------------------
 Creazione della tabella: ft_investimento
------------------------------------------------------------------
*/ 
CREATE TABLE ft_investimento (
    id_investimento SERIAL NOT NULL,
    nome VARCHAR(255),
    descrizione TEXT,
    budget DECIMAL(15,2),
    id_azienda INTEGER,
    tipo_investimento VARCHAR(255),
    data_investimento DATE,
	dt_update timestamp DEFAULT now(),
    CONSTRAINT const_ft_investimento_pk PRIMARY KEY (id_investimento),
    CONSTRAINT const_ft_investimento_unique UNIQUE (nome, tipo_investimento, data_investimento)
    --,CONSTRAINT const_ft_investimento_fk1 FOREIGN KEY (id_azienda)  REFERENCES ft_azienda(id_azienda)
);

/*
------------------------------------------------------------------
 Creazione della tabella: ft_roi
------------------------------------------------------------------
*/ 
CREATE TABLE ft_roi (
    id_roi SERIAL NOT NULL,
    data DATE,
    valore DECIMAL(6,2),
    id_investimento INTEGER,
    descrizione TEXT,
    periodo_analizzato_inizio DATE,
    periodo_analizzato_fine DATE,
	dt_update timestamp DEFAULT now(),
    CONSTRAINT const_ft_roi_pk PRIMARY KEY (id_roi)
    --CONSTRAINT const_ft_roi_fk1 FOREIGN KEY (id_investimento)  REFERENCES ft_investimento(id_investimento)
);

/*
------------------------------------------------------------------
 Creazione della tabella: ft_recensione
------------------------------------------------------------------
*/ 
CREATE TABLE ft_recensione (
    id_recensione SERIAL NOT NULL,
    testo TEXT,
    voto INTEGER,
    id_cliente INTEGER,
    id_prodotto INTEGER,
	dt_update timestamp DEFAULT now(),
    CONSTRAINT const_ft_recensione_pk PRIMARY KEY (id_recensione)
    --CONSTRAINT const_ft_recensione_fk1 FOREIGN KEY (id_cliente)  REFERENCES ft_cliente(id_cliente),
    --CONSTRAINT const_ft_recensione_fk2 FOREIGN KEY (id_prodotto)  REFERENCES ft_prodotto(id_prodotto)
);

/*
------------------------------------------------------------------
------------------------------------------------------------------
 SCRIPT SQL PER L' INSERIMENTO DEI RECORD NELLE TABELLE
------------------------------------------------------------------
------------------------------------------------------------------
*/ 

/*
------------------------------------------------------------------
 Inserimento record nella tabella: ft_azienda
------------------------------------------------------------------
*/ 
INSERT INTO ft_azienda (ragione_sociale, indirizzo, settore, anno_fondazione, descrizione, sito_web)
VALUES ('Banco di Napoli', 'Via Roma, 101', 'Banca', 1800, 'Banca storica italiana', 'www.bancodinapoli.it'),
       ('FintechLab', 'Via Dante, 10', 'Start-up', 2015, 'Incubatore di start-up fintech', 'www.fintechlab.it'),
       ('Intesa Sanpaolo', 'Piazza San Carlo, 156', 'Banca', 1823, 'Gruppo bancario italiano', 'www.intesasanpaolo.com'),
       ('Moneyfarm', 'Piazza della Scala, 2', 'Gestione patrimoniale', 2011, 'Servizio di gestione patrimoniale online', 'www.moneyfarm.it'),
       ('N26', 'Piazza San Babila, 3', 'Banca', 2013, 'Banca online europea', 'www.n26.com');

/*
------------------------------------------------------------------
 Inserimento record nella tabella: dm_categoria
------------------------------------------------------------------
*/ 
INSERT INTO dm_categoria (nome,codice) 
VALUES ('Servizi bancari','BB'), 
       ('Assicurazioni','AA'), 
       ('Investimenti','II'), 
       ('Finanza partecipativa','AA');
	
/*
------------------------------------------------------------------
 Inserimento record nella tabella: ft_investimento
------------------------------------------------------------------
*/ 
INSERT INTO ft_investimento (nome, descrizione, budget, id_azienda, tipo_investimento, data_investimento)
VALUES ('Fondo comune di investimento', 'Investimento a basso rischio', 5000.00, 1, 'Titoli azionari', '2021-01-01'),
       ('Obbligazioni', 'Investimento a medio rischio', 8000.00, 2, 'Titoli obbligazionari', '2021-02-01'),
       ('Azioni', 'Investimento a alto rischio', 10000.00, 1, 'Titoli azionari', '2021-03-01'),
       ('Cambio valuta', 'Investimento a rischio variabile', 5000.00, 3, 'Forex', '2021-04-01'),
       ('Derivati', 'Investimento ad alto rischio', 15000.00, 2, 'Opzioni', '2021-05-01'),
       ('Fondo comune di investimento', 'Investimento a basso rischio', 2000.00, 1, 'Titoli azionari', '2011-02-12'),
       ('Fondo comune di investimento', 'Investimento a basso rischio', 3400.00, 1, 'Titoli azionari', '2011-03-04'),
       ('Fondo comune di investimento', 'Investimento a basso rischio', 560.00, 1, 'Titoli azionari', '2011-05-11'),
       ('Obbligazioni', 'Investimento a medio rischio', 8000.00, 1, 'Titoli obbligazionari', '2011-02-15'),
       ('Obbligazioni', 'Investimento a medio rischio', 8000.00, 1, 'Titoli obbligazionari', '2011-07-11'),
       ('Obbligazioni', 'Investimento a medio rischio', 8000.00, 5, 'Titoli obbligazionari', '2011-08-16'),
       ('Obbligazioni', 'Investimento a medio rischio', 8000.00, 1, 'Titoli obbligazionari', '2011-09-17'),
       ('Azioni', 'Investimento a alto rischio', 1000.00, 1, 'Titoli azionari', '2011-03-01'),
       ('Azioni', 'Investimento a alto rischio', 2900.00, 1, 'Titoli azionari', '2011-03-21'),
       ('Azioni', 'Investimento a alto rischio', 4200.00, 1, 'Titoli azionari', '2011-03-22'),
       ('Azioni', 'Investimento a alto rischio', 7600.00, 1, 'Titoli azionari', '2011-03-23'),
       ('Azioni', 'Investimento a alto rischio', 9600.00, 1, 'Titoli azionari', '2011-03-24'),
       ('Cambio valuta', 'Investimento a rischio variabile', 1500.00, 1, 'Forex', '2014-01-01'),
       ('Cambio valuta', 'Investimento a rischio variabile', 2500.00, 1, 'Forex', '2014-01-02'),
       ('Cambio valuta', 'Investimento a rischio variabile', 4250.00, 5, 'Forex', '2014-01-03'),
       ('Cambio valuta', 'Investimento a rischio variabile',  100.00, 5, 'Forex', '2014-01-06'),
       ('Cambio valuta', 'Investimento a rischio variabile', 1210.00, 1, 'Forex', '2015-01-01'),
       ('Derivati', 'Investimento ad alto rischio', 2300.00, 1, 'Opzioni', '2015-05-01'),
       ('Derivati', 'Investimento ad alto rischio', 3400.00, 1, 'Opzioni', '2015-04-01'),
       ('Derivati', 'Investimento ad alto rischio',  450.00, 1, 'Opzioni', '2015-03-01'),
       ('Derivati', 'Investimento ad alto rischio', 5600.00, 1, 'Opzioni', '2012-02-01'),
       ('Derivati', 'Investimento ad alto rischio', 6700.00, 1, 'Opzioni', '2012-01-01'),
       ('Fondo comune di investimento', 'Investimento a basso rischio', 200.00, 2, 'Titoli azionari', '2020-02-12'),
       ('Fondo comune di investimento', 'Investimento a basso rischio', 340.00, 2, 'Titoli azionari', '2020-03-04'),
       ('Fondo comune di investimento', 'Investimento a basso rischio',  5600.00, 2, 'Titoli azionari', '2023-05-11'),
       ('Obbligazioni', 'Investimento a medio rischio', 2000.00, 2, 'Titoli obbligazionari', '2020-02-15'),
       ('Obbligazioni', 'Investimento a medio rischio', 1000.00, 2, 'Titoli obbligazionari', '2020-07-11'),
       ('Obbligazioni', 'Investimento a medio rischio', 3000.00, 2, 'Titoli obbligazionari', '2020-08-16'),
       ('Obbligazioni', 'Investimento a medio rischio', 4000.00, 2, 'Titoli obbligazionari', '2020-09-17'),
       ('Azioni', 'Investimento a alto rischio', 2000.00, 2, 'Titoli azionari', '2020-03-01'),
       ('Azioni', 'Investimento a alto rischio', 1900.00, 2, 'Titoli azionari', '2020-03-21'),
       ('Azioni', 'Investimento a alto rischio', 3200.00, 2, 'Titoli azionari', '2020-03-22'),
       ('Azioni', 'Investimento a alto rischio', 8600.00, 2, 'Titoli azionari', '2020-03-23'),
       ('Azioni', 'Investimento a alto rischio', 8400.00, 2, 'Titoli azionari', '2020-03-24'),
       ('Cambio valuta', 'Investimento a rischio variabile', 2525.00, 2, 'Forex', '2019-01-01'),
       ('Cambio valuta', 'Investimento a rischio variabile', 1532.00, 2, 'Forex', '2019-01-02'),
       ('Cambio valuta', 'Investimento a rischio variabile', 4450.00, 6, 'Forex', '2019-01-03'),
       ('Cambio valuta', 'Investimento a rischio variabile',  222.00, 2, 'Forex', '2019-01-06'),
       ('Cambio valuta', 'Investimento a rischio variabile', 3333.00, 2, 'Forex', '2019-01-04'),
       ('Derivati', 'Investimento ad alto rischio', 3330.00, 2, 'Opzioni', '2019-05-01'),
       ('Derivati', 'Investimento ad alto rischio', 444.00, 2, 'Opzioni', '2019-04-01'),
       ('Derivati', 'Investimento ad alto rischio',  550.00, 2, 'Opzioni', '2019-03-01'),
       ('Derivati', 'Investimento ad alto rischio', 800.00, 2, 'Opzioni', '2019-01-01'),
       ('Derivati', 'Investimento ad alto rischio', 3700.00, 2, 'Opzioni', '2019-02-01'),
       ('Fondo comune di investimento', 'Investimento a basso rischio', 1000.00, 3, 'Titoli azionari', '2018-02-12'),
       ('Fondo comune di investimento', 'Investimento a basso rischio', 300.00, 3, 'Titoli azionari', '2018-03-04'),
       ('Fondo comune di investimento', 'Investimento a basso rischio',  160.00, 3, 'Titoli azionari', '2018-05-11'),
       ('Obbligazioni', 'Investimento a medio rischio', 2300.50, 3, 'Titoli obbligazionari', '2018-02-15'),
       ('Obbligazioni', 'Investimento a medio rischio', 3400.00, 3, 'Titoli obbligazionari', '2018-07-11'),
       ('Obbligazioni', 'Investimento a medio rischio', 1200.50, 3, 'Titoli obbligazionari', '2018-08-16'),
       ('Obbligazioni', 'Investimento a medio rischio', 1100.00, 3, 'Titoli obbligazionari', '2018-09-17'),
       ('Azioni', 'Investimento a alto rischio', 106.50, 3, 'Titoli azionari', '2018-03-01'),
       ('Azioni', 'Investimento a alto rischio', 207.00, 3, 'Titoli azionari', '2018-03-21'),
       ('Azioni', 'Investimento a alto rischio', 208.50, 3, 'Titoli azionari', '2018-03-22'),
       ('Azioni', 'Investimento a alto rischio', 609.00, 3, 'Titoli azionari', '2018-03-23'),
       ('Azioni', 'Investimento a alto rischio', 301.50, 3, 'Titoli azionari', '2018-03-24'),
       ('Cambio valuta', 'Investimento a rischio variabile', 2500.00, 3, 'Forex', '2018-01-01'),
       ('Cambio valuta', 'Investimento a rischio variabile', 1500.50, 3, 'Forex', '2018-01-02'),
       ('Cambio valuta', 'Investimento a rischio variabile', 5550.00, 7, 'Forex', '2018-01-03'),
       ('Cambio valuta', 'Investimento a rischio variabile',  666.50, 7, 'Forex', '2018-01-06'),
       ('Cambio valuta', 'Investimento a rischio variabile', 310.00, 3, 'Forex', '2018-01-04'),
       ('Derivati', 'Investimento ad alto rischio', 301.00, 3, 'Opzioni', '2018-05-01'),
       ('Derivati', 'Investimento ad alto rischio', 402.00, 7, 'Opzioni', '2018-04-01'),
       ('Derivati', 'Investimento ad alto rischio',  53.00, 7, 'Opzioni', '2018-03-01'),
       ('Derivati', 'Investimento ad alto rischio', 504.00, 7, 'Opzioni', '2018-01-01'),
       ('Derivati', 'Investimento ad alto rischio', 605.00, 3, 'Opzioni', '2018-03-03');

/*
------------------------------------------------------------------
 Inserimento record nella tabella: ft_prodotto
------------------------------------------------------------------
*/ 
INSERT INTO ft_prodotto (nome, descrizione, prezzo, id_azienda, id_categoria, valutazione_media, tipologia)
VALUES ('Conto corrente', 'Conto corrente bancario', 0, 1, 1, 4.5, '1'),
       ('Assicurazione auto', 'Assicurazione auto online', 250, 3, 2, 4.2, '2'),
       ('Piano di ft_investimento', 'Servizio di gestione patrimoniale', 10000, 4, 3, 4.8, '1'),
       ('Carta di credito', 'Carta di credito internazionale', 0, 5, 1, 4.6, '1'),
       ('Crowdfunding', 'Finanziamento collaborativo per progetti', 5000, 2, 4, 3.9, '2'),
       ('Assicurazione casa', 'Assicurazione riparazioni casa', 5000, 6, 22, 3.9, '8');

/*
------------------------------------------------------------------
 Inserimento record nella tabella: ft_cliente
------------------------------------------------------------------
*/ 
INSERT INTO ft_cliente (nome, cognome, indirizzo, email, numero_telefono, data_nascita, professione)
VALUES ('Mario', 'Rossi', 'Via Garibaldi, 3', 'mario.rossi@email.com', '+390123456789', '1990-01-01', 'Impiegato'),
       ('Anna', 'Bianchi', 'Via Dante, 5', 'anna.bianchi@email.com', '+390987654321', '1985-03-15', 'Libera professionista'),
       ('Luigi', 'Verdi', 'Via Roma, 10', 'luigi.verdi@email.com', '+390246810123', '1995-12-31', 'Studente'),
       ('Davide', 'Rossi', 'Via Garibaldi, 3', NULL, '+390123456789', '1990-01-01', 'Impiegato'),
       ('Michele', 'Rossi', 'Via Mistero, 4', NULL, '+390345678901', '1976-03-12', 'Impiegato'),
       ('Franco', 'Rossi', 'Piazza castello, 5', 'franco.rossi@email.com', NULL, '1981-11-28', 'Operaio'),
       ('Rossella', 'Rossi', 'Corso Francia, 44', 'rossella.rossi@email.com', '+390444456766', '1991-02-21', 'Impiegato'),
       ('Anna', 'Bianchi', 'Via Dante, 5', NULL, NULL, '1990-03-15', 'Libera professionista'),
       ('Aldo', 'Verdi', 'Via Roma, 10', 'luigi.verdi@email.com', '+390246810123', '1995-12-31', 'Studente'),
       ('Giuseppe', 'Verdi', 'Via adda, 55', 'giuseppe.verdi@email.com', '+390423454342', '1990-07-12', 'Studente');

/*
------------------------------------------------------------------
 Inserimento record nella tabella: ft_transazione
------------------------------------------------------------------
*/ 
INSERT INTO ft_transazione (data_transazione, importo, id_cliente, id_prodotto, metodo_pagamento, stato_transazione)
VALUES ('2022-02-15', 1200, 1, 1, 'Bonifico', 'Completata'),
       ('2022-02-20', 500, 2, 3, 'Addebito su conto', 'Completata'),
       ('2022-02-25', 200, 3, 4, 'Carta di credito', 'Completata'), 
       ('2022-02-28', 10000, 1, 3, 'Bonifico', 'In attesa'), 
	   ('2022-03-05', 5000, 2, 5, 'Bonifico', 'Completata'),
	   ('2010-02-03', 1200,  1, 1, 'Bonifico',           'Completata'),
	   ('2010-02-04', 1000,  1, 1, 'Addebito su conto',  'In attesa' ), 
	   ('2010-02-05', 5000,  1, 2, 'Carta di credito',   'Completata'),
	   ('2010-03-06', 5000,  1, 3, 'Bonifico',           'Completata'),
	   ('2010-02-07', 2000,  1, 4, 'Addebito su conto',  'Completata'), 
	   ('2010-02-08', 5000,  1, 5, 'Carta di credito',   'Completata'),
	   ('2011-02-03', 2200,  2, 1, 'Bonifico',           'Completata'),
	   ('2011-07-04', 3000,  2, 1, 'Addebito su conto',  'Completata'), 
	   ('2011-02-05', 6000,  2, 2, 'Carta di credito',   'Completata'),
	   ('2011-06-06', 5230,  2, 3, 'Bonifico',           'In attesa' ),
	   ('2011-02-07', 1200,  333, 4, 'Addebito su conto',  'Completata'), 
	   ('2011-06-08', 2300,  2, 5, 'Carta di credito',   'Completata'),
	   ('2013-05-03', 2200,  3, 1, 'Addebito su conto',  'Completata'),
	   ('2013-05-04', 3000,  3, 1, 'Addebito su conto',  'Completata'), 
	   ('2013-03-05', 6000,  3, 46, 'Carta di credito',   'Completata'),
	   ('2013-04-06', 5230,  3, 3, 'Bonifico',           'Completata'),
	   ('2013-02-07', 1200,  3, 4, 'Carta di credito',  'Completata'), 
	   ('2013-02-08', 2300,  333, 5, 'Carta di credito',   'In attesa' ),
	   ('2014-02-03', 2200,  4, 1, 'Bonifico',           'In attesa' ),
	   ('2014-02-11', 3000,  4, 46, 'Addebito su conto',  'Completata'), 
	   ('2014-02-05', 6000,  4, 2, 'Carta di credito',   'Completata'),
	   ('2014-03-11', 5230,  4, 3, 'Addebito su conto',  'Completata'),
	   ('2014-02-12', 1200,  4, 4, 'Addebito su conto',  'Completata'), 
	   ('2014-02-09', 2300,  4, 5, 'Carta di credito',   'Completata'),
	   ('2015-02-15', 2200,  2, 1, 'Bonifico',           'Completata'),
	   ('2015-02-14', 3000,  2, 1, 'Carta di credito',   'Completata'), 
	   ('2015-02-15', 6000,  444, 44, 'Carta di credito',   'Completata'),
	   ('2015-03-16', 5230,  444, 44, 'Carta di credito',   'Completata'),
	   ('2015-02-17', 1200,  444, 46, 'Carta di credito',   'Completata'), 
	   ('2015-02-18', 2300,  555, 55, 'Carta di credito',    'In attesa');

/*
------------------------------------------------------------------
 Inserimento record nella tabella: ft_recensione
------------------------------------------------------------------
*/ 
INSERT INTO ft_recensione (testo, voto, id_cliente, id_prodotto) 
VALUES ('Ottimo servizio clienti', 5, 1, 1), 
       ('Buon rapporto qualità-prezzo', 4, 2, 1), 
       ('Molto soddisfatto', 5, 1, 3), 
       ('Distinto', 4, 3, 3), 
       ('Un po'' deludente', 3, 2, 4),
	   ('Ottima gestione, ci siamo trovati bene', 5, 1, 1), 
       ('Buon rapporto qualità-prezzo', 4, 2, 1), 
       ('Molto soddisfatto', 5, 1, 3), 
       ('Consigliato', 4, 3, 3), 
       ('Un po deludente', 3, 2, 4),
       ('Tutto perfetto', 5, 1, 2), 
       ('Buon rapporto qualità-prezzo', 4, 1, 1), 
       ('Molto soddisfatto', 5, 1, 5), 
       ('Solo un po lenti nella gestione del cliente, per il resto buono', 4, 1, 4),
       ('Ottimo servizio clienti', 5, 2, 3), 
       ('Pienamente soddisfatto', 5, 2, 5), 
       ('Deludente', 3, 2, 2),
       ('Ottimo servizio clienti', 5, 3, 2), 
       ('Buon rapporto qualità-prezzo', 4, 3, 1), 
       ('Soddisfatto', 5, 3, 5), 
       ('Poca qualità nel servizio', 3, 3, 4),
       ('Ottimo servizio clienti', 5, 4, 5), 
       ('Buon rapporto qualità-prezzo', 4, 4, 2), 
       ('Molto precisi', 5, 4, 4), 
       ('Consigliato', 4, 4, 3), 
       ('Un po deludente', 3, 4, 1),
       ('Ottimo servizio clienti', 5, 5, 2), 
       ('Buon rapporto qualità-prezzo', 4, 555, 111), 
       ('Molto soddisfatto', 5, 5, 5), 
       ('Gestione del cliente da migliorare secondo me', 4, 5, 3), 
       ('Da migliorare', 3, 5, 4),
       ('Ottimo servizio clienti', 5, 66, 5), 
       ('Buon rapporto qualità-prezzo', 4, 6, 44), 
       ('Molto soddisfatto', 5, 6, 3), 
       ('Consigliato', 4, 6, 44), 
       ('Un po deludente', 3, 6, 1),
       ('Ottimo servizio clienti', 5, 7, 1), 
       ('Buon rapporto qualità-prezzo', 4, 7, 44), 
       ('Molto soddisfatto', 5, 7, 2), 
       ('Consigliato', 4, 7, 5), 
       ('Mediocre, dovete seguire meglio il cliente', 3, 7, 3),
       ('Ottimo servizio clienti', 5, 8, 1), 
       ('Buon rapporto qualità-prezzo', 4, 8, 2), 
       ('Molto soddisfatto', 5, 8, 3), 
       ('Consigliato', 4, 8, 4), 
       ('Un po deludente', 3, 8, 5);	   

/*
------------------------------------------------------------------
 Inserimento record nella tabella: ft_roi
------------------------------------------------------------------
*/ 
INSERT INTO ft_roi (valore, data, id_investimento, descrizione, periodo_analizzato_inizio, periodo_analizzato_fine )
VALUES (10, '2022-01-01', 1, 'Recensione positiva', '2022-01-01','2022-03-31'),
       (8,  '2022-02-01', 1, 'Recensione negativa', '2022-04-01','2022-06-30'),
       (11, '2022-03-01', 1, 'poco margine', '2022-07-01','2022-08-30'),
       (7,  '2022-04-01', 1, 'bassa resa', '2022-09-01','2022-10-30'),
       (7,  '2022-05-01', 111, 'bassa resa', '2022-01-01','2022-3-30'),
       (21, '2022-06-01', 222, 'buono', '2022-04-01','2022-6-30'),
       (12, '2022-02-01', 2, 'Recensione neutra',   '2022-01-01','2022-03-31'),
       (15, '2022-03-01', 3, 'Recensione positiva', '2022-01-01','2022-06-30'),
       (5,  '2022-03-01', 4, 'Recensione neutra',   '2022-01-01','2022-12-31');

