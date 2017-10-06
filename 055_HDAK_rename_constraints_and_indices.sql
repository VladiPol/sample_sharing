--------------------------------------------------------------------------------
-- $Beschreibung:
-- Umbennen der Indices und Constraints von der Temp Tabelle zum Original  
--------------------------------------------------------------------------------

ALTER TABLE TMP_KRDB_DA_TABLE_KTB_HST RENAME CONSTRAINT HDAK_HPAK_FK_TMP TO HDAK_HPAK_FK;
ALTER TABLE TMP_KRDB_DA_TABLE_KTB_HST RENAME CONSTRAINT HDAK_PK_TMP TO HDAK_PK;
ALTER TABLE TMP_KRDB_DA_TABLE_KTB_HST RENAME CONSTRAINT HDAK_KOK5_FK_TMP TO HDAK_KOK5_FK;
ALTER INDEX HDAK_OK_I_TMP RENAME TO HDAK_OK_I;
ALTER INDEX HDAK_PK_TMP RENAME TO HDAK_PK;
ALTER INDEX HDAK_ID_FI_TMP RENAME TO HDAK_ID_FI;
