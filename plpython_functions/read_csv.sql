-- Reads in a CSV file and dynamically creates a table
-- Assumes first row of CSV is column names
-- Uses PLPython as a string manipulator but executes pure SQL
-- Takes in the following arguments...
--     csv_file: full filepath for CSV to read in
--     csv_table: schema.tablename for output table
--     (optional) column_types: Try to imput column types (int, numeric, or text) given values in the second row of CSV (defaults to FALSE)
--     (optional) delimiter: delimiter character for CSV file (defaults to comma)
create or replace function read_csv(csv_file text, csv_table text, column_types boolean default false, delimiter text default ',')
returns text as
$$

# Bring in CSV header row
f = open(csv_file, mode='r')
header = [h.strip().lower().replace(' ', '_') for h in f.readline().split(delimiter)]
column_names = {}
for h in header:
    column_names[h] = 'text'

# Try to impute column types
if column_types == True:
    row = f.readline().strip().split(delimiter)
    for i in range(len(header)):
        try:
            int(row[i])
            column_names[header[i]] = 'integer'
        except:
            try:
                float(row[i])
                column_names[header[i]] = 'numeric'
            except:
                pass

# Create table with all of the variables from the header
execute_str = 'create table ' + csv_table + ' (' + header[0] + ' ' + column_names[header[0]]
for h in header[1:]:
    execute_str = execute_str + ', ' + h + ' ' + column_names[h]

# Finish creating table and fill table with CSV values
execute_str = execute_str + ');\ncopy ' + csv_table + " from '" + csv_file + "' delimiter '" + delimiter + "' csv header;"

# Execute SQL and return the code executed for comparison
plpy.execute(execute_str)
return execute_str

$$
language plpythonu;
