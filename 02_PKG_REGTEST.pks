CREATE OR REPLACE PACKAGE PKG_RegTest authid current_user
AS
g_debug boolean := false;
/* produce sql to query diff patterns and counts */
procedure create_test_sql (p_table_owner in varchar2,P_TABLE_NAME in varchar2,p_ref_owner in varchar2,p_ref_name in varchar2,
 p_primary_key_columns in varchar2,p_exclude_columns in varchar2 default null,
 p_remap_columns in varchar2 default null,p_remap_ref_columns in varchar2 default null,p_additional_join_clause in varchar2 default null,
 p_filter_condition in varchar2 default null, p_ref_filter_condition in varchar2 default null);

/* produce sql to get some sample records for a diff pattern */
procedure create_compare_sql (p_table_owner in varchar2,P_TABLE_NAME in varchar2,p_ref_owner in varchar2,p_ref_name in varchar2,
 p_primary_key_columns in varchar2,p_exclude_columns in varchar2 default null,
 p_remap_columns in varchar2 default null,p_remap_ref_columns in varchar2 default null,p_additional_join_clause in varchar2 default null,
 p_filter_condition in varchar2 default null, p_ref_filter_condition in varchar2 default null,p_null_if_identical in boolean default true);
/* produce sql to query diff patterns and counts and insert the result into the regtest_result table*/
procedure create_ins_regtest_result_sql (p_table_owner in varchar2,P_TABLE_NAME in varchar2,p_ref_owner in varchar2,p_ref_name in varchar2,
 p_primary_key_columns in varchar2,p_exclude_columns in varchar2 default null,
 p_remap_columns in varchar2 default null,p_remap_ref_columns in varchar2 default null,p_additional_join_clause in varchar2 default null,
 p_filter_condition in varchar2 default null, p_ref_filter_condition in varchar2 default null);
/* calls create_ins_regtest_result_sql and runs the created sql using execute immediate*/
procedure run_test (p_table_owner in varchar2,P_TABLE_NAME in varchar2,p_ref_owner in varchar2,p_ref_name in varchar2,
 p_primary_key_columns in varchar2,p_exclude_columns in varchar2 default null,
 p_remap_columns in varchar2 default null,p_remap_ref_columns in varchar2 default null,p_additional_join_clause in varchar2 default null,
 p_filter_condition in varchar2 default null, p_ref_filter_condition in varchar2 default null);

 /* produce sql to get some sample records for a diff pattern */
procedure create_details_for_pattern_sql (p_table_owner in varchar2,P_TABLE_NAME in varchar2,p_ref_owner in varchar2,p_ref_name in varchar2,
 p_primary_key_columns in varchar2,p_exclude_columns in varchar2 default null,
 p_remap_columns in varchar2 default null,p_remap_ref_columns in varchar2 default null,p_additional_join_clause in varchar2 default null,
 p_filter_condition in varchar2 default null, p_ref_filter_condition in varchar2 default null,p_null_if_identical in boolean default true);

procedure unit_test;
procedure show_results;

procedure help;

END RISKMART."PKG_REGTEST";
/

