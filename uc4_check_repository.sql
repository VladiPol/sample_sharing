--
-- Timeouts
--
select
            u4oh_name            as master,
            u4jp_object          as object_name,
            u4jp_otype           as object_type,
            u4jp_exttimeout/3600 as timeout_in_stunden,
            u4jp_extexecute      as aktion_nach_timeout
            
   from
            ods.uc4_jpp u4jp, ods.uc4_oh u4oh
   where
              u4jp_ExtTimeout > 0
            and (u4jp_object like '%SPOT#BASIS%')
            and u4jp_object in ('JOBP.SPOT#BASIS@ODS_LADEN','JOBP.SPOT#BASIS@DWH_LADEN','JOBP.SPOT#BASIS@GESAMT_LADEN')
            and u4jp_u4oh_if = u4oh_if
            and U4OH_CLIENT = (select decode(NAME,'SPTP',300,'SPTV',200,100) as client from v$database)
            and U4OH_NAME not like '%\_SPTE'  escape '\'
            and U4OH_NAME not like '%\_SPT_T' escape '\'
            and U4OH_NAME not like '%\_MT'    escape '\'
   order by
            1, 2
;

--
-- Statistik
--
-- cast(from_tz(cast(u4ah_timestamp1 as timestamp),'UTC') at time zone 'Europe/Berlin' as date) as aktivierung,
select
            U4AH_NAME       as name,
            u4ah_otype      as typ,
            u4ah_idnr       as runid,
            u4ah_parentact  as parent,
            u4ah_status     as status,
            case
                when u4ah_runtime = 0 then null
                else to_char(trunc(u4ah_runtime/3600),'fm00')||':'||
                     to_char(trunc((u4ah_runtime - (trunc(u4ah_runtime/3600)*3600) ) / 60),'fm00')||':'||
                     to_char(u4ah_runtime - (trunc(u4ah_runtime/3600)*3600) - trunc((u4ah_runtime - (trunc(u4ah_runtime/3600)*3600) ) / 60)*60,'fm00')
            end             as laufzeit,
            u4ah_timestamp1 as aktivierung,
            u4ah_timestamp2 as startzeit,
            u4ah_timestamp4 as ende,
            u4ah_archive1   as archiv1,
           u4ah_archive2   as archiv2,
            u4ah_client     as mandant
   from 
            ods.UC4_AH ah
   where
            U4AH_OH_IDNR = (select u4oh_idnr from ods.uc4_oh 
                               where U4OH_NAME = 'JOBP.SPOT#BASIS@BDB_STAGE$L06'
                                     and u4oh_client = (select decode(NAME,'SPTP',300,'SPTV',200,100) as client
                                                           from v$database
                                                       )
                           )
            and u4ah_timestamp1 > add_months(sysdate,-3) 
   order by
            aktivierung desc
;
