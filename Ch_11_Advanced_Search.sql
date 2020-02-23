-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Configurate MySQL Database
-- export PATH=$PATH:/usr/local/mysql/bin
-- mysql -u Study -p bank

-- CHAPTER 11: Advanced Searching
-- The most basic kind of query are the types with where clauses and
-- grouping techniques to search out and return the results you need.
-- But there are other type of queries where you paginating through.
-- Reading a number of record at each time.

-- 01. Paginating through a result set
-- You want to paginate or scroll through 5 records at a time.
-- There is button on the front each, your SQL statement need to fetch 5 rows
-- at a time, and then the next 5 and so forth.

-- In MySQL and PostgreSQL
-- This is particularly easy.

select sal
from emp
order by sal limit 5 offset 0;

/* Output:
+------+
| sal  |
+------+
|  950 |
|  960 |
| 1250 |
| 1250 |
| 1300 |
+------+
5 rows in set (0.05 sec)
*/

-- To select the next 5

select sal
from emp
order by sal limit 5 offset 5;

-- limit x offset y << This is easy to read and easy to write!
-- Offset clause will start at that row 0 (being first)
-- Limit clause will restricts the number of rows returned.

-- 02. Skipping n rows from a table
-- Return every other emlpoyee in the table.


-- First step, create row numbers using MySQL
-- count how many employee names are less than the current

select a.ename, (select count(*) from emp b
                 where b.ename <= a.ename) as rownum
from emp a
order by a.ename;

/* Output:
+--------+--------+
| ename  | rownum |
+--------+--------+
| ADAMS  |      1 |
| ALLEN  |      2 |
| BLAKE  |      3 |
| CLARK  |      4 |
| FORD   |      5 |
| JAMES  |      6 |
| JONES  |      7 |
| KING   |      8 |
| MARTIN |      9 |
| MILLER |     10 |
| SCOTT  |     11 |
| SMITH  |     12 |
| TURNER |     13 |
| WARD   |     14 |
+--------+--------+
14 rows in set (0.00 sec)
*/

-- Then the next step is mod rownum by 2 with remainder = 1
-- Since we are starting at 1
-- mod(1, 2) = 1
-- mod(2, 2) = 0 
-- etc

select x.ename, x.rownum
from (
select a.ename, (select count(*) from emp b
               where a.ename <= b.ename) as rownum
from emp a
) x
where mod(x.rownum, 2) = 1
order by x.rownum;

/* Output:
+--------+--------+
| ename  | rownum |
+--------+--------+
| WARD   |      1 |
| SMITH  |      3 |
| MILLER |      5 |
| KING   |      7 |
| JAMES  |      9 |
| CLARK  |     11 |
| ALLEN  |     13 |
+--------+--------+
7 rows in set (0.00 sec)
*/

-- 03. Incorporating or logic when using an outer joins
-- You want to return the name and department information for all
-- employees in the department 10 and 20 along with department information
-- 30 and 40. But for 30 and 40 you don't need emlpoyee information.

select e.ename, d.deptno, d.dname, d.loc
from dept d left join emp e 
   on (d.deptno = e.deptno
      and (e.deptno = 10 or e.deptno = 20))
order by 2;

/* Output:
+--------+--------+------------+----------+
| ename  | deptno | dname      | loc      |
+--------+--------+------------+----------+
| MILLER |     10 | ACCOUNTING | NEW YORK |
| CLARK  |     10 | ACCOUNTING | NEW YORK |
| KING   |     10 | ACCOUNTING | NEW YORK |
| SMITH  |     20 | RESEARCH   | DALLAS   |
| FORD   |     20 | RESEARCH   | DALLAS   |
| JONES  |     20 | RESEARCH   | DALLAS   |
| SCOTT  |     20 | RESEARCH   | DALLAS   |
| ADAMS  |     20 | RESEARCH   | DALLAS   |
| NULL   |     30 | SALES      | CHICAGO  |
| NULL   |     40 | OPERATIONS | BOSTON   |
+--------+--------+------------+----------+
10 rows in set (0.01 sec)
*/

/* Kind of interesting, I didn't thought about using an or here */

-- Alternatively, you can filter on inline view << -- see line 149-151
-- and then use an outer left join

select e.ename, d.deptno, d.dname, d.loc
from dept d left join (
   select ename, deptno
   from emp
   where deptno in (10, 20)
) e on (e.deptno = d.deptno)
order by 2;

/* Output:
+--------+--------+------------+----------+
| ename  | deptno | dname      | loc      |
+--------+--------+------------+----------+
| CLARK  |     10 | ACCOUNTING | NEW YORK |
| KING   |     10 | ACCOUNTING | NEW YORK |
| MILLER |     10 | ACCOUNTING | NEW YORK |
| SMITH  |     20 | RESEARCH   | DALLAS   |
| JONES  |     20 | RESEARCH   | DALLAS   |
| SCOTT  |     20 | RESEARCH   | DALLAS   |
| ADAMS  |     20 | RESEARCH   | DALLAS   |
| FORD   |     20 | RESEARCH   | DALLAS   |
| NULL   |     30 | SALES      | CHICAGO  |
| NULL   |     40 | OPERATIONS | BOSTON   |
+--------+--------+------------+----------+
10 rows in set (0.00 sec)
*/

-- 04. Filling in missing values in a range of values
-- Return the number of employees hired each year for the entire decade of 
-- a certain time, but there are some years with no employee hired.
-- Please fill in the blank when they are 0.

-- Start: Use T10 as a pivot table, because it has 10 rows.
-- Use the build in function extract to generate one row for each year
-- since 1980 (or whever it started).
-- Then use an outer join (left join) to get the count.

-- Happy Thanks Giving! :)
-- Back from Vacation ! :)

select y.yr, coalesce(x.cnt, 0) as cnt
from (
select min_year-mod(cast(min_year as int), 10)+rn as yr
from (
select (select min(extract(year from hiredate))
    from emp) as min_year,
    id-1 as rn
from t10) a
) y
left join (select extract(year from hiredate) as yr, count(*) as cnt
from emp
group by extract(year from hiredate)
) x
on (y.yr = x.yr);

-- 05. Selecting the Top n records
-- Limit a result set to a specific number of recrods based on
-- ranking of some sort. For example: return the names and salaries of 
-- of the employees with top 5 salaries.

select ename, sal, rnk
from (
select (
	select count(distinct b.sal)
	from emp b
	where a.sal <= b.sal
) as rnk,
a.sal,
a.ename
from emp a
) x
where rnk <= 5
order by rnk;

/* Output:
+-------+------+------+
| ename | sal  | rank |
+-------+------+------+
| KING  | 5000 |    1 |
| FORD  | 3600 |    3 |
| SCOTT | 3600 |    3 |
| JONES | 3570 |    4 |
| BLAKE | 2850 |    5 |
+-------+------+------+
5 rows in set (0.00 sec)
*/

-- Discussion: First use scalar subquery to determine what is the rank
-- Then that table will be filtered for the top 5 ranked salary.
