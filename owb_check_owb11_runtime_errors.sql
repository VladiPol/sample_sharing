

-- #################################################
-- # Runtime Repository Abfrage ohne Workspace (EUS_SHARED)
-- #################################################

-- Die Fehlermeldungen zum bestimmten Mapping
select
            wra.rta_lob_name                                                         as mapping_name,
            round((wra.rta_elapse / 60))                                             as minuten,
            wra.rta_elapse as sekunden,
            wra.CREATION_DATE                                                        as start_time, 
            wra.creation_date + (wra.rta_elapse / 86400)                             AS end_time, 
            DECODE(wra.rta_status,0,'0 - RUNNING',2,'2 - FAILURE',1,'1 - COMPLETE')  AS status,
            wra.rta_errors                                                           AS err, 
            wra.rta_select                                                           as sel, 
            wra.rta_insert                                                           as ins, 
            wra.rta_update                                                           as upd, 
            wra.rta_merge                                                            as mer, 
            wra.created_by,
            wre.rte_sqlerrm                                                          as fehlermeldung,
            wra.rta_iid                                                              as map_run_id
   from
            owbsys.OWB$WB_RT_AUDIT  wra,
            owbsys.OWB$WB_RT_ERRORS wre
   where
                wra.CREATION_DATE >= sysdate - 3
               and wra.rta_lob_name like  '%PVE%HYP%'
               -- BDB Level 01 Unref
            --   and wra.rta_lob_name in  ('"MPO_ZASA"','"MPO_VDRI"','"MPO_VPBB"','"MPO_UEBA"','"MPO_TBV3"','"MPO_SCMK"','"MPO_BRRS"','"MPO_BAUP"','"MPO_PATI"','"MPO_OKAL"','"MPO_BRAO"','"MPO_BRAG"','"MPO_KPAD"','"MPO_MAHN"','"MPO_GAAT"','"MPO_EXGI"','"MPO_ENVO"','"MPO_DITR"','"MPO_CCTK"','"MPO_CCTC"','"MPO_BUAK"','"MPO_BRAV"','"MPO_AUPC"')
               -- BDB Level 01 Hist
               --and wra.rta_lob_name in  ('"MPO_KRKR"','"MPO_KRKB"','"MPO_HPAI"','"MPO_HAVB"','"MPO_HBWE"','"MPO_HBWS"','"MPO_HBWV"','"MPO_HBLA"','"MPO_HEXG"','"MPO_HKOE"','"MPO_HKOB"','"MPO_HLAN"','"MPO_HOGS"','"MPO_HOPD"','"MPO_HPRA"','"MPO_HPRB"','"MPO_HPRE"','"MPO_HRRP"','"MPO_HVOA"')
               -- Kordoba Stage
               --and wra.rta_lob_name like '%MPS_%%'
--and                to_number(to_char(wra.CREATION_DATE,'hh24')) between 2 and 4
--and                to_number(to_char(wra.CREATION_DATE,'d')) between 1 and 6
               --and  (wra.rta_lob_name like '%MPS_%_TABLE%' or wra.rta_lob_name like '%"MPS_KORDOBA_KONTEN"%')
               --and  (wra.rta_lob_name like '%MPO_%_PHY%' ) and wra.rta_lob_name not like '%MPO_DOXI%' and wra.rta_lob_name not like '%MPO_PITA%' and wra.rta_lob_name not like '%MPO_DPP%'
--and  (wra.rta_lob_name like '%MPO_%5"' ) and  (wra.rta_lob_name not like '%PHY%' )
            and wra.RTA_IID = wre.rta_iid(+)
        --    and   wra.rta_errors > 0
          --and wra.rta_status <> 1
   order by
            wra.CREATION_DATE desc, wra.RTA_IID desc
;



-- Alle Fehlermeldungen von OVB vor einem Tag
select
           rta_lob_name as mapping_name, wram.creation_date as start_time, wraml.plain_text as fehlermeldung
  
   from
            owbsys.OWB$WB_RT_AUDIT_MESSAGE_LINES wraml,
            owbsys.owb$wb_rt_audit_messages      wram,
            owbsys.OWB$WB_RT_AUDIT               wra
   where
            wraml.AUDIT_MESSAGE_ID = wram.AUDIT_MESSAGE_ID
            and wram.audit_execution_id = wra.rte_id(+)
            and wram.creation_date > sysdate-3
   order by
            wram.creation_date desc;


--
-- Notfall: Fehler die in den obigen zwei SQL-Statements nicht angezeigt werden
--
select creation_date, plain_text  from owbsys.OWB$WB_RT_AUDIT_MESSAGE_LINES a, owbsys.owb$wb_rt_audit_messages b where A.AUDIT_MESSAGE_ID = B.AUDIT_MESSAGE_ID
and plain_text not like '%ORA-01400: cannot insert NULL into ("ODS"."EHYP_LEADSTATUS"."ELST_EMST_IF")%' order by creation_date desc;

