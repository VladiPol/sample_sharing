--------------------------------------------------------------------------------
-- $Beschreibung:
-- Erweiterung im Util für den retail-Mart: drop partition
--------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE RETAIL_MART.PCK_UTIL
AS
   PROCEDURE "P_TRUNCATE_PARTITION" ("A_TABLE_NAME" IN VARCHAR2, "A_STICHTAG" IN VARCHAR2, "A_SUB_PART" IN VARCHAR2);

   PROCEDURE "P_TRUNCATE_PARTITION" ("A_TABLE_NAME" IN VARCHAR2, "A_STICHTAG" IN VARCHAR2);
   
   PROCEDURE "P_DS_BULK_PRE_MAP" ("P_TABLE" IN VARCHAR2);
   
   PROCEDURE "P_DS_BULK_POST_MAP" ("P_TABLE" IN VARCHAR2,"P_DEGREE" IN NUMBER);
   
   PROCEDURE "P_DROP_PARTITION" ("P_TABLE_NAME" IN VARCHAR2 ,"P_STICHTAG" IN NUMBER);
                         
END "PCK_UTIL";
/