CREATE OR REPLACE PROCEDURE public.monitoraggio_tempistiche()
 LANGUAGE plpgsql
AS $procedure$
/*
 QUESTO E' UN TEMPLATE per creare una nuova procedura in postgresql.
 l'esempio quì riportato ipotizza di creare una procedura chiamata: "nome_procedura" che accetta in entrata un valore passato
 come parametro "par_1" di tipo "integer".
 
 P.S. Ricorda che la differenza tra una funzione e una procedura consiste nel fatto che una 
 funzione gestisce sempre un "valore di ritorno", mentre una procedura non prevede nessun valore di ritorno.
*/
declare
	-- dichiarazione delle variabili
	ultima_data_ora timestamp;
begin
	call scrivi_log('monitoraggio_tempistiche','','');
	call scrivi_log('monitoraggio_tempistiche','inizio_procedura:monitoraggio_tempistiche','');
	select 
		max(cli.dt_update) INTO ultima_data_ora 
	from
		ft_cliente as cli
	;
	CALL scrivi_log('monitoraggio_tempistiche','   Tabella ft_cliente ultimo record: '|| ultima_data_ora);
	select 
		max(az.dt_update) INTO ultima_data_ora 
	from
		ft_azienda as az
	;
	CALL scrivi_log('monitoraggio_tempistiche','   Tabella ft_azienda ultimo record: '|| ultima_data_ora);
	select 
		max(inv.dt_update) INTO ultima_data_ora 
	from
		ft_investimento as inv
	;
	CALL scrivi_log('monitoraggio_tempistiche','   Tabella ft_investimento ultimo record: '|| ultima_data_ora);
	select 
		max(pro.dt_update) INTO ultima_data_ora 
	from
		ft_prodotto as pro
	;
	CALL scrivi_log('monitoraggio_tempistiche','   Tabella ft_prodotto ultimo record: '|| ultima_data_ora);
	select 
		max(rec.dt_update) INTO ultima_data_ora 
	from
		ft_recensione as rec
	;
	CALL scrivi_log('monitoraggio_tempistiche','   Tabella ft_recensione ultimo record: '|| ultima_data_ora);
	select 
		max(roi.dt_update) INTO ultima_data_ora 
	from
		ft_roi as roi
	;
	CALL scrivi_log('monitoraggio_tempistiche','   Tabella ft_roi ultimo record: '|| ultima_data_ora);
	select 
		max(tra.dt_update) INTO ultima_data_ora 
	from
		ft_transazione as tra
	;
	CALL scrivi_log('monitoraggio_tempistiche','   Tabella ft_transazione ultimo record: '|| ultima_data_ora);
	call scrivi_log('monitoraggio_tempistiche','fine_procedura:monitoraggio_tempistiche','');
	/* contenuto della procedura
	 Questa riga di codice è solo da esempio, voi la sostituirete con il codice che vorrete eseguire
	*/
	
exception
	when others then 
		begin
			call scrivi_log('monitoraggio_tempistiche','Codice errore: '|| sqlerrm || ' descrizione errore: '|| sqlstate,'ERRORE');
			/* la seguente riga è commentata ma se la scommento propago l’errore alla funzione chiamante*/
			/*RAISE EXCEPTION '% %',sqlstate,sqlerrm; */
		end;
end; 
$procedure$
;


