--------------------------------
--INNER JOIN implicita
--------------------------------

1) visualizzare la "ragione_sociale" delle aziende, i "nomi" degli investimenti e il "valore" dei ROI, per le Aziende che hanno investimenti con associati dei ROI.
Utilizzare esclusivamente le INNER JOIN IMPLICITE.

--------------------------------
--REVERSE ENGENEERING
--------------------------------

--2) Indentare e descivere con i commenti che cosa fa la seguente select:
/* Seleziona la colonna ragione sociale con l'alias rag_soc*/
SELECT 
	az.ragione_sociale as rag_soc 
FROM 
	ft_azienda AS az;
 
--3) Indentare e descivere con i commenti che cosa fa la seguente select:
SELECT 
	roi.valore as valore_roi 
FROM 
	ft_roi AS roi 
where 
	(roi.valore between 8 and 10 and roi.descrizione = 'Recensione positiva') 
	or (roi.valore > 10 and roi.descrizione = 'Recensione positiva');

4) Indentare correttamente la seguente select:
/*Ricaviamo le macchine e il loro ultimo passggio al transito alla stazione logica E*/
select 
	a.cd_plant_mfg_code, 
	a.cd_model_code, 
	a.cd_chassis_code,
	max(a.dt_transit_timestamp) as dt_transit_timestamp
from 
	[dbo].[VIEW_DAM_transit_logic] as a 
where
	a.cd_plant_mfg_code = '145' 
	and a.cd_logic_station_code = 'E'
	and a.cd_evento_code = 'T' 
	and a.dt_transit_timestamp > '2023-01-01'
group by  
	a.cd_plant_mfg_code, 
	a.cd_model_code, 
	a.cd_chassis_code;

5) Indentare e descivere con i commenti che cosa fa la seguente select:
/*Tutte le avvitature che hanno avuto dei difetti*/
select  
	rs1.cd_plant_mfg_code, 
	rs1.cd_model_code, 
	rs1.cd_chassis_code, 
	rs1.cd_operation_code, 
	rs1.dt_operation_timestamp, 
	rs1.cd_operation_attempt_code, 
	sum(rs1.conta_nok) as oper_nok, 
	rs1.ds_note_desc, 
	rs1.cd_tool_type_code
from
	( 
	select 
		rs_item.cd_plant_mfg_code,
		rs_item.cd_model_code,
		rs_item.cd_chassis_code, 
		rs_item.cd_operation_code,
		rs_item.dt_operation_timestamp,
		rs_item.cd_operation_attempt_code,
		rs_item.ds_operation_attempt_result_desc,
		case 
			when rs_item.ds_operation_attempt_result_desc in ('OK', 'OK*', 'OK-OPERATOR', 'OKOPERATOR', 'SCL-OK*') then 1 
			else 0 
		end as conta_ok,
		case 
			when rs_item.ds_operation_attempt_result_desc in ('NOK', 'NOK-OPERATOR', 'NOKOPERATOR', 'NOK**') then 1 
			else 0 
		end as conta_nok,
		rs_SCR.ds_note_desc,
		rs_SCR.cd_tool_type_code
	from 
		( 
		select 
			ite .*,
			VIEW_DAM_routing_operation.cd_workplace_code
		from 
			dbo.VIEW_DAM_routing_operation_item  as ite
		inner join
			dbo.VIEW_DAM_routing_operation as ope on
				ite.cd_plant_mfg_code = ope.cd_plant_mfg_code
				and ite.cd_model_code = ope.cd_model_code
				and ite.cd_chassis_code = ope.cd_chassis_code
				and ite.cd_operation_code = ope.cd_operation_code
				and ite.dt_operation_timestamp = ope.dt_operation_timestamp
		where 
			ite.cd_plant_mfg_code = '145'
		)as rs_item
	inner join  
		( 
		select distinct 
			op.cd_operation_code,
			op.cd_workplace_code,
			op.ds_note_desc,
			op.cd_tool_type_code 
		from 
			VIEW_DAM_anag_operation as op
		where 
			op.cd_plant_mfg_code = '145'
			and op.cd_operation_type_code = 'SCR'
		) as rs_SCR on 
			rs_SCR.cd_operation_code = rs_item.cd_operation_code
			and rs_SCR.cd_workplace_code = rs_item.cd_workplace_code
	where 
		rs_item.ds_operation_attempt_result_desc <> ''
	) as rs1 
group by 
	rs1.cd_plant_mfg_code,
	rs1.cd_model_code,
	rs1.cd_chassis_code,
	rs1.cd_operation_code,
	rs1.dt_operation_timestamp,
	rs1.cd_operation_attempt_code,
	rs1.ds_note_desc,
	rs1.cd_tool_type_code;

6) Indentare e descivere con i commenti che cosa fa la seguente select:
(N.B. IN QUESTO CASO GLI "A CAPO" SONO GIA CORRETTI)
select 
	tab_ope.*,
	tab_tr.dt_transit_timestamp
from
-- Creo tab_tr che contiene tutti gli CHASSIS passati al transito logico "E" a partire da 2 mesi prima della data attuale
	(
	select 
		a.cd_plant_mfg_code,
		a.cd_model_code,
		a.cd_chassis_code,
		max(a.dt_transit_timestamp) as dt_transit_timestamp
	from	
		[dbo].[VIEW_DAM_transit_logic] as a
	where
		a.cd_plant_mfg_code = '145'
		and a.cd_logic_station_code = 'E'
		and a.cd_evento_code = 'T'
		and a.dt_transit_timestamp > DATEADD(month,
		DATEDIFF(month, 0, DATEADD(month, -2, GETDATE())), 0)
	group by 
		a.cd_plant_mfg_code,
		a.cd_model_code,
		a.cd_chassis_code
	) as tab_tr
inner join
(
-- Lettura ROUTING e ITEM (senza lettura MEASURE)
select
tab_result.cd_plant_mfg_code as plant,
tab_result.cd_model_code as model,
tab_result.cd_chassis_code as chassis,
tab_result.cd_operation_code as operation,
tab_result.ds_operation_desc as operation_desc,
tab_result.dt_operation_timestamp as operation_timestamp,
tab_result.dt_operation_date as operation_date,
tab_result.ds_operation_result_desc as result_origin,
tab_result.cd_operation_shift_code as operation_shift_code,
tab_result.cd_workplace_code as workplace,
tab_result.cd_wog_operation_code, 
tab_result.ds_wog_operation_desc,
tab_result.num_avvitature,
tab_result.oper_nok,
tab_result.measure,
case
when defe.cd_work_operation_code is not null 
then 'Y'
else 'N'
end as defect,
case
when tab_result.ds_operation_result_desc in ('OK', 'OK-NOPRIMOCOLPO', 'OK OPERATORE', 'OK OPERATOR', 'KO', 'NOK', 'NOK OPERATORE', 'NOT OK')
and defe.cd_work_operation_code is null
and tab_result.oper_nok = 0 
then 'OK senza Difetto'
when tab_result.ds_operation_result_desc in ('OK', 'OK-NOPRIMOCOLPO', 'OK OPERATORE', 'OK OPERATOR', 'KO', 'NOK', 'NOK OPERATORE', 'NOT OK')
and defe.cd_work_operation_code is null
and tab_result.measure = 'N' 
then 'OK senza Misura e senza Difetto'
when tab_result.ds_operation_result_desc in ('OK', 'OK-NOPRIMOCOLPO', 'OK OPERATORE', 'OK OPERATOR', 'KO', 'NOK', 'NOK OPERATORE', 'NOT OK')
and defe.cd_work_operation_code is null
and tab_result.oper_nok > 0 
then 'OK con KO parziale'
when tab_result.ds_operation_result_desc in ('OK', 'OK-NOPRIMOCOLPO', 'OK OPERATORE', 'OK OPERATOR', 'KO', 'NOK', 'NOK OPERATORE', 'NOT OK')
and defe.cd_work_operation_code is not null
and tab_result.measure = 'N' 
then 'KO con Difetto'
when tab_result.ds_operation_result_desc in ('OK', 'OK-NOPRIMOCOLPO', 'OK OPERATORE', 'OK OPERATOR', 'KO', 'NOK', 'NOK OPERATORE', 'NOT OK')
and defe.cd_work_operation_code is not null
and tab_result.oper_nok > 0 
then 'KO con Difetto'
when tab_result.ds_operation_result_desc in ('OK', 'OK-NOPRIMOCOLPO', 'OK OPERATORE', 'OK OPERATOR', 'KO', 'NOK', 'NOK OPERATORE', 'NOT OK')
and defe.cd_work_operation_code is not null
and tab_result.oper_nok = 0 
then 'OK con Difetto'
else 
'Not Defined'
end as result,
SUBSTRING(tab_result.cd_operation_code, 1, 3) as prefix,
tab_result.ds_note_desc,
tab_result.cd_tool_type_code
from
(
-- Creazione di TAB RESULT con operazioni e dettagli ITEM
select
tb_main.cd_plant_mfg_code,
tb_main.cd_model_code,
tb_main.cd_chassis_code,
tb_main.cd_operation_code,
tb_main.ds_operation_desc,
tb_main.dt_operation_timestamp,
tb_main.dt_operation_date,
tb_main.ds_operation_result_desc,
tb_main.cd_operation_shift_code,
tb_main.cd_workplace_code,
tb_main.cd_wog_operation_code,
tb_main.ds_wog_operation_desc,
tb_dett.num_avvitature,
tb_dett.oper_nok,
case
when tb_dett.num_avvitature > 0
then 'Y'
else 'N'
end as measure,
tb_dett.ds_note_desc,
tb_dett.cd_tool_type_code
from
(
-- Estrazione dalla ROUTING_OPERATION delle operazioni
select
rr.cd_plant_mfg_code,
rr.cd_model_code,
rr.cd_chassis_code,
rr.cd_operation_code,
rr.ds_operation_desc,
rr.dt_operation_timestamp,
rr.dt_operation_date,
rr.ds_operation_result_desc,
rr.cd_operation_shift_code,
rr.cd_workplace_code,
rr.cd_wog_operation_code,
rr.ds_wog_operation_desc
from
(
select
*
from
dbo.VIEW_DAM_routing_operation with (NOLOCK)
where
cd_plant_mfg_code = '145'
and right(cd_operation_code, 3)!= 'WOG'
) as rr
left join 
(
select
'NOTEXECUTED' as descr
union
select
'NOT DONE' as descr
union
select
'NON PREVISTO' as descr
union
select
'NON PREV. OPER.' as descr
union
select
'CICLO NON ESEGUITO' as descr
union
select
'NON ESEGUITO' as descr
union
select
'NOEXEC' as descr
union
select
'DUPLICATO' as descr
) as rs_descr
on
rr.ds_operation_result_desc = rs_descr.descr
where
rs_descr.descr is null
and rr.ds_operation_result_desc is not null
and rr.cd_operation_type_code = 'SCR'
) as tb_main
left join
(
-- Dettaglio con Avvitature Previste e tentativi KO (da ITEM) e esistenza delle measure (Y/N)
select 
rs2.cd_plant_mfg_code,
rs2.cd_model_code,
rs2.cd_chassis_code,
rs2.cd_operation_code,
rs2.dt_operation_timestamp,
count(rs2.cd_operation_attempt_code) as num_avvitature,
sum(rs2.oper_nok) as oper_nok,
rs2.ds_note_desc,
rs2.cd_tool_type_code
from
(
-- Lettura distinct item e conteggio NOK
select 
rs1.cd_plant_mfg_code,
rs1.cd_model_code,
rs1.cd_chassis_code,
rs1.cd_operation_code,
rs1.dt_operation_timestamp,
rs1.cd_operation_attempt_code,
sum(rs1.conta_nok) as oper_nok,
rs1.ds_note_desc,
rs1.cd_tool_type_code
from
(
-- Lettura item e definizione NOK x conteggio
select
rs_item.cd_plant_mfg_code,
rs_item.cd_model_code,
rs_item.cd_chassis_code,
rs_item.cd_operation_code,
rs_item.dt_operation_timestamp,
rs_item.cd_operation_attempt_code,
rs_item.ds_operation_attempt_result_desc,
case
when rs_item.ds_operation_attempt_result_desc in ('OK', 'OK*', 'OK-OPERATOR', 'OKOPERATOR', 'SCL-OK*') 
then 1
else 0
end as conta_ok,
case
when rs_item.ds_operation_attempt_result_desc in ('NOK', 'NOK-OPERATOR', 'NOKOPERATOR', 'NOK**') 
then 1
else 0
end as conta_nok,
rs_SCR.ds_note_desc,
rs_SCR.cd_tool_type_code
from
(
select
ite .*,
VIEW_DAM_routing_operation.cd_workplace_code
from
dbo.VIEW_DAM_routing_operation_item  as ite
inner join
dbo.VIEW_DAM_routing_operation as ope on
ite.cd_plant_mfg_code = ope.cd_plant_mfg_code
and ite.cd_model_code = ope.cd_model_code
and ite.cd_chassis_code = ope.cd_chassis_code
and ite.cd_operation_code = ope.cd_operation_code
and ite.dt_operation_timestamp = ope.dt_operation_timestamp
where
ite.cd_plant_mfg_code = '145'
)as rs_item
inner join 
(
select distinct
op.cd_operation_code,
op.cd_workplace_code,
op.ds_note_desc,
op.cd_tool_type_code
from
VIEW_DAM_anag_operation as op
where
op.cd_plant_mfg_code = '145'
and op.cd_operation_type_code = 'SCR'
) as rs_SCR on
rs_SCR.cd_operation_code = rs_item.cd_operation_code
and rs_SCR.cd_workplace_code = rs_item.cd_workplace_code
where
rs_item.ds_operation_attempt_result_desc <> ''
) as rs1
group by
rs1.cd_plant_mfg_code,
rs1.cd_model_code,
rs1.cd_chassis_code,
rs1.cd_operation_code,
rs1.dt_operation_timestamp,
rs1.cd_operation_attempt_code,
rs1.ds_note_desc,
rs1.cd_tool_type_code
) as rs2
group by
rs2.cd_plant_mfg_code,
rs2.cd_model_code,
rs2.cd_chassis_code,
rs2.cd_operation_code,
rs2.dt_operation_timestamp,
rs2.ds_note_desc,
rs2.cd_tool_type_code
) tb_dett on
tb_dett.cd_plant_mfg_code = tb_main.cd_plant_mfg_code
and tb_dett.cd_model_code = tb_main.cd_model_code
and tb_dett.cd_chassis_code = tb_main.cd_chassis_code
and tb_dett.cd_operation_code = tb_main.cd_operation_code
and tb_dett.dt_operation_timestamp = tb_main.dt_operation_timestamp
) tab_result
left join
(
select distinct
df.cd_plant_mfg_code,
df.cd_model_code,
df.cd_chassis_code,
df.cd_work_operation_code,
df.dt_opening_timestamp
from
[dbo].[VIEW_DAM_defect] as df
) as defe on
defe.cd_plant_mfg_code = tab_result.cd_plant_mfg_code
and defe.cd_model_code = tab_result.cd_model_code
and defe.cd_chassis_code = tab_result.cd_chassis_code
and defe.cd_work_operation_code = tab_result.cd_operation_code
and defe.dt_opening_timestamp = tab_result.dt_operation_timestamp
) as tab_ope on
tab_ope.plant = tab_tr.cd_plant_mfg_code
and tab_ope.model = tab_tr.cd_model_code
and tab_ope.chassis = tab_tr.cd_chassis_code;

--------------------------------
--SELECT ANNIDATE
--------------------------------

/*7) Visualizzare tutti i dettagli del cliente più giovane 
(usando la SELECT annidata nel costrutto di WHERE)*/
select 
	fc.*
from 
	ft_cliente as fc
where 
	fc.data_nascita =
		(
			select
				max(fc.data_nascita) 
			from
				ft_cliente as fc 
		);
/*8) Visualizzare tutti i dettagli del cliente più giovane 
(usando la SELECT annidata in JOIN nel costrutto di FROM)*/

9) Visualizzare i dettagli dell'investimento con il BUDGET minore
(usando la SELECT annidata nel costrutto di WHERE)

10) Visualizzare i dettagli dell'investimento con il BUDGET minore
(usando la SELECT annidata in JOIN nel costrutto di FROM)

11) Visualizzare il nome di "tutte" le Aziende, la quantità di investimenti fatti e la quantità di prodotti
(usando le 2 SELECT annidate in JOIN nel costrutto di FROM)

12) Visualizzare nome e cognome di "tutti" i clienti, la quantità di transazioni effettuate, la quantità di feedback effettuati
(usando le 2 SELECT annidate in JOIN nel costrutto di FROM)

13)  Visualizzare il nome di "tutti" i prodotti, il numero di feedback ricevuti ed il numero di transazioni in cui sono presenti.

14) Visualizzare i dettagli dei clienti che hanno acquistato tutti i prodotti disponibili
(usando la SELECT annidata nel costrutto di HAVING)

15) Visualizzare i dettagli dei clienti che hanno acquistato tutti i prodotti disponibili
(usando la SELECT annidata in JOIN nel costrutto di FROM)