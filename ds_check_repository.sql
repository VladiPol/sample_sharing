-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Select zum Auffinden von Tabellen in Jobs
-- Starten auf der DB INFINTE mit User External
-- Zeigt welche Tabellen in den Jobs vorkommt
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT DISTINCT DATASTAGEX_DSJOBDEF.NAME_XMETA Job,
                  DATASTAGEXDSFLOWVARIBL.TABLEDEF_XMETA,
                  SUBSTR (DATASTAGEXDSFLOWVARIBL.TABLEDEF_XMETA,
                            INSTR (DATASTAGEXDSFLOWVARIBL.TABLEDEF_XMETA,
                                   '\\',
                                   1,
                                   2)
                          + 2)
                     tabelle
    FROM    XMETA.DATASTAGEXDSFLOWVARIBL
         JOIN
            XMETA.DATASTAGEX_DSJOBDEF
         ON (    DATASTAGEX_DSJOBDEF.XMETA_REPOS_OBJECT_ID_XMETA =
                    DATASTAGEXDSFLOWVARIBL.XMETA_LOCKINGROOT_XMETA
             AND 'DLDEED01:DE_DATA_LAKE_SPTE' = DSNAMESPACE_XMETA)
   WHERE DATASTAGEXDSFLOWVARIBL.TABLEDEF_XMETA LIKE '%base%'
            AND NOT DATASTAGEX_DSJOBDEF.NAME_XMETA LIKE '%Optimized%'
         AND NOT DATASTAGEX_DSJOBDEF.NAME_XMETA LIKE 'CopyOf%'
         AND NOT DATASTAGEX_DSJOBDEF.NAME_XMETA LIKE '%TEST'
         AND NOT DATASTAGEX_DSJOBDEF.NAME_XMETA LIKE 'TEST%'
         AND NOT DATASTAGEX_DSJOBDEF.NAME_XMETA LIKE '%Sample'
         AND NOT DATASTAGEX_DSJOBDEF.NAME_XMETA LIKE '%Initial_Hash_Value%'
ORDER BY 3;


-- Eingabe des Suchmusters (z.Bsp. BDB oder BAISMART oder KNEIFF) in P_JOBNAME
-- Eingabe ab wann die Stati der gesuchten Jobs ausgewertet werden in P_STICHTAG
-- Select 1: Statusübersicht
-- Select 2: Error-Details
DEFINE P_JOBNAME = 'BAIS';
DEFINE P_STICHTAG = '20160217';

SET LINESIZE 2000
SET PAGESIZE 60    
SET VERIFY OFF

ALTER SESSION SET NLS_DATE_FORMAT = 'DD.MM.YYYY HH24:MI:SS';

COL JOB_NAME      FOR A40
COL FLOW_ALIAS    FOR A15
COL INVOCATION_ID FOR A40
COL STATUS        FOR A25
COL START_TIME    FOR A20
COL END_TIME      FOR A20
COL ANZ_FEHLER   FOR A10
COL PROJECTNAME   FOR A20
COL FOLDERPATH    FOR A35
CLEAR BREAKS

SELECT   F_JOB_RUN.JOB_RUN_ID ,                      --> MAP_RUN_ID
         F_JOB_RUN.JOB_NM                                     JOB_NAME,
         d_job_exec.projectname ,
         d_job_exec.folderpath  ,
         F_FLOW_DEF.FLOW_ID                                   FLOW_ID,
         F_FLOW_DEF.FLOW_ALIAS                                FLOW_ALIAS,
         F_FLOW_RUN.INVOCATION_ID                             INVOCATION_ID,  
         to_date(to_char(F_FLOW_RUN.STRT_TMS,'DD.MM.YYYY HH24:MI:SS')) START_TIME,        
         to_date(to_char(F_FLOW_RUN.END_TMS ,'DD.MM.YYYY HH24:MI:SS')) END_TIME,
         trunc((to_date(to_char(F_FLOW_RUN.END_TMS ,'DD.MM.YYYY HH24:MI:SS')) - to_date(to_char(F_FLOW_RUN.STRT_TMS,'DD.MM.YYYY HH24:MI:SS'))) * 24 * 60, 2)  MINUTEN,
         F_FLOW_RUN.ST_NM || case when f_err_log.anzahl_fehler < 50 then ' with Warnings' end             STATUS,         
         d_job_run.totalrowsconsumed as rows_selected,
         d_job_run.totalrowsproduced as rows_produced,         case when f_err_log.anzahl_fehler = 50 and upper(F_FLOW_RUN.ST_NM) = 'ABORTED' then '> 50' else to_char(f_err_log.anzahl_fehler) end ANZ_FEHLER
FROM  dlfwk.fwk_flow_def   f_flow_def     
   INNER JOIN dlfwk.fwk_flow_run   f_flow_run  ON  f_flow_def.flow_id = f_flow_run.flow_id     
   INNER JOIN dlfwk.fwk_job_run    f_job_run   ON  f_flow_run.invocation_id = f_job_run.invocation_id     
   INNER JOIN dsodb.jobrun         d_job_run   ON  f_job_run.invocation_id = d_job_run.invocationid     
   INNER JOIN dsodb.jobexec        d_job_exec  ON  (d_job_run.jobid = d_job_exec.jobid AND f_job_run.job_nm = d_job_exec.jobname) 
    LEFT OUTER JOIN (SELECT invocation_id                            ,job_run_id                            ,count(*) as anzahl_fehler                        
                   FROM dlfwk.fwk_error_log                       
                 GROUP BY invocation_id, job_run_id
                 ) f_err_log   ON ( f_job_run.invocation_id = f_err_log.invocation_id  AND  f_job_run.job_run_id = f_err_log.job_run_id)  
 WHERE F_FLOW_DEF.MST_JOB_NM like '%&P_JOBNAME%'   
  AND f_flow_run.strt_tms >= to_date('&P_STICHTAG','YYYYMMDD')
ORDER BY START_TIME
;


--
-- Auswertung 2: Error-Details
--
COL JOB_NAME      FOR A40
COL FLOW_ALIAS    FOR A15
COL INVOCATION_ID FOR A30
COL STATUS        FOR A25
COL ERROR_MSG     FOR A80
COL ERROR_DATA    FOR A150
BREAK ON JOB_RUN_ID SKIP PAGE DUPLICATES

SELECT  F_JOB_RUN.JOB_RUN_ID,                                --> MAP_RUN_ID
        F_JOB_RUN.JOB_NM                                     JOB_NAME,         
        case when F_FLOW_RUN.ST_NM  = 'Finished' THEN 'Finished with Warnings' else F_FLOW_RUN.ST_NM END          STATUS,         
        to_date(to_char(F_ERR_LOG.ERROR_TMS,'DD.MM.YYYY HH24:MI:SS')) ERROR_TIME,         
        substr(F_ERR_LOG.ERROR_ADD_INFO,instr(F_ERR_LOG.ERROR_ADD_INFO,'ORA'),80) as ERROR_MSG,         
        substr(F_ERR_LOG.RCPCOLUMNLIST,1,150) AS ERROR_DATA  
 FROM  dlfwk.fwk_flow_def   f_flow_def     
INNER JOIN dlfwk.fwk_flow_run   f_flow_run  ON ( f_flow_def.flow_id       = f_flow_run.flow_id      )      
INNER JOIN dlfwk.fwk_job_run    f_job_run   ON ( f_flow_run.invocation_id = f_job_run.invocation_id )      
INNER JOIN dlfwk.fwk_error_log  f_err_log   ON ( f_job_run.invocation_id  = f_err_log.invocation_id  AND  f_job_run.job_run_id = f_err_log.job_run_id)  
WHERE F_FLOW_DEF.MST_JOB_NM like '%&P_JOBNAME%'   
AND f_flow_run.strt_tms >=  to_date('&P_STICHTAG','YYYYMMDD')
ORDER BY ERROR_TIME
;

--
-- Meldungen zum Job
--
SELECT CAST (
            FROM_TZ (CAST (JL.LOGTIMESTAMP AS TIMESTAMP), 'UTC')
               AT TIME ZONE 'Europe/Berlin' AS DATE)
            AS LOGTIMESTAMP,
         JL.EVENTID,
         JL.LOGTYPE,
         JE.JOBNAME,
         JE.JOBTYPE,
         TO_CHAR (SUBSTR (JL.MESSAGETEXT, 1, 200)) AS MESSAGETEXT
    FROM DSODB.JOBRUN JR
         LEFT OUTER JOIN DSODB.JOBRUNLOG JL ON JR.RUNID = JL.RUNID
         LEFT OUTER JOIN DSODB.JOBEXEC JE ON JR.JOBID = JE.JOBID
   WHERE JR.INVOCATIONID = '150165994604514535380000008701'
ORDER BY 4, 2, 1


--
-- Check, if the job the parameter (for example) 
-- max-apt verwendet
--
select 
            jdef.name_xmeta                     as jobname, 
            JDEF.CATEGORY_XMETA                 as job_pfad, 
            jdef.dsnamespace_xmeta              as project, 
            to_char(substr(PVAL.VALUEEXPRESSION_XMETA,1,3500)) as value_expression 
   from 
            xmeta.DATASTAGEXDSPARAMETRVL pval, 
            xmeta.DATASTAGEX_DSJOBDEF    jdef 
   where 
            pval.VALUEEXPRESSION_XMETA LIKE '%max.apt%' 
            -- and pval.PARAMETERNAME_XMETA = '$APT_CONFIG_FILE' 
  
            and PVAL.XMETA_LOCKINGROOT_XMETA  = jdef.XMETA_REPOS_OBJECT_ID_XMETA 
            and jdef.dsnamespace_xmeta = 'DLDEEP01:DE_DATA_LAKE_SPTP' 
            -- and jdef.name_xmeta  like '%BAISMART%' 
            and JDEF.CATEGORY_XMETA not like '\\999_User_private\\%' 
   order by 
            JDEF.CATEGORY_XMETA, 
            jdef.name_xmeta;


--
-- Job-Laufzeiten
-- z.B. alle Jobs zwischen 03:00 und 09:00 Uhr mit der Laufzeit > 15 Minuten
SELECT * FROM
(
SELECT /*+ parallel(4)  */
         -- CAST (FROM_TZ (CAST (JL.LOGTIMESTAMP AS TIMESTAMP), 'UTC') AT TIME ZONE 'Europe/Berlin' AS DATE) AS LOGTIMESTAMP,         
         CAST (FROM_TZ (CAST (JR.RUNSTARTTIMESTAMP AS TIMESTAMP), 'UTC') AT TIME ZONE 'Europe/Berlin' AS DATE) AS RUNSTARTTIMESTAMP,
         CAST (FROM_TZ (CAST (JR.RUNENDTIMESTAMP AS TIMESTAMP), 'UTC') AT TIME ZONE 'Europe/Berlin' AS DATE) AS RUNENDTIMESTAMP,         
         JE.JOBNAME,         
         (JR.RUNENDTIMESTAMP - JR.RUNSTARTTIMESTAMP) AS LAUFZEIT,
         ROUND((CAST (JR.RUNENDTIMESTAMP AS DATE) - CAST (JR.RUNSTARTTIMESTAMP AS DATE))*24*60) AS JOB_LAUFZEIT_MINUTEN         
    FROM DSODB.JOBRUN JR
         LEFT OUTER JOIN DSODB.JOBRUNLOG JL ON JR.RUNID = JL.RUNID
         LEFT OUTER JOIN DSODB.JOBEXEC JE ON JR.JOBID = JE.JOBID
   WHERE JE.JOBNAME != 'FWK_SQ_Start_Flow'
   and LOGTYPE = 'RUN'
   and trunc(JL.LOGTIMESTAMP) = trunc(sysdate)   
   --JR.INVOCATIONID = '150165994604514535380000008701'
ORDER BY 4, 2, 1
)
WHERE 
RUNSTARTTIMESTAMP between to_date('30.08.2017 3:00:00','dd.mm.yyyy HH24:MI:SS') and to_date('30.08.2017 9:00:00','dd.mm.yyyy HH24:MI:SS')
and JOB_LAUFZEIT_MINUTEN > 15
order by 1;

