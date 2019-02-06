-- Im Rahmen des DataLake Frameworks muss pro DataStage Objekt (Job oder Sequence) ein Eintrag in die Definitions-Tabelle DLFWK.FWK_FLOW_DEF eingetragen werden. 
-- https://confluence/display/ITCSWH/IIS+-+Pflegen+DLFWK.FWK_FLOW_DEF

exec dlfwk.p_utilities.P_put_entry_in_all_projects('DM_CRS_1', 'DE_DM_CRSMART_CRS_RETAIL_1', 'Befüllung der Tabelle CRSMART.CRS_RETAIL part 1', 'DE_DM_CRSMART_CRS_RETAIL_1');

-- Den Eintrag finden
select * from DLFWK.FWK_FLOW_DEF where FLOW_NM like '%CRSMART%' order by 2;

-- Den Eintrag löschen
delete from DLFWK.FWK_FLOW_DEF where FLOW_ALIAS = 'DM_CRS_1';

