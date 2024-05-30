/*
 Tabella che monitora l'esecuzione di tutti i miei processi 
 Questa tabella è fondamentale per poter verificare l'esecuzione corretta dei
 processi automatizzati, qualsiasi essi siano:
	 TRATTAMENTO DATI
	 CONTROLLI DI CONSISTENZA DATI
	 CALCOLO DI KPI
	 TRASPORTO DATI
	 ecc..
*/
CREATE TABLE ft_log_monitoraggio(
    id_monitoraggio SERIAL NOT NULL,   /*sequenziale automatico*/
    livello VARCHAR(1000),             /*questo è il livello di gravità del log: ERROR, WARNING, ecc..*/
    tracciato VARCHAR(1000),           /*questo è il nome del tracciato o processo che voglio monitorare*/
    testo VARCHAR(4000),               /*questo è il testo del log*/
    dt_update timestamp DEFAULT now(), /*data di scrittura del log*/
    CONSTRAINT const_ft_monitoraggio_pk PRIMARY KEY (id_monitoraggio)
);

/**************************************************************************/

CREATE OR REPLACE PROCEDURE scrivi_log(p_tracciato varchar(1000), p_testo varchar(4000), p_livello varchar(1000) DEFAULT '')
 LANGUAGE plpgsql
AS $procedure$
	/*
	 Procedura che scrive i record nel LOG.
	 Il terzo parametro è opzionale perchè se non viene inserito prende come valore di DEFAULT ''
	*/
begin
	insert into ft_log_monitoraggio (tracciato, testo, livello) values (p_tracciato, p_testo, p_livello);
exception
	when others then 
		begin
			RAISE EXCEPTION '% %',sqlstate,sqlerrm;
		end;	
end; $procedure$
;
