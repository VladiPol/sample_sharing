CREATE TABLE T_TAB_LEVELS
(
  VORSYSTEM      VARCHAR2(30 BYTE)              NOT NULL,
  TABLE_NAME     VARCHAR2(30 BYTE)              NOT NULL,
  PK_CONSTRAINT  VARCHAR2(30 BYTE)              NOT NULL,
  STUFE          NUMBER(10)                     NOT NULL,
  REFERENZIERT   VARCHAR2(1 BYTE)               NOT NULL,
  WFL_OBJEKT     VARCHAR2(30 BYTE),
  LAUFZEIT       NUMBER(10),
  RELEASE        VARCHAR2(30 BYTE)              NOT NULL,
  ANLAGE_DATUM   DATE
)
TABLESPACE OWB_DATA
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX TBLV_UK ON T_TAB_LEVELS
(RELEASE, TABLE_NAME)
LOGGING
TABLESPACE OWB_INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


GRANT SELECT ON T_TAB_LEVELS TO READ_ODS;

GRANT DELETE, INSERT, UPDATE ON T_TAB_LEVELS TO WRITE_ODS;

---------------------------------------------------------------------------
-- CREATE OR REPLACE procedure ODS.error_handling (p_statement IN VARCHAR2)
---------------------------------------------------------------------------
CREATE OR REPLACE procedure ODS.error_handling (p_statement IN VARCHAR2)
IS
   v_statement_manipuliert varchar2(4000);
   v_length                number;
   v_last_character        char(1);
   ERROR_ORA_00942         EXCEPTION;
   ERROR_ORA_04043         EXCEPTION;
   ERROR_ORA_12003         EXCEPTION;
   ERROR_ORA_02289         EXCEPTION;
   ERROR_ORA_01434         EXCEPTION;
   ERROR_ORA_02024         EXCEPTION;
   ERROR_ORA_01430         EXCEPTION;
   ERROR_ORA_02275         EXCEPTION;
   ERROR_ORA_00904         EXCEPTION;
   ERROR_ORA_01442         EXCEPTION;
   ERROR_ORA_02443         EXCEPTION;
   ERROR_ORA_01418         EXCEPTION;
   ERROR_ORA_01927         EXCEPTION;
   ERROR_ORA_02260         EXCEPTION;
   ERROR_ORA_02261         EXCEPTION;
   ERROR_ORA_01917         EXCEPTION;
   ERROR_ORA_04080         EXCEPTION;
   ERROR_ORA_02441         EXCEPTION;
   ERROR_ORA_00955         EXCEPTION;
   ERROR_ORA_01451         EXCEPTION;
   ERROR_ORA_14312	EXCEPTION;
    -- table or view does not exist
   PRAGMA exception_init(ERROR_ORA_00942,-00942);
    -- object OWNER.OBJECT_NAME does not exist (beinhaltet Package, Procedure und Function)
   PRAGMA exception_init(ERROR_ORA_04043,-04043);
    -- materialized view OWNER.OBJECT_NAME does not exist
   PRAGMA exception_init(ERROR_ORA_12003,-12003);
    -- sequence does not exist
   PRAGMA exception_init(ERROR_ORA_02289,-02289);
    -- private synonym to be dropped does not exist
   PRAGMA exception_init(ERROR_ORA_01434,-01434);
   -- database link not found
   PRAGMA exception_init(ERROR_ORA_02024,-02024);
    -- column being added already exists in table
   PRAGMA exception_init(ERROR_ORA_01430,-01430);
    -- such a referential constraint already exists in the table
   PRAGMA exception_init(ERROR_ORA_02275,-02275);
    -- "xxx_column_name_xxx": invalid identifier
   PRAGMA exception_init(ERROR_ORA_00904,-00904);
    -- column to be modified to NOT NULL is already NOT NULL
   PRAGMA exception_init(ERROR_ORA_01442,-01442);
    -- cannot drop constraint - nonexistent constraint
   PRAGMA exception_init(ERROR_ORA_02443,-02443);
    -- specified index does not exist
   PRAGMA exception_init(ERROR_ORA_01418,-01418);
    -- cannot REVOKE privileges you did not grant
   PRAGMA exception_init(ERROR_ORA_01927,-01927);
    -- table can have only one primary key
   PRAGMA EXCEPTION_INIT(ERROR_ORA_02260,-02260);
    -- such unique or primary key already exists in the table
   PRAGMA EXCEPTION_INIT(ERROR_ORA_02261,-02261);
    -- user or role 'string' does not exist
   PRAGMA EXCEPTION_INIT(ERROR_ORA_01917,-01917);
    -- t r i g g e r <'string'> does not exist
   PRAGMA EXCEPTION_INIT(ERROR_ORA_04080,-04080);
    -- Cannot drop non existent primary key
   PRAGMA EXCEPTION_INIT(ERROR_ORA_02441,-02441);
    -- name is already being used by existing object
   PRAGMA EXCEPTION_INIT(ERROR_ORA_00955,-00955);
    -- Auf NULL zu ändernde Spalte kann nicht auf NULL gesetzt werden
   PRAGMA EXCEPTION_INIT(ERROR_ORA_01451,-01451);
    -- Value ['?'] already exists in partition [?]
   PRAGMA EXCEPTION_INIT(ERROR_ORA_14312,-14312);
BEGIN
     -- eventuelle rechtsbündige Blanks entfernen
     v_statement_manipuliert := rtrim(p_statement);
     v_length := length(v_statement_manipuliert);
     v_last_character := substr(v_statement_manipuliert,v_length);

     -- letzte Stelle abschneiden, wenn es sich um ein Semikolon handelt
     if v_last_character = ';'
       then v_statement_manipuliert := substr(v_statement_manipuliert,1,v_length-1);
     end if;

     execute immediate v_statement_manipuliert;

EXCEPTION
          when    ERROR_ORA_00942
               or ERROR_ORA_04043
               or ERROR_ORA_12003
               or ERROR_ORA_02289
               or ERROR_ORA_01434
               or ERROR_ORA_02024
               or ERROR_ORA_01430
               or ERROR_ORA_02275
               or ERROR_ORA_00904
               or ERROR_ORA_01442
               or ERROR_ORA_02443
               or ERROR_ORA_01418
               or ERROR_ORA_01927
               or ERROR_ORA_02260
               or ERROR_ORA_02261
               or ERROR_ORA_01917
               or ERROR_ORA_04080
               or ERROR_ORA_02441
               or ERROR_ORA_00955
               or ERROR_ORA_01451
               or ERROR_ORA_14312
               then dbms_output.put_line ('***** Folgende Meldung wird ignoriert *****');
                    dbms_output.put_line (replace(upper(sqlerrm), 'O'||'RA-' , 'O R A - ') );
END;
/

---------------------------------------------------------------------------
-- CREATE OR REPLACE PROCEDURE ODS."P_TAB_LEVELS"("P_RELEASE" IN VARCHAR2,  "P_RELEASE_ALT" IN VARCHAR2,  "P_LOESCHUNG" IN VARCHAR2 DEFAULT 'N')
---------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ODS."P_TAB_LEVELS"("P_RELEASE" IN VARCHAR2,  "P_RELEASE_ALT" IN VARCHAR2,  "P_LOESCHUNG" IN VARCHAR2 DEFAULT 'N') IS
v_level       NUMBER;
v_update_rows NUMBER;
BEGIN

   -- 1. Saetze zu uebergebeben Relase loeschen, falls Loesch-Flag gesetzt
   -- ====================================================================
   IF p_loeschung = 'Y'
   THEN

     DELETE FROM t_tab_levels  tbll
     WHERE  tbll.release = p_release;

   END IF;

   -- 2. Level-Tabelle mit Level 1 fuellen
   -- ====================================
   INSERT INTO t_tab_levels (vorsystem, table_name, pk_constraint, stufe, referenziert, wfl_objekt, laufzeit, release, anlage_datum)
     SELECT nvl(tbl2.vorsystem, 'XXXX'), uc1.table_name, uc1.constraint_name, 1
           ,decode((select count(*) from user_constraints uc2 where uc1.constraint_name = uc2.r_constraint_name),0, 'N','J')
           ,tbl2.wfl_objekt
           ,tbl2.laufzeit
           ,p_release
           ,sysdate
      FROM   user_constraints uc1
            ,t_tab_levels     tbl2
      WHERE  uc1.table_name not like 'WB_%'   -- OWB Tabellen werden ausgeschlossen
        AND UC1.TABLE_NAME not like 'BIN$%'
        AND  uc1.constraint_type = 'P'
        AND  tbl2.release    (+) = p_release_alt
        AND  tbl2.table_name (+) = uc1.table_name
      ORDER BY table_name;

   -- 3. Levels fuer Tabellen ermitteln
   -- =================================
   v_level := 1;
   v_update_rows := -1;
   WHILE v_update_rows <> 0
     AND v_level       < 20            -- nur zur Sicherheit, Vermeidung Endlosschleife
   LOOP

     UPDATE t_tab_levels
     SET    stufe = v_level + 1
     WHERE  table_name IN (SELECT cons.table_name
                           FROM   user_constraints  cons
                                 ,t_tab_levels      tbll
                           WHERE  cons.r_constraint_name =  tbll.pk_constraint
                 AND  cons.table_name        <> tbll.table_name
                             AND  tbll.stufe             =  v_level
                 AND  tbll.release           =  p_release
                             -- Sonderfall wegen Kreisreferenz:
                             --  1. Mitartbeiter <-> Organisationseinheiten
                             --  2. WAV_WERBEAKTIONEN <-> WAV_WKZ
                             AND  cons.constraint_name  NOT IN ('OREI_MIAB_FK', 'WERA_WEKZ_FK','PRVO_BASE_FK' )

                          )
       AND  release = p_release;

     v_update_rows := SQL%ROWCOUNT;
     COMMIT;

     v_level := v_level + 1;

     dbms_output.put_line('UpdateRows: ' || v_update_rows);
     dbms_output.put_line('Level:      ' || v_level);

   END LOOP;

   COMMIT;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;

END P_TAB_LEVELS;
/

