/*
1) Eseguire il seguente codice di creazione tabella:

CREATE TABLE ft_kpi_valori_medi (
    id_monitoraggio SERIAL NOT NULL,
    azienda VARCHAR(255),
    tot_budget_investimenti integer,
	tot_importo_transazioni integer,
	flag_budget_superiore_alla_media boolean,
	flag_importo_superiore_alla_media boolean,
	dt_update timestamp DEFAULT now(),	
    CONSTRAINT const_ft_monit_tr_pk PRIMARY KEY (id_monitoraggio)
);

2) Realizzare e testare una funzione chiamata: roi_get_somma_budget_azienda() che:
	accetti come parametro in entrata l'identificativo di una azienda e restituisca la "somma dei budget" degli investimenti per quella azienda.
	Nel caso non trovi l'azienda deve restituire 0

3) Realizzare e testare una funzione chiamata: roi_get_somma_importo_transazioni() che:
	accetti come parametro in entrata l'identificativo di una azienda e restituisca la "somma degli importi di tutte le transazioni sui prodotti di quella azienda."
	Nel caso non trovi l'azienda deve restituire 0

4) Realizzare e testare una proceruda chiamata: roi_kpi_valori_medi() che:
	step1: cancella tutti i record della tabella: ft_kpi_valori_medi 
	step2: Cicla per ogni record della tabella: ft_azienda
		step2.1: Registra in una variabile la somma dei budget (richiamando la funzione roi_get_somma_budget_azienda)
		step2.2: Registra in una variabile la somma degli importi (richiamando la funzione roi_get_somma_importo_transazioni)
		step2.3: Inserisce un record nella tabella ft_kpi_valori_medi con i valori delle colonne:
			azienda (codice fiscale)
			tot_budget_investimenti
			tot_importo_transazioni
	step3: Cicla per ogni record della tabella ft_kpi_valori_medi
		step3.1: Registra in una variabile booleana, il valore TRUE se il totale budget è superiore alla "media di tutti i totali budget della tabella: ft_kpi_valori_medi"
		step3.2: Registra in una variabile booleana, il valore TRUE se il totale importo è superiore alla "media di tutti i totali importi della tabella: ft_kpi_valori_medi"
		step3.3: Fa l'update del record della tabella ft_kpi_valori_medi aggiungendo le informazioni registrate ai punti 4.1 e 4.2
*/

/*******************************************************
 * 1) Eseguire il seguente codice di creazione tabella:*
 *******************************************************/
CREATE TABLE ft_kpi_valori_medi (
    id_monitoraggio SERIAL NOT NULL,
    azienda VARCHAR(255),
    tot_budget_investimenti integer,
	tot_importo_transazioni integer,
	flag_budget_superiore_alla_media boolean,
	flag_importo_superiore_alla_media boolean,
	dt_update timestamp DEFAULT now(),	
    CONSTRAINT const_ft_monit_tr_pk PRIMARY KEY (id_monitoraggio)
);
/************************************************************************************************************************************************
 *2) Realizzare e testare una funzione chiamata: roi_get_somma_budget_azienda() che:                                                            *
	accetti come parametro in entrata l'identificativo di una azienda e restituisca la "somma dei budget" degli investimenti per quella azienda.*
	Nel caso non trovi l'azienda deve restituire 0                                                                                              *
 ************************************************************************************************************************************************/
CREATE OR REPLACE FUNCTION public.roi_get_somma_budget_azienda(p_id_azienda integer)
 RETURNS numeric 
 LANGUAGE plpgsql
AS $$
/*
 	Questa funzione prende come parametro in entrata l'identificativo di una azienda e restituisce la "somma dei budget" degli investimenti per quella azienda.
	Nel caso non trovi l'azienda restituisce 0
*/
declare
	-- Variabile che restituirà il valore di ritorno
	somma_budget numeric;
begin
	call scrivi_log('roi_get_somma_budget_azienda','','');
	call scrivi_log('roi_get_somma_budget_azienda','Inizio Funzione:roi_get_somma_budget_azienda','');

	call scrivi_log('roi_get_somma_budget_azienda','recupero la somma del budget','');
	select 
		sum(ft_investimento.budget) into somma_budget
	from 
		ft_investimento
	where 
		ft_investimento.id_azienda = p_id_azienda
	;
	/*Se non esite azienda forzo il valore 0 */
	
	if somma_budget is null THEN
		call scrivi_log('roi_get_somma_budget_azienda','forzo il valore a 0','');
		somma_budget := 0;
	end if
	call scrivi_log('roi_get_somma_budget_azienda','Fine Funzione:roi_get_somma_budget_azienda','');
	--restituzione del valore di ritorno
	return somma_budget;
exception
	when others then 
		begin
			call scrivi_log('roi_get_somma_budget_azienda','Errore codice:' || sqlstate ||'descrizione: '||sqlerrm ,'ERRORE');
			return somma_budget;
			
		end;
end; 
$$
;

/************************************************************************************************************************************************
 * 3) Realizzare e testare una funzione chiamata: roi_get_somma_importo_transazioni() che:
	accetti come parametro in entrata l'identificativo di una azienda e restituisca la "somma degli importi di tutte le transazioni sui prodotti di quella azienda."
	Nel caso non trovi l'azienda deve restituire 0                                                                                            *
 ************************************************************************************************************************************************/
CREATE OR REPLACE FUNCTION public.roi_get_somma_importo_transazioni(p_id_azienda integer)
 RETURNS numeric 
 LANGUAGE plpgsql
AS $$
/*
 	Questa funzione prende come parametro in entrata l'identificativo di una azienda e restituisce la "somma degli importi" di tutte le transazioni sui prodotti di quella azienda.
	Nel caso non trovi l'azienda restituisce 0
*/
declare
	-- Variabile che restituirà il valore di ritorno
	somma_importi numeric;
begin
	call scrivi_log('roi_get_somma_importo_transazioni','','');
	call scrivi_log('roi_get_somma_importo_transazioni','Inizio Funzione:roi_get_somma_importo_transazioni','');
	
	call scrivi_log('roi_get_somma_importo_transazioni','Trovo importi e faccio la somma','');
	select
		sum(tran.importo) into somma_importi 
	from
		ft_transazione as tran
	inner join 
		ft_prodotto as pro on
		tran.id_prodotto = pro.id_prodotto 
	where 
		pro.id_azienda = p_id_azienda
	;
	IF somma_importi IS NULL THEN
		call scrivi_log('roi_get_somma_importo_transazioni','forzo valore a 0','');
		somma_importi := 0;
	END IF 
	call scrivi_log('roi_get_somma_importo_transazioni','Fine Funzione:roi_get_somma_importo_transazioni','');
	--restituzione del valore di ritorno
	return somma_importi;
exception
	when others then 
		begin
			call scrivi_log('roi_get_somma_importo_transazioni','Errore codice:' || sqlstate ||'descrizione: '||sqlerrm ,'ERRORE');
			return somma_budget;
			
		end;
end; 
$$
;

/************************************************************************************************************************************************
 * 4) Realizzare e testare una proceruda chiamata: roi_kpi_valori_medi() che:
	step1: cancella tutti i record della tabella: ft_kpi_valori_medi 
	step2: Cicla per ogni record della tabella: ft_azienda
		step2.1: Registra in una variabile la somma dei budget (richiamando la funzione roi_get_somma_budget_azienda)
		step2.2: Registra in una variabile la somma degli importi (richiamando la funzione roi_get_somma_importo_transazioni)
		step2.3: Inserisce un record nella tabella ft_kpi_valori_medi con i valori delle colonne:
			azienda (codice fiscale)
			tot_budget_investimenti
			tot_importo_transazioni
	step3: Cicla per ogni record della tabella ft_kpi_valori_medi
		step3.1: Registra in una variabile booleana, il valore TRUE se il totale budget è superiore alla "media di tutti i totali budget della tabella: ft_kpi_valori_medi"
		step3.2: Registra in una variabile booleana, il valore TRUE se il totale importo è superiore alla "media di tutti i totali importi della tabella: ft_kpi_valori_medi"
		step3.3: Fa l'update del record della tabella ft_kpi_valori_medi aggiungendo le informazioni registrate ai punti 4.1 e 4.2                                                                                        *
 ************************************************************************************************************************************************/
CREATE OR REPLACE PROCEDURE public.roi_kpi_valori_medi()
 LANGUAGE plpgsql
AS $procedure$
/*
 Questa procedura fa i seguenti cose:
	step1: cancella tutti i record della tabella: ft_kpi_valori_medi 
	step2: Cicla per ogni record della tabella: ft_azienda
		step2.1: Registra in una variabile la somma dei budget (richiamando la funzione roi_get_somma_budget_azienda)
		step2.2: Registra in una variabile la somma degli importi (richiamando la funzione roi_get_somma_importo_transazioni)
		step2.3: Inserisce un record nella tabella ft_kpi_valori_medi con i valori delle colonne:
			azienda (codice fiscale)
			tot_budget_investimenti
			tot_importo_transazioni
	step3: Cicla per ogni record della tabella ft_kpi_valori_medi
		step3.1: Registra in una variabile booleana, il valore TRUE se il totale budget è superiore alla "media di tutti i totali budget della tabella: ft_kpi_valori_medi"
		step3.2: Registra in una variabile booleana, il valore TRUE se il totale importo è superiore alla "media di tutti i totali importi della tabella: ft_kpi_valori_medi"
		step3.3: Fa l'update del record della tabella ft_kpi_valori_medi aggiungendo le informazioni registrate ai punti 4.1 e 4.2
*/
declare
	v_somma_budget NUMERIC;
	v_somma_importi NUMERIC;
	v_record record;
	v_tot_budget_sup_med boolean;
	v_tot_importo_sup_med boolean;
	v_avg_budget numeric;
	v_avg_importo numeric;
begin
	v_tot_budget_sup_med := false;
	v_tot_importo_sup_med := false;
	call scrivi_log('roi_kpi_valori_medi','Inizio Procedura:roi_kpi_valori_medi','');
	call scrivi_log('roi_kpi_valori_medi','step 1: cancellazione valori da tabella kpi_valori_medi','');
	/*
	 * ------------------------------------------------------------------
	 * step1: cancella tutti i record della tabella: ft_kpi_valori_medi
	 * ------------------------------------------------------------------
	 * */
	DELETE FROM ft_kpi_valori_medi;
	call scrivi_log('roi_kpi_valori_medi','step 2: Cicla per ogni record della tabella: ft_azienda','');
	/*
	 * ------------------------------------------------------
	 * step2: Cicla per ogni record della tabella: ft_azienda
	 * ------------------------------------------------------
	 * */
	FOR v_record IN 
    	SELECT 
     		AZ.*
		FROM 
			ft_azienda as az
	loop
		/*--------------------------------------------------
		 * step2.1: Registra in una variabile la somma dei budget (richiamando la funzione roi_get_somma_budget_azienda)
		 * -------------------------------------------------
		*/
		v_somma_budget := roi_get_somma_budget_azienda(v_record.id_azienda);
		call scrivi_log('roi_kpi_valori_medi','somma budget:'|| v_somma_budget,'');
		/*step2.2: Registra in una variabile la somma degli importi (richiamando la funzione roi_get_somma_importo_transazioni)*/
		v_somma_importi := roi_get_somma_importo_transazioni(v_record.id_azienda);
		call scrivi_log('roi_kpi_valori_medi','somma importi:'|| v_somma_importi,'');	
		/*step2.3: Inserisce un record nella tabella ft_kpi_valori_medi con i valori delle colonne:
			azienda (ragione sociale)
			tot_budget_investimenti
			tot_importo_transazioni*/
		call scrivi_log('roi_kpi_valori_medi','inserisco i valori nella tabella kpi_valori medi','');
		insert into ft_kpi_valori_medi (azienda,tot_budget_investimenti,tot_importo_transazioni)
			values (v_record.ragione_sociale,v_somma_budget,v_somma_importi);
	END LOOP;
	select 
		avg(kpi.tot_budget_investimenti) into v_avg_budget,
		avg(kpi.tot_importo_transazioni) into v_avg_importo                                             /*recupero valore medio budget*/ 
	from 
		ft_kpi_valori_medi as kpi
	/*step3: Cicla per ogni record della tabella ft_kpi_valori_medi
		step3.1: Registra in una variabile booleana, il valore TRUE se il totale budget è superiore alla "media di tutti i totali budget della tabella: ft_kpi_valori_medi"
		step3.2: Registra in una variabile booleana, il valore TRUE se il totale importo è superiore alla "media di tutti i totali importi della tabella: ft_kpi_valori_medi"
		step3.3: Fa l'update del record della tabella ft_kpi_valori_medi aggiungendo le informazioni registrate ai punti 4.1 e 4.2*/
		FOR v_record IN 
    	SELECT 
     		kpivm.*
		FROM 
			ft_kpi_valori_medi as kpivm
	loop
		if v_record.tot_budget_investimenti > v_avg_budget then
			v_tot_budget_sup_med :=true;
		end if
		if v_record.tot_importo_transazioni > v_avg_importo then
			v_tot_importo_sup_med:=true;
		end if
		update ft_kpi_valori_medi 
				SET flag_budget_superiore_alla_media  = 
					v_tot_budget_sup_med
					,flag_importo_superiore_alla_media = 
					v_tot_importo_sup_med
				where azienda = v_record.ragione_sociale;
					
	END LOOP;
	call scrivi_log('roi_kpi_valori_medi','Fine Procedura:roi_kpi_valori_medi','');
exception
	when others then 
		begin
			call scrivi_log('roi_kpi_valori_medi','Errore codice:' || sqlstate ||'descrizione: '||sqlerrm ,'ERRORE');
		end;
end; 
$procedure$
;

