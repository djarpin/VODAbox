-- Create table segmentation procedure
\o segmentation_table.log

-- Summarize by customer and product category
-- Odd ranking is necessary to create IDs for principal component analysis
drop table if exists segmentation;
create table segmentation as
with cust_prod as
(select customer_id, product_class_id,
        sum(s.store_sales) as sales
 from sales_fact_1997 s
 inner join product p
 on s.product_id = p.product_id
 group by s.customer_id, p.product_class_id)
select cp.customer_id, cp.product_class_id,
       cast(dc.row_id - 1 as int) as row_id,
       cast(dp.col_id - 1 as int) as col_id,
       cast(log(cp.sales + 1) as float) as log_sales
from cust_prod cp
inner join (select customer_id,
                   rank() over (order by customer_id) as row_id
            from (select distinct customer_id
                  from cust_prod) dcu) dc
on cp.customer_id = dc.customer_id
inner join (select product_class_id,
                   rank() over (order by product_class_id) as col_id
            from (select distinct product_class_id
                  from cust_prod) dpu) dp
on cp.product_class_id = dp.product_class_id
order by row_id, col_id;

-- get number of rows and columns for matrix if it were not sparse
select max(row_id) + 1 as number_of_rows,
       max(col_id) + 1 as number_of_columns
from segmentation;
