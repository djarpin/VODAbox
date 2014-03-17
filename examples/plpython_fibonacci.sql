-- Use PL/Python to create a function that calculates a fibonacci sequence value using recursion
\o plpython_fibonacci.log

-- Create PL/Python Fibonacci function
create or replace function python_fib(x integer) returns integer as
$$
def fib(val):
    if val == 0:
        return 0
    elif val == 1:
        return 1
    else:
        return fib(val - 1) + fib(val - 2)
return fib(x)
$$
language plpythonu;

-- Calculate first 10 terms in the fibonacci sequence
select public.python_fib(1);
select public.python_fib(2);
select public.python_fib(3);
select public.python_fib(4);
select public.python_fib(5);
select public.python_fib(6);
select public.python_fib(7);
select public.python_fib(8);
select public.python_fib(9);
select public.python_fib(10);
select public.python_fib(20);
