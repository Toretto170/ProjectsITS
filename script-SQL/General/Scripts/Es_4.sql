select 
	cli.nome,
	cli.cognome,
	cli.data_nascita, 
	date_part('year',age(current_date,cli.data_nascita)) as eta
from 
	ft_cliente as cli
;


/*
 * per ogni transazione mostrare:
 * nome e cognome del cliente
 * descrizione del prodotto
 * categoria di appartenenza
 * azienda proprietaria di quel prodotto
 */
select
	ft.id,
	fc.nome as nome_cliente,
	fc.cognome as cognome_cliente,
	fp.descrizione as descrizione_prodotto,
	dc.nome as categoria,
	fa.ragione_sociale as azienda
from 
	ft_transazione as ft
inner join 
	ft_cliente as fc on
		ft.cliente = fc.id
inner join 
	ft_prodotto as fp on
		ft.prodotto = fp.id 
inner join 
	dm_categoria as dc on
		fp.categoria = dc.id 
inner join 
	ft_azienda as fa on
		fa.id = fp.azienda 
;
select
	fc.nome,
	fc.cognome 
from 
	ft_cliente  as fc
inner join
	(
	select 
		ft.metodo_pagamento 
	from 
		ft_transazione as ft
	inner join
		(
		select
			fp.*
		from 
			ft_prodotto as fp
		where 
			fp.prezzo > ( 
							select 
								avg(fp2.prezzo) 
							from 
								ft_prodotto as fp2 
						)
		) as pro2 on 
			ft.prodotto = pro2.id
	inner join 
		(
		select 
			fa.*
		from 
			ft_azienda as fa
		where 
			fa.anno_fondazione > 1820
		) as azi on 
			pro2.azienda = azi.id
	group by 
		ft.metodo_pagamento 
	) as recordset on 
	 ft_transazione.cliente = fc.id 
;


/*
 * es 3
 */

/*
per ogni prodotto mostrare:
prodotto
quantità transazioni
categoria di appartenenza
*/

/*
proiettare i clienti riconducibili alle aziende e la quantità di prodotti per ogni azienda/cliente:
cognome cliente,
nome cliente
ragione_sociale_azienda
quantita_prodotti

per fare questo analizzare il diagramma ER e decidere quali tabelle relazionare e in che modo
*/
