CREATE OR REPLACE FUNCTION public.grafico_a_barre(p_percentuale numeric)
 RETURNS varchar(100)
 LANGUAGE plpgsql
AS $function$
/*
 **************************************************************************
 **************************************************************************
 Questa funzione restituisce una stringa di lettere "X" 
 per la quantità di percentuale passata come parametro
 **************************************************************************
 **************************************************************************
*/
declare
	-- dichiarazione delle variabili
	ris varchar(100);
begin
	/*creo una stringa di lettere "X" per la quantità di percentuale passata come parametro */
	ris := left('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',round(p_percentuale)::integer);
	/*restituisco la stringa*/
	return ris;
exception
	when others then 
		begin
			/*la seguente riga di codice scrive l'errore nella tabella di log: ft_monitoraggio_log*/
			call scrivi_log('grafico_a_barre', 'Errore codice: '|| sqlstate || ' descrizione: ' || sqlerrm, 'ERRORE');
		end;
end; 
$function$
;


/*
 **************************************************************************
 **************************************************************************
 Esempio di utilizzo della funzione per creare un grafico a barre
 **************************************************************************
 **************************************************************************
*/
select	
	roi.descrizione,
	roi.valore,
	grafico_a_barre(roi.valore) as barre
from 
	ft_roi as roi
order by 
	roi.valore desc	
;

/*altro esempio*/

select
	inv.budget, 
	inv3.budget_massimo,
	round((100 / inv3.budget_massimo * inv.budget)) as percentuale,
	grafico_a_barre(100 / inv3.budget_massimo * inv.budget) as barre
from 
	ft_investimento as inv
inner join
	(
	select 
		max(inv2.budget) as budget_massimo
	from
		ft_investimento as inv2
	) as inv3 on
		1=1
order by 	
	percentuale desc
;