CREATE OR REPLACE PROCEDURE ROI_controlli_consistenza_dati()
 LANGUAGE plpgsql
AS $$
/*
 Questa procedura dimostra come sia possibile effettuare delle verifiche di inconsistenza dei dati,
 registrare eventualmente i risultati che emergono tramite delle variabili, 
 e creare un potenziale REPORT scrivendo su tabella  la situazione riscontrata.
 
 P.S. In questo esempio ho deciso di scrivere il reporto direttamente nella tabella dei LOG ma avrei potuto
 creare  una tabella dedicata a questo tipo di record dove ad esempio i valori dei:
	 -record_mancanti
	 -record totali
	 -percentuale_mancanti
 potessero essere scritti in colonne separate in modo da poter 
 successivamente interrogare tale tabella per ulteriori statistiche
 
 Created By: Davide Roi
 Date: 2023-05-15
 */
declare
	/*dichiaro le variabili che mi serviranno per contenere i conteggi dei record*/
	v_qta_record_mancanti numeric;
	v_qta_record_totali numeric;
	v_testo varchar(4000);
begin
	
	/*scrivo l'inizio della procedura*/
	insert into ft_log_monitoraggio (tracciato, testo) values ('_01_controlli_consistenza_dati', ' ');
	insert into ft_log_monitoraggio (tracciato, testo) values ('_01_controlli_consistenza_dati', 'Inizio procedura: __01_controlli_consistenza_dati');

	/************************************************************/
	/***** FT_PRODOTTO senza FT_AZIENDA ****************************/
	/************************************************************/

	/*inserisco in v_qta_record_mancanti la quantità dei record tabella ft_prodotto mancanti in tabella ft_azienda*/
	select
		count(pro.*) into v_qta_record_mancanti
	from
		ft_prodotto as pro
	left join
		ft_azienda as az on
			pro.id_azienda  = az.id_azienda 
	where 
		az.id_azienda is null	
	;
	/*inserisco in v_qta_record_totali la quantità dei record totali tabella ft_prodotto*/
	select
		count(pro.*) into v_qta_record_totali
	from
		ft_prodotto as pro
	;
	/*scrivo il risultato nella variabile: v_testo*/
	v_testo := '   Record tabella ft_prodotto senza relazione con ft_azienda - Rec Totali: ' || v_qta_record_totali || ' Rec Mancanti: ' ||
		v_qta_record_mancanti || ' Rapporto percentuale mancanti: ' || round(100/v_qta_record_totali*v_qta_record_mancanti) || '%';

	/*inserisco il resoconto nella tabella di LOG*/
	insert into ft_log_monitoraggio (tracciato, testo) values ('_01_controlli_consistenza_dati', v_testo);

	/************************************************************/
	/***** FT_INVESTIMENTO senza FT_AZIENDA ****************************/
	/************************************************************/

	/*inserisco in v_qta_record_mancanti la quantità dei record tabella ft_investimento mancanti in tabella ft_azienda*/
	select
		count(inv.*) into v_qta_record_mancanti
	from
		ft_investimento as inv
	left join
		ft_azienda as az on
			inv.id_azienda  = az.id_azienda 
	where 
		az.id_azienda is null	
	;
	/*inserisco in v_qta_record_totali la quantità dei record totali tabella ft_investimento*/
	select
		count(inv.*) into v_qta_record_totali
	from
		ft_investimento as inv
	;
	
	/*scrivo il risultato nella variabile: v_testo*/
	v_testo := '   Record tabella ft_investimento senza relazione con ft_azienda - Rec Totali: ' || v_qta_record_totali || ' Rec Mancanti: ' ||
		v_qta_record_mancanti || ' Rapporto percentuale mancanti: ' || round(100/v_qta_record_totali*v_qta_record_mancanti) || '%';

	/*inserisco il resoconto nella tabella di LOG*/
	insert into ft_log_monitoraggio (tracciato, testo) values ('_01_controlli_consistenza_dati', v_testo);


	/************************************************************/
	/***** FT_ROI senza FT_INVESTIMENTO ****************************/
	/************************************************************/

	/*inserisco in v_qta_record_mancanti la quantità dei record tabella ft_investimento mancanti in tabella ft_azienda*/
	select
		count(roi.*) into v_qta_record_mancanti
	from
		ft_roi as roi
	left join
		ft_investimento as inv on
			roi.id_investimento = inv.id_investimento  
	where 
		inv.id_investimento is null
	;
	/*inserisco in v_qta_record_totali la quantità dei record totali tabella ft_investimento*/
	select
		count(roi.*) into v_qta_record_totali
	from
		ft_roi as roi
	;

	/*scrivo il risultato nella variabile: v_testo*/
	v_testo := '   Record tabella ft_roi senza relazione con ft_investimento - Rec Totali: ' || v_qta_record_totali || ' Rec Mancanti: ' ||
		v_qta_record_mancanti || ' Rapporto percentuale mancanti: ' || round(100/v_qta_record_totali*v_qta_record_mancanti) || '%';

	/*inserisco il resoconto nella tabella di LOG*/
	insert into ft_log_monitoraggio (tracciato, testo) values ('_01_controlli_consistenza_dati', v_testo);

	/*scrivo la fine della procedura*/
	insert into ft_log_monitoraggio (tracciato, testo) values ('_01_controlli_consistenza_dati', 'Fine procedura: __01_controlli_consistenza_dati');
EXCEPTION
  WHEN OTHERS THEN 
	begin
		call scrivi_log('_01_controlli_consistenza_dati','Descrizione:' || sqlerrm || ' - Codice errore:' || sqlstate,'ERRORE');
	end;
 end; $$
;