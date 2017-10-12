
--
-- Gibt es ein bestimmtes Tabellenkürzel schon
--
select * from dba_tab_columns x where X.COLUMN_NAME like upper('hugo%') and owner = 'ODS' and table_name not like '%\_V'  escape '\' and table_name not like '%\_MV' escape '\';
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = upper('KFWUMWANDLUNGSAUFTRAEGE') order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = upper('KFWUMWANDLUNGSAUFTRAG_KONTEN') order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = upper('KRDB_MG_TABLE_VWD') order by anlage_datum;

2017-22-Jul_V1



ods.KFWUMWANDLUNGSAUFTRAEGE


select table_name, release, anlage_datum, STUFE, REFERENZIERT
   from ods.t_tab_levels x 
   where X.TABLE_NAME = (select distinct table_name from dba_tab_columns x where X.COLUMN_NAME 
--
like upper('owaa%')
--
                          and owner = 'ODS' and table_name not like '%\_V' escape '\' and table_name not like '%\_MV' escape '\'
                        )
order by anlage_datum;




--
-- Gibt es Tabellen mit einem bestimmten Namensmuster
--
select * from dba_tables x where X.TABLE_NAME like upper('%ZAHLUNG%') and owner in ( 'ODS','STAGE') order by 1,2;



--
-- Fields_to_use
--
select distinct X.TABLE_NAME from stage.Fields_to_use x where X.TABLE_NAME like 'KONDI%';

ods.partner
ods.orte

--
-- Welche Releases sind vorhanden?
--
select release, anlage_datum, count(*) from ods.t_tab_levels x group by release, anlage_datum order by anlage_datum desc;


OUTB_AKTION_MITARBEITER



select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'VMPROVISIONSMODELLZUORD' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'PKRKVORGAENGE' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'SCHUFAMERKMALE' order by anlage_datum desc;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'SCHUFAAUSKUENFTE' order by anlage_datum desc;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'PKRKWEITEREKREDITE_HST' order by anlage_datum desc;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'OUTB_AKTION_MITARBEITER' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'FESTGELDWEISUNGEN' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'PARTNER_HST' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'PARTNER' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'PARTNERKONTEN' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'OUTB_AKTIONSKONFIG' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'JBPM_ITEM' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'CONTACTS' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'KONTAKTERGEBNISSE' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'PKRKAUSGABEN_HST' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'PKRKEINNAHMEN' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'PKRKEINNAHMEN_HST' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'KORDOBAADRESSKEYS' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'KULA_KONTOUNTERLAGEN' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'BELWERTERMITTLUNGEN_KORREKTUR' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'BELWERTERMITTLUNG_KORREKT_HST' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'PARTNERVERKNUEPFUNGEN' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'PARTNERVERKNUEPFUNGEN_HST' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'PKRKVORGANGSFINANZEN' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'WIDERRUFSANGEBOTE' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'VORGAENGE' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'VORGAENGE_HST' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'VORZEITIGERUECKZAHLUNGEN' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'VPKOMMUNIKATIONEN' order by anlage_datum;


JOBS.SPOT#BASIS@BDB_MPO$VPKO$PHY läuft seit dem 22.9.2016 fälschlich in JOBP.SPOT#BASIS@BDB_LOESCH$TAEGLICH mit und löscht jeden Tag wieder die Neukunden seit dem 22.9

zusätzliche Details:
VPKOMMUNIKATIONEN = Level 4 Unref
MPS und MPO lief da das letzte Mal
Das erklärt aber noch nicht die lange Laufzeit des Jobs DE_OS_BDB_VPKOMMUNIKATIONEN schwankend von 3min - 80min in der täglichen Praxis


 



-- Abhängigkeiten für  VORGANGSCOREERGEBNISSE_HST
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'VORGANGSCOREERGEBNISSE' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'VORGANGSCOREERGEBNISSE_HST' order by anlage_datum;

select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'BAUFIVORGANGSSCOREZUORDNUN_HST' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'BEHAVIOUR_SCORE_AUSGABE' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'CONTACTS' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'KONTAKTERGEBNISSE' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'BAUFIVORGANGSOBJEKTE' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'VORGANGSCOREVALUES_HST' order by anlage_datum;

select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'INFO_SCORE' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'INFO_SCORE_HST' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'OUTPUTDOKUMENTE' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'OUTPUTDOKUMENTE_HST' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'OUTPUTDOKUMENTTEXTBAUSTEINE' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'OUTPUTDOKUMENTVARIABLEN' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'SCHRIFTSTUECKE' order by anlage_datum;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'SCHRIFTSTUECKE_HST' order by anlage_datum;



-- Risk
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'ZAHLUNGSVERSPRECHENKONTEN' order by anlage_datum;       -- 12 Ref
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'SCOREERGEBNISSE' order by anlage_datum;              -- 12 Ref
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'VORGANGSCOREKOKRITERIEN' order by anlage_datum;      -- 13 Ref
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'VORGANGSCOREKODETAILS' order by anlage_datum;        -- 14 Unref
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'RULEENGINESCOREERGEBNISSE' order by anlage_datum;    -- 06 Unref
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'SCOREKOHINWEISGRUENDE' order by anlage_datum;        -- 02 Ref


riskmart.MPR_PKRK_SCOREERGEBNISSE


ods.mpo_smkm

STAGE.SB_SCHUFAA    

ods.PKRKVORGANGSFINANZEN_HST
stage.MPS_BAUFIVORGANGSPARTNERFINANH


ods.INFO_SCORE_HST    -- HISC




select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME like '%DX%' and release = '2013-18-Juli'  order by stufe ;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME like '%ZAPPROLONGANGEBOTE%'   order by stufe ;
select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME like 'SCHUFA_ANFRAGE_REFERENZEN'   order by anlage_datum desc,stufe ;

KRDB_DX_TABLE_AEH
KRDB_DX_TABLE_AUS
KRDB_DX_TABLE_STA
KRDB_DX_TABLE_INH
KRDB_DX_TABLE_CRE

select table_name, release, anlage_datum, STUFE, REFERENZIERT from ods.t_tab_levels x where X.TABLE_NAME = 'FESTGELDWEISUNGEN' order by anlage_datum;

FESTGELDWEISUNGEN



delete from ods.t_tab_levels where release = 'FEB_2009';
delete from ods.t_tab_levels where release = 'SEP_2009';
delete from ods.t_tab_levels where release = 'SEP_2009a';
update ods.t_tab_levels set release = '2014-33-Nov' where release = '2014-33';



--
-- Daten in ODS.T_TAB_LEVELS eintragen
--
DECLARE 
  P_RELEASE VARCHAR2(32767);
  P_RELEASE_ALT VARCHAR2(32767);
  P_LOESCHUNG VARCHAR2(32767);

BEGIN 
  P_RELEASE := '2017-22-Jul_V1';
  P_RELEASE_ALT := '2066-88-DEK';
  P_LOESCHUNG := 'N';

  ODS.P_TAB_LEVELS ( P_RELEASE, P_RELEASE_ALT, P_LOESCHUNG );
  COMMIT; 
END; 






--
-- Levelermittlung
--
select * from (
select r1.table_name    r1_table_name
      ,r1.pk_constraint r1_pk
      ,r1.stufe         r1_lvl
      ,r1.referenziert  r1_ref
      ,r1.release       r1_release
      ,r2.table_name    r2_table_name
      ,r2.pk_constraint r2_pk
      ,r2.stufe         r2_lvl
      ,r2.referenziert  r2_ref
      ,r2.release       r2_release
from   (select table_name, pk_constraint, stufe, referenziert, release from ods.t_tab_levels where release = '2017-22-Jul_V1' 
       --    and table_name not like 'BIN$%' and table_name not like 'EHWDB%' and table_name not like 'HBCI%' and table_name not like 'EHDB%'  and table_name not like 'EHYP%'  and table_name not like 'EMMI%'
       --    and table_name not like 'PBOX_DOKUMENTE%'
       --    and table_name not in ('FPS_TEST_PARTITIONED','PBOX_PARTNER_TS','RISIKOVORSORGE_IFRS','IBRP_EVENTS','KRDB_KK_TABLE_KTB_HST','KRDB_DA_TABLE_ATP','ZAP_VM_SST_ANFRAGEN','JOURNAL_FIDI_TEST','PKRK_ABLEHNUNGSBEGRUENDUNGEN','PZST_UNTERKATEGORIEN') 
       )   r1
       full outer join
       (select table_name, pk_constraint, stufe, referenziert, release from ods.t_tab_levels where release = '2017-05-18_BCBS'
       --    and table_name not like 'BIN$%' and table_name not like 'EHWDB%' and table_name not like 'HBCI%'  and table_name not like 'EHDB%'  and table_name not like 'EHYP%'  and table_name not like 'EMMI%'
       --    and table_name not like 'PBOX_DOKUMENTE%'
       --    and table_name not in ('FPS_TEST_PARTITIONED','PBOX_PARTNER_TS','RISIKOVORSORGE_IFRS','IBRP_EVENTS','KRDB_KK_TABLE_KTB_HST','KRDB_DA_TABLE_ATP','ZAP_VM_SST_ANFRAGEN','JOURNAL_FIDI_TEST','PKRK_ABLEHNUNGSBEGRUENDUNGEN','PZST_UNTERKATEGORIEN')
        ) r2
       on r1.table_name = r2.table_name
) 
where ( (nvl(r1_lvl, -1) <> nvl(r2_lvl, -1)) or       (r1_ref <> r2_ref)  )
--and ( r1_table_name like '%DX%' or r1_table_name like '%SP_' )
order by r1_table_name, r2_table_name
;

ods.FAELLIGKEITENLISTENKONTEN



--
-- Welche Release-Objekte werden im BAISMART verwendet, da dieser Ablauf sehtr lange läuft und somit ewig auf die Einspiel-Startzeit gewartet werden müsste
--
select  * 
   from 
          (
           select
                       referenced_owner, referenced_name, referenced_type,name ,count(*) 
              from 
                       dba_dependencies
              where 
                           referenced_owner in ( 'ODS', 'PVMART', 'BSMMART') 
                       and owner = 'BAISMART'  
              group by
                       referenced_owner, referenced_name, referenced_type,name
          )
    where
          -- alle im Release veränderten ODS-Objekte 
          referenced_name in ('BAUFIVORGAENGE_HST','PARTNERUMZUGSTREFFER','PARTNERZUSAETZEVP','PE_PERSONENDATEN','PKRKVORGANGSFINANZEN_HST','ZAPAUFTRAEGESTANDARD_HST','KRDB_ED_TABLE_FRS')
;





--
-- durschnittliche Laufzeit der Mappings eines Levels
--
select
--            wra.rta_lob_name                                                         as mapping_name,
 --     count(*),
            round(avg(wra.rta_elapse/60))                                             as schnitt_laufzeit_minuten,
            round(median(wra.rta_elapse/60))                                             as median_laufzeit_minuten,
            round(avg(wra.rta_select))                                                           as sel, 
            round(avg(wra.rta_insert))                                                           as ins, 
            round(avg(wra.rta_update))                                                           as upd, 
            round(avg(wra.rta_merge))                                                            as mer 
   from
            owbsys.OWB$WB_RT_AUDIT  wra
   where
                wra.CREATION_DATE >= sysdate - 150
            and wra.rta_lob_name in (select      '"'||replace(substr(U4JP_OBJECT, instr(U4JP_OBJECT,'_')+1),'$','_')||'"' as mappings
                                        from     ods.uc4_jpp
                                        where    u4jp_OH_IDNR = (select u4oh_idnr from ods.uc4_oh where U4OH_NAME = 'JOBP.SPOT#BASIS@KRDB_STAGE$L01$UNREF')
                                                 and u4jp_otype = 'JOBS'
                                                 and  u4jp_OH_IDNR not in (select  u4oh_idnr  from ods.uc4_oh where U4OH_NAME in ( 'JOBS.SPOT#BASIS@KRDB_MPS$ED$TABLE$VPT','JOBS.SPOT#BASIS@KRDB_MPS$ED$TABLE$FRS','JOBS.SPOT#BASIS@KRDB_MPS$ED$TABLE$VRT','JOBS.SPOT#BASIS@KRDB_MPS$ZG$TABLE$KZK') )
                                    )
            -- nur erfolgreich gelaufene  1 = COMPLETE
            and wra.rta_status = 1
--group by             wra.rta_lob_name  
   order by
            avg(wra.rta_elapse) desc
;






--
-- Laufzeiten der einzelnen STAGE-SUB-Workflows
--
SELECT      sub,
            ROUND (AVG (mappings), 1) as mappings,
            ROUND (AVG (laufzeit))    as laufzeit
   FROM
            (  SELECT TO_CHAR (ex.created_on, 'dd.mm.yyyy') AS tag,
                       SUBSTR (ex.execution_name, 1, 20) AS sub,
                       COUNT (*) AS mappings,
                       SUM (ex.elapse_time) AS laufzeit
                  FROM owb_paris.all_rt_audit_executions ex
                 WHERE ex.created_on > SYSDATE - 50
                       --AND ex.execution_name LIKE 'WFL_STAGE_BDB_SUB%'
                       AND ex.execution_name LIKE 'WFL_ODS_PHZ_SUB%' and substr(to_char(ex.created_on,'DAY'),1,7) = 'SAMSTAG'
              GROUP BY SUBSTR (ex.execution_name, 1, 20),
                       TO_CHAR (ex.created_on, 'dd.mm.yyyy')
            )
   GROUP BY
            sub
   ORDER BY
            sub
;
-- Ergebnis für 2012-14 (1.3.2012 bezüglich der letzten 50 Tage)
-- WFL_STAGE_BDB_SUB_01    32,7    1033
-- WFL_STAGE_BDB_SUB_02    41,9    1719
-- WFL_STAGE_BDB_SUB_03    41,9    912
-- WFL_STAGE_BDB_SUB_04    45,2    799
-- WFL_STAGE_BDB_SUB_05    31,9    825
-- WFL_STAGE_BDB_SUB_06    48,2    510    <<<<<========
-- WFL_STAGE_BDB_SUB_07    45,2    752
-- WFL_STAGE_BDB_SUB_08    32,9    629
-- WFL_STAGE_BDB_SUB_09    31,7    1077
-- WFL_STAGE_BDB_SUB_10    31,7    826
-- WFL_STAGE_BDB_SUB_11    101,1    635


-- Ergebnis für 2012-14 (6.3.2012 bezüglich der letzten 100 Tage)
-- WFL_ODS_PHZ_SUB_030:    23    258
-- WFL_ODS_PHZ_SUB_040:    28    243
-- WFL_ODS_PHZ_SUB_050:    36    602
-- WFL_ODS_PHZ_SUB_060:    27    516
-- WFL_ODS_PHZ_SUB_070:    20    1906
-- WFL_ODS_PHZ_SUB_080:    24    1456
-- WFL_ODS_PHZ_SUB_090:    31    379
-- WFL_ODS_PHZ_SUB_100:    27    113           <<<<<=============
-- WFL_ODS_PHZ_SUB_110:    22    490
-- WFL_ODS_PHZ_SUB_120:    59    767
-- WFL_ODS_PHZ_SUB_200:    81,2    2563





--
-- Welchen Strang eines Workflows sollte man erweitern?
-- auszuführen als analysis@SPTP
select 
            substr(ex.execution_name ,1, instr(ex.execution_name,':')-1 )             as workflow,
            substr(ex.execution_name , instr(ex.execution_name,':')+1)                as Mapping,
            to_char(to_date(round(avg(to_char(ex.created_on + ex.elapse_time/24/60/60 ,'sssss'))) ,'sssss') ,'hh24:mi:ss') AS ende_zeit
   from
            owb_paris.all_rt_audit_executions ex,
            (select PROCESS_name,source_activity_name  
                from owb_paris.ALL_IV_PROCESS_transitions
                where PROCESS_NAME = 'WFL_ODS_L14_REF' and TARGET_ACTIVITY_NAME = 'AND_ACTIVITY'
            ) rel
   where
                ex.created_on > sysdate-1
            -- auf relevanten Workflow aus Inline-View rel einschränken
            and instr(ex.execution_name, rel.process_name) > 0
            -- Workflow selber nicht anlisten
            and instr(ex.execution_name,':') > 0
            -- nur endständige Mappings pro Workflow-Strang betrachten
            and substr(ex.execution_name , instr(ex.execution_name,':')+1) = rel.source_activity_name
   group by 
            substr(ex.execution_name ,1, instr(ex.execution_name,':')-1 ),
            substr(ex.execution_name , instr(ex.execution_name,':')+1)
   order by
            workflow,
            ende_zeit,
            mapping 
;





--
-- Welche STAGE-Mappings laufen am längsten
--
select 
         ex.execution_name,
         count(*) anz_laeufe,
         round(avg(ex.elapse_time)) AS avg_laufzeit
from
         owb_paris.all_rt_audit_executions ex
where
         ex.created_on > sysdate-35 and
         ex.execution_audit_status  = 'COMPLETE'
         and ex.return_result = 'OK'
and         ex.execution_name like 'WFL_STAGE_BDB_SUB%'
and   ex.execution_name not like '%:AND_ACTIVITY'
and   ex.execution_name not like '%:AND1'
group by ex.execution_name
order by
         2 asc,3 desc
;






--
-- Datenladungen dokumentieren
--
select 
 count(*), sum(mr.NUMBER_RECORDS_INSERTED) as inserted, min(ex.created_on) as start_zeit, max(ex.created_on) as ende_zeit,round((max(ex.created_on) - min(ex.created_on)) *1440) as dauer
from
         owb_paris.all_rt_audit_executions ex,
         owb_paris.all_rt_audit_map_runs   mr
where
         ex.created_on > to_date('30.03.2012 08','dd.mm.yyyy hh24') and
         ex.execution_audit_id = mr.execution_audit_id(+)
and         ex.execution_name like '%MPS%'
and nvl(ex.return_result,'laufend') = 'OK'
;
-- bdb6t->spt7t 30.03.2012 08:38-09:05 27min  481 Stage-Mappings   808.522.214 Sätze
-- bdb6e->spte  29.03.2012 16:19-16:54 35min  481 Stage-Mappings   795.470.297 Sätze




-- Baufi-Batch-Läufe
-- ANALYSIS@BDB6T
SELECT * FROM enprod.BATCH_REPORTS ORDER BY 1 DESC;
SELECT * FROM ENPROD.BATCH_REPORT_DETAILS ORDER BY 1 DESC;




--
-- Error wegen Inkonsistenzen
--
WFL_ODS_SUB_DMSR:MPO_DMSR    31.03.2012 08:00:56    31.03.2012 08:22:26    WARNING    ORA-01407: cannot update ("ODS"."DMS_REFERENZEN"."DMSR_SCST_IF") to NULL 
delete STAGE.SB_DMS_REFERENZEN where DMSR_SCST_ID in (
select   distinct s.DMSR_SCST_ID
   from  STAGE.SB_DMS_REFERENZEN_INC s,
         ODS.SCHRIFTSTUECKE          o
   where
         s.DMSR_SCST_ID = O.SCST_ID(+)
         and O.SCST_ID is null
         and o.SCST_PHY_GELOSCHT(+)  = 'N'
         )
;


-- WFL_ODS_L07_UNREF:WFL_ODS_SUB_KOER:MPO_KOER    4.4.12 3:25-4:35     ORA-01407: cannot update ("ODS"."KONTAKTERGEBNISSE"."KOER_CNTC_IF") to NULL
-- ods.mpo_koer
--delete STAGE.SB_KONTAKTERGEBNISSE where KOER_CNTC_ID in (
select   count(distinct s.KOER_CNTC_ID)
   from  STAGE.SB_KONTAKTERGEBNISSE_INC s,
         ODS.CONTACTS                   o
   where
         s.KOER_CNTC_ID = O.CNTC_ID(+)
         and O.CNTC_ID is null
--)
;
-- SPT7T = 138033335
select max(X.CNTC_ID) from ODS.CONTACTS x;
-- BDB6T = 135273091
select max(cntc_id) from ENPROD.CONTACTS;
select /*+ parallel(x,8) */ max(cntc_id) from STAGE.SB_CONTACTS x;

-- 135.273.662
select min(cntc_id) from ENPROD.CONTACTS x where X.CNTC_abschlusszeitpunkt >= to_date('18.04.2012','dd.mm.yyyy');
-- 135.273.708
select max(cntc_id) from ENPROD.CONTACTS;
update ODS.ODSPARAMETER x set X.ODPA_NUM_VALUE = 135267187 where X.ODPA_PARAMETER_BEZ = 'CNTC_MAX_CNTC_ID';




-- WFL_ODS_L06_UNREF:MPO_OTAX    ORA-00001: unique constraint (ODS.OTAX_UK_I) violated
-- ODS.OUTB_AUFTRAGSDATEN_XML 
-- OTAX_UK_I    1.OTAX_OTAU_IF  2.OTAX_ATTRIBUT_NAME
select   count(distinct s.KOER_CNTC_ID)
   from  STAGE.OUTB_AUFTRAGSDATEN_X s,
         ODS.CONTACTS                   o
   where
         s.KOER_CNTC_ID = O.CNTC_ID(+)
         and O.CNTC_ID is null
;


select * from STAGE.SB_OUTB_AUFTRAG_XML_V;
select otau_id, xml_attribut_name, count(*) from STAGE.SB_OUTB_AUFTRAG_XML_V group by otau_id, xml_attribut_name having count(*) > 1;


-- ods.MPO_ZAPA    04.04.2012 04:17:42    04.04.2012 04:18:18    WARNING    ORA-02292: integrity constraint (ODS.ZKDS_ZAPA_FK) violated - child record found
ods.ZAPPROLONGANGEBOTE
ODS.ZAPKONDITIONSSTAFFELN
select   distinct s.DMSR_SCST_ID
   from  STAGE.SB_ZAPPROLONGANGEBOTE s,
         ODS.ZAPKONDITIONSSTAFFELN   o
   where
         s.DMSR_SCST_ID = O.SCST_ID(+)
         and O.SCST_ID is null
         and o.SCST_PHY_GELOSCHT(+)  = 'N'
         )
;



ORA-02292: integrity constraint (ODS.ZKDS_ZAPA_FK) violated - child record found





  
  -- 641
create table pnzKONTOSALDEN_PASSIV_TGL_HIST
as select /*+ use_hash(x,pakt) parallel(x,4) parallel(pakt,4) */ *
 from ods.KONTOSALDEN_PASSIV_TGL_HIST x , ods.partnerkonten pakt 
where  x.ktph_wochentag = 5 and X.KTPH_KONTONUMMER = PAKT.PAKT_KONTO_nr(+)
and PAKT.PAKT_KONTO_nr is null;



delete ods.KONTOSALDEN_PASSIV_TGL_HIST where KTPH_IF    in (
select ktph_if from  pnzKONTOSALDEN_PASSIV_TGL_HIST);







--
--
--
MPO_SBSI    03.05.2012 02:47:01    03.05.2012 02:47:53    WARNING    ORA-01400: cannot insert NULL into ("ODS"."BERECHNUNGSSICHERHEITEN"."SBSI_BVOB_IF")
ods.MPO_SBSI    03.05.2012 02:47:01    03.05.2012 02:47:25    WARNING    ORA-01400: cannot insert NULL into ("ODS"."BERECHNUNGSSICHERHEITEN"."SBSI_BVOB_IF")


select   distinct s.SBSI_BVOB_ID
   from  STAGE.SB_BERECHNUNGSSICHERHEITEN s,
         ODS.BAUFIVORGANGSOBJEKTE   o
   where
         s.SBSI_BVOB_ID = O.bvob_id(+)
         and O.bvob_ID is null
         and o.bvob_PHY_GELOSCHT(+)  = 'N'
;

stage.MPS_BAUFIVORGANGSOBJEKTE
ods.mpo_BVOB


select * from ODS.BAUFIVORGANGSOBJEKTE where bvob_id = 1997940;




--
--
---
ods.MPO_ZVKO    03.05.2012 10:37:07    03.05.2012 10:38:38    WARNING    ORA-01400: cannot insert NULL into ("ODS"."ZAHLUNGSVERSPRECHENKONTEN"."ZVKO_ZAVP_IF")
ODS.ZAHLUNGSVERSPRECHEN ODS.MPO_ZAVP  
select   distinct s.ZVKO_ZAVP_id
   from  STAGE.SB_ZAHLUNGSVERSPRECHENKONTEN s,
         ODS.ZAHLUNGSVERSPRECHEN   o
   where
         s.ZVKO_ZAVP_id = O.zavp_id(+)
         and O.zavp_ID is null
         and o.zavp_PHY_GELOSCHT(+)  = 'N'
;
select * from ODS.ZAHLUNGSVERSPRECHEN where zavp_id = 1091496;
delete stage.sb_ZAHLUNGSVERSPRECHEN where zavp_id not in (1091496,1091498,1091501,1091497,1091500,1091502,1091503,1091495,1091499);
select * from stage.sb_ZAHLUNGSVERSPRECHEN where zavp_id  in (1091496,1091498,1091501,1091497,1091500,1091502,1091503,1091495,1091499);




--
--
--
ods.MPO_BOVZ    03.05.2012 02:44:20    03.05.2012 02:58:40    WARNING    ORA-01400: cannot insert NULL into ("ODS"."BAUFIOBJEKTVORGANGZUORDNUNGEN"."BOVZ_BVOB_IF")

select   distinct s.BOVZ_BVOB_Id
   from  STAGE.SB_BAUFIOBJEKTVORGANGZUORDNUNG s,
         ODS.BAUFIVORGANGSOBJEKTE   o
   where
         s.BOVZ_BVOB_Id = O.bvob_id(+)
         and O.bvob_ID is null
         and o.bvob_PHY_GELOSCHT(+)  = 'N'
;




--
--
--
ods.MPO_BOAT    03.05.2012 02:44:14    03.05.2012 03:25:52    WARNING    ORA-01400: cannot insert NULL into ("ODS"."BAUFIOBJEKTATTR"."BOAT_BVOB_IF")
select   distinct s.BOAT_BVOB_Id
   from  STAGE.SB_BAUFIOBJEKTATTR s,
         ODS.BAUFIVORGANGSOBJEKTE   o
   where
         s.BOAT_BVOB_Id = O.bvob_id(+)
         and O.bvob_ID is null
         and o.bvob_PHY_GELOSCHT(+)  = 'N'
;


