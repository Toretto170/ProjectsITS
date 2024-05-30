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
	somma_budget := 0;
	select 
		sum(ft_investimento.budget) into somma_budget
	from 
		ft_investimento
	where 
		ft_investimento.id_azienda = p_id_azienda
	;
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