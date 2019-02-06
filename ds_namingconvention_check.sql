-- 30.04.2018  R. Penz    Combine now Stages, Links and StageVariables in one Select
-- 04.05.2018  R. Penz    Check stage variables for length and digit at 3. position
--
-- Namingconvention-Check
-- Now with Stages, Links and StageVariables
-- but still not 100% the same as in UC4-Deployment, because of no determination of Inner and Outer Join out of XMETA
--
-- STAGEs
select * from (
               SELECT
                           j.DSNAMESPACE_XMETA            as project,
                           j.CATEGORY_XMETA               as Folder,
                           j.NAME_XMETA                   as jobname,
                           s.STAGETYPE_XMETA              as object_type,
                           s.NAME_XMETA                   as object_NAME,
                           s.XMETA_CREATED_BY_USER_XMETA  as user_created,
                           s.XMETA_MODIFIED_BY_USER_XMETA as user_modified,
                           cast(CASE
                                     WHEN s.STAGETYPE_XMETA =    'PxSort'              AND s.NAME_XMETA not LIKE 'SRT\_%' escape '\' THEN 'Sort should start with SRT_'
                                     WHEN s.STAGETYPE_XMETA =    'PxAggregator'        AND s.NAME_XMETA not LIKE 'AGG\_%' escape '\' THEN 'Aggregator should start with AGG_'
                                     WHEN s.STAGETYPE_XMETA =    'PxCopy'              AND s.NAME_XMETA not LIKE 'CPY\_%' escape '\' THEN 'Copy should start with CPY_'
                                     WHEN s.STAGETYPE_XMETA =    'PxLookup'            AND s.NAME_XMETA not LIKE 'LKP\_%' escape '\' THEN 'Lookup should start with LKP_'
                                     WHEN s.STAGETYPE_XMETA =    'PxChecksum'          AND s.NAME_XMETA not LIKE 'CHS\_%' escape '\' THEN 'Checksum should start with CHS_'
                                     WHEN s.STAGETYPE_XMETA =    'PxFunnel'            AND s.NAME_XMETA not LIKE 'FNL\_%' escape '\' THEN 'Funnel should start with FNL_'
                                     WHEN s.STAGETYPE_XMETA =    'PxFilter'            AND s.NAME_XMETA not LIKE 'FLT\_%' escape '\' THEN 'Filter should start with FLT_'
                                     WHEN s.STAGETYPE_XMETA =    'PxJoin'              AND (s.NAME_XMETA not LIKE 'JN_\_%' escape '\' or substr(s.name_xmeta,3,1) not in ('I','O','F')) THEN 'Joiner should start with JN and use a following I, O or F for Inner, Outer or FULL Join'
                                     WHEN s.STAGETYPE_XMETA =    'PxPeek'              AND s.NAME_XMETA not LIKE 'PEK\_%' escape '\' THEN 'Peek should start with PEK_'
                                     WHEN s.STAGETYPE_XMETA =    'PxSequentialFile'    AND s.NAME_XMETA not LIKE 'SQF\_%' escape '\' THEN 'Sequential File should start with SQF_'
                                     WHEN s.STAGETYPE_XMETA =    'PxModify'            AND s.NAME_XMETA not LIKE 'MOD\_%' escape '\' THEN 'Modify should start with MOD_'
                                     WHEN s.STAGETYPE_XMETA =    'PxGeneric'           AND s.NAME_XMETA not LIKE 'GEN\_%' escape '\' THEN 'Generic should start with GEN_'
                                     WHEN s.STAGETYPE_XMETA =    'PxChangeCapture'     AND s.NAME_XMETA not LIKE 'CHC\_%' escape '\' THEN 'Change Capture should start with CHC_'
                                     WHEN s.STAGETYPE_XMETA LIKE 'CTransformerStage%'  AND s.NAME_XMETA not LIKE 'XFM\_%' escape '\' THEN 'Transformer should start with XFM_'
                                     WHEN s.STAGETYPE_XMETA LIKE 'OracleConnector%'    AND s.NAME_XMETA not LIKE 'ORA\_%' escape '\' THEN 'Oracle Connector should start with ORA_'
                                     WHEN s.STAGETYPE_XMETA LIKE 'ODBCConnector%'      AND s.NAME_XMETA not LIKE 'ODB\_%' escape '\' THEN 'ODBC Connector should start with ODB_'
                                     WHEN s.STAGETYPE_XMETA LIKE 'PxRemDup%'           AND s.NAME_XMETA not LIKE 'RDU\_%' escape '\' THEN 'Remove Duplicates should start with RDU_' 
                                     WHEN s.STAGETYPE_XMETA =    'CTerminatorActivity' AND s.NAME_XMETA not LIKE 'TAC\_%' escape '\' THEN 'Terminator Activity should start with TAC_'
                                     WHEN s.STAGETYPE_XMETA =    'CExceptionHandler'   AND s.NAME_XMETA not LIKE 'XHD\_%' escape '\' THEN 'Exception Handler should start with XHD_'
                                     ELSE 'XXXXX'
                                END as varchar2(200))                            as Error_description
                  FROM
                                      XMETA.DATASTAGEX_DSSTAGE s
                           INNER JOIN XMETA.DATASTAGEX_DSJOBDEF j ON (j.XMETA_REPOS_OBJECT_ID_XMETA = s.XMETA_LOCKINGROOT_XMETA)
                  WHERE
                           (
                               (s.STAGETYPE_XMETA =    'PxSort'              AND UPPER(s.NAME_XMETA) not LIKE 'SRT\_%' escape '\')
                            OR (s.STAGETYPE_XMETA =    'PxAggregator'        AND UPPER(s.NAME_XMETA) not LIKE 'AGG\_%' escape '\')
                            OR (s.STAGETYPE_XMETA =    'PxCopy'              AND UPPER(s.NAME_XMETA) not LIKE 'CPY\_%' escape '\')
                            OR (s.STAGETYPE_XMETA =    'PxLookup'            AND UPPER(s.NAME_XMETA) not LIKE 'LKP\_%' escape '\')
                            OR (s.STAGETYPE_XMETA =    'PxChecksum'          AND UPPER(s.NAME_XMETA) not LIKE 'CHS\_%' escape '\')
                            OR (s.STAGETYPE_XMETA =    'PxFunnel'            AND UPPER(s.NAME_XMETA) not LIKE 'FNL\_%' escape '\')
                            OR (s.STAGETYPE_XMETA =    'PxFilter'            AND UPPER(s.NAME_XMETA) not LIKE 'FLT\_%' escape '\')
                            OR (s.STAGETYPE_XMETA =    'PxJoin'              AND UPPER(s.NAME_XMETA) not LIKE 'JN%')
                            OR (s.STAGETYPE_XMETA =    'PxPeek'              AND UPPER(s.NAME_XMETA) not LIKE 'PEK\_%' escape '\')
                            OR (s.STAGETYPE_XMETA =    'PxSequentialFile'    AND UPPER(s.NAME_XMETA) not LIKE 'SQF\_%' escape '\')
                            OR (s.STAGETYPE_XMETA =    'PxModify'            AND UPPER(s.NAME_XMETA) not LIKE 'MOD\_%' escape '\')
                            OR (s.STAGETYPE_XMETA =    'PxGeneric'           AND UPPER(s.NAME_XMETA) not LIKE 'GEN\_%' escape '\')
                            OR (s.STAGETYPE_XMETA LIKE 'PxChangeCapture'     AND UPPER(s.NAME_XMETA) not LIKE 'CHC\_%' escape '\')
                            OR (s.STAGETYPE_XMETA LIKE 'CTransformerStage%'  AND upper(s.NAME_XMETA) not LIKE 'XFM\_%' escape '\')
                            OR (s.STAGETYPE_XMETA LIKE 'OracleConnector%'    AND upper(s.NAME_XMETA) not LIKE 'ORA\_%' escape '\')
                            OR (s.STAGETYPE_XMETA LIKE 'ODBCConnector%'      AND upper(s.NAME_XMETA) not LIKE 'ODB\_%' escape '\')
                            OR (s.STAGETYPE_XMETA =    'PxRemDup'            AND upper(s.NAME_XMETA) not LIKE 'RDU\_%' escape '\')
                            OR (s.STAGETYPE_XMETA =    'CTerminatorActivity' AND upper(s.NAME_XMETA) not LIKE 'TAC\_%' escape '\')
                            OR (s.STAGETYPE_XMETA =    'CExceptionHandler'   AND upper(s.NAME_XMETA) not LIKE 'XHD\_%' escape '\')
                           )
               union
               --
               -- LINKs
               --
               SELECT
                        DSNAMESPACE_XMETA                                                              as project,
                        j.CATEGORY_XMETA                                                               as Folder,
                        j.NAME_XMETA                                                                   as jobname,
                        cast('LINK' as nvarchar2(255))                                                 as object_type,
                        l.NAME_XMETA                                                                   as object_name,
                        j.XMETA_CREATED_BY_USER_XMETA                                                  as user_created,
                        j.XMETA_MODIFIED_BY_USER_XMETA                                                 as user_modified,
                        cast('Error ' || l.NAME_XMETA || ' starts with wrong Prefix' as varchar2(200)) as Error_description
                  FROM
                                   XMETA.DATASTAGEX_DSLINK   l
                        INNER JOIN XMETA.DATASTAGEX_DSJOBDEF j ON (j.XMETA_REPOS_OBJECT_ID_XMETA = l.XMETA_LOCKINGROOT_XMETA)
                  WHERE
                           (   SUBSTR(l.NAME_XMETA,4,1) <> '_'
                            OR SUBSTR(l.NAME_XMETA, 1, 3) not IN
                                                                 ('mov',
                                                                  'rea',
                                                                  'wri',
                                                                  'ref',
                                                                  'rej',
                                                                  'ins',
                                                                  'upd',
                                                                  'msg',
                                                                  'lnk',
                                                                  'cus',
                                                                  'fai',
                                                                  'oka',
                                                                  'oth',
                                                                  'val',
                                                                  'unc',
                                                                  'ust',
                                                                  'war')
                           )
                         
               union
               --
               -- StageVariables
               --
               select   jobdef.DSNAMESPACE_XMETA                                                                      as project,
                        jobdef.CATEGORY_XMETA                                                                         as Folder,
                        jobdef.name_xmeta                                                                             as JOBNAME,
                        stage.STAGETYPE_XMETA                                                                         as object_type,
                        stage.name_xmeta                                                                              as object_name,
                        jobdef.XMETA_CREATED_BY_USER_XMETA                                                            as user_created,
                        jobdef.XMETA_MODIFIED_BY_USER_XMETA                                                           as user_modified,
                        cast(
                             case
                                when flow.name_xmeta not like 'sv%'                                    then 'Error - StageVariable ' || flow.name_xmeta || ' do not start with sv'
                                when REGEXP_INSTR(substr(flow.name_xmeta,3,1), '([[:digit:]]{1})') > 0 then 'Error - StageVariable ' || flow.name_xmeta || ' needs at 3. position a letter'
                                when length(flow.name_xmeta) < 3                                       then 'Error - StageVariable ' || flow.name_xmeta || ' does not have a minimum length of 3'
                                else 'Error - StageVariable ' || flow.name_xmeta
                             end as varchar2(200)
                            ) as Error_description
                  from  
                             XMETA.datastagex_dsstage     stage
                        join xmeta.datastagex_dsjobdef    jobdef on stage.of_jobdef_xmeta = jobdef.xmeta_repos_object_id_xmeta
                        join xmeta.datastagexdsflowvaribl flow on flow.of_jobobject_xmeta = stage.xmeta_repos_object_id_xmeta
                  where 
                        (   -- first two positions have to be sv in small letters
                            flow.name_xmeta not like 'sv%'
                            -- 3. position have to be a letter, not a digit
                         or REGEXP_INSTR(substr(flow.name_xmeta,3,1), '([[:digit:]]{1})') > 0
                            -- variable name needs at least a length of 3
                         or length(flow.name_xmeta) < 3
                        )
)
 where     jobname like '%EHWDB%'
       and Folder not like '\\999%' -- no private user folder
       and Folder not like '\\100%' -- no common folder
       and jobname like 'DE%'
       and project like '%:DE_DATA_LAKE%'
;
