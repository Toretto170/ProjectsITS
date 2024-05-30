CREATE TABLE ft_azienda (
    id SERIAL NOT NULL,
    ragione_sociale VARCHAR(255) NOT NULL,
    indirizzo VARCHAR(255) NOT NULL,
    settore VARCHAR(255),
    anno_fondazione INTEGER,
    descrizione TEXT,
    sito_web VARCHAR(255),
    CONSTRAINT const_ft_azienda_pk PRIMARY KEY (id),
    CONSTRAINT const_ft_azienda_unique UNIQUE (ragione_sociale,indirizzo)
);

-- Creazione tabella dm_categoria
CREATE TABLE dm_categoria (
    id SERIAL NOT NULL,
    nome VARCHAR(255) NOT NULL,
    CONSTRAINT const_dm_categoria_pk PRIMARY KEY (id),
    CONSTRAINT const_ft_dm_categoria_unique UNIQUE (nome)
);

-- Creazione tabella ft_prodotto
CREATE TABLE ft_prodotto (
    id SERIAL NOT NULL,
    nome VARCHAR(255),
    descrizione TEXT,
    prezzo DECIMAL(10,2),
    azienda INTEGER NOT NULL,
    categoria INTEGER NOT NULL,
    valutazione_media DECIMAL(3,2),
    CONSTRAINT const_ft_prodotto_pk PRIMARY KEY (id),
    CONSTRAINT const_ft_prodotto_fk1 FOREIGN KEY (azienda)  REFERENCES ft_azienda(id),
    CONSTRAINT const_ft_prodotto_fk2 FOREIGN KEY (categoria)  REFERENCES dm_categoria(id)
);

-- Creazione tabella ft_cliente
CREATE TABLE ft_cliente (
    id SERIAL NOT NULL,
    nome VARCHAR(255),
    cognome VARCHAR(255),
    indirizzo VARCHAR(255),
    email VARCHAR(255),
    numero_telefono VARCHAR(20),
    data_nascita DATE,
    professione VARCHAR(255),
    CONSTRAINT const_ft_cliente_pk PRIMARY KEY (id),
    CONSTRAINT const_ft_cliente_unique UNIQUE (nome, cognome, data_nascita)
);

-- Creazione tabella ft_transazione
CREATE TABLE ft_transazione (
    id SERIAL NOT NULL,
    data_transazione DATE,
    importo DECIMAL(10,2),
    cliente INTEGER NOT NULL,
    prodotto INTEGER NOT NULL,
    metodo_pagamento VARCHAR(255),
    stato_transazione VARCHAR(255),
    CONSTRAINT const_ft_transazione_pk PRIMARY KEY (id),
    CONSTRAINT const_ft_transazione_fk1 FOREIGN KEY (cliente)  REFERENCES ft_cliente(id),
    CONSTRAINT const_ft_transazione_fk2 FOREIGN KEY (prodotto)  REFERENCES ft_prodotto(id)
);

-- Creazione tabella ft_investimento
CREATE TABLE ft_investimento (
    id SERIAL NOT NULL,
    nome VARCHAR(255),
    descrizione TEXT,
    budget DECIMAL(15,2),
    azienda INTEGER NOT NULL,
    tipo_investimento VARCHAR(255),
    data_investimento DATE,
    CONSTRAINT const_ft_investimento_pk PRIMARY KEY (id),
    CONSTRAINT const_ft_investimento_fk1 FOREIGN KEY (azienda)  REFERENCES ft_azienda(id),
    CONSTRAINT const_ft_investimento_unique UNIQUE (nome, tipo_investimento, data_investimento)
);







-- Creazione tabella ft_roi
CREATE TABLE ft_roi (
    id SERIAL NOT NULL,
    data DATE,
    valore DECIMAL(6,2),
    investimento INTEGER REFERENCES ft_investimento(id),
    descrizione TEXT,
    periodo_analizzato_inizio DATE,
    periodo_analizzato_fine DATE,
    CONSTRAINT const_ft_roi_pk PRIMARY KEY (id),
    CONSTRAINT const_ft_roi_fk1 FOREIGN KEY (investimento)  REFERENCES ft_investimento(id)
);

-- Creazione tabella ft_recensione
CREATE TABLE ft_recensione (
    id SERIAL NOT NULL,
    testo TEXT NOT NULL,
    voto INTEGER NOT NULL,
    cliente INTEGER NOT NULL,
    prodotto INTEGER NOT NULL,
    CONSTRAINT const_ft_recensione_pk PRIMARY KEY (id),
    CONSTRAINT const_ft_recensione_fk1 FOREIGN KEY (cliente)  REFERENCES ft_cliente(id),
    CONSTRAINT const_ft_recensione_fk2 FOREIGN KEY (prodotto)  REFERENCES ft_prodotto(id)
);
-------------------------------------------
--SCRIPT SQL PER L' INSERIMENTO DEI RECORD NELLE TABELLE
-------------------------------------------
-- Inserimento record nella tabella ft_azienda
INSERT INTO ft_azienda (ragione_sociale, indirizzo, settore, anno_fondazione, descrizione, sito_web)
VALUES ('Banco di Napoli', 'Via Roma, 101', 'Banca', 1800, 'Banca storica italiana', 'www.bancodinapoli.it'),
       ('FintechLab', 'Via Dante, 10', 'Start-up', 2015, 'Incubatore di start-up fintech', 'www.fintechlab.it'),
       ('Intesa Sanpaolo', 'Piazza San Carlo, 156', 'Banca', 1823, 'Gruppo bancario italiano', 'www.intesasanpaolo.com'),
       ('Moneyfarm', 'Piazza della Scala, 2', 'Gestione patrimoniale', 2011, 'Servizio di gestione patrimoniale online', 'www.moneyfarm.it'),
       ('N26', 'Piazza San Babila, 3', 'Banca', 2013, 'Banca online europea', 'www.n26.com');

-- Inserimento record nella tabella dm_categoria
INSERT INTO dm_categoria (nome) 
VALUES ('Servizi bancari'), 
       ('Assicurazioni'), 
       ('Investimenti'), 
	 ('Finanza partecipativa');
	
-- Inserimento dati nella tabella Investimento
INSERT INTO ft_investimento (nome, descrizione, budget, azienda, tipo_investimento, data_investimento)
VALUES ('Fondo comune di investimento', 'Investimento a basso rischio', 5000.00, 1, 'Titoli azionari', '2021-01-01'),
       ('Obbligazioni', 'Investimento a medio rischio', 8000.00, 2, 'Titoli obbligazionari', '2021-02-01'),
       ('Azioni', 'Investimento a alto rischio', 10000.00, 1, 'Titoli azionari', '2021-03-01'),
       ('Cambio valuta', 'Investimento a rischio variabile', 5000.00, 3, 'Forex', '2021-04-01'),
       ('Derivati', 'Investimento ad alto rischio', 15000.00, 2, 'Opzioni', '2021-05-01');


-- Inserimento record nella tabella ft_prodotto
INSERT INTO ft_prodotto (nome, descrizione, prezzo, azienda, categoria, valutazione_media)
VALUES ('Conto corrente', 'Conto corrente bancario', 0, 1, 1, 4.5),
       ('Assicurazione auto', 'Assicurazione auto online', 250, 3, 2, 4.2),
       ('Piano di ft_investimento', 'Servizio di gestione patrimoniale', 10000, 4, 3, 4.8),
       ('Carta di credito', 'Carta di credito internazionale', 0, 5, 1, 4.6),
       ('Crowdfunding', 'Finanziamento collaborativo per progetti', 5000, 2, 4, 3.9);

-- Inserimento record nella tabella ft_cliente
INSERT INTO ft_cliente (nome, cognome, indirizzo, email, numero_telefono, data_nascita, professione)
VALUES ('Mario', 'Rossi', 'Via Garibaldi, 3', 'mario.rossi@email.com', '+390123456789', '1990-01-01', 'Impiegato'),
       ('Anna', 'Bianchi', 'Via Dante, 5', 'anna.bianchi@email.com', '+390987654321', '1985-03-15', 'Libera professionista'),
       ('Luigi', 'Verdi', 'Via Roma, 10', 'luigi.verdi@email.com', '+390246810123', '1995-12-31', 'Studente');
-- AGGIUNTA Inserimento record nella tabella ft_cliente
INSERT INTO ft_cliente (nome, cognome, indirizzo, email, numero_telefono, data_nascita, professione)
VALUES ('Davide', 'Rossi', 'Via Garibaldi, 3', NULL, '+390123456789', '1990-01-01', 'Impiegato'),
	 	 ('Michele', 'Rossi', 'Via Mistero, 4', NULL, '+390345678901', '1976-03-12', 'Impiegato'),
       ('Franco', 'Rossi', 'Piazza castello, 5', 'franco.rossi@email.com', NULL, '1981-11-28', 'Operaio'),
       ('Rossella', 'Rossi', 'Corso Francia, 44', 'rossella.rossi@email.com', '+390444456766', '1991-02-21', 'Impiegato'),
       ('Anna', 'Bianchi', 'Via Dante, 5', NULL, NULL, '1990-03-15', 'Libera professionista'),
       ('Aldo', 'Verdi', 'Via Roma, 10', 'luigi.verdi@email.com', '+390246810123', '1995-12-31', 'Studente'),
       ('Giuseppe', 'Verdi', 'Via adda, 55', 'giuseppe.verdi@email.com', '+390423454342', '1990-07-12', 'Studente');
-- Inserimento record nella tabella ft_transazione
INSERT INTO ft_transazione (data_transazione, importo, cliente, prodotto, metodo_pagamento, stato_transazione)
VALUES ('2022-02-15', 1200, 1, 1, 'Bonifico', 'Completata'),
       ('2022-02-20', 500, 2, 3, 'Addebito su conto', 'Completata'),
       ('2022-02-25', 200, 3, 4, 'Carta di credito', 'Completata'), 
       ('2022-02-28', 10000, 1, 3, 'Bonifico', 'In attesa'), 
	   ('2022-03-05', 5000, 2, 5, 'Bonifico', 'Completata');

-- Inserimento record nella tabella ft_recensione 
INSERT INTO ft_recensione (testo, voto, cliente, prodotto) 
VALUES ('Ottimo servizio clienti', 5, 1, 1), 
       ('Buon rapporto qualità-prezzo', 4, 2, 1), 
       ('Molto soddisfatto', 5, 1, 3), 
       ('Consigliato', 4, 3, 3), 
       ('Un po'' deludente', 3, 2, 4);

-- Inserimento dati nella tabella ROI
INSERT INTO ft_roi (valore, data, investimento, descrizione, periodo_analizzato_inizio, periodo_analizzato_fine )
VALUES (10, '2022-01-01', 1, 'Recensione positiva', '2022-01-01','2022-03-31'),
       (12, '2022-02-01', 2, 'Recensione neutra',  '2022-01-01','2022-03-31'),
       (8, '2022-02-01', 1, 'Recensione negativa',  '2022-01-01','2022-06-30'),
       (15, '2022-03-01', 3, 'Recensione positiva',  '2022-01-01','2022-06-30'),
       (5, '2022-03-01', 4, 'Recensione neutra',  '2022-01-01','2022-12-31');


