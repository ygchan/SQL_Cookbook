-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Configurate MySQL Database
-- export PATH=$PATH:/usr/local/mysql/bin
-- mysql -u Study -p bank

-- CHAPTER 12. Reporting and Warehousing
-- The queries that will be helpful for creating reports. They usually
-- involves reporting specific formatting with different level of aggregation.
-- Another focus is on transposing / pivoting result sets, converting rows
-- into columns. Pivoting is extremely important topic.

-- 01. Pivoting result set into one row

select deptno, count(1) as count
from emp
group by deptno;

/* Output:
+--------+-------+
| deptno | count |
+--------+-------+
|     10 |     3 |
|     20 |     5 |
|     30 |     6 |
+--------+-------+
3 rows in set (0.00 sec)
*/

/* George's attempt - I have seen this problem before
and practiced with Sally too. */
select 
	sum(case when deptno = 10 then count
	else 0 end) as deptno_10,
	sum(case when deptno = 20 then count
	else 0 end) as deptno_20,
	sum(case when deptno = 30 then count
	else 0 end) as deptno_30
from (
	select deptno, count(1) as count
	from emp
	group by deptno
) x;

-- Solution is actually again simplier (4 lines vs. 12 lines)
-- Transpose the result set using a case expression and the aggregate
-- function sum base on deptno.
select 
  sum(case when deptno = 10 then 1 else 0 end) as deptno_10,
  sum(case when deptno = 20 then 1 else 0 end) as deptno_20,
  sum(case when deptno = 30 then 1 else 0 end) as deptno_30
from emp;

/* Output:
+-----------+-----------+-----------+
| deptno_10 | deptno_20 | deptno_30 |
+-----------+-----------+-----------+
|         3 |         5 |         6 |
+-----------+-----------+-----------+
1 row in set (0.00 sec)
*/

-- Discussion: First you have to use case expression to separate the rows
-- into rows columns. Then sum the count of occurrence of each deptno.
-- Since you want one row, you will not use group by and deptno.

-- Another solution is to use inline view
-- Please use max aggerate function.
select 
  max(case when deptno = 10 then count else null end) as deptno_10,
  max(case when deptno = 20 then count else null end) as deptno_20,
  max(case when deptno = 30 then count else null end) as deptno_30
from (
select deptno, count(1) as count
from emp p
group by deptno
) x;

-- 02. Pivoting Result set into multiple rows
-- Turning rows into columns, with one row having one value.

-- step 1: grouping each job and employee name
select e.job,
	e.ename,
	(select count(*) from emp d
	where e.job = d.job and e.empno < d.empno) as rank
from emp e;

/* Output:
+-----------+--------+------+
| job       | ename  | rank |
+-----------+--------+------+
| CLERK     | SMITH  |    3 |
| SALESMAN  | ALLEN  |    3 |
| SALESMAN  | WARD   |    2 |
| MANAGER   | JONES  |    2 |
| SALESMAN  | MARTIN |    1 |
| MANAGER   | BLAKE  |    1 |
| MANAGER   | CLARK  |    0 |
| ANALYST   | SCOTT  |    1 |
| PRESIDENT | KING   |    0 |
| SALESMAN  | TURNER |    0 |
| CLERK     | ADAMS  |    2 |
| CLERK     | JAMES  |    1 |
| ANALYST   | FORD   |    0 |
| CLERK     | MILLER |    0 |
+-----------+--------+------+
*/

-- step 2: pivot the table using result set (case expression)
-- and the aggregate function max while grouping the values.

select 
	max(case when job = 'CLERK' then ename end) as CLERK,
  max(case when job = 'SALESMAN' then ename end) as SALESMAN,
  max(case when job = 'MANAGER' then ename end) as MANAGER,
  max(case when job = 'ANALYST' then ename end) as ANALYST
from (
select e.job,
	e.ename,
	(select count(*) from emp d
	where e.job = d.job and e.empno < d.empno) as rank
from emp e
) x
group by rank;

/* Output:
+--------+----------+---------+---------+
| CLERK  | SALESMAN | MANAGER | ANALYST |
+--------+----------+---------+---------+
| MILLER | TURNER   | CLARK   | FORD    |
| JAMES  | MARTIN   | BLAKE   | SCOTT   |
| ADAMS  | WARD     | JONES   | NULL    |
| SMITH  | ALLEN    | NULL    | NULL    |
+--------+----------+---------+---------+
4 rows in set (0.00 sec)
*/

-- Using the previous solution does not work, because you want the data
-- returned in multiple rows. First you need to group by the job and employee
-- name, assign a rank so you can group the scalar subquery.

-- Repeat: Use a scalar subquery to rank each employee by Empno, pivot the
-- result set using case expression and the aggregate function max while 
-- grouping on the value returned by the scalary subquery.

-- Important thing: George you forgot to put end at the case statement
-- a few times, it created a syntax error that is not easy to CATCH!
-- remember to GROUP BY RANK if you don't want a lot of gaps.

-- Create combination and rank
-- Use case expression and max/min aggerate function
-- Group by rank to remove duplicate

/* Pracitce */
-- step 1: create a combination of job, ename with rank
select job, ename,
  /* subquery to get rank or rownumber */
  (select count(*) from emp s
  where s.job = e.job and s.empno < e.empno) as rank
from emp e;

-- step 2: pivot using case expression and max aggerate function.
select 
  max(case when x.job = 'CLERK' then x.ename end) as CLERK,
  max(case when x.job = 'SALESMAN' then x.ename end) as SALESMAN,
  max(case when x.job = 'MANAGER' then x.ename end) as MANAGER,
  max(case when x.job = 'ANALYST' then x.ename end) as ANALYST
from (
  select job, ename,
    (select count(*) from emp s
    where s.job = e.job and s.empno < e.empno) as rank
  from emp e
) x
group by rank;

-- 03. Reverse pivoting result set
-- You want to transfrom columns to rows.

-- Given this please transpose it back.
/* Output:
+-----------+-----------+-----------+
| deptno_10 | deptno_20 | deptno_30 |
+-----------+-----------+-----------+
|         3 |         5 |         6 |
+-----------+-----------+-----------+
1 row in set (0.00 sec)
*/

/* First attemp: */
select '10' as deptno,
  deptno_10 as counts_by_dept
from x
union all
select '20' as deptno,
  deptno_20 as counts_by_dept
from x
union all
select '30' as deptno,
  deptno_30 as counts_by_dept
from x;

-- Feedback: eh... not really correct?
-- Solution: using cartesian product.

select d.deptno,
  -- without using case expression, you will get multiple rows
  case d.deptno
    when 10 then e.deptno_10
    when 20 then e.deptno_20
    when 30 then e.deptno_30 
  end as counts_by_dept
from 
  -- cartesian product
  (
  select 
    sum(case when deptno=10 then 1 else 0 end) as deptno_10,
    sum(case when deptno=20 then 1 else 0 end) as deptno_20,
    sum(case when deptno=30 then 1 else 0 end) as deptno_30
  from emp
  ) e,
  (select distinct deptno 
  from emp
  where deptno <= 30) d;

/* Output:
+--------+----------------+
| deptno | counts_by_dept |
+--------+----------------+
|     20 |              5 |
|     30 |              6 |
|     10 |              3 |
+--------+----------------+
3 rows in set (0.00 sec)
*/

-- Using cartesian product to convert columns to rows.
-- But you must know in advance how many columns you want to convert to rows.
-- Becuase it must have a cardinality of at least the number of columns
-- you want to transpose.

-- Discussion: We used inline view for the "wide" table, or denormalized table.
-- Using a cartesian product allows you to return a row for each column.

/* Remember do not put 

from 
  (select 
  sum(case when deptno = 10 then 1 else 0 end) as deptno_10,
  sum(case when deptno = 20 then 1 else 0 end) as deptno_20,
  sum(case when deptno = 30 then 1 else 0 end) as deptno_30
  from emp e
  ) c,
  (select distinct deptno
  from emp
  where deptno <= 30
  ) d;

when it is open like that, MySQL will throw all kind of errors.
*/ 

-- 04: Is Skipped as not implemented in MySQL and PostgreSQL.
-- 05: Suppressing Repeating Values from result set

-- Create a rank first
select 
  case rank
  when 0 then x.deptno
  else ''
  end as DEPT,
  ename
from (
select deptno, ename,
  (select count(*) from emp s
  where s.deptno = e.deptno and s.empno < e.empno) as rank
from emp e
order by deptno, ename
) x
order by deptno, rank;

/* Output:
+------+--------+
| DEPT | ename  |
+------+--------+
| 10   | CLARK  |
|      | KING   |
|      | MILLER |
| 20   | SMITH  |
|      | JONES  |
|      | SCOTT  |
|      | ADAMS  |
|      | FORD   |
| 30   | ALLEN  |
|      | WARD   |
|      | MARTIN |
|      | BLAKE  |
|      | TURNER |
|      | JAMES  |
+------+--------+
14 rows in set (0.00 sec)
*/

-- Discussion: The author did not provide MySQL solution.
-- But I think this will work fine. Author has taught me really well...
-- I am not sure I could have it done without him showing me all the examples.










