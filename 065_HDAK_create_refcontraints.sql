--------------------------------------------------------------------------------
-- $Beschreibung:
-- Wiederanlage der FK-Contraints zur Originaltabelle  
--------------------------------------------------------------------------------

ALTER TABLE KRDB_DA_TABLE_GEB_HST ADD (CONSTRAINT HDTG_HDAK_FK FOREIGN KEY (HDTG_HDAK_IF) REFERENCES KRDB_DA_TABLE_KTB_HST (HDAK_IF) DISABLE NOVALIDATE);
ALTER TABLE KRDB_DA_TABLE_RAT_HST ADD (CONSTRAINT HDTR_HDAK_FK FOREIGN KEY (HDTR_HDAK_IF) REFERENCES KRDB_DA_TABLE_KTB_HST (HDAK_IF) DISABLE NOVALIDATE);
