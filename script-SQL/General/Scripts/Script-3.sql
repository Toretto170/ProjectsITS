select 
	*
from 
	ft_prodotto 

select 
	*
from 
	ft_cliente 

select
	*
from 
	ft_investimento 

select
	*
from 
	ft_cliente 
where 
	data_nascita > '01-01-1989'

select 
	ft_cliente.nome,
	ft_cliente.cognome,
	ft_cliente.indirizzo 
from
	ft_cliente 
where
	ft_cliente.data_nascita > '01-01-1989'
	
select 
	fa.settore 
from
	ft_azienda fa 
where 
	fa.settore = 'Banca'
	
select
	fa.ragione_sociale as rag_soc,
	fa.descrizione  as descr
from
	ft_azienda fa
where 
	fa.anno_fondazione >= 01-01-2000

	
select 
	fi.nome,
	fi.budget 
from 
	ft_investimento fi
where 
	fi.tipo_investimento = 'Titoli_azionari'
	and
	fi.budget between 5000 and 9000
order by 
	fi.budget desc;

select 
	cli.nome ,
	cli.cognome 
from
	ft_cliente cli;

--Es 10
select 
	fp.prezzo,
	fp.descrizione 
from
	ft_prodotto as fp
where 
	fp.valutazione_media > 4.5
	and 
	fp.prezzo > 100
order by 
	fp.prezzo asc;
	
--Es 11
select 
	*
from
	ft_cliente as cli
order by
	cli.cognome asc;

select 
	fr.voto,
	fr.testo 
from 
	ft_recensione as fr
where 
	fr.voto > 3
order by 
	fr.voto desc;


select
	max(fc.data_nascita) as cliente_giovane
from 
	ft_cliente as fc; 

select 
	*
from 
	ft_azienda as fa
where 
	fa.anno_fondazione =
	( 
	select 
		max(fa.anno_fondazione) as azienda_giovane
	from
		ft_azienda as fa 
	);

select 
	avg(fi.budget) as valore_medio_investimenti
from
	ft_investimento fi;

select 
	max(fr.valore) as max_valore 
from 
	ft_roi fr;

select 
	count(fr.*) as ris
from 
	ft_roi as fr
where 
	fr.valore > 3;

select 
	count(fp.*) as ris 
from 
	ft_prodotto as fp
where 
	fp.prezzo > 100;

select 
	fp.descrizione,
	fp.prezzo 
from 
	ft_prodotto as fp
where 
	fp.prezzo in (250,15,5000);

select 
	fp.descrizione,
	fp.prezzo
from 
	ft_prodotto as fp
where 
	fp.prezzo not in(10000,15);
	
