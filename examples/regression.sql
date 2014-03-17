-- Use MADlib to run a simple linear regression
\o regression.log
\x

-- run regression
drop table if exists regression_coef;
drop table if exists regression_coef_summary;
select madlib.linregr_train('regression',
                            'regression_coef',
                            'sales',
                            'array[1, total_children]');

-- look at output
select *
from regression_coef;
