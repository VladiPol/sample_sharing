--------------------------------------------------------------------------------
-- $Beschreibung:
-- Partition mit gültigen Datensätzen auf NOCOMPRESS setzen und defragmentieren  
--------------------------------------------------------------------------------

BEGIN
FOR c_get_part in (select high_value,partition_name
from all_tab_partitions where table_name = 'KRDB_DA_TABLE_KTB_HST')
LOOP
-- Nicht die Partition mit den aktuellen Datensätzen komprimieren
IF substr(c_get_part.high_value,11,4) = '3000' THEN
EXECUTE IMMEDIATE('ALTER TABLE KRDB_DA_TABLE_KTB_HST MOVE PARTITION '||c_get_part.partition_name||' NOCOMPRESS');
END IF;
END LOOP;
END;
