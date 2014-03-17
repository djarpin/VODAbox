-- Showcase MADlib's fast count distinct
\timing
\o fast_count_distinct.log

-- Benchmark
\echo 'Benchmark query timing ='
select class, 
       count(distinct value) as distinct_value
from fast_count_distinct
group by class;

-- Flajolet Martin algorithm
\echo 'Flajolet Martin query timing ='
select class, 
       madlib.fmsketch_dcount(value) as approx_distinct_value
from fast_count_distinct
group by class;
