
select 
	count(*) as car_count
from
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
		and a.dt_transit_timestamp > '2023-01-01'
	group by  
		a.cd_plant_mfg_code, 
		a.cd_model_code, 
		a.cd_chassis_code
)as rs1
;