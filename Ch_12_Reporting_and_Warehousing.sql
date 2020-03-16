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

-- 06. Pivoting result set to faciliate inter-row calculation
-- Get the sum of the department and calculate in-line difference

select 
  sum(case when deptno = 10 then sal else 0 end) as d10_sal,
  sum(case when deptno = 20 then sal else 0 end) as d20_sal,
  sum(case when deptno = 30 then sal else 0 end) as d30_sal
from emp;

/* Output:
+---------+---------+---------+
| d10_sal | d20_sal | d30_sal |
+---------+---------+---------+
|    8750 |   13050 |    9400 |
+---------+---------+---------+
1 row in set (0.00 sec)
*/

-- Then calculate it using inline view

select 
  d20_sal - d10_sal as d20_d10_dif,
  d20_sal - d30_sal as d20_d30_dif
from (
select 
  sum(case when deptno = 10 then sal else 0 end) as d10_sal,
  sum(case when deptno = 20 then sal else 0 end) as d20_sal,
  sum(case when deptno = 30 then sal else 0 end) as d30_sal
from emp
) totals_by_dept;

/* Output:
+-------------+-------------+
| d20_d10_dif | d20_d30_dif |
+-------------+-------------+
|        4300 |        3650 |
+-------------+-------------+
1 row in set (0.02 sec)
*/

-- Discussion: Sum(Case expression) aggerate and create expression base
-- on the columns choices.

-- 07. Creating Bucket of Data of a Fixed Size
-- create buckets of 5 employee each base on employee number.

-- create rank first
select empno, ename,
  (select count(*) 
  from emp a
  where a.empno < e.empno) as rank
from emp e;

/* Output:
+-------+--------+------+
| empno | ename  | rank |
+-------+--------+------+
|  7369 | SMITH  |    0 |
|  7499 | ALLEN  |    1 |
|  7521 | WARD   |    2 |
|  7566 | JONES  |    3 |
|  7654 | MARTIN |    4 |
|  7698 | BLAKE  |    5 |
|  7782 | CLARK  |    6 |
|  7788 | SCOTT  |    7 |
|  7839 | KING   |    8 |
|  7844 | TURNER |    9 |
|  7876 | ADAMS  |   10 |
|  7900 | JAMES  |   11 |
|  7902 | FORD   |   12 |
|  7934 | MILLER |   13 |
+-------+--------+------+
14 rows in set (0.00 sec)
*/

-- each bucket has 0 element
-- div is a function that divide and return int value
select (rank div 5 + 1) as bucket, x.empno, x.ename
from (select 
  empno, ename,
  (select count(*) 
  from emp a
  where a.empno < e.empno) as rank
from emp e
) x 
order by bucket, rank; 

/* Output:
+--------+-------+--------+
| bucket | empno | ename  |
+--------+-------+--------+
|      1 |  7369 | SMITH  |
|      1 |  7499 | ALLEN  |
|      1 |  7521 | WARD   |
|      1 |  7566 | JONES  |
|      1 |  7654 | MARTIN |
|      2 |  7698 | BLAKE  |
|      2 |  7782 | CLARK  |
|      2 |  7788 | SCOTT  |
|      2 |  7839 | KING   |
|      2 |  7844 | TURNER |
|      3 |  7876 | ADAMS  |
|      3 |  7900 | JAMES  |
|      3 |  7902 | FORD   |
|      3 |  7934 | MILLER |
+--------+-------+--------+
14 rows in set (0.00 sec)
*/

-- My solution is pretty close to the book's.
/* Find a small typo in the book on P.389. */

select ceil(rnk/5.0) as bucket,
  empno, ename
from (
  select e.empno, e.ename,
    (select count(*) from emp d
    where d.empno < e.empno)+1 as rnk
  from emp e
) x
order by bucket;

-- 08. Creating a Predeined number of Buckets
-- Please organize your data into fixed number of buckets.
-- You know how many elements, but don't know how many bucket.

select mod(count(*), 4) + 1 as grp,
  e.empno,
  e.ename
from emp e, emp d
where e.empno >= d.empno
group by e.empno, e.ename
order by 1;

/* Output:
+------+-------+--------+
| grp  | empno | ename  |
+------+-------+--------+
|    1 |  7566 | JONES  |
|    1 |  7900 | JAMES  |
|    1 |  7788 | SCOTT  |
|    2 |  7369 | SMITH  |
|    2 |  7839 | KING   |
|    2 |  7654 | MARTIN |
|    2 |  7902 | FORD   |
|    3 |  7499 | ALLEN  |
|    3 |  7844 | TURNER |
|    3 |  7698 | BLAKE  |
|    3 |  7934 | MILLER |
|    4 |  7521 | WARD   |
|    4 |  7876 | ADAMS  |
|    4 |  7782 | CLARK  |
+------+-------+--------+
14 rows in set (0.09 sec)
*/

-- 09. Creating Horizontal Histograms
-- Use SQL to generate histograms that extend horizontally.
-- Display the number of employees in each department as
-- horizontal histograms with each employee represented by *.

select deptno, count(*) as count
from emp
group by deptno;

select deptno,
  case count
    when 1 then '*'
    when 2 then '**'
    when 3 then '***'
    when 4 then '****'
    when 5 then '*****'
    when 6 then '******'
    when 7 then '*******'
    when 8 then '********'
    when 9 then '*********'
    when 10 then '**********'
  end as cnt
from (
  select deptno, count(*) as count
  from emp
  group by deptno
) x;

/* Output: 
+--------+--------+
| deptno | cnt    |
+--------+--------+
|     10 | ***    |
|     20 | *****  |
|     30 | ****** |
+--------+--------+
3 rows in set (0.02 sec)
*/

-- Somewhat close to the book
select deptno,
  lpad('*', count(*), '*') as cnt
from emp
group by deptno;

/* Output:
+--------+--------+
| deptno | cnt    |
+--------+--------+
|     10 | ***    |
|     20 | *****  |
|     30 | ****** |
+--------+--------+
3 rows in set (0.02 sec)
*/

-- 10. Creating Vertical Histograms
-- Generate a histogram that grows from the bottom up.
-- Display the number of employees in each department as a Vertical
-- histogram with each employee represented by an instance of *.

select 
  case when e.deptno = 10 then '*' else null end deptno_10,
  case when e.deptno = 20 then '*' else null end deptno_20,
  case when e.deptno = 30 then '*' else null end deptno_30,
  (select count(*) from emp d
  where e.deptno = d.deptno and e.empno < d.empno) as rank
from emp e;

/* Output:
+-----------+-----------+-----------+------+
| deptno_10 | deptno_20 | deptno_30 | rank |
+-----------+-----------+-----------+------+
| NULL      | *         | NULL      |    4 |
| NULL      | NULL      | *         |    5 |
| NULL      | NULL      | *         |    4 |
| NULL      | *         | NULL      |    3 |
| NULL      | NULL      | *         |    3 |
| NULL      | NULL      | *         |    2 |
| *         | NULL      | NULL      |    2 |
| NULL      | *         | NULL      |    2 |
| *         | NULL      | NULL      |    1 |
| NULL      | NULL      | *         |    1 |
| NULL      | *         | NULL      |    1 |
| NULL      | NULL      | *         |    0 |
| NULL      | *         | NULL      |    0 |
| *         | NULL      | NULL      |    0 |
+-----------+-----------+-----------+------+
14 rows in set (0.04 sec)
*/

select 
  max(deptno_10) as d10,
  max(deptno_20) as d20,
  max(deptno_30) as d30
from (
  select
    case when e.deptno = 10 then '*' else null end deptno_10,
    case when e.deptno = 20 then '*' else null end deptno_20,
    case when e.deptno = 30 then '*' else null end deptno_30,
    (select count(*) from emp d
    where e.deptno = d.deptno and e.empno < d.empno) as rank
  from emp e
) x
group by rank
order by 1 desc, 2 desc, 3 desc;

/* Output:
+------+------+------+
| d10  | d20  | d30  |
+------+------+------+
| *    | *    | *    |
| *    | *    | *    |
| *    | *    | *    |
| NULL | *    | *    |
| NULL | *    | *    |
| NULL | NULL | *    |
+------+------+------+
6 rows in set (0.02 sec)
*/

-- 11. Returning non-group by columns
-- Return columns in your selected list that are not also listed
-- in the group by clause.

select ename, max(sal)
from emp 
group by ename;
