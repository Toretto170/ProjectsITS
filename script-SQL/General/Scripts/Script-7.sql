create or replace function confronta (par_1 numeric , par_2 numeric) RETURNS numeric 
language plpgsql
as $$
declare
risultato numeric;
begin
	
	if par_1 > par_2 then
		risultato := 1;
	else
		risultato :=0;
	end if;
	
	return risultato;
end; $$
