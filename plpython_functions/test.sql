-- Script to test each of the PLPython functions in this directory
\o test.log

-- Sample sales data
drop table if exists temp;
create table temp as
select customer_id, product_id, time_id, unit_sales, store_sales
from sales_fact_1997
limit 100;

select *
from temp;


-- Transpose horizontally
drop table if exists temp_transpose;
select transpose('temp', 'temp_transpose', 'horizontally', 'customer_id', 'product_id', 'unit_sales, store_sales');

select *
from temp_transpose;


-- Fill nulls with zeros
drop table if exists temp_zero;
select fill_nulls('temp_transpose', 'temp_zero');

select *
from temp_zero;


-- Transpose back to a long vertical file
drop table if exists temp_reverse;
select transpose('temp_zero', 'temp_reverse', 'vertically', 'customer_id', 'metric', 'value');

select *
from temp_reverse;


-- Cube summary all combinations of 3 variables
drop table if exists temp_cube;
select cube_summary('temp', 'temp_cube', 'customer_id, product_id, time_id', 'sum(unit_sales) as sum_unit_sales, sum(store_sales) as sum_store_sales');

select *
from temp_cube;


-- Fill nulls of cube by variables
drop table if exists temp_cube_all;
select fill_nulls('temp_cube', 'temp_cube_all', 'customer_id, product_id, time_id', 'All');

select *
from temp_cube_all;


-- Add indicator variables
drop table if exists temp_indicators;
select create_indicators('temp', 'temp_indicators', 'customer_id');

select *
from temp_indicators;
