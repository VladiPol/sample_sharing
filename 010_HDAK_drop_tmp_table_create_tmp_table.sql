--------------------------------------------------------------------------------
-- $Beschreibung:
-- Löschen und Erstellen der Temp-Tabelle für Migration  
--------------------------------------------------------------------------------

execute error_handling('DROP TABLE ODS.TMP_KRDB_DA_TABLE_KTB_HST');

CREATE TABLE ODS.TMP_KRDB_DA_TABLE_KTB_HST 
TABLESPACE ODSKR_DATA
COMPRESS FOR QUERY HIGH 
PARTITION BY RANGE (HDAK_GUELTIG_BIS) 
INTERVAL(NUMTODSINTERVAL(1, 'DAY'))
(
PARTITION P_1 VALUES LESS THAN (TO_DATE('  2012-09-05 00:00:00',
'SYYYY-MM-DD HH24:MI:SS',
'NLS_CALENDAR=GREGORIAN'))
)
PARALLEL (DEGREE 32)
PCTFREE 0
ENABLE ROW MOVEMENT
AS
(SELECT * FROM ODS.KRDB_DA_TABLE_KTB_HST);

ALTER TABLE ODS.KRDB_DA_TABLE_KTB_HST  NOPARALLEL;
