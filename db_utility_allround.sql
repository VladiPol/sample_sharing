-- Nicht numerische Werte finden
select case when regexp_like(accountbalance, '^-?[[:digit:],.]*$') then 'Numeric' else 'Non-Numeric' end as type, count(*)      
from   mart.fatca_grid_customers_de_v 
where  accountbalance is not null 
group by case when regexp_like(accountbalance, '^-?[[:digit:],.]*$') then 'Numeric' else 'Non-Numeric' 
end;

--Tablespacebelegung
 col "Tablespace" for a22
 col "Used MB" for 99,999,999
 col "Free MB" for 99,999,999
 col "Total MB" for 99,999,999

 select df.tablespace_name "Tablespace",
 totalusedspace "Used MB",
 (df.totalspace - tu.totalusedspace) "Free MB",
 df.totalspace "Total MB",
 round(100 * ( (df.totalspace - tu.totalusedspace)/ df.totalspace))
 "Pct. Free"
 from
 (select tablespace_name,
 round(sum(bytes) / 1048576) TotalSpace
 from dba_data_files 
 group by tablespace_name) df,
 (select round(sum(bytes)/(1024*1024)) totalusedspace, tablespace_name
 from dba_segments 
 group by tablespace_name) tu
 where df.tablespace_name = tu.tablespace_name ; 

-- Tabelspacebelegung
select b.tablespace_name, tbs_size SizeMb, a.free_space FreeMb
from  (select tablespace_name, round(sum(bytes)/1024/1024 ,2) as free_space
       from dba_free_space
       group by tablespace_name) a,
      (select tablespace_name, sum(bytes)/1024/1024 as tbs_size
       from dba_data_files
       group by tablespace_name) b
where a.tablespace_name(+)=b.tablespace_name;