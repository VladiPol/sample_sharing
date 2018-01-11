CREATE TABLE PROC_PROTOCOL
(
  ROOT_PROC        VARCHAR2(61 BYTE)            NOT NULL,
  ROOT_PROC_START  DATE                         DEFAULT SYSDATE,
  PROC             VARCHAR2(61 BYTE)            NOT NULL,
  PROC_START       DATE                         DEFAULT SYSDATE,
  PROC_NOW         DATE                         DEFAULT SYSDATE,
  PROC_END         DATE,
  CONTENT          VARCHAR2(2000 BYTE)
)
TABLESPACE MART_DATA
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    0
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
COMPRESS BASIC 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE PROC_PROTOCOL IS 'used by procedures and maybe UNIX-scripts to protocol steps at runtime';

COMMENT ON COLUMN PROC_PROTOCOL.ROOT_PROC IS 'is the name of the calling procedure or other program';

COMMENT ON COLUMN PROC_PROTOCOL.ROOT_PROC_START IS 'timestamp when the root proc has been started, this and the root_proc column value are the common values of multiple proc that are called in one root process';

COMMENT ON COLUMN PROC_PROTOCOL.PROC IS 'owner and name of this proc other program';

COMMENT ON COLUMN PROC_PROTOCOL.PROC_START IS 'timestamp when this proc has been started';

COMMENT ON COLUMN PROC_PROTOCOL.PROC_NOW IS 'current timestamp';

COMMENT ON COLUMN PROC_PROTOCOL.PROC_END IS 'end timestamp of this proc';

COMMENT ON COLUMN PROC_PROTOCOL.CONTENT IS 'the logging content, the information the proc wants to protocol';



GRANT SELECT ON PROC_PROTOCOL TO APP_SAS_MLRM;

GRANT SELECT ON PROC_PROTOCOL TO APP_SAS_RA;

GRANT SELECT ON PROC_PROTOCOL TO GFRSMART;

GRANT INSERT, SELECT ON PROC_PROTOCOL TO PUBLIC;

GRANT SELECT ON PROC_PROTOCOL TO READ_RETAIL_MART;

GRANT SELECT ON PROC_PROTOCOL TO READ_RISKMART;

GRANT SELECT ON PROC_PROTOCOL TO READ_RISKMART_REG;

GRANT DELETE, INSERT, SELECT, UPDATE ON PROC_PROTOCOL TO RETAIL_MART;

GRANT SELECT ON PROC_PROTOCOL TO RISKMART_REG;

GRANT DELETE, INSERT, UPDATE ON PROC_PROTOCOL TO WRITE_RETAIL_MART;

GRANT DELETE, INSERT, UPDATE ON PROC_PROTOCOL TO WRITE_RISKMART;
