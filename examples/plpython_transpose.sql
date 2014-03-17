-- Create a function to transpose long datasets into wide datasets frequenly used for modeling
\o plpython_transpose.log

-- Create PL/Python transpose function
create or replace function transpose(long_table text, wide_table text, by_column text, label_column text, value_column text) 
returns text as
$$
qlist = plpy.execute('select distinct ' + label_column + ' from ' + long_table + ';')
vlist = value_column.split(',')
execute_str = 'create table ' + wide_table + ' as select ' + by_column
for qdict in qlist:
    for qd in qdict:
        q = str(qdict[qd])
        for v in vlist:
            qclean = v.strip() + '_' + q.replace('.', '_').replace(' ', '_')
            execute_str = execute_str + ', max(case when ' + label_column + " = '" + q + "' then " + v + ' else null end) as ' + qclean
execute_str = execute_str + ' from ' + long_table + ' group by ' + by_column + ';'
plpy.execute(execute_str)
return execute_str
$$
language plpythonu;

-- Summarize sales to the store day level
drop table if exists time_store_sales;
create table time_store_sales as
select time_id, store_id,
       sum(store_sales) as sa4st
from sales_fact_1997
group by time_id, store_id;

-- Use transpose function
drop table if exists time_sales;
select transpose('time_store_sales', 'time_sales', 'time_id', 'store_id', 'sa4st');

-- Top 10 rows from transpose table
select *
from time_sales
order by time_id
limit 10;
