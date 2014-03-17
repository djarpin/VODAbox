-- Summarize sales per day by customer
drop table if exists regression;
create table regression as
select s.customer_id, s.time_id, s.sales,
       c.yearly_income, c.total_children
from (select customer_id, time_id,
             sum(store_sales) as sales
      from sales_fact_1997
      group by customer_id, time_id) s
inner join customer c
on s.customer_id = c.customer_id;
