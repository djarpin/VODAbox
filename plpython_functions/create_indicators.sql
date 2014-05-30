-- Creates a set of {0, 1} indicator variables for all distinct values of given variable
-- Uses PLPython as a string manipulator but executes pure SQL
-- Takes in the following arguments...
--     input_table: schema.tablename for table with variables that should be turned into indicators
--     indicator_table: schema.tablename for output table with indicator variables
--     value_columns: comma-separated list of columns on input_table whose unique values should be turned into a set of {0, 1} indicator variables
--     (optional) keep_columns: comma-separatted list of columns to copy directly from input_table to indicator_table (defaults to all variables)
create or replace function create_indicators(input_table text, indicator_table text, value_columns text, keep_columns text default '*')
returns text as
$$

execute_str = 'create table ' + indicator_table + ' as select ' + keep_columns

# Separate out list of value columns
value_list = [v.strip() for v in value_columns.split(',')]

# Get distinct values for all value columns and generate many case statements to create individual indicator columns
for v in value_list:
    distinct_values = plpy.execute('select distinct ' + v + ' from ' + input_table + ';')
    for distinct_dict in distinct_values:
        for distinct_value in distinct_dict:
            d = distinct_dict[distinct_value]
            execute_str = execute_str + ', case when ' + v + ' = ' + str(d) + ' then 1 else 0 end as ' + v + '_' + str(d)

execute_str = execute_str + ' from ' + input_table + ';'

# Execute SQL and return the SQL string
plpy.execute(execute_str)
return execute_str

$$
language plpythonu;
