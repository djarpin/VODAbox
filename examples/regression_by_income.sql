-- Use MADlib to run a regression for each income
\o regression_by_income.log
\x

-- run regression
drop table if exists regression_coef_income;
drop table if exists regression_coef_income_summary;
select madlib.linregr_train('regression',
                            'regression_coef_income',
                            'sales',
                            'array[1, total_children]',
                            'yearly_income');

-- look at output
select *
from regression_coef_income;
