-- Transposes table horizontally (long to wide) or vertically (wide to long)
-- Uses PLPython as a string manipulator but executes pure SQL
-- Takes in the following arguments...
--     input_table: schema.tablename of input table
--     transpose_table: schema.tablename of output table
--     transpose_type: how table should be transposed (accepts values 'horizontally' or 'vertically')
--     by_columns: comma separated list of columns to keep as by groups when transposing
--     label_column: for 'horizontally' input_table column name whose values will suffix column names on transpose_table
--                   for 'vertically' text string which will be the column name on transpose_table that holds the column names from input_table as values
--     value_column: for 'horizontally' comma separated list of column names on input_table whose values will be transposed
--                   for 'vertically' text string which will be the column name on transpose_table that holds the values from input_table
create or replace function transpose(input_table text, transpose_table text, transpose_type text, by_column text, label_column text, value_column text)
returns text as
$$

# Transpose table horizontally
if transpose_type.lower()[0] == 'h':

    # Get list of columns whose values should be transposed
    value_list = [v.strip() for v in value_column.split(',')]

    # Get distinct suffixes for the transposed variables
    q_list = plpy.execute('select distinct ' + label_column + ' from ' + input_table + ';')

    # Loop through value columns one at a time and takes max(case when ) based on label column
    execute_str = 'create table ' + transpose_table + ' as select ' + by_column
    for q_dict in q_list:
        for q_d in q_dict:
            q = str(q_dict[q_d])
            for v in value_list:
                q_clean = v.strip() + '_' + q.replace('.', '_').replace(' ', '_')
                execute_str = execute_str + ', max(case when ' + label_column + " = '" + q + "' then " + v + ' else null end) as ' + q_clean
    execute_str = execute_str + ' from ' + input_table + ' group by ' + by_column + ';'

# Or transpose table vertically
if transpose_type.lower()[0] == 'v':

    # Check if user specified schema and if not assume public is the schema
    if '.' in input_table:
        schema, table = input_table.split('.')
    else:
        schema = 'public'
        table = input_table

    # Get list of columns on input table
    col_list = plpy.execute("select column_name from information_schema.columns where table_schema = '" + schema + "' and table_name = '" + table + "';")

    # Loop through columns and add them to unnest statements
    execute_str = 'create table ' + transpose_table + ' as select ' + by_column
    label_str = ', unnest(array['
    value_str = ', unnest(cast(array['
    first_col = True
    for col_dict in col_list:
        for col_d in col_dict:
            col = col_dict[col_d]
            if col not in by_column:
                if first_col:
                    label_str = label_str + "'" + col + "'"
                    value_str = value_str + col
                    first_col = False
                else:
                    label_str = label_str + ", '" + col + "'"
                    value_str = value_str + ', ' + col
    execute_str = execute_str + label_str + ']) as ' + label_column + value_str + '] as text[])) as ' + value_column + ' from ' + input_table + ';'

# Execute code and return text of SQL command
plpy.execute(execute_str)
return execute_str

$$
language plpythonu;
