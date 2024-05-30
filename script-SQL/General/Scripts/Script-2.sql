select 
	fc.nome 
from
	ft_cliente as fc
where 
	professione = 'Impiegato'
	
select 
	fp.descrizione
from
	ft_prodotto as fp 
inner join 
ft_azienda as az 
		on fp.azienda = az.id 
where 
	az.ragione_sociale='FintechLab'
	and fp.prezzo > 240


	