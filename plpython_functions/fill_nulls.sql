-- Replace all nulls in a table with a specified value
-- Uses PLPython as a string manipulator but executes pure SQL
-- Takes in the following arguments...
--     null_table: schema.tablename for input table
--     fill_table: schema.tablename for output table
--     fill_value: what value should replace nulls (defaults to 0)
create or replace function fill_nulls(null_table text, fill_table text, fill_value text default '0')
returns text as
$$

# Check if schema was specified with input table otherwise assume public
if '.' in null_table:
    schema, table = null_table.split('.')
else:
    schema = 'public'
    table = null_table

# Get list of all columns on the input table
col_list = plpy.execute("select column_name from information_schema.columns where table_schema = '" + schema + "' and table_name = '" + table + "';")

# Simple select statement coalescing every variable with the fill value
execute_str = 'create table ' + fill_table + ' as select '
first_col = True
for col_dict in col_list:
    for col_d in col_dict:
        col = col_dict[col_d]
        if first_col:
            execute_str = execute_str + 'coalesce(' + col + ', ' + fill_value + ') as ' + col
            first_col = False
        else:
            execute_str = execute_str + ', coalesce(' + col + ', ' + fill_value + ') as ' + col
execute_str = execute_str + ' from ' + null_table + ';'

# Execute SQL and return the code executed for comparison
plpy.execute(execute_str)
return execute_str

$$
language plpythonu;
