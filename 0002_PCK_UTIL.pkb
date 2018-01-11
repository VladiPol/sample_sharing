--------------------------------------------------------------------------------
-- $Beschreibung:
-- Erweiterung im Util für den retail-Mart: drop partition
--------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY RETAIL_MART.PCK_UTIL
AS
   PROCEDURE "P_TRUNCATE_PARTITION" ("A_TABLE_NAME" IN VARCHAR2, "A_STICHTAG" IN VARCHAR2)
   IS
   BEGIN
      PCK_UTIL.P_TRUNCATE_PARTITION (A_TABLE_NAME, A_STICHTAG, NULL);
   END "P_TRUNCATE_PARTITION";

   PROCEDURE "P_TRUNCATE_PARTITION" ("A_TABLE_NAME" IN VARCHAR2, "A_STICHTAG" IN VARCHAR2, "A_SUB_PART" IN VARCHAR2)
   IS
      TYPE T_BUFFER_TAB IS TABLE OF VARCHAR2 (32767);

      PARTITION_DOES_NOT_EXIST   EXCEPTION;
      PRAGMA EXCEPTION_INIT (PARTITION_DOES_NOT_EXIST, -02149);

      ----------------------------------------------------------------
      P_OWNER                    VARCHAR2 (30) := 'RETAIL_MART';
      P_TABLE_NAME               VARCHAR2 (30) := TRIM (A_TABLE_NAME);
      P_STICHTAG                 VARCHAR2 (30) := TRIM (A_STICHTAG);
      P_SUB_PART                 VARCHAR2 (30) := TRIM (A_SUB_PART);
      ----------------------------------------------------------------
      V_OWNER                    VARCHAR2 (30);
      V_TABLE_NAME               VARCHAR2 (30);
      V_PARTITION_NAME           VARCHAR2 (30);
      V_SUBPARTITION_NAME        VARCHAR2 (30);
      V_HIGH_VALUE               VARCHAR2 (32767);

      SQL_EXEC                   VARCHAR2 (32767);
      SUBPART_LST                VARCHAR2 (32767) := '';
      DONE_LST                   VARCHAR2 (32767) := '';
      POS                        INTEGER;
      SUBPART                    VARCHAR2 (32767);

      DISABLE_CONSTR_TAB         T_BUFFER_TAB := T_BUFFER_TAB ();
      ENABLE_CONSTR_TAB          T_BUFFER_TAB := T_BUFFER_TAB ();
      TRUNCATE_PART_TAB          T_BUFFER_TAB := T_BUFFER_TAB ();
   BEGIN
      DBMS_OUTPUT.ENABLE (1000000);

      DBMS_OUTPUT.PUT_LINE ('Tuncate (Sub-)Partition:');
      DBMS_OUTPUT.PUT_LINE ('OWNER= ' || P_OWNER);
      DBMS_OUTPUT.PUT_LINE ('TABLE_NAME= ' || P_TABLE_NAME);
      DBMS_OUTPUT.PUT_LINE ('STICHTAG= ' || P_STICHTAG);
      DBMS_OUTPUT.PUT_LINE ('SUBPARTITION= ' || P_SUB_PART);
      DBMS_OUTPUT.PUT (CHR (10));

      -- SQLs fuer DISABLE/ENABLE CONSTRAINTs generieren

      FOR C0 IN (WITH PK_CONSTR
                      AS (SELECT OWNER, TABLE_NAME, CONSTRAINT_NAME
                            FROM ALL_CONSTRAINTS
                           WHERE OWNER = P_OWNER AND CONSTRAINT_TYPE = 'P' AND STATUS = 'ENABLED'),
                      FK_CONSTR
                      AS (SELECT OWNER,
                                 CONSTRAINT_NAME,
                                 TABLE_NAME,
                                 R_OWNER,
                                 R_CONSTRAINT_NAME
                            FROM ALL_CONSTRAINTS
                           WHERE CONSTRAINT_TYPE = 'R' AND STATUS = 'ENABLED'),
                      PK_FK_RELATIONS
                      AS (SELECT PK.OWNER,
                                 PK.TABLE_NAME,
                                 FK.OWNER USEDBY_OWNER,
                                 FK.TABLE_NAME USEDBY_TABLE_NAME,
                                 FK.CONSTRAINT_NAME TOBEDISABLED_CONSTRAINT_NAME
                            FROM PK_CONSTR PK JOIN FK_CONSTR FK ON PK.OWNER = FK.R_OWNER AND PK.CONSTRAINT_NAME = FK.R_CONSTRAINT_NAME)
                   SELECT USEDBY_OWNER || '.' || USEDBY_TABLE_NAME USEDBY_TABLE_NAME, TOBEDISABLED_CONSTRAINT_NAME
                     FROM PK_FK_RELATIONS
                    WHERE OWNER = P_OWNER AND TABLE_NAME = P_TABLE_NAME
                 ORDER BY 1, 2)
      LOOP
         DISABLE_CONSTR_TAB.EXTEND ();
         DISABLE_CONSTR_TAB (DISABLE_CONSTR_TAB.LAST) := 'ALTER TABLE ' || C0.USEDBY_TABLE_NAME || ' DISABLE CONSTRAINT ' || C0.TOBEDISABLED_CONSTRAINT_NAME;

         ENABLE_CONSTR_TAB.EXTEND ();
         ENABLE_CONSTR_TAB (ENABLE_CONSTR_TAB.LAST) :=
            'ALTER TABLE ' || C0.USEDBY_TABLE_NAME || ' ENABLE NOVALIDATE CONSTRAINT ' || C0.TOBEDISABLED_CONSTRAINT_NAME;
      END LOOP;

      -- Falls kein Subpartitionsname angegeben, dann TRUNCATE PARTITION generieren ...

      IF P_SUB_PART IS NULL
      THEN
         TRUNCATE_PART_TAB.EXTEND ();
         TRUNCATE_PART_TAB (TRUNCATE_PART_TAB.LAST) :=
            'ALTER TABLE ' || P_OWNER || '.' || P_TABLE_NAME || ' TRUNCATE PARTITION FOR ( TO_DATE(''' || P_STICHTAG || ''', ''YYYYMMDD'') ) UPDATE INDEXES';
      ELSE
         -- ... ansonsten einzelne TRUNCATE SUBPARTITIONs generieren

         FOR C IN (SELECT TABLE_OWNER,
                          TABLE_NAME,
                          PARTITION_NAME,
                          SUBPARTITION_NAME
                     FROM ALL_TAB_SUBPARTITIONS
                    WHERE TABLE_OWNER = P_OWNER AND TABLE_NAME = P_TABLE_NAME)
         LOOP
            SELECT TABLE_OWNER,
                   TABLE_NAME,
                   PARTITION_NAME,
                   SUBPARTITION_NAME,
                   HIGH_VALUE
              INTO V_OWNER,
                   V_TABLE_NAME,
                   V_PARTITION_NAME,
                   V_SUBPARTITION_NAME,
                   V_HIGH_VALUE
              FROM ALL_TAB_SUBPARTITIONS
             WHERE TABLE_OWNER = C.TABLE_OWNER AND TABLE_NAME = C.TABLE_NAME AND PARTITION_NAME = C.PARTITION_NAME AND SUBPARTITION_NAME = C.SUBPARTITION_NAME;

            SUBPART_LST := V_HIGH_VALUE;

            LOOP
               POS := INSTR (SUBPART_LST, ',');

               IF POS = 0
               THEN
                  SUBPART := SUBPART_LST;
                  SUBPART_LST := '';
               ELSE
                  SUBPART := SUBSTR (SUBPART_LST, 1, POS - 1);
                  SUBPART_LST := SUBSTR (SUBPART_LST, POS + 1, 2000);
               END IF;

               IF NVL (INSTR (DONE_LST, '[' || SUBPART || ']'), 0) = 0
               THEN
                  DONE_LST := DONE_LST || '[' || SUBPART || ']';

                  IF SUBPART LIKE ('''' || P_SUB_PART || '''')
                  THEN
                     TRUNCATE_PART_TAB.EXTEND ();
                     TRUNCATE_PART_TAB (TRUNCATE_PART_TAB.LAST) :=
                           'ALTER TABLE '
                        || V_OWNER
                        || '.'
                        || V_TABLE_NAME
                        || ' TRUNCATE SUBPARTITION FOR ( TO_DATE('''
                        || P_STICHTAG
                        || ''', ''YYYYMMDD''), '
                        || SUBPART
                        || ' ) UPDATE INDEXES';
                  END IF;
               END IF;

               IF NVL (LENGTH (SUBPART_LST), 0) = 0
               THEN
                  EXIT;
               END IF;
            END LOOP;
         END LOOP;
      END IF;

      -- ==========================================================================
      -- generierte SQLs ausfuehren:
      -- ==========================================================================

      -- DISABLE CONSTRAINTS ...

      IF TRUNCATE_PART_TAB.COUNT > 0 AND DISABLE_CONSTR_TAB.COUNT > 0
      THEN
         FOR I_DIS IN DISABLE_CONSTR_TAB.FIRST .. DISABLE_CONSTR_TAB.LAST
         LOOP
            BEGIN
               SQL_EXEC := DISABLE_CONSTR_TAB (I_DIS);
               DBMS_OUTPUT.PUT_LINE (SQL_EXEC);

               EXECUTE IMMEDIATE (SQL_EXEC);
            EXCEPTION
               WHEN OTHERS
               THEN
                  --RAISE_APPLICATION_ERROR (-20001, '(DISABLE CONSTRAINT) ' || SUBSTR (SQLERRM, 1, 500));
                  DBMS_OUTPUT.PUT_LINE ('(DISABLE CONSTRAINT) ' || SUBSTR (SQLERRM, 1, 500));
            END;
         END LOOP;

         DBMS_OUTPUT.PUT (CHR (10));
      END IF;

      -- TRUNCATE PARTITION/SUBPARTITION ...

      IF TRUNCATE_PART_TAB.COUNT > 0
      THEN
         FOR I_TRUNC IN TRUNCATE_PART_TAB.FIRST .. TRUNCATE_PART_TAB.LAST
         LOOP
            BEGIN
               SQL_EXEC := TRUNCATE_PART_TAB (I_TRUNC);
               DBMS_OUTPUT.PUT_LINE (SQL_EXEC);

               EXECUTE IMMEDIATE (SQL_EXEC);
            EXCEPTION
               /*WHEN PARTITION_DOES_NOT_EXIST
               THEN
                  NULL;*/
               WHEN OTHERS
               THEN
                  --RAISE_APPLICATION_ERROR (-20001, '(TRUNCATE (SUB-)PARTITION) ' || SUBSTR (SQLERRM, 1, 500));
                  DBMS_OUTPUT.PUT_LINE ('TRUNCATE (SUB-)PARTITION) ' || SUBSTR (SQLERRM, 1, 500));
            END;
         END LOOP;

         DBMS_OUTPUT.PUT (CHR (10));
      END IF;

      -- ENABLE CONSTRAINTS ...

      IF TRUNCATE_PART_TAB.COUNT > 0 AND ENABLE_CONSTR_TAB.COUNT > 0
      THEN
         FOR I_ENA IN ENABLE_CONSTR_TAB.FIRST .. ENABLE_CONSTR_TAB.LAST
         LOOP
            BEGIN
               SQL_EXEC := ENABLE_CONSTR_TAB (I_ENA);
               DBMS_OUTPUT.PUT_LINE (SQL_EXEC);

               EXECUTE IMMEDIATE (SQL_EXEC);
            EXCEPTION
               WHEN OTHERS
               THEN
                  --RAISE_APPLICATION_ERROR (-20001, '(ENABLE CONSTRAINT) ' || SUBSTR (SQLERRM, 1, 500));
                  DBMS_OUTPUT.PUT_LINE ('(ENABLE CONSTRAINT) ' || SUBSTR (SQLERRM, 1, 500));
            END;
         END LOOP;
      END IF;

      DBMS_OUTPUT.PUT_LINE ('*** ENDE');
   END "P_TRUNCATE_PARTITION";
   PROCEDURE "P_DS_BULK_PRE_MAP" ("P_TABLE" IN VARCHAR2) IS
    NoSuchIndex EXCEPTION;
    PRAGMA EXCEPTION_INIT(NoSuchIndex, -01418);

    CURSOR cur_indexes_unusable IS
    SELECT  'ALTER INDEX ' || UI.INDEX_NAME || ' unusable' ALTER_STMT
    FROM    USER_INDEXES UI,
            ALL_IND_PARTITIONS IP
    WHERE   NVL(IP.STATUS, UI.STATUS) IN ('USABLE','VALID')
    AND     UI.INDEX_NAME = IP.INDEX_NAME(+)
    AND     UI.TABLE_NAME IN ('' || P_TABLE || '');

    CURSOR cur_constraints_disable IS
    SELECT  'ALTER TABLE ' || P_TABLE || ' disable constraint ' || CONSTRAINT_NAME ALTER_STMT
    FROM    USER_CONSTRAINTS UC
    WHERE   UC.STATUS IN ('ENABLED')
    AND     UC.TABLE_NAME IN ('' || P_TABLE || '')
    AND     UC.CONSTRAINT_TYPE = 'P';

BEGIN

        FOR rec IN cur_constraints_disable LOOP
            EXECUTE IMMEDIATE rec.alter_stmt;
        END LOOP;

        FOR rec IN cur_indexes_unusable LOOP
            EXECUTE IMMEDIATE rec.alter_stmt;
        END LOOP;

EXCEPTION
  WHEN others THEN
    RAISE_APPLICATION_ERROR(-20001, 'PCK_UTIL.P_DS_BULK_PRE_MAP: ' || substr(sqlerrm, 1, 500));

END;



PROCEDURE "P_DS_BULK_POST_MAP" ("P_TABLE" IN VARCHAR2,
                         "P_DEGREE" IN NUMBER) IS
    NoSuchIndex EXCEPTION;
    PRAGMA EXCEPTION_INIT(NoSuchIndex, -01418);

    CURSOR cur_indexes_rebuild IS
    SELECT  DECODE (PARTITIONED, 'NO', 'ALTER INDEX ' || UI.INDEX_NAME || ' rebuild parallel ' || P_DEGREE,
                                 'YES', 'ALTER INDEX ' || IP.INDEX_NAME || ' rebuild subpartition ' || IP.SUBPARTITION_NAME ||' parallel ' || P_DEGREE) ALTER_STMT
    FROM    USER_INDEXES UI,
            ALL_IND_SUBPARTITIONS IP
    WHERE   NVL(IP.STATUS, UI.STATUS) NOT IN ('USABLE','VALID')
   AND     UI.INDEX_NAME = IP.INDEX_NAME(+)
    AND     UI.TABLE_NAME IN ('' || P_TABLE || '')
    UNION ALL
    SELECT  'ALTER INDEX ' || INDEX_NAME || ' noparallel' ALTER_STMT
    FROM    USER_INDEXES UI
    WHERE   UI.TABLE_NAME IN ('' || P_TABLE || '')
    AND     TO_NUMBER(DECODE(DEGREE, 'DEFAULT', '1', DEGREE)) = 1;

    CURSOR cur_constraints_enable IS
    SELECT  'ALTER TABLE ' || P_TABLE || ' enable validate constraint ' || CONSTRAINT_NAME ALTER_STMT
    FROM    USER_CONSTRAINTS UC
    WHERE   UC.TABLE_NAME IN ('' || P_TABLE || '')
    AND     UC.CONSTRAINT_TYPE = 'P';

BEGIN

        FOR rec IN cur_indexes_rebuild LOOP
             EXECUTE IMMEDIATE rec.alter_stmt;
        END LOOP;

        FOR rec IN cur_constraints_enable LOOP
             EXECUTE IMMEDIATE rec.alter_stmt;
        END LOOP;

EXCEPTION
  WHEN others THEN
    RAISE_APPLICATION_ERROR(-20001, 'PCK_UTIL.P_DS_BULK_POST_MAP: ' || substr(sqlerrm, 1, 500));

END;


PROCEDURE "P_DROP_PARTITION" ("P_TABLE_NAME" IN VARCHAR2
                            ,"P_STICHTAG" IN NUMBER)
IS
    V_SQL VARCHAR2(4000);
    PARTITION_DOES_NOT_EXIST     EXCEPTION;
    PRAGMA EXCEPTION_INIT (PARTITION_DOES_NOT_EXIST, -02149);
    PARTITION_LETZTE     EXCEPTION;
    PRAGMA EXCEPTION_INIT (PARTITION_LETZTE, -14758);
BEGIN
--V_SQL := 'ALTER TABLE RETAIL_MART.'||P_TABLE_NAME||' DROP PARTITION FOR ( TO_DATE(''' || P_STICHTAG || ''', ''YYYYMMDD'') ) UPDATE INDEXES';
V_SQL := 'ALTER TABLE RETAIL_MART.'||P_TABLE_NAME||' DROP PARTITION FOR ( TO_DATE(''' || P_STICHTAG || ''', ''YYYYMMDD'') )';
EXECUTE IMMEDIATE (V_SQL);
EXCEPTION
WHEN PARTITION_DOES_NOT_EXIST
    THEN
    dbms_output.put_line('Partition für den Wert '||P_STICHTAG||' der Tabelle '||P_TABLE_NAME||' nicht vorhanden.');
WHEN PARTITION_LETZTE
    THEN
    dbms_output.put_line('-14758: Letzte Partition im Range-Bereich kann nicht gelöscht werden');
WHEN OTHERS
                              THEN
                                 RAISE_APPLICATION_ERROR (
                                    -20002,
                                    'P_DROP_PARTITION(): ' || SUBSTR (SQLERRM, 1, 500));
END "P_DROP_PARTITION";
-----------------------------


END "PCK_UTIL";
/