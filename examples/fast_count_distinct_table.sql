-- Create temporary table
drop table if exists fast_count_distinct;
create table fast_count_distinct
(class text, value int);
insert into fast_count_distinct select 'A', 1 from generate_series(1, 300000);
insert into fast_count_distinct select 'A', 2 from generate_series(1, 350000);
insert into fast_count_distinct select 'A', 3 from generate_series(1, 300000);
insert into fast_count_distinct select 'A', 4 from generate_series(1, 300000);
insert into fast_count_distinct select 'A', 5 from generate_series(1, 350000);
insert into fast_count_distinct select 'A', 6 from generate_series(1, 300000);
insert into fast_count_distinct select 'A', 7 from generate_series(1, 300000);
insert into fast_count_distinct select 'A', 8 from generate_series(1, 350000);
insert into fast_count_distinct select 'A', 9 from generate_series(1, 300000);
insert into fast_count_distinct select 'B', 1 from generate_series(1, 1000000);
insert into fast_count_distinct select 'B', 2 from generate_series(1, 500000);
