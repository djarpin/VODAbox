-- Score other customers
\o segmentation_scoring.log

-- Create training table
drop table if exists segmentation_train;
create table segmentation_train as
select s.cluster_id,
       cast(c.customer_id as int) as id, c.state_province, c.total_children, c.num_children_at_home, c.num_cars_owned,
       c.marital_status, c.houseowner, c.occupation, c.education, c.gender, c.yearly_income
from customer c
inner join (select distinct se.customer_id, cl.cluster_id
            from segmentation se
            inner join segmentation_cluster cl
            on se.row_id = cl.row_id) s
on c.customer_id = s.customer_id;

-- Create scoring table
drop table if exists segmentation_score;
create table segmentation_score as
select 0 as cluster_id,
       cast(c.customer_id as int) as id, c.state_province, c.total_children, c.num_children_at_home, c.num_cars_owned,
       c.marital_status, c.houseowner, c.occupation, c.education, c.gender, c.yearly_income
from customer c
left join (select distinct se.customer_id, cl.cluster_id
           from segmentation se
           inner join segmentation_cluster cl
           on se.row_id = cl.row_id) s
on c.customer_id = s.customer_id
where s.customer_id is null;

-- Estimate random forest
select * 
from madlib.rf_clean('segmentation_rf');
select *
from madlib.rf_train('infogain',
                     'segmentation_train',
                     'segmentation_rf',
                     10,
                     NULL,
                     0.67,
                     'total_children, num_children_at_home, num_cars_owned',
                     'total_children, num_children_at_home, num_cars_owned, state_province, marital_status, houseowner, occupation, education, gender, yearly_income',
                     'id',
                     'cluster_id',
                     'explicit',
                     10,
                     0.0,
                     0.0,
                     0);

-- Predict random forest
drop table if exists segmentation_pred;
select *
from madlib.rf_classify('segmentation_rf',
                        'segmentation_train',
                        'segmentation_pred');

-- Check out sample
select s.*, c.fname, c.lname, c.address1
from segmentation_pred s
inner join customer c
on s.id = c.customer_id
limit 100;
