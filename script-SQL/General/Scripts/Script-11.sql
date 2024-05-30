CALL public.monitoraggio_tempistiche();

SELECT 
	id_monitoraggio, livello, tracciato, testo, dt_update
FROM 
	public.ft_log_monitoraggio;
