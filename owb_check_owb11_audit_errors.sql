exec OWBSYS.WB_WORKSPACE_MANAGEMENT.SET_WORKSPACE('OWB_PARIS.OWB_PARIS');

select OWBSYS.WB_WORKSPACE_MANAGEMENT.GET_WORKSPACE_NAME,
 OWBSYS.WB_WORKSPACE_MANAGEMENT.GET_WORKSPACE_OWNER
from dual;

select ',''' || map_name || '''', start_time, end_time
  ,round(elapse_time/60,2) runtime, run_status
 , number_records_selected SEL, R.NUMBER_RECORDS_INSERTED INS , R.NUMBER_RECORDS_UPDATED UPD
 , R.NUMBER_RECORDS_MERGED MER
 --, T.TARGET_NAME
 , E.RUN_ERROR_MESSAGE
 from owbsys.ALL_RT_AUDIT_MAP_RUNS r,
      --owbsys.ALL_RT_AUDIT_MAP_RUN_TARGETS t,
      owbsys.ALL_RT_AUDIT_MAP_RUN_ERRORS e
      --,dba_tables db
 where 1=1
   and r.created_on >= trunc(sysdate)-3
   --and (run_status = 'RUNNING' or
   --E.RUN_ERROR_MESSAGE is not null)
   --and start_time between to_date('17.07.2013 22:25','dd.mm.yyyy hh24:mi') 
   --             and     to_date('17.07.2013 22:35','dd.mm.yyyy hh24:mi')
   --and round(elapse_time/60,2) > 10 
   --and map_name like '%MPM_LOAD_GSTIFF_BAUFI%'
  -- and T.TARGET_NAME  = db.table_name
   --and db.owner = 'SAPBAMART'
   --and R.MAP_RUN_ID = T.MAP_RUN_ID
   and R.MAP_RUN_ID = E.MAP_RUN_ID(+) 
   --and R.NUMBER_RECORDS_MERGED > 10000000
 order by 2 desc;


-- Fehlerhandling 
select distinct ex.execution_name 
   --, map_name 
   , mr.start_time  beginn
   , mr.end_time ende
   , mr.run_status status
   , MR.NUMBER_ERRORS fehler
   , mr.number_records_selected anzahl
   , MR.NUMBER_RECORDS_INSERTED ins
   , MR.NUMBER_RECORDS_UPDATED upd
   , MR.NUMBER_RECORDS_MERGED mer
   , MR.NUMBER_ERRORS, MR.NUMBER_LOGICAL_ERRORS, MR.NUMBER_RECORDS_DISCARDED
   , MR.CREATED_BY schema
   , T.TARGET_NAME
   , ME.RUN_ERROR_MESSAGE RUN_TEXT
   --, EXM.MESSAGE_TEXT EXEC_TEXT
   --, EPA.PARAMETER_NAME, EPA.VALUE
  from owbsys.ALL_RT_AUDIT_MAP_RUNS mr
      ,owbsys.ALL_RT_AUDIT_MAP_RUN_TARGETS t
      ,owbsys.ALL_RT_AUDIT_MAP_RUN_ERRORS me
      ,owbsys.ALL_RT_AUDIT_EXECUTIONS ex
      ,owbsys.ALL_RT_AUDIT_EXEC_MESSAGES exm
      ,owbsys.ALL_RT_AUDIT_EXECUTION_PARAMS epa
 where 1=1
   and mr.created_on >= trunc(sysdate)-1
   --and run_status = 'RUNNING'
   and ME.RUN_ERROR_MESSAGE is not null
   --and (ex.execution_name = 'MPM_DIM_UC4_OBJEKT1' )
   and MR.MAP_RUN_ID         = T.MAP_RUN_ID(+)
   and MR.MAP_RUN_ID         = ME.MAP_RUN_ID(+) 
   and MR.EXECUTION_AUDIT_ID = EX.EXECUTION_AUDIT_ID(+)
   and EX.EXECUTION_AUDIT_ID = EPA.EXECUTION_AUDIT_ID(+)
   and EX.EXECUTION_AUDIT_ID = EXM.EXECUTION_AUDIT_ID(+)
 order by mr.end_time desc;
 
select * 
from  OWBSYS.ALL_RT_AUDIT_EXEC_MESSAGES
where created_on >= sysdate - 1
order by MESSAGE_AUDIT_ID desc;

select   ex.execution_audit_id, ex.execution_name, 
         map_name, start_time, end_time, round(ex.elapse_time/60,2), run_status
   --  , number_records_selected, R.NUMBER_RECORDS_INSERTED
   --  , R.NUMBER_RECORDS_UPDATED
   --  , R.NUMBER_RECORDS_MERGED
   --  , T.TARGET_NAME
   --  , E.RUN_ERROR_MESSAGE
       , EXM.MESSAGE_TEXT
  from   OWBSYS.ALL_RT_AUDIT_MAP_RUNS r,
         OWBSYS.ALL_RT_AUDIT_EXECUTIONS ex,
         --OWBSYS.ALL_RT_AUDIT_MAP_RUN_TARGETS t,
         --OWBSYS.ALL_RT_AUDIT_MAP_RUN_ERRORS e,
         OWBSYS.ALL_RT_AUDIT_EXEC_MESSAGES exm
 where   1=1
   and   ex.created_on >= trunc(sysdate)-10
   --and ( run_status = 'RUNNING' or
   --      EXM.MESSAGE_TEXT is not null )
   and (ex.execution_name in 
   ('MPM_CB_CASH_FLOWS'
,'MPM_CB_EXCHANGE_RATES'
,'MPM_CB_FACILITIES'
,'MPM_CB_FX_FORWARDS'
,'MPM_CB_INTEREST_RATES'
,'MPM_CB_PROFITSANDLOSSES'
,'MPM_CB_REDUCTION_SCHEDULES'
,'MPM_BAUFI_ANGEBOTE'
,'MPM_BAUFI_HEDGES'
,'MPM_BESTSWAPTRADES_DEL'
,'MPM_CAPS_FLOORS'
,'MPM_CAPS_FLOORS_DEL'
,'MPM_MONEYMARKETS_DEL'
,'MPM_PASSIVPRODUKTE'
,'MPM_RATENKREDITE'
,'MPM_REPO_BILAT_DEL'
,'MPM_REPO_DEL'
,'MPM_SET_DATUM'
,'MPM_WERTPAPIERE_DEL'
 ))
   --and R.MAP_RUN_ID = T.MAP_RUN_ID(+)
   --and R.MAP_RUN_ID = E.MAP_RUN_ID(+) 
   and EX.EXECUTION_AUDIT_ID = R.EXECUTION_AUDIT_ID(+)
   and EX.EXECUTION_AUDIT_ID = EXM.EXECUTION_AUDIT_ID(+)
 order by 2, EX.EXECUTION_AUDIT_ID desc;
 

-- Check SAPBAMART
select ',''' || map_name || '''', start_time, end_time
  ,round(elapse_time/60,2) runtime, run_status
 , number_records_selected SEL, R.NUMBER_RECORDS_INSERTED INS , R.NUMBER_RECORDS_UPDATED UPD
 , R.NUMBER_RECORDS_MERGED MER
 , T.TARGET_NAME
 , E.RUN_ERROR_MESSAGE
 from owbsys.ALL_RT_AUDIT_MAP_RUNS r,
      owbsys.ALL_RT_AUDIT_MAP_RUN_TARGETS t,
      owbsys.ALL_RT_AUDIT_MAP_RUN_ERRORS e,
      dba_tables db
 where 1=1
   and r.created_on >= trunc(sysdate)-1
   --and (run_status = 'RUNNING' or
   --E.RUN_ERROR_MESSAGE is not null)
   --and start_time between to_date('17.07.2013 22:25','dd.mm.yyyy hh24:mi') 
   --             and     to_date('17.07.2013 22:35','dd.mm.yyyy hh24:mi')
   --and round(elapse_time/60,2) > 10 
   --and map_name like '%MPM_LOAD_GSTIFF_BAUFI%'
   and T.TARGET_NAME  = db.table_name
   and db.owner = 'SAPBAMART'
   and R.MAP_RUN_ID = T.MAP_RUN_ID
   and R.MAP_RUN_ID = E.MAP_RUN_ID(+) 
   --and R.NUMBER_RECORDS_MERGED > 10000000
 order by 2 desc;


-- Check Kordoba-Datenpool
select rta.CREATION_DATE DATUM, rta.RTA_LOB_NAME MAP, ROUND(rta_ELAPSE/60,2) "ELAPSE Min", rta.RTA_SELECT SELECTED, 
 rta.RTA_INSERT INSERTED, rta.RTA_UPDATE UPDATED, rta.RTA_DELETE DELETED, rta.RTA_MERGE MERGED,
 rtd.RTD_SOURCE SOURCE, rtd.RTD_TARGET TARGET, 
 --rtd.RTD_STATUS STATUS, rtd.RTD_STATEMENT STMT,  RTE_DEST_TABLE DEST, 
 rte.RTE_STATEMENT ERR_STMT,  rte.RTE_SQLERR ERR,  rte.RTE_SQLERRM SQLERRM
from  owbsys.owb$wb_rt_audit rta,
      owbsys.owb$wb_rt_audit_detail rtd,
      owbsys.owb$wb_rt_errors rte,
      owbsys.owb$wb_rt_error_rows rtr
where rte.rta_iid(+) = rta.rta_iid
and rte.rte_iid = rtr.rte_iid(+)
and rta.rta_iid = rtd.rta_iid
and ( --   rta.RTA_LOB_NAME like '"MPO_KKK5%"' 
    rta.RTA_LOB_NAME = '"MPO_KKBO"'
 or rta.RTA_LOB_NAME = '"MPO_KKBH"'
 --orrta.RTA_LOB_NAME = '"MPO_KEV5"'
 --orrta.RTA_LOB_NAME = '"MPO_KBO5"' 
 or rta.RTA_LOB_NAME like '"MPS_%_TABLE_%"'
 --orrta.RTA_LOB_NAME = '"MPS_UK_TABLE_UMS"' 
 or rta.RTA_LOB_NAME like '%5_PHY%'
 or rta.RTA_LOB_NAME like '"MPO%5%'  )
and rta.CREATION_DATE  >= sysdate - 1
--and rte.rte_sqlerrm is not null
order by ROUND(rta_ELAPSE/60,2) desc, rta.RTA_IID desc;

-- Check HST-Mappings
select rta.CREATION_DATE DATUM, rta.RTA_LOB_NAME MAP, ROUND(rta_ELAPSE/60,2) "ELAPSE Min", rta.RTA_SELECT SELECTED, 
 rta.RTA_INSERT INSERTED, rta.RTA_UPDATE UPDATED, rta.RTA_DELETE DELETED, rta.RTA_MERGE MERGED,
 rtd.RTD_SOURCE SOURCE, rtd.RTD_TARGET TARGET, 
 --rtd.RTD_STATUS STATUS, rtd.RTD_STATEMENT STMT,  RTE_DEST_TABLE DEST, 
 rte.RTE_STATEMENT ERR_STMT,  rte.RTE_SQLERR ERR,  rte.RTE_SQLERRM SQLERRM
from  owbsys.owb$wb_rt_audit rta,
 owbsys.owb$wb_rt_audit_detail rtd,
 owbsys.owb$wb_rt_errors rte,
 owbsys.owb$wb_rt_error_rows rtr
where rte.rta_iid(+) = rta.rta_iid
and rte.rte_iid = rtr.rte_iid(+)
and rta.rta_iid = rtd.rta_iid
and ( rta.RTA_LOB_NAME in ('"MPO_HLAN"','"MPO_HORT"','"MPO_HOBA"','"MPO_HOGS"','"MPO_HPAR"','"MPO_HBVO"','"MPO_HBVO2"'
,'"MPO_HBVF"','"MPO_HBOV"','"MPO_HKRV"','"MPO_HKRV2"','"MPO_HPAA"','"MPO_HPAK"','"MPO_HKOA"','"MPO_HBAV"','"MPO_HBAV2"'
,'"MPO_HPRZ"','"MPO_HPAV"','"MPO_HPZK"','"MPO_HVOA"','"MPO_HPKO"','"MPO_HMEN"','"MPO_HBLA"','"MPO_HKIL"','"MPO_HKST"'
,'"MPO_HKOV"','"MPO_HKOB','"MPO_HRIP"'
,'"MPO_HDAK"', '"MPO_HKKK"', '"MPO_HKKV"', '"MPO_HKKS"', '"MPO_HFGK"','"MPO_HPDK"', '"MPO_HSPK"','"MPO_HDTG"'
,'"MPO_HHIP"','"MPO_HBAR"','"MPO_HDAR"','"MPO_HKOB"','"MPO_HKBZ"'
))
and rta.CREATION_DATE  >= sysdate - 2
--and rtd.RTD_TARGET like '%KK_TABLE_KTB%'
--and rte.rte_sqlerrm is not null
--order by rta.RTA_IID desc;
order by trunc(rta.CREATION_DATE) desc, rta_ELAPSE desc;



-- Alte OWB-10 Audit Informationen
select r.execution_audit_id, map_name, start_time, end_time, round(elapse_time/60,2), run_status
 , number_records_selected, R.NUMBER_RECORDS_INSERTED
 , R.NUMBER_RECORDS_UPDATED
 , R.NUMBER_RECORDS_MERGED
 --, T.TARGET_NAME
 , E.MESSAGE_TEXT
  from OWB_PARIS.OWB10_AUDIT_MAP_RUNS r,--   ALL_RT_AUDIT_MAP_RUNS r,
 -- owbsys.ALL_RT_AUDIT_MAP_RUN_TARGETS t,
  OWB_PARIS.OWB10_AUDIT_EXEC_MESSAGES e--   ALL_RT_AUDIT_MAP_RUN_ERRORS e
 where 1=1
   and r.created_on >= trunc(sysdate)-150
   and (run_status = 'RUNNING' or
   E.MESSAGE_TEXT is not null)
   --and map_name like '%MPM_HA_BAUFIS_NEUGESCHAEFT%'  
   --and T.TARGET_NAME = 'CONTACTS'
--   and R.MAP_RUN_ID = T.MAP_RUN_ID
   and R.MAP_RUN_ID = E.MESSAGE_AUDIT_ID(+) 
 order by R.EXECUTION_AUDIT_ID desc;


-- Gesamtlauflaufzeit Kordoba-ODS
-- 21.11.2011   CHG-037204   zentralen Parameter f¸r PRE_MAP_INCREMENT wieder von 4 auf 8 erhˆhen, da nun neue Hardware
select 
 trunc(created_on),
 count(ex.execution_name)AS anz_mappings,
 round(sum(elapse_time)  / 60,2)   AS laufzeit_min
from
 OWBSYS.all_rt_audit_executions ex
where
 ex.created_on > sysdate-10 and
 ex.execution_name in (select distinct name from dba_source where text like '%\_INC%' escape '\' and text not like '%PHY%' and owner = 'ODS' and name like '%5')
 group by trunc(created_on)
order by
 1 desc
;

select 
 trunc(created_on),
 count(ex.execution_name)AS anz_mappings,
 round(sum(elapse_time)  / 60,2)   AS laufzeit_min
from
 owbsys.all_rt_audit_executions ex
where   ex.created_on > sysdate-1
and   (   execution_name = 'MPO_KKBO'
 or execution_name = 'MPO_KKBH'
 or execution_name like 'MPS_%_TABLE_%'
 or execution_name like '%5_PHY%'
 or execution_name like 'MPO%5%'  )
group by trunc(created_on)
order by
 1 desc
;

-- Laufzeitauswertung Kordoba incl. TOP3
select 
 trunc(ex.created_on),
 count(ex.execution_name)   AS anz_mappings,
 sum(round(ex.elapse_time / 60,2))  AS laufzeit_min,
 max(top.TOP1_MAP) TOP1_MAP,
 max(top.TOP1_ELAPSE) TOP1_ELAPSE,
 max(top.TOP2_MAP) TOP2_MAP,
 max(top.TOP2_ELAPSE) TOP2_ELAPSE,
 max(top.TOP3_MAP) TOP3_MAP,
 max(top.TOP3_ELAPSE) TOP3_ELAPSE
from   owbsys.all_rt_audit_executions ex,
(SELECT created_on,
 MAX(CASE  rang WHEN 1 THEN  execution_name ELSE NULL END) AS TOP1_MAP,
 MAX(CASE  rang WHEN 1 THEN  runtime ELSE NULL END) AS TOP1_ELAPSE,
 MAX(CASE  rang WHEN 2 THEN  execution_name ELSE NULL END) AS TOP2_MAP,
 MAX(CASE  rang WHEN 2 THEN  runtime ELSE NULL END) AS TOP2_ELAPSE,
 MAX(CASE  rang WHEN 3 THEN  execution_name ELSE NULL END) AS TOP3_MAP,
 MAX(CASE  rang WHEN 3 THEN  runtime ELSE NULL END) AS TOP3_ELAPSE   
 FROM
(SELECT  trunc(created_on) created_on, 
  execution_name, 
  round(elapse_time / 60 ,2) runtime,
  row_number() over(partition by trunc(created_on) order by elapse_time desc nulls last ) rang
 FROM owbsys.all_rt_audit_executions
 WHERE  created_on > sysdate-20 
 AND( execution_name in( 'MPO_KKBO', 'MPO_KKBH')
 or execution_name like 'MPS_%_TABLE_%'
 or execution_name like '%5_PHY%'
 or execution_name like 'MPO%5%'  )
)
 WHERE RANG < 4 
 GROUP BY created_on) top   
where 1=1--ex.execution_name   = top.execution_name
and trunc(ex.created_on) = top.created_on
and ex.created_on > sysdate-20 
and(  execution_name in( 'MPO_KKBO', 'MPO_KKBH')
 or ex.execution_name like 'MPS_%_TABLE_%'
 or ex.execution_name like '%5_PHY%'
 or ex.execution_name like 'MPO%5%'  )
group by trunc(ex.created_on)
order by 1 desc;


-- Laufzeitauswertung Kordoba incl. TOP1 ja LADE-STEP
select trunc(ex.created_on),
 count(ex.execution_name)   AS anz_mappings,
 sum(round(ex.elapse_time / 60,2))  AS laufzeit_min,
 max(top.TOP1_STAGE_MAP) TOP1_STAGE_MAP,
 max(top.TOP1_STAGE_ELAPSE) TOP1_STAGE_ELAPSE,
 max(top.TOP1_PHY_MAP) TOP1_PHY_MAP,
 max(top.TOP1_PHY_ELAPSE) TOP1_PHY_ELAPSE,
 max(top.TOP1_ODS_MAP) TOP1_ODS_MAP,
 max(top.TOP1_ODS_ELAPSE) TOP1_ODS_ELAPSE
from   owbsys.all_rt_audit_executions ex,
(SELECT created_on,
 MAX(CASE  WHEN rang = 1 and step = '01_STAGE' THEN  execution_name ELSE NULL END) AS TOP1_STAGE_MAP,
 MAX(CASE  WHEN rang = 1 and step = '01_STAGE' THEN  runtime ELSE NULL END) AS TOP1_STAGE_ELAPSE,
 MAX(CASE  WHEN rang = 1 and step = '02_PHY' THEN  execution_name ELSE NULL END) AS TOP1_PHY_MAP,
 MAX(CASE  WHEN rang = 1 and step = '02_PHY' THEN  runtime ELSE NULL END) AS TOP1_PHY_ELAPSE,
 MAX(CASE  WHEN rang = 1 and step = '03_ODS' THEN  execution_name ELSE NULL END) AS TOP1_ODS_MAP,
 MAX(CASE  WHEN rang = 1 and step = '03_ODS' THEN  runtime ELSE NULL END) AS TOP1_ODS_ELAPSE   
 FROM
(SELECT  trunc(created_on) created_on, 
  CASE 
  WHEN execution_name like 'MPS_%_TABLE_%' THEN '01_STAGE'
  WHEN execution_name like '%5_PHY%' THEN '02_PHY'
  ELSE '03_ODS'
  END STEP,
  execution_name, 
  round(elapse_time / 60 ,2) runtime,
  row_number() over(partition by  trunc(created_on),
  CASE 
  WHEN execution_name like 'MPS_%_TABLE_%' THEN '01_STAGE'
  WHEN execution_name like '%5_PHY%' THEN '02_PHY'
  ELSE '03_ODS'
  END
   order by elapse_time desc nulls last ) rang
 FROMowbsys.all_rt_audit_executions
 WHERE  created_on > sysdate-10 
 AND( execution_name = 'MPO_KKBO'
 or execution_name = 'MPO_KKBH'
 or execution_name like 'MPS_%_TABLE_%'
 or execution_name like '%5_PHY%'
 or execution_name like 'MPO%5%'  )
)
 WHERE RANG < 2 
 GROUP BY created_on ) top
where 1=1
andtrunc(ex.created_on) = top.created_on
andex.created_on > sysdate-10 
and( ex.execution_name = 'MPO_KKBO'
 or ex.execution_name= 'MPO_KKBH'
 or ex.execution_name like 'MPS_%_TABLE_%'
 or ex.execution_name like '%5_PHY%'
 or ex.execution_name like 'MPO%5%'  )
group by trunc(ex.created_on)
order by 1 desc;

-- Laufzeitauswertung Kordoba incl. TOP3 und TOP1 je LADE-STEP kombinert
select trunc(ex.created_on),
 count(ex.execution_name)   AS anz_mappings,
 sum(round(ex.elapse_time / 60,2))  AS laufzeit_min,
 max(TOP1_MAP) TOP1_MAP, 
 max(TOP1_ELAPSE) TOP1_ELAPSE,
 max(TOP2_MAP) TOP2_MAP, 
 max(TOP2_ELAPSE) TOP2_ELAPSE,
 max(TOP3_MAP) TOP3_MAP, 
 max(TOP3_ELAPSE) TOP3_ELAPSE,   
 max(top.TOP1_STAGE_MAP) TOP1_STAGE_MAP,
 max(top.TOP1_STAGE_ELAPSE) TOP1_STAGE_ELAPSE,
 max(top.TOP1_PHY_MAP) TOP1_PHY_MAP,
 max(top.TOP1_PHY_ELAPSE) TOP1_PHY_ELAPSE,
 max(top.TOP1_ODS_MAP) TOP1_ODS_MAP,
 max(top.TOP1_ODS_ELAPSE) TOP1_ODS_ELAPSE
from   owbsys.all_rt_audit_executions ex,
(SELECT created_on,
 MAX(CASE  rang2 WHEN 1 THEN  execution_name ELSE NULL END) AS TOP1_MAP,
 MAX(CASE  rang2 WHEN 1 THEN  runtime ELSE NULL END) AS TOP1_ELAPSE,
 MAX(CASE  rang2 WHEN 2 THEN  execution_name ELSE NULL END) AS TOP2_MAP,
 MAX(CASE  rang2 WHEN 2 THEN  runtime ELSE NULL END) AS TOP2_ELAPSE,
 MAX(CASE  rang2 WHEN 3 THEN  execution_name ELSE NULL END) AS TOP3_MAP,
 MAX(CASE  rang2 WHEN 3 THEN  runtime ELSE NULL END) AS TOP3_ELAPSE,   
 MAX(CASE  WHEN rang = 1 and step = '01_STAGE' THEN  execution_name ELSE NULL END) AS TOP1_STAGE_MAP,
 MAX(CASE  WHEN rang = 1 and step = '01_STAGE' THEN  runtime ELSE NULL END) AS TOP1_STAGE_ELAPSE,
 MAX(CASE  WHEN rang = 1 and step = '02_PHY' THEN  execution_name ELSE NULL END) AS TOP1_PHY_MAP,
 MAX(CASE  WHEN rang = 1 and step = '02_PHY' THEN  runtime ELSE NULL END) AS TOP1_PHY_ELAPSE,
 MAX(CASE  WHEN rang = 1 and step = '03_ODS' THEN  execution_name ELSE NULL END) AS TOP1_ODS_MAP,
 MAX(CASE  WHEN rang = 1 and step = '03_ODS' THEN  runtime ELSE NULL END) AS TOP1_ODS_ELAPSE   
 FROM
(SELECT  trunc(created_on) created_on, 
  CASE 
  WHEN execution_name like 'MPS_%_TABLE_%' THEN '01_STAGE'
  WHEN execution_name like '%5_PHY%' THEN '02_PHY'
  ELSE '03_ODS'
  END STEP,
  execution_name, 
  round(elapse_time / 60 ,2) runtime,
  row_number() over(partition by  trunc(created_on),
  CASE 
  WHEN execution_name like 'MPS_%_TABLE_%' THEN '01_STAGE'
  WHEN execution_name like '%5_PHY%' THEN '02_PHY'
  ELSE '03_ODS'
  END
   order by elapse_time desc nulls last ) rang,
 row_number() over(partition by  trunc(created_on)  order by elapse_time desc nulls last ) rang2
 FROM owbsys.all_rt_audit_executions
 WHERE  created_on > sysdate-10 
 AND( execution_name = 'MPO_KKBO'
 or execution_name = 'MPO_KKBH'
 or execution_name like 'MPS_%_TABLE_%'
 or execution_name like '%5_PHY%'
 or execution_name like 'MPO%5%'  )
)
 WHERE RANG < 4 
 GROUP BY created_on ) top
where 1=1
and trunc(ex.created_on) = top.created_on
and ex.created_on > sysdate-30 
and( ex.execution_name = 'MPO_KKBO'
 or ex.execution_name= 'MPO_KKBH'
 or ex.execution_name like 'MPS_%_TABLE_%'
 or ex.execution_name like '%5_PHY%'
 or ex.execution_name like 'MPO%5%'  )
group by trunc(ex.created_on)
order by 1 desc;


---
--- Select ohne Workspace setzen
---
select  wra.rta_lob_name             as mapping_name,
        round((wra.rta_elapse / 60)) as minuten,
        wra.CREATION_DATE            as start_time, 
        wra.creation_date + (wra.rta_elapse / 86400) as end_time, 
        DECODE(wra.rta_status,0,'0 - RUNNING',2,'2 - FAILURE',1,'1 - COMPLETE')  as status,
        wra.rta_errors   as err, 
        wra.rta_select   as sel, 
        wra.rta_insert   as ins, 
        wra.rta_update   as upd, 
        wra.rta_merge    as mer, 
        wra.created_by   as created_by,
        wre.rte_sqlerrm  as fehlermeldung
from    owbsys.OWB$WB_RT_AUDIT  wra,
        owbsys.OWB$WB_RT_ERRORS wre
where   wra.CREATION_DATE >= sysdate - 30
  and   wra.rta_lob_name like '%MPO_HKKK%'
  and   wra.RTA_IID = wre.rta_iid(+)
--and   wra.rta_errors > 0
order by wra.CREATION_DATE desc;


select
   rta_lob_name as mapping_name, wram.creation_date as start_time, wraml.plain_text as fehlermeldung
   from
owbsys.OWB$WB_RT_AUDIT_MESSAGE_LINES wraml,
owbsys.owb$wb_rt_audit_messages  wram,
owbsys.OWB$WB_RT_AUDIT   wra
   where
wraml.AUDIT_MESSAGE_ID = wram.AUDIT_MESSAGE_ID
and wram.audit_execution_id = wra.rte_id(+)
   order by
wram.creation_date desc;


--- Laufzeitauswertung Ausreiﬂerermittlung
--- Test 1
WITH with_tab
     AS (SELECT *
           FROM (SELECT ex.EXECUTION_NAME AS mapping,
                        mr.CREATION_DATE AS start_zeit,
                        mr.rta_select AS saetze,
                        ROUND (mr.rta_elapse) AS dauer_in_sekunden,
                        CASE
                           WHEN mr.rta_elapse / 60 <= 3 THEN 3
                           WHEN mr.rta_elapse / 60 <= 5 THEN 2
                           WHEN mr.rta_elapse / 60 <= 60 THEN 1.5
                           ELSE 1.2
                        END
                           AS laufzeit_faktor,
                        DECODE (NVL (mr.rta_elapse, 0),
                                0, 0,
                                ROUND (mr.rta_select / mr.rta_elapse))
                           AS anzahl_saetze_pro_sekunde
                   FROM owbsys.OWB$WB_RT_AUDIT mr,
                        owbsys.OWB$WB_RT_AUDIT_EXECUTIONS ex
                  WHERE     ex.AUDIT_EXECUTION_ID = mr.RTE_ID
                        AND mr.rta_status = 1)
          WHERE dauer_in_sekunden > 0)
  SELECT q.mapping,
         Start_Zeit,
         Saetze,
         Dauer_in_sekunden,
         ROUND (Saetze / Dauer_in_sekunden) AS Saetze_pro_sek,
         s.median_sek_dauer,
         s.median_saetze_pro_sek,
         s.median_saetze_pro_sek * (1 / q.laufzeit_faktor),
         q.laufzeit_faktor,
         ROUND ( (dauer_in_sekunden - median_sek_dauer) / median_sek_dauer, 1)
            AS langlaeufer_faktor
    FROM with_tab q,
         (  SELECT mapping,
                   ROUND (MEDIAN (Saetze / Dauer_in_sekunden))
                      AS median_saetze_pro_sek,
                   ROUND (MEDIAN (Dauer_in_sekunden)) AS median_sek_dauer
              FROM with_tab
          GROUP BY mapping) s
   WHERE     Start_Zeit >= trunc(sysdate)-10
         AND q.Saetze / q.Dauer_in_sekunden < s.median_saetze_pro_sek * (1 / q.laufzeit_faktor)
         AND q.Dauer_in_sekunden > s.median_sek_dauer
         AND q.mapping = s.mapping
         --and q.mapping = 'MPO_HOBA'
         AND dauer_in_sekunden > 1200
ORDER BY ROUND ( (dauer_in_sekunden - median_sek_dauer) / median_sek_dauer, 1) DESC;


--- Test 2
       select r.map_name map_name
             ,r.map_run_id map_run_id
             ,q.datum datum
             ,q.laufzeit laufzeit
             ,q.laufzeit_median laufzeit_median
             --,q.laufzeit_avg
             ,q.anz_rows
             ,round(avg   (anz_rows) over(partition by r.map_name),0) anz_rows_avg
             --,round((q.laufzeit * 60) / anz_rows,4)          laufzeit_row_sec1
             ,round( anz_rows / (q.laufzeit * 60) ,4)        laufzeit_row_sec2
             --,round((q.laufzeit_avg * 60) / anz_rows,4)      laufzeit_row_avg_sec
             --,round((q.laufzeit_median * 60) / anz_rows,4)   laufzeit_row_median_sec1
             ,round( anz_rows / (q.laufzeit_median * 60) ,4)   laufzeit_row_median_sec2
             --,round(((q.laufzeit_median * 60) / anz_rows) * 1.2,4) laufzeit_toleranz1
             ,round(( anz_rows / (q.laufzeit_median * 60) ) * 1.2,4) laufzeit_toleranz2
             --,row_number() over(partition by r.map_name order by trunc(r.created_on) desc nulls last ) rang      
        from  owbsys.ALL_RT_AUDIT_MAP_RUNS r,
              owbsys.ALL_RT_AUDIT_MAP_RUN_ERRORS e,
              (
              select map_name
                    ,r.map_run_id map_run_id
                    ,trunc(r.created_on) datum
                    ,round(elapse_time/60,2) laufzeit
                    ,sum ( NVL(R.NUMBER_RECORDS_INSERTED,0) + 
                           NVL(R.NUMBER_RECORDS_UPDATED,0) + 
                           NVL(R.NUMBER_RECORDS_MERGED,0)) anz_rows
                    ,round(avg   (round(elapse_time/60,2)) over(partition by map_name),2) laufzeit_avg
                    ,round(median(round(elapse_time/60,2)) over(partition by map_name),2) laufzeit_median
                    --,row_number() over(partition by r.map_name order by trunc(r.created_on) desc nulls last ) rang
             from   owbsys.ALL_RT_AUDIT_MAP_RUNS r,
                    owbsys.ALL_RT_AUDIT_MAP_RUN_ERRORS e
             where 1=1
               and r.created_on >= trunc(sysdate)-10
               and E.RUN_ERROR_MESSAGE is null
               --and map_name like '%KKK%'  
               and R.MAP_RUN_ID = E.MAP_RUN_ID(+) 
             group by map_name, r.map_run_id, trunc(r.created_on), round(elapse_time/60,2)
              ) q
         where 1=1
           and R.MAP_RUN_ID   = E.MAP_RUN_ID(+) 
           and R.MAP_RUN_ID   = Q.MAP_RUN_ID
           and Q.ANZ_ROWS     > 0
           --and q.laufzeit     > q.laufzeit_median 
           and q.laufzeit_median > 10
         group by r.map_name,r.map_run_id,q.datum,trunc(r.created_on),
                  q.laufzeit,q.anz_rows,q.laufzeit_avg,q.laufzeit_median
         having round(anz_rows / (q.laufzeit * 60),4) * 1.2 < round((anz_rows / (q.laufzeit_median * 60)) ,4);      
         --having round((q.laufzeit * 60) / anz_rows,4) > round(((q.laufzeit_median * 60) / anz_rows) * 1.2,4) ;
         
         
              
--  Check Mappings, zu bestimmter Uhrzeit mit Ressourcenengpass, auf Parallel Hint und Tabellengrˆﬂe
select distinct execution_audit_id, map_name, start_time, end_time
  ,round(elapse_time/60,2) runtime, run_status
 , number_records_selected SEL, R.NUMBER_RECORDS_INSERTED INS , R.NUMBER_RECORDS_UPDATED UPD
 , R.NUMBER_RECORDS_MERGED MER
 , T.TARGET_NAME
 , E.RUN_ERROR_MESSAGE
  from owbsys.ALL_RT_AUDIT_MAP_RUNS r,
       owbsys.ALL_RT_AUDIT_MAP_RUN_TARGETS t,
       owbsys.ALL_RT_AUDIT_MAP_RUN_ERRORS e,
       dba_tables dbt,
       dba_source dbs
 where 1=1
   and r.created_on >= trunc(sysdate)-8
   --and (run_status = 'RUNNING' or
   --E.RUN_ERROR_MESSAGE is not null)
   and start_time between to_date('30.10.2013 02:30','dd.mm.yyyy hh24:mi') 
                  and     to_date('30.10.2013 03:00','dd.mm.yyyy hh24:mi')
   --and round(elapse_time/60,2) > 10 
   --and map_name like '%MPO%'
   --and T.TARGET_NAME = 'MPO_HPRZ'
   and R.MAP_RUN_ID  = T.MAP_RUN_ID
   and T.TARGET_NAME = dbt.table_name
   and dbt.num_rows  < 1000000
   and map_name      = dbs.name
   and lower(dbs.text) like '%append parallel%'
   and R.MAP_RUN_ID  = E.MAP_RUN_ID(+) 
   --and R.NUMBER_RECORDS_MERGED > 10000000
 order by 3 desc;