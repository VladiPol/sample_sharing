--------------------------------------------------------------------------------
-- $Beschreibung:
-- Analyze TMP-Table  
--------------------------------------------------------------------------------

exec DBMS_STATS.GATHER_TABLE_STATS (ownname => 'ODS' , tabname => 'TMP_KRDB_DA_TABLE_KTB_HST', cascade => true, method_opt=>'FOR ALL COLUMNS SIZE 1', estimate_percent=> 0.5, degree=>32);
