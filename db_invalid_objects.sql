select object_name from dba_objects where status <> 'VALID'
-- and object_type not in ('MATERIALIZED VIEW')
order by owner, object_name;

/*
declare                                                                                                                                                                                                 
 count_ number := 0;                                                                                                                                                                                    
 begin                                                                                                                                                                                                  
   select count(1) into count_ from dba_objects                                                                                                                                                         
   where status='INVALID' and object_type not in ('MATERIALIZED VIEW');                                                                                                                                 
 if count_ != 0                                                                                                                                                                                         
 then                                                                                                                                                                                                   
   execute immediate('exec sys.UTL_RECOMP.RECOMP_SERIAL');                                                                                                                                                                             
 end if;                                                                                                                                                                                                
 end;                                                                                                                                                                                                   
/
*/

select owner, object_name, object_type from dba_OBJECTS where status <> 'VALID' order by owner, object_name;

-- All recompilieren
exec sys.UTL_RECOMP.RECOMP_SERIAL;

alter package ING_STAGE.MPS_GRID_FATCA_REPORTABLE_CUST compile;

select count(*) from dba_OBJECTS where status <> 'VALID';
select owner, object_type, count(*) from dba_OBJECTS where status <> 'VALID' group by owner, object_type order by owner, object_type;
