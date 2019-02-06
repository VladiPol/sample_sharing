prompt
prompt
prompt *****************************************************************************
prompt Sessions die aufgrund eines Locks warten, also nicht ausgeführt werden können
prompt *****************************************************************************
column command  format a18
column osuser   format a12
column username format a12

select s.osuser,
       s.username,
       to_char(s.LOGON_TIME,'dd.mm.yyyy hh24:mi') as logon_time,
       s.status,
       s.module,
       decode(s.command,1,'CREATE TABLE'
                     ,2,'INSERT'
                     ,3,'SELECT'
                     ,4,'CREATE CLUSTER'
                     ,5,'ALTER CLUSTER'
                     ,6,'INS/UPD'
                     ,7,'DELETE'
                     ,8,'DROP'
                     ,9,'CREATE INDEX'
                    ,10,'DROP INDEX'
                    ,11,'ALTER INDEX'
                    ,12,'DROP TABLE'
                    ,15,'ALTER TABLE'
                    ,17,'GRANT'
                    ,24,'CREATE PROCEDURE'
                    ,25,'ALTER PACKAGE'
                    ,27,'NO OPERATION'
                    ,29,'COMMENT'
                    ,40,'ALTER TABLESPACE'
                    ,44,'COMMIT'
                    ,45,'ROLLBACK'
                    ,47,'PL/SQL EXECUTE'
                    ,49,'ALTER SYSTEM KILL'
                    ,62,'ANALYZE_SCHEMA'
                    ,-67,'MERGE'
                    ,74,'CREATE MATERIALIZED VIEW'
                    ,-74,'LOCAL INDEX UPDATE'
                    ,76,'DROP MATERIALIZED VIEW'
                    ,85,'TRUNCATE TABLE'
                    ,94,'CREATE PACKAGE'
                    ,95,'ALTER PACKAGE COMPILE'
                    ,97,'CREATE PACKAGE BODY'
                    ,189,'MERGE'
                    ,to_char(command) || '...Sonstige'
                      ) "command",
       inst_id,substr(s.sid || ',' || s.serial#,1,11) "SID,SERIAL#"
,S.BLOCKING_SESSION,   wait_class,
   seconds_in_wait
from     gv$session s
where    lockwait is not null
or S.BLOCKING_SESSION is not null
;
