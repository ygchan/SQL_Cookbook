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














