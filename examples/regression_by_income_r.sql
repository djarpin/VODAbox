-- Run a linear regression in R
\o plr_temp.log
\timing

-- Create a PL/R function
drop function regression_r(float8[]) cascade;
create or replace function regression_r(float8[]) returns float8 as
$$
  xyidx <- rep(1:2, length(arg1) / 2)
  y <- arg1[xyidx == 1]
  x <- arg1[xyidx == 2]
  slope <- lm(y ~ x)$coefficients[2]
  return(slope)
$$
language plr;

-- create function for aggregate
create or replace function regression_r_accum(float8[], float8, float8) returns float8[] as
$$
  select case when $1 is null then array[$2, $3] else $1 || $2 || $3 end
$$ language sql;

-- create aggregate
drop aggregate if exists regression_r_agg(float8, float8);
create aggregate regression_r_agg(float8, float8) (
  sfunc = regression_r_accum,
  stype = float8[],
  finalfunc = regression_r
);

-- Call PL/R function by income
select yearly_income,
       regression_r_agg(sales, total_children) as beta
from regression
group by yearly_income
order by yearly_income;
