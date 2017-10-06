CREATE OR REPLACE PROCEDURE proc_compress (p_owner       VARCHAR2,
                                           p_table       VARCHAR2,
                                           p_stichtag    NUMBER,
                                           p_offset      NUMBER)
IS
   v_alter_statement        VARCHAR2 (1000);
   v_SUBPARTITIONING_TYPE   VARCHAR2 (50);
BEGIN
   --Partitionstyp auslesen
   SELECT SUBPARTITIONING_TYPE
     INTO v_SUBPARTITIONING_TYPE
     FROM ALL_PART_TABLES
    WHERE TABLE_NAME = p_table;

   v_alter_statement := 'alter table ' || p_table || '  nologging';
   DBMS_OUTPUT.put_line ('Tabelle: '|| p_table || ' hat die Subpartitiontype:' || v_SUBPARTITIONING_TYPE);
   DBMS_OUTPUT.put_line (v_alter_statement);

   EXECUTE IMMEDIATE (v_alter_statement);

   v_alter_statement := 'alter table ' || p_table || ' compress for query HIGH';
   DBMS_OUTPUT.put_line (v_alter_statement);

   EXECUTE IMMEDIATE (v_alter_statement);

   IF (v_SUBPARTITIONING_TYPE = 'NONE')
   THEN
      FOR v_rec
         IN (SELECT PARTITION_NAME FROM ALL_TAB_PARTITIONS
                    INNER JOIN ALL_OBJECTS
                       ON     SUBOBJECT_NAME = PARTITION_NAME
                          AND OBJECT_NAME = TABLE_NAME
                          AND TABLE_NAME = p_table
                          AND OBJECT_TYPE = 'TABLE PARTITION'
                          AND TRUNC (CREATED) >= TRUNC (TO_DATE (p_stichtag, 'yyyymmdd')) - p_offset)
      LOOP
         BEGIN
            v_alter_statement :='ALTER TABLE ' || p_table || ' MOVE PARTITION ' || v_rec.PARTITION_NAME || ' UPDATE INDEXES COMPRESS for query high';
            DBMS_OUTPUT.put_line (v_alter_statement);

            EXECUTE IMMEDIATE (v_alter_statement);
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.PUT_LINE ('(COMPRESS for query high) ' || SUBSTR (SQLERRM, 1, 500));
         END;
      END LOOP;
   ELSE 
      FOR v_rec
         IN (SELECT SUBPARTITION_NAME
               FROM ALL_TAB_SUBPARTITIONS
                    INNER JOIN ALL_OBJECTS
                       ON     TABLE_NAME = OBJECT_NAME
                          AND SUBPARTITION_NAME = SUBOBJECT_NAME
              WHERE     TABLE_NAME = p_table
                    AND TRUNC (CREATED) >= TRUNC (TO_DATE (p_stichtag, 'yyyymmdd')) - p_offset)
      LOOP
         BEGIN
            v_alter_statement :='ALTER TABLE ' || p_table || ' MOVE SUBPARTITION ' || v_rec.SUBPARTITION_NAME || ' UPDATE INDEXES COMPRESS for query high';
            DBMS_OUTPUT.put_line (v_alter_statement);

            EXECUTE IMMEDIATE (v_alter_statement);
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.PUT_LINE (
                  '(COMPRESS for query high) ' || SUBSTR (SQLERRM, 1, 500));
         END;

         DBMS_STATS.gather_table_stats (
            ownname            => p_owner,
            tabname            => p_table,
            estimate_percent   => DBMS_STATS.AUTO_SAMPLE_SIZE,
            degree             => 32,
            PARTNAME           => v_rec.SUBPARTITION_NAME);
      END LOOP;
   END IF;
   DBMS_STATS.gather_table_stats (
            ownname            => p_owner,
            tabname            => p_table,
            estimate_percent   => DBMS_STATS.AUTO_SAMPLE_SIZE,
            degree             => 32);--,
            --PARTNAME           => v_rec.SUBPARTITION_NAME);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      v_alter_statement := 'ALTER TABLE ' || p_table || ' MOVE COMPRESS for query high';
      DBMS_OUTPUT.put_line (v_alter_statement);

      EXECUTE IMMEDIATE (v_alter_statement);

      DBMS_STATS.gather_table_stats (
         ownname            => p_owner,
         tabname            => p_table,
         estimate_percent   => DBMS_STATS.AUTO_SAMPLE_SIZE,
         degree             => 32);
END;

/

GRANT EXECUTE ON PROC_COMPRESS TO EXEC_RETAIL_MART;
