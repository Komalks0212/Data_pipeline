--drop table meta.load_tables_population_log;
create table meta.load_tables_population_log
(load_id integer NOT NULL GENERATED ALWAYS AS identity,
 table_name varchar,
 status_ld_generic_tab varchar default 'I', 
 status_ld_spec_tab varchar default 'P',
 ld_into_generic_tab_at timestamp NULL DEFAULT now(),
 ld_into_generic_tab_by varchar NULL DEFAULT CURRENT_USER,
 ld_into_spec_tab_at timestamp,
 ld_into_spec_tab_by varchar
);

comment on column meta.load_tables_population_log.ld_into_generic_tab_by is 'I-Initialized, C-Completed, E-Error';
comment on column meta.load_tables_population_log.ld_into_spec_tab_by is 'P-Pending, I-Initialized, C-Completed, E-Error';

select * from meta.load_tables_population_log;

call proc_update_log_table(pvi_purpose:= 'INSERT'::varchar, pvi_table_name:= 'dm.tab'::varchar);
call proc_update_log_table(pvi_purpose:= 'UPDATE', pvo_load_id:= 1, pvi_status_ld_spec_tab := 'E');

--drop procedure staging.proc_update_log_table;
CREATE OR REPLACE PROCEDURE staging.proc_update_log_table(pvi_purpose varchar, pvi_table_name varchar default null, pvi_status_ld_generic_tab varchar default null, pvi_status_ld_spec_tab varchar default null, inout pvo_load_id integer default null) 
LANGUAGE plpgsql 
AS $procedure$ 

    declare
    
    	vv_custom_message varchar;
    	vv_proc_name varchar := 'proc_update_log_table'; 
    	error_msg varchar;
    
    begin

    	if lower(pvi_purpose) = 'insert' then
    	
			EXECUTE 'INSERT INTO meta.load_tables_population_log(table_name) VALUES($1) RETURNING load_id'
			INTO pvo_load_id
			USING pvi_table_name;
		
		elseif lower(pvi_purpose) = 'update' then

			if pvi_status_ld_generic_tab is not null then
	
				UPDATE meta.load_tables_population_log 
				set status_ld_generic_tab = pvi_status_ld_generic_tab, ld_into_generic_tab_at =  now(), 
				ld_into_generic_tab_by = current_user
				where load_id = pvo_load_id;
				
			elseif pvi_status_ld_spec_tab is not null then
				
				update meta.load_tables_population_log 
				set status_ld_spec_tab = pvi_status_ld_spec_tab, ld_into_spec_tab_at =  now(),
				ld_into_spec_tab_by = current_user 
				where load_id = pvo_load_id;
			
			end if;
		
		end if;
		
    exception when others then 
    
		error_msg := 'error occurred while executing procedure ' || coalesce(vv_proc_name,'') ;  
		
		EXECUTE 'INSERT INTO meta.database_log(proc_name, error) VALUES($1, $2)'
		USING vv_proc_name, error_msg;
	    		
	end; 
$procedure$
;

--drop procedure pr_ld_batch_run_one;
CREATE OR REPLACE PROCEDURE staging.proc_load_file_into_db(pvi_table_name varchar, inout pvo_result varchar default 'N') 
LANGUAGE plpgsql 
AS $procedure$ 
    declare
    
    	error_msg varchar;
    	vv_proc_name varchar := 'proc_load_file_into_db'; 
    	vv_result boolean default null; 
    	pvo_load_id int;
    
    begin
	   	   
		execute ('truncate table staging.generic_load_table restart identity');

		call staging.proc_update_log_table(pvi_purpose:= 'Insert'::varchar, pvi_table_name := pvi_table_name, pvo_load_id := pvo_load_id);
						
		call staging.proc_load_data(pvi_file_name := substring(pvi_table_name, 1,2), pvi_load_id := pvo_load_id, pvo_result := pvo_result);
		
    exception when others then 
      
	    error_msg := 'error occurred while executing procedure ' || coalesce(vv_proc_name,'') || ' error :' || sqlerrm ;  
		
		EXECUTE 'INSERT INTO meta.database_log(proc_name, error) VALUES($1, $2)'
		USING vv_proc_name, error_msg;
	    		
	end; 
$procedure$
;

CREATE OR REPLACE PROCEDURE staging.proc_load_data(in pvi_file_name varchar, in pvi_load_id integer, inout pvo_result varchar DEFAULT 'N'::varchar) LANGUAGE plpgsql
AS $procedure$ 
    declare  
    
		vv_variable varchar;
    	vv_var_str varchar;
    	vv_col_num varchar;
    	vv_col_num_str varchar;
    	vv_variables varchar;
    	error_msg varchar;
    	vv_meta_variable varchar;
    	vv_present boolean default false;
    	vv_datatype varchar;
    	vv_specfc_excptn varchar := 'N';
    	vv_proc_name varchar := 'proc_load_data'; 
    	vv_result varchar default null; 
    
    begin 
		   
	    call staging.proc_update_log_table(pvi_purpose:= 'UPDATE', pvi_status_ld_spec_tab := 'I', pvo_load_id:= pvi_load_id); 
	   
	    pvi_file_name := lower(pvi_file_name);   
	   
	   -- If the column name is file_name.DATASET then the column will not be loaded
	    for vv_col_num, vv_variable in (with mytab as(
										select 	unnest(string_to_array('column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,column13,column14,column15,column16,column17,column18,column19,column20,column21,column22,column23,column24,column25,column26,column27,column28,column29,column30,column31,column32,column33,column34,column35,column36,column37,column38,column39,column40,column41,column42,column43,column44,column45,column46,column47,column48,column49,column50,column51,column52,column53,column54,column55,column56,column57,column58,column59,column60,column61,column62,column63,column64,column65,column66,column67,column68,column69,column70,column71,column72,column73,column74,column75,column76,column77,column78,column79,column80,column81,column82,column83,column84,column85,column86,column87,column88,column89,column90,column91,column92,column93,column94,column95,column96,column97,column98,column99,column100', ',')) AS "columns", 
										unnest(array[column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,column13,column14,column15,column16,column17,column18,column19,column20,column21,column22,column23,column24,column25,column26,column27,column28,column29,column30,column31,column32,column33,column34,column35,column36,column37,column38,column39,column40,column41,column42,column43,column44,column45,column46,column47,column48,column49,column50,column51,column52,column53,column54,column55,column56,column57,column58,column59,column60,column61,column62,column63,column64,column65,column66,column67,column68,column69,column70,column71,column72,column73,column74,column75,column76,column77,column78,column79,column80,column81,column82,column83,column84,column85,column86,column87,column88,column89,column90,column91,column92,column93,column94,column95,column96,column97,column98,column99,column100]) AS "variables"
										FROM staging.generic_load_table
										where id = 1) select * from mytab where mytab.variables is not null) loop
			
			vv_col_num := lower(vv_col_num);
			vv_variable := lower(vv_variable);
					   
			for vv_meta_variable, vv_datatype in (SELECT column_name, data_type
									FROM information_schema.columns
									WHERE table_schema = 'staging' AND 
									table_name = ('load_domain_' || pvi_file_name) and column_name = vv_variable) loop 
										
				vv_present := true;
				
				if vv_datatype = 'numeric' then
					vv_col_num := '(' || vv_col_num || ')::numeric';
				end if;
					
				vv_var_str := (select concat_ws(', ', vv_var_str, vv_variable));	
				vv_col_num_str := (select concat_ws(', ', vv_col_num_str, vv_col_num));
		
			end loop;
				
			if vv_present = false then
				vv_specfc_excptn := 'Y';
				error_msg := 'error occurred while executing procedure ' || coalesce(vv_proc_name,'')   ||  ' while processing domain ' || coalesce(pvi_file_name,'') || ' with error : Varaible ' || coalesce(vv_variable, '') || ' does not exist in the domain table.';
				raise;
								
			end if;
			
			vv_present = false;
			   		    
		end loop;
	
		EXECUTE ( 'truncate staging.load_domain_' || pvi_file_name) ; 
			
		EXECUTE ('insert into staging.load_domain_' || pvi_file_name || ' (' || vv_var_str ||') '  
				|| 'select ' || vv_col_num_str || ' from staging.generic_load_table WHERE id <> 1'); 
		
   		vv_var_str = '';
   		vv_col_num_str = '';
   		
   		call staging.proc_update_log_table(pvi_purpose:= 'UPDATE', pvi_status_ld_spec_tab := 'C', pvo_load_id:= pvi_load_id);  		
   	
   		vv_var_str = '';
   		vv_col_num_str = '';
   		
   		pvo_result = 'Y';
   
   	
	exception when others then 
		
		call staging.proc_update_log_table(pvi_purpose:= 'UPDATE', pvi_status_ld_spec_tab := 'E', pvo_load_id:= pvi_load_id);
	      
	    error_msg := 'error occurred while executing procedure ' || coalesce(vv_proc_name,'') || ' , error: ' || sqlerrm ;  
		
		EXECUTE 'INSERT INTO meta.database_log(proc_name, error) VALUES($1, $2)'
		USING vv_proc_name, error_msg;
	
	end; 
    
$procedure$
;


select * from meta.load_tables_population_log ; 

select * from meta.database_log order by log_id desc;

select * from staging.generic_load_table ;

select * from staging.load_domain_dm ;
