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








