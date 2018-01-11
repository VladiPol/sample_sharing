CREATE OR REPLACE PACKAGE BODY RISKMART.PKG_RegTest
AS
type t_varchar_array is VARRAY(2000) of varchar2(4000); -- array type
type t_varchar_map is TABLE of varchar2(200) index by varchar2(200); -- map type
g_BUFFER CLOB; -- buffer to store created sql for execution
g_fill_buffer boolean := false; -- if true, p() writes to v_buffer and not to dbms output
ex_custom EXCEPTION;
 PRAGMA EXCEPTION_INIT( ex_custom, -20001 );
-- cursor for table column information
Cursor c_columns(cp_table_owner varchar2, cp_table_name varchar2)
is
select
atc.column_name,
atc.data_TYPE,
atc.DATA_LENGTH,
atc.DATA_PRECISION,
atc.DATA_SCALE,
atc.column_id,
atc.owner,
atc.table_name,
atc.data_default,
case when length(atc.column_name) > 20
then  trim(substr(atc.column_name,1,17))||trim(to_char(atc.column_id,'000'))
else atc.column_name
end as short_column_name
from all_tab_columns atc
where upper(atc.owner) = upper(cp_table_owner) and upper(atc.table_name)= upper(cp_table_name)
order by column_id;

-- output procedure, writes to dbms output or g_buffer
procedure p(a_string in varchar2)
is
begin
if g_fill_buffer then
 g_BUFFER := g_BUFFER||CASE WHEN g_BUFFER IS NULL OR g_BUFFER = '' THEN '' ELSE CHR (10)END ||a_string;
else
dbms_output.put_line(a_string);
end if
;
end
;

-- debug output
procedure p_debug(a_string in varchar2) is begin if g_debug then dbms_output.put_line(a_string); end if; end;

-- create log entry for procedure call
procedure log_call ( p_table_owner in varchar2,P_TABLE_NAME in varchar2,p_ref_owner in varchar2,p_ref_name in varchar2,
                           p_primary_key_columns in varchar2,p_exclude_columns in varchar2 default null,
                           p_remap_columns in varchar2 default null,p_remap_ref_columns in varchar2 default null,p_additional_join_clause in varchar2 default null,
                           p_filter_condition in varchar2 default null, p_ref_filter_condition in varchar2 default null,
                           p_proc_name in varchar2 default null,p_start_date in DATE default sysdate, p_end_date in DATE default sysdate)
is
v_call_string varchar2(2000);

function ret_arg_if_not_null(a_arg in varchar2,a_value in varchar2) return varchar2
is
v_ret varchar2(1000);
begin
v_ret :='';
if trim(a_value) is not null then
v_ret := ','||a_arg||'=>'''||replace(a_value,'''','''''')||'''';
end if;
return v_ret;
end;

begin
-- mandatory arguments
v_call_string := 'RISKMART.PKG_RegTest.'||p_proc_name||'(p_table_owner=>'''||p_table_owner||''',p_table_name=>'''||p_table_name||''',p_ref_owner=>'''||p_ref_owner||''',p_ref_name=>'''||p_ref_name||''',p_primary_key_columns=>'''||p_primary_key_columns||'''';
-- optional arguments
v_call_string := v_call_string||ret_arg_if_not_null('p_exclude_columns',p_exclude_columns);
v_call_string := v_call_string||ret_arg_if_not_null('p_remap_columns',p_remap_columns);
v_call_string := v_call_string||ret_arg_if_not_null('p_remap_ref_columns',p_remap_ref_columns);
v_call_string := v_call_string||ret_arg_if_not_null('p_additional_join_clause',p_additional_join_clause);
v_call_string := v_call_string||ret_arg_if_not_null('p_filter_condition',p_filter_condition);
v_call_string := v_call_string||ret_arg_if_not_null('p_ref_filter_condition',p_ref_filter_condition);
v_call_string := v_call_string||');';


insert into RISKMART.PROC_PROTOCOL(ROOT_PROC,ROOT_PROC_START,PROC,PROC_START,PROC_NOW,PROC_END,CONTENT)
values(p_proc_name,p_start_date,p_proc_name,p_start_date,sysdate,p_end_date,v_call_string);

end;

/* create dfferences for a column */
function diff_values(a_column_id in number,a_select in varchar2, a_select_type in varchar2, a_ref_select in varchar2, a_ref_select_type in char, a_null_if_identical in boolean default true) return varchar2
is
v_1 varchar2(2000);
v_2 varchar2(2000);
begin

if upper(a_select_type) = 'C' then
    v_1 := 't1.'||trim(a_select);
else
    v_1 := trim(a_select);
end if;

if upper(a_ref_select_type) = 'C' then
    v_2 := 't2.'||trim(a_ref_select);
else
    v_2 := trim(a_ref_select);
end if;

-- select null or one of the values for identical values, value1[value2] for different values
if a_null_if_identical then
return ' (case when('||v_1||' is null and '||v_2||' is null) or '||v_1||'='||v_2||' then '''' else '||v_1||' ||''[''||'||v_2||'||'']'' end ) as '||trim(a_select)||'  ';
else
return ' (case when('||v_1||' is null and '||v_2||' is null) or '||v_1||'='||v_2||' then  '||v_1||' else '||v_1||' ||''[''||'||v_2||'||'']'' end ) as '||trim(a_select)||'  ';
end if;

end;

function column_position_char(a_column_id in number) return varchar2
is
begin
return trim(substr('123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',mod(a_column_id,61),1));
end;

/* create sql to select the diff pattern character for a column */
function diff_binary(a_column_id in number,a_select in varchar2,a_select_type in char, a_ref_select in varchar2, a_ref_select_type in char) return varchar2
is
v_1 varchar2(2000);
v_2 varchar2(2000);
v_d varchar2(10);
begin
v_d := column_position_char(a_column_id);

if upper(a_select_type) = 'C' then
    v_1 := 't1.'||trim(a_select);
else
    v_1 := trim(a_select);
end if;

if upper(a_ref_select_type) = 'C' then
    v_2 := 't2.'||trim(a_ref_select);
else
    v_2 := trim(a_ref_select);
end if;

return ' ( case when ( '||v_1||' is null and  '||v_2||' is null ) or '||v_1||'='||v_2||' then ''-'' else '''||v_d||''' end ) ';
end;
-- diff_binary

function column_names(p_owner in varchar2, p_table_name in varchar2 ) return t_varchar_array
is
v_array t_varchar_array;
v_i integer;
v_error varchar2(200);
begin
v_i := 1;
v_array :=t_varchar_array();
for v_records in c_columns(p_owner, p_table_name)
loop
v_array.extend();
v_array(v_i) := v_records.column_name;
v_i := v_i+1;
end loop;

if v_i = 1 then
v_error :=  ' FATAL ERROR - query returned no column names for '||p_owner||'.'||p_table_name||'  ';
dbms_output.put_line(v_error);
 raise_application_error( -20001,v_error);
end if;

return v_array;
end;


/* initialise array from a  string 'value1;value2;value3;....' */
function string_to_array(p_str in varchar2,p_delim in varchar2) return t_varchar_array
is
v_count integer;
v_next integer;
v_current integer;
v_previous integer;
v_array t_varchar_array;
v_chunk varchar(200);
v_i integer;
begin
v_count := 1;
v_previous := 1;
v_current := 0;
v_array :=t_varchar_array();
v_i:=1;
v_next := instr(p_str,p_delim,1,v_count);
while v_next > 0 loop
v_chunk := substr(p_str,v_current+1,v_next-v_current-1);
v_array.extend();
v_array(v_i) := v_chunk;
v_i := v_i+1;
v_count := v_count+1;
v_current := v_next;
v_next := instr(p_str,p_delim,1,v_count);
end loop;
v_chunk := substr(p_str,v_current+1,length(p_str)-v_current);
v_array.extend();
v_array(v_i) := v_chunk;
return v_array;
end;
-- string_to_array

/* initialise a key/value map from a string 'key1;value1;key2;value2;...' */
function string_to_map(p_str in varchar2,p_delim in varchar2) return t_varchar_map
is
v_count integer;
v_next integer;
v_current integer;
v_previous integer;
v_map t_varchar_map;
v_key varchar2(200) ;
v_value varchar(200);
begin
v_count := 1;
v_previous := 1;
v_current := 0;
v_next := instr(p_str,p_delim,1,v_count);
while v_next > 0 loop
v_key := substr(p_str,v_current+1,v_next-v_current-1);
v_current := v_next;
v_count := v_count+1;
v_next := instr(p_str,p_delim,1,v_count);
if(v_next = 0 ) then
    v_next := length(p_str)+1;
end if;
v_value := substr(p_str,v_current+1,v_next-v_current-1);

v_map(v_key) := v_value;

v_current := v_next;
v_count := v_count+1;
v_next := instr(p_str,p_delim,1,v_count);
end loop;

return v_map;

end;
--string_to_map

/* find a value in a array defined by a string 'value1;value2;value3;.... */
function find_in_delimited_string(p_str in varchar2,p_delim in varchar2,p_pattern in varchar2) return boolean
is
v_count integer;
v_next integer;
v_current integer;
v_previous integer;
v_chunk varchar(200);
v_i integer;
begin
v_count := 1;
v_previous := 1;
v_current := 0;
v_i:=1;
v_next := instr(p_str,p_delim,1,v_count);
while v_next > 0 loop
v_chunk := substr(p_str,v_current+1,v_next-v_current-1);
if upper(trim(p_pattern)) = upper(trim(v_chunk)) then
return true;
end if;

v_i := v_i+1;
v_count := v_count+1;
v_current := v_next;
v_next := instr(p_str,p_delim,1,v_count);
end loop;
v_chunk := substr(p_str,v_current+1,length(p_str)-v_current);

if trim(p_pattern) = trim(v_chunk)
then
return true;
else
return false;
end if;

end;
--string_to_array

/* find a value in an array */
function find_in_array(p_array in t_varchar_array,p_str in varchar2) return boolean
is
v_i integer;
v_ret boolean;
begin
v_ret := false;
for v_i in p_array.first..p_array.last
loop
if upper(trim(p_array(v_i))) = upper(trim(p_str)) then
v_ret := true;
end if;
end loop;
return v_ret;
end; --find_in_array

/* find the value for a key in a key/value map defined by a string 'key1;value1;key2,value2;...'*/
function find_mapped_string(p_str in varchar2,p_delim in varchar2,p_key in varchar2) return varchar2
is
v_count integer;
v_next integer;
v_current integer;
v_previous integer;
v_key varchar2(200) ;
v_value varchar(200);
v_return varchar2(200) := p_key;
begin
v_count := 1;
v_previous := 1;
v_current := 0;
v_next := instr(p_str,p_delim,1,v_count);
while v_next > 0 loop
v_key := substr(p_str,v_current+1,v_next-v_current-1);
v_current := v_next;
v_count := v_count+1;
v_next := instr(p_str,p_delim,1,v_count);
if(v_next = 0 ) then
    v_next := length(p_str)+1;
end if;
v_value := substr(p_str,v_current+1,v_next-v_current-1);

if upper(trim(p_key)) = upper(trim(v_key)) then
v_return := v_value;
end if;

v_current := v_next;
v_count := v_count+1;
v_next := instr(p_str,p_delim,1,v_count);
end loop;

return v_return;

end;
--string_to_map


/* create sql code to create a string of concatenated primary key values */
function primary_key_string(p_primary_key_columns in varchar2,p_tab_prefix in varchar2) return varchar2
is
v_key_column_array t_varchar_array;
v_return varchar2(2000);
begin
  v_key_column_array:=string_to_array(p_primary_key_columns,';') ;
  for v_i in v_key_column_array.first..v_key_column_array.last
  loop
    if v_i>1 then
      v_return:=v_return||'||';
    end if;
    v_return := trim(v_return)||' '||trim('trim(to_char('||trim(p_tab_prefix)||'.'||trim(v_key_column_array(v_i))||'))');
  end loop;
  return v_return;
end;

/* create sql for the join condition */
function join_condition(p_primary_key_columns in varchar2) return varchar2
is
v_key_column_array t_varchar_array;
v_return varchar2(2000);
begin
v_key_column_array:=string_to_array(p_primary_key_columns,';') ;
for v_i in v_key_column_array.first..v_key_column_array.last
loop

if v_i>1 then
v_return:=v_return||' and';
end if;
v_return := trim(v_return)||' '||trim('t1.'||trim(v_key_column_array(v_i))||'=t2.'||trim(v_key_column_array(v_i)));
end loop;
return v_return;
end;


/* create sql for the filter condition  on one table */
function create_filter_condition(p_map in t_varchar_map,p_table_alias in varchar2 default null) return varchar2
is
v_ret varchar2(2000);
v_column varchar2(200);
v_i integer;
begin
v_i := 1;
v_column := p_map.first;

while v_column is not null
loop

if v_i > 1 then
v_ret := v_ret||' and ';
end if;

-- condition is used
if p_table_alias is not null then
v_ret := v_ret||trim(p_table_alias)||'.';
end if;

v_ret:=v_ret||trim(v_column)||p_map(v_column);

v_i := v_i+1;
v_column := p_map.next(v_column);
end loop;

return v_ret;
end;

/* create sql for the filter condition  on one table */
function create_filter_condition(p_condition in varchar2,p_table_alias in varchar2 default null) return varchar2
is
v_return varchar2(2000);
begin
v_return := null;
if trim(p_condition) is not null then
    v_return :=  create_filter_condition(string_to_map(p_condition,';'),p_table_alias);
end if;
return v_return;
end;

/* create complete where clause for both tables */
function create_filter_clause(p_conditions_1 in varchar2,p_alias_1 in varchar2,p_conditions_2 in varchar2,p_alias_2 in varchar2) return varchar2
is
v_where_clause varchar2(2000);
begin
  v_where_clause := null;
  if trim(p_conditions_1) is not null then
    v_where_clause := v_where_clause||create_filter_condition(string_to_map(p_conditions_1,';'),p_alias_1);
  end if;
  if trim(p_conditions_2) is not null then
    if length(trim(v_where_clause)) is not null then
      v_where_clause := v_where_clause||' and ';
    end if;
    v_where_clause := v_where_clause||create_filter_condition(string_to_map(p_conditions_2,';'),p_alias_2);
  end if;
  return v_where_clause;
end;

/* create sql to select the complete diff pattern for a row*/
procedure create_diff_pattern_select (p_table_owner in varchar2,P_TABLE_NAME in varchar2,p_ref_owner in varchar2,p_ref_name in varchar2,
                           p_exclude_columns in varchar2,p_remap_columns in varchar2 default null,p_remap_ref_columns in varchar2 default null)
is
v_logical_column_id integer;
v_skip_column boolean;
v_table_column_names t_varchar_array;
v_ref_column_names t_varchar_array;
v_select_value varchar2(2000);
v_type char;
v_ref_select_value varchar2(2000);
v_ref_type char;
begin
v_table_column_names := column_names(p_table_owner,p_table_name);
v_ref_column_names := column_names(p_ref_owner,p_ref_name);

v_logical_column_id := 0;

for v_records in c_columns(p_table_owner, p_table_name)
loop

if find_in_delimited_string(p_exclude_columns,';',v_records.column_name)
then
v_skip_column := true;
else
v_skip_column := false;
end if;

v_select_value := find_mapped_string(p_remap_columns,';',v_records.column_name);

if find_in_array(v_table_column_names,v_select_value)
then
v_type := 'c';
else
v_type := 't';
end if;

v_ref_select_value := find_mapped_string(p_remap_ref_columns,';',v_records.column_name);
if trim(v_ref_select_value) = trim(v_records.column_name) then  -- not mapped
    if find_in_array(v_ref_column_names,trim(v_records.column_name)) -- check if its a valid column in the ref table
        then
        v_ref_type := 'c';
    else -- column doesn't exist im ref table - skip it
        v_skip_column := true;
        v_ref_type := 'c' ;
    end if;
elsif find_in_array(v_ref_column_names,v_ref_select_value) -- mapped, check if it is a column
then
v_ref_type := 'c';
else
v_ref_type := 't';
end if;

if not v_skip_column then
v_logical_column_id  := v_logical_column_id+1;
end if;


if v_logical_column_id=1 and not v_skip_column then
p(diff_binary(v_records.column_id,v_select_value,v_type,v_ref_select_value,v_ref_type));
elsif v_skip_column then
p('--||'||diff_binary(v_records.column_id,v_select_value,v_type,v_ref_select_value,v_ref_type));
else
p('||'||diff_binary(v_records.column_id,v_select_value,v_type,v_ref_select_value,v_ref_type));
end if;
end loop;
end;

/* generate sql to create the comparison row for joined records */
procedure create_compare_select (p_table_owner in varchar2,P_TABLE_NAME in varchar2,p_ref_owner in varchar2,p_ref_name in varchar2,
                           p_exclude_columns in varchar2 default null,p_remap_columns in varchar2 default null,p_remap_ref_columns in varchar2 default null,
                           p_null_if_identical in boolean default true)
is
v_logical_column_id integer;
v_skip_column boolean;
v_table_column_names t_varchar_array;
v_ref_column_names t_varchar_array;
v_select_value varchar2(2000);
v_type char;
v_ref_select_value varchar2(2000);
v_ref_type char; -- column or text
begin

v_table_column_names := column_names(p_table_owner,p_table_name);
v_ref_column_names := column_names(p_ref_owner,p_ref_name);

v_logical_column_id := 0;
for v_records in c_columns(p_table_owner,p_table_name)
loop

if find_in_delimited_string(p_exclude_columns,';',v_records.column_name)
then
v_skip_column := true;
else
v_skip_column := false;
end if;

v_select_value := find_mapped_string(p_remap_columns,';',v_records.column_name);
if find_in_array(v_table_column_names,v_select_value)
then
v_type := 'c';
else
v_type := 't';
end if;

v_ref_select_value := find_mapped_string(p_remap_ref_columns,';',v_records.column_name);
if trim(v_ref_select_value) = trim(v_records.column_name) then  -- not mapped
    if find_in_array(v_ref_column_names,trim(v_records.column_name)) -- check if its a valid column in the ref table
        then
        v_ref_type := 'c';
    else -- column doesn't exist im ref table - skip it
        v_skip_column := true;
        v_ref_type := 'c' ;
    end if;
elsif find_in_array(v_ref_column_names,v_ref_select_value) -- mapped, check if it is a column
then
v_ref_type := 'c';
else
v_ref_type := 't';
end if;

if not v_skip_column then
v_logical_column_id  := v_logical_column_id+1;
end if;

if v_logical_column_id=1 and not v_skip_column then
p(diff_values(v_records.column_id,v_select_value,v_type,v_ref_select_value,v_ref_type,p_null_if_identical));
elsif v_skip_column then
p('--,'||diff_values(v_records.column_id,v_select_value,v_type,v_ref_select_value,v_ref_type,p_null_if_identical));
else
p(','||diff_values(v_records.column_id,v_select_value,v_type,v_ref_select_value,v_ref_type,p_null_if_identical));
end if;
end loop;
end;

function get_filter_condition(p_filter_condition in varchar2, p_table_alias in varchar2 default null) return varchar2
is
v_return varchar2(2000);
begin
if instr(p_filter_condition,';') > 0 then
    v_return := create_filter_condition(p_filter_condition,p_table_alias);
else
    v_return := trim(p_filter_condition);
end if;

return v_return;
end;

/* apply filter condition to tables before joining */
procedure create_from_clause(p_table_owner in varchar2,P_TABLE_NAME in varchar2,p_ref_owner in varchar2,p_ref_name in varchar2,
                           p_primary_key_columns in varchar2,p_exclude_columns in varchar2 default null,
                           p_remap_columns in varchar2 default null,p_remap_ref_columns in varchar2 default null,p_additional_join_clause in varchar2 default null,
                           p_filter_condition in varchar2 default null, p_ref_filter_condition in varchar2 default null)
is
v_where_clause varchar2(2000);
v_ref_where_clause varchar2(2000);
begin

v_where_clause := get_filter_condition(p_filter_condition);
v_ref_where_clause := get_filter_condition(p_ref_filter_condition);

if trim(v_where_clause) is not null then
p(' FROM ( select * from '||trim(p_table_owner)||'.'||trim(p_table_name)||' where '||v_where_clause||')  t1 ' );
else
p(' FROM '||trim(p_table_owner)||'.'||trim(p_table_name)||' t1 ');
end if;

if trim(v_ref_where_clause) is not null then
p(' FULL OUTER JOIN ( select * from '||trim(p_ref_owner)||'.'||trim(p_ref_name)||' where '||v_ref_where_clause||'  )  t2 on ( '||join_condition(p_primary_key_columns)||p_additional_join_clause||')');
else
p(' FULL OUTER JOIN '||trim(p_ref_owner)||'.'||trim(p_ref_name)||' t2 on ( '||join_condition(p_primary_key_columns)||p_additional_join_clause||')');
end if;

end;
/* create sql for diff pattern test */
procedure create_test_sql (p_table_owner in varchar2,P_TABLE_NAME in varchar2,p_ref_owner in varchar2,p_ref_name in varchar2,
                           p_primary_key_columns in varchar2,p_exclude_columns in varchar2 default null,
                           p_remap_columns in varchar2 default null,p_remap_ref_columns in varchar2 default null,p_additional_join_clause in varchar2 default null,
                           p_filter_condition in varchar2 default null, p_ref_filter_condition in varchar2 default null)
is
begin

p(' select ');
p(' case when t2_pk is null then ''no matching key in old data found''  ');
p('            when t1_pk is null then ''NO MATCHING KEY IN NEW DATA FOUND''  ');
p('            ELSE diff_str  END ');
p('       AS DIFF_STRING,     ');
p('       count(*)  as rec_count,               ');
p('       min(t1_pk||''##''||t2_pk) AS min_Beispiel_Primary_Key, ');
p('       max(t1_pk||''##''||t2_pk) AS max_Beispiel_Primary_Key, ');
p('       (SELECT GLOBAL_NAME||''@''||to_char(SYSDATE, ''YYYYMMDD HH24MISS'') FROM GLOBAL_NAME) AS "datasource@datetime", ');
p('      ''SELECT * FROM '||trim(p_table_owner)||'.'||trim(p_table_name)||' t1 WHERE '||primary_key_string(p_primary_key_columns,'t1')||' IN (''''''||min(t1_pk)||'''''', ''''''||max(t1_pk)||'''''' )   ');
p(' UNION ALL SELECT * FROM '||trim(p_ref_owner)||'.'||trim(p_ref_name)||' t2 WHERE '||primary_key_string(p_primary_key_columns,'t2')||' IN (''''''||min(t2_pk)||'''''', ''''''||max(t2_pk)||'''''') ');
p(' ORDER BY 1, 5 '' AS detail_statement ');
p(' FROM ');
p(' ( ');
P(' SELECT ');

create_diff_pattern_select (p_table_owner=>p_table_owner,p_table_name=>P_TABLE_NAME,p_ref_owner=>p_ref_owner,p_ref_name=>p_ref_name,
                           p_exclude_columns=>p_exclude_columns,p_remap_columns=>p_remap_columns,p_remap_ref_columns=>p_remap_ref_columns);


p(' AS diff_str, ');
p(' '||primary_key_string(p_primary_key_columns,'t1')||' t1_pk, ');
p(' '||primary_key_string(p_primary_key_columns,'t2')||' t2_pk ');


create_from_clause (p_table_owner=>p_table_owner,p_table_name=>P_TABLE_NAME,p_ref_owner=>p_ref_owner,p_ref_name=>p_ref_name,
                           p_primary_key_columns=>p_primary_key_columns,p_exclude_columns=>p_exclude_columns,p_remap_columns=>p_remap_columns,p_remap_ref_columns=>p_remap_ref_columns,
                            p_additional_join_clause=>p_additional_join_clause,p_filter_condition=>p_filter_condition,p_ref_filter_condition=>p_ref_filter_condition);


p(' ) ');
p(' GROUP BY ROLLUP ( ');
p('     case when t2_pk is null then ''no matching key in old data found''  ');
p('            when t1_pk is null then ''NO MATCHING KEY IN NEW DATA FOUND''  ');
p('            ELSE diff_str  end ');
p(' ) ');

end;

/* create sql to get diff patterns and insert the result into the regtest_result table */
procedure create_ins_regtest_result_sql (p_table_owner in varchar2,P_TABLE_NAME in varchar2,p_ref_owner in varchar2,p_ref_name in varchar2,
                           p_primary_key_columns in varchar2,p_exclude_columns in varchar2 default null,
                           p_remap_columns in varchar2 default null,p_remap_ref_columns in varchar2 default null,p_additional_join_clause in varchar2 default null,
                           p_filter_condition in varchar2 default null, p_ref_filter_condition in varchar2 default null)
is
begin
p(' insert into RISKMART.regtest_result ');
p(' ( "DATASOURCE@DATETIME",DETAIL_STATEMENT,DIFF_STRING,MAX_BEISPIEL_PRIMARY_KEY,MIN_BEISPIEL_PRIMARY_KEY, ' );
p(' OCCURANCE_COUNT,REGTEST_DATETIME,REGTEST_OBJECTS) ');
p(' select  "datasource@datetime",detail_statement,diff_string,MAX_BEISPIEL_PRIMARY_KEY,MIN_BEISPIEL_PRIMARY_KEY,rec_count,sysdate,');
p(''''||p_table_owner||'.'||p_table_name||' - '||p_ref_owner||'.'||p_ref_name||'''');
p(' from ( ');
create_test_sql (p_table_owner,P_TABLE_NAME,p_ref_owner,p_ref_name,p_primary_key_columns,p_exclude_columns ,
                           p_remap_columns,p_remap_ref_columns,p_additional_join_clause,p_filter_condition, p_ref_filter_condition );
p(' ) ');
end;

procedure create_details_for_pattern_sql (p_table_owner in varchar2,P_TABLE_NAME in varchar2,p_ref_owner in varchar2,p_ref_name in varchar2,
                           p_primary_key_columns in varchar2,p_exclude_columns in varchar2 default null,
                           p_remap_columns in varchar2 default null,p_remap_ref_columns in varchar2 default null,p_additional_join_clause in varchar2 default null,
                           p_filter_condition in varchar2 default null, p_ref_filter_condition in varchar2 default null,p_null_if_identical in boolean default true)
is
begin
create_compare_sql (p_table_owner,P_TABLE_NAME,p_ref_owner,p_ref_name,p_primary_key_columns,p_exclude_columns ,
                           p_remap_columns,p_remap_ref_columns,p_additional_join_clause,p_filter_condition, p_ref_filter_condition,p_null_if_identical);
end;

/* create sql to get differences for some records matching a diff pattern */
procedure create_compare_sql(p_table_owner in varchar2,P_TABLE_NAME in varchar2,p_ref_owner in varchar2,p_ref_name in varchar2,
                           p_primary_key_columns in varchar2,p_exclude_columns in varchar2 default null,
                           p_remap_columns in varchar2 default null,p_remap_ref_columns in varchar2 default null,p_additional_join_clause in varchar2 default null,
                           p_filter_condition in varchar2 default null, p_ref_filter_condition in varchar2 default null,p_null_if_identical in boolean default true)
is
begin

p(' select * from  ( select ');
create_diff_pattern_select (p_table_owner,P_TABLE_NAME,p_ref_owner,p_ref_name,
                           p_exclude_columns ,p_remap_columns,p_remap_ref_columns);


p(' AS diff_str, ');
create_compare_select (p_table_owner,P_TABLE_NAME,p_ref_owner,p_ref_name,
                           p_exclude_columns ,p_remap_columns,p_remap_ref_columns,p_null_if_identical);

p(' ,'||primary_key_string(p_primary_key_columns,'t1')||' t1_pk ');
p(' ,'||primary_key_string(p_primary_key_columns,'t2')||' t2_pk ');

create_from_clause (p_table_owner=>p_table_owner,p_table_name=>P_TABLE_NAME,p_ref_owner=>p_ref_owner,p_ref_name=>p_ref_name,
                           p_primary_key_columns=>p_primary_key_columns,p_exclude_columns=>p_exclude_columns,p_remap_columns=>p_remap_columns,p_remap_ref_columns=>p_remap_ref_columns,
                            p_additional_join_clause=>p_additional_join_clause,p_filter_condition=>p_filter_condition,p_ref_filter_condition=>p_ref_filter_condition);

p(' ) ');
p(' where diff_str like ''%'' and rownum < 100; ') ;
end;

/* run diff pattern test and write the result plus some additional information to regtest_result */
procedure run_test (p_table_owner in varchar2,P_TABLE_NAME in varchar2,p_ref_owner in varchar2,p_ref_name in varchar2,
                           p_primary_key_columns in varchar2,p_exclude_columns in varchar2 default null,
                           p_remap_columns in varchar2 default null,p_remap_ref_columns in varchar2 default null,p_additional_join_clause in varchar2 default null,
                           p_filter_condition in varchar2 default null, p_ref_filter_condition in varchar2 default null)
is
v_rowcount number;
v_time timestamp;
v_select_statement varchar2(4000);
type t_integer_array IS VARRAY(2000) OF INTEGER;
v_diff_sum t_integer_array;
v_skip_column boolean;
v_logical_column_id integer;
v_regtest_objects varchar2(2000);
v_datasource varchar2(2000);
v_datetime date;
v_diff_length integer;
v_diff_base_string varchar2(200);
v_diff_str varchar2(200);
v_start_date date;
begin
  v_start_date := sysdate;

  g_buffer :='BEGIN '; --initialise Buffer

  g_fill_buffer := true; --produced sql will be written to v_buffer and not to dbms_output
  create_ins_regtest_result_sql (p_table_owner, P_TABLE_NAME, p_ref_owner, p_ref_name, p_primary_key_columns, p_exclude_columns,
                                 p_remap_columns, p_remap_ref_columns, p_additional_join_clause, p_filter_condition, p_ref_filter_condition);
  g_fill_buffer := false;

  g_BUFFER := g_BUFFER || '; :v_ROWCOUNT := SQL%ROWCOUNT; COMMIT; END;';

  p(' start running sql ');
  v_time := sysdate;
  execute immediate g_BUFFER USING OUT v_rowcount;
  p(v_rowcount||' records inserted into riskmart.regtest_result - retrieve with:');
  v_select_statement := 'SELECT * FROM riskmart.regtest_result WHERE REGTEST_DATETIME=to_date('''||to_char(v_time,'DDMMYYYY hh24:mi:ss')||''',''DDMMYYYY hh24:mi:ss'') '||
                        ' ORDER BY CASE WHEN DETAIL_STATEMENT IS NULL THEN 1 ELSE 0 END, NLSSORT(DIFF_STRING,''NLS_SORT=BINARY''); ';
  p(v_select_statement);

  -- write some summary information
  v_diff_sum := t_integer_array();
  v_diff_sum.extend(200);

  p_debug(' scan results');

  -- read in the results
  for v_result_rec in ( select * from riskmart.regtest_result where regtest_datetime =  to_date(to_char(v_time,'DDMMYYYY hh24:mi:ss'),'DDMMYYYY hh24:mi:ss')
      and trim(diff_string) is not null and upper(diff_string) not like '%MATCHING%' )
  loop
    p_debug (' diff_str'||v_result_rec.diff_string);
    v_regtest_objects := v_result_rec.regtest_objects;
    v_datasource := v_result_rec."DATASOURCE@DATETIME";
    v_datetime := v_result_rec.REGTEST_DATETIME;
    v_diff_length := length(v_result_rec.diff_string);

    -- scan diffstring and sum up differences per column
    for v_i in 1..v_diff_length loop
      if substr(v_result_rec.diff_string,v_i,1) <> '-' then
        v_diff_sum(v_i) := nvl(v_diff_sum(v_i),0) + v_result_rec.occurance_count;
      end if;
    end loop;
  end loop;

  v_diff_base_string := substr('------------------------------------------------------------------------------------------------------------------------------',1,v_diff_length);
  v_logical_column_id := 0;
  -- create one summary record for a column if total difference count is > 0
  for v_records in c_columns(p_table_owner, p_table_name) loop
    -- excluded columns are not represented in the diff_string
    if find_in_delimited_string(p_exclude_columns,';',v_records.column_name) then
      v_skip_column := true;
    else
      v_skip_column := false;
      v_logical_column_id  := v_logical_column_id+1;
      -- create diffstring for this column
      v_diff_str := substr(v_diff_base_string,1,v_logical_column_id-1)||trim(column_position_char(v_records.column_id))||substr(v_diff_base_string,v_logical_column_id+1);

      p_debug(' write '||v_records.column_name||' '||v_diff_str||' ' ||nvl(v_diff_sum(v_logical_column_id),0));
      -- create summary record if there are any differences for this column
      if nvl(v_diff_sum(v_logical_column_id),0) > 0 then
        insert into riskmart.regtest_result(regtest_objects,regtest_datetime,occurance_count,diff_string,MIN_BEISPIEL_PRIMARY_KEY,"DATASOURCE@DATETIME")
        values (v_regtest_objects,v_datetime,nvl(v_diff_sum(v_logical_column_id),0),v_diff_str,v_records.column_name,v_datasource );
      end if;
    end if;
  end loop;
  log_call (
            p_table_owner=>p_table_owner, P_TABLE_NAME=>P_TABLE_NAME,
            p_ref_owner=>p_ref_owner, p_ref_name=>p_ref_name,
            p_primary_key_columns=>p_primary_key_columns,
            p_exclude_columns=>p_exclude_columns,
            p_remap_columns=>p_remap_columns,
            p_remap_ref_columns=>p_remap_ref_columns,
            p_additional_join_clause=>p_additional_join_clause,
            p_filter_condition=>p_filter_condition,
            p_ref_filter_condition=>p_ref_filter_condition,
            p_proc_name=>'RUN_TEST',p_start_date=>v_start_date, p_end_date=>sysdate);
  commit;
end;

procedure show_results
is
begin
for v_rec in (
SELECT to_char(max(rr.REGTEST_DATETIME), 'YYYY.MM.DD HH24:MM:DD') AS last_RegTest,
'SELECT * FROM riskmart.regtest_result WHERE REGTEST_OBJECTS = '''||rr.REGTEST_OBJECTS||''' ORDER BY REGTEST_DATETIME DESC, CASE WHEN DETAIL_STATEMENT IS NULL THEN 1 ELSE 0 END, NLSSORT(DIFF_STRING,''NLS_SORT=BINARY'') --'||trim(to_char(max(rr.REGTEST_DATETIME), 'YYYY.MM.DD HH24:MM:DD')) as report_statement
FROM
riskmart.regtest_result rr
GROUP BY REGTEST_OBJECTS
ORDER BY 2)
loop
dbms_output.put_line(v_rec.report_statement);
end loop;
end;


/* test procedure for the package */
procedure unit_test
is
begin
p('-- Beispielhafter Aufruf von create_test_sql');
create_test_sql( p_table_owner=>'RISKMART',P_TABLE_NAME=>'KK_ANTRAEGE',
                 p_ref_owner=>'RISKMART',p_ref_name=>'KK_ANTRAEGE',
                 p_exclude_columns=>'KANT_GUELTIG_AB;KANT_GUELTIG_BIS;KANT_LAUF_NR;KANT_LAUF_NAME' ,
                 p_primary_key_columns=>'KANT_VGNR;KANT_QUELLE',
                 p_remap_columns=>'',p_additional_join_clause=>' and t1.kant_gueltig_kz = ''J'' and t2.kant_gueltig_kz = ''J'' ',
                 p_filter_condition=>'KANT_GUELTIG_BIS;=to_date(''99991231'',''YYYYMMDD'')', p_ref_filter_condition=>'KANT_GUELTIG_BIS;=to_date(''99991231'',''YYYYMMDD'')');

p('-- Beispielhafter Aufruf von create_compare_sql');
create_compare_sql( p_table_owner=>'RISKMART',P_TABLE_NAME=>'KK_ANTRAEGE',
                                p_ref_owner=>'RISKMART',p_ref_name=>'KK_ANTRAEGE',
                                p_exclude_columns=>'KANT_GUELTIG_AB;KANT_LAUF_NR;KANT_LAUF_NAME' ,
                                p_primary_key_columns=>'KANT_VGNR;KANT_QUELLE',
                                p_remap_columns=>'',p_additional_join_clause=>q'# and t1.kant_gueltig_kz = 'J' and t2.kant_gueltig_kz = 'J' #',
                                p_filter_condition=>q'#KANT_GUELTIG_BIS;=to_date('99991231','YYYYMMDD')#', p_ref_filter_condition=>q'#KANT_GUELTIG_BIS;=to_date('99991231','YYYYMMDD')#');
end;


procedure help
is
begin
p('Procedure Argumente:');
p('  Alle Standardargumente sind vom Datentyp VARCHAR2.');
p('  Semikolon (;) wird in Listen als Seperator benutzt.');
p('  Die Ausgaben (generierten SQL Statements oder Informationen) werden im DBMS_Output ausgegeben.');
p('  ');
P('Notwendige Argumente:');
p('  P_TABLE_OWNER: Schema der Haupttabelle.         P_TABLE_OWNER=>''RISKMART''');
p('  P_TABLE_NAME : Name der Haupttabelle.           P_TABLE_NAME=>''KK_ANTRAEGE''');
p('  P_REF_OWNER  : Schema der Vergleichstabelle.    P_REF_OWNER=>''RISKMART''');
p('  P_REF_TABLE  : Name der Vergleichstabelle       P_REF_TABLE=>''KK_ANTRAEGE_REF''');
p('  P_PRIMARY_KEY_COLUMNS: Liste der Schlüsselspalten in der Haupttabelle. Wird auch als Join-Bedingung benutzt.');
p('                                                  P_PRIMARY_KEY_COLUMNS=>''KANT_VGNR;KANT_QUELLE''');
p(' ');
p('Optionale Argumente:');
p('  P_EXCLUDE_COLUMNS: Liste der Spalten der Haupttabelle, die nicht verglichen werden sollen.');
p('                   z.B.: p_exclude_columns=>''KANT_GUELTIG_AB;KANT_LAUF_NR;KANT_LAUF_NAME;KANT_HASH_VALUE''');
p('                         Der SQL Code für diese exclude-Spalten wird im generierten Statement auskommentiert.');
p('  P_REMAP_COLUMNS: Liste von column name und ersetzendem String für die Haupttabelle.  ');
p('                  Der ersetzende String kann auch ein anderer column name sein, dann wird der Tabellen Alias t1 gegebenenfalls hinzugefügt. ');
p('                  z.B.: P_REMAP_COLUMNS=>''KANT_LAUF_NR;4711;KANT_GUELTIG_AB;KANT_DATUM_GESENDET;KANT_GUELTIG_BIS;NVL(t1.KANT_GUELTIG_BIS,to_date(''''99991231'''',''''YYYYMMDD'''')) '' ');
P('  P_REMAP_REF_COLUMNS: wie P_REMAP_COLUMNS nur für die Vergleichstabelle (alias t2) ');
p('  P_ADDITIONAL_JOIN_CLAUSE: string, der an die join clause für den primary key angehängt werden soll  ');
p('                  z.B.: P_ADDITIONAL_JOIN_CONDITION=>''t1.kant_gueltig_kz=''''J'''' and t2.kant_gueltig_kz=''''J'''' '' ');
p(' Filterbedingungen fuer die zu vergleichenden Mengen, werden in die from  clause eingebaut ');
p('  P_FILTER_CONDITION: Bedingungen fuer die erste Tabelle');
p('  P_REF_FILTER_CONDITION: Bedingungen fuer die zweite Tabelle ');
p('      z.B.: P_FILTER_CONDITION=''kant_gueltig_kz=''''J'''' '',P_REF_FILTER_CONDITION=''kant_gueltig_kz=''''J'''' ''  ');
p(' führt zu : ');
p(' select ... from ( select * from <owner>.<table> where KANT_GUELTIG_KZ = ''J'' ) t1 ');
p(' full outer join ( select * from <ref_owner>.<ref_table> where KANT_GUELTIG_KZ = ''J'' ) t2 on ( ..... ' );
p(' ');
p(' ');
p(' public procedures:');
p(' alle Prozeduren haben die oben aufgelisteten Argumente');
p(' ');
p(' procedure run_test: ruft create_ins_regtest_result_sql auf und führt das erzeugte SQL Statement aus. ');
p(' ');
p(' procedure create_test_sql: generiere SQL zur Erzeugung der Diff Pattern');
p(' ');
P( 'procedure create_compare_sql: erzeuge SQL um einige Datensätze zu einen Differenzen-Pattern auszugeben');
p('       Zusätzliches Argument: P_NULL_IF_IDENTICAL in boolean default true. Regelt ob der Inhalt der identischen columns ausgegeben wird oder nicht (default) ');
p(' ');
p(' procedure create_ins_regtest_result_sql: ruft create_test_Sql auf und ergänzt das erzeugte SQL so dass das Ergebniss in der REGTEST_RESULT Tabelle abgelegt wird ');
p('  ');
p(' procedure unit_test: ruft beispielhaft create_test_sql und create_details_for_pattern_sql für RISKMART KK_ANTRAEGE auf');
p('  ');
p(' prodedure help: gibt diesen Hilfetext aus');
END;
END;
/

