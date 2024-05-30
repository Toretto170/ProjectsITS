create or replace  view view_monitor_log as
SELECT 
	id_monitoraggio, livello, tracciato, testo, dt_update
FROM 
	public.ft_log_monitoraggio
order by 
	id_monitoraggio desc 
;