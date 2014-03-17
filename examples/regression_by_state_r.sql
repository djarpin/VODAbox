-- Run a linear regression in R
\o regression_by_income_r.log
\timing

-- Create a PL/R function
create or replace function regression_r(float8, float8) returns float8 as
$body$
  slope <- NA
  y <- farg1
  x <- farg2 
  slope <- lm(y ~ x)$coefficients[2]
  return(slope)
$body$
language plr window;

-- Call PL/R function by income
select distinct yearly_income, 
       regression_r(sales, total_children) over (partition by yearly_income) as beta
from regression
order by yearly_income;
