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

-- 06. Finding records with the highest and lowest values
-- IE: JAMES and KING

/* Output:
+--------+------+------+
| ename  | sal  | rank |
+--------+------+------+
| SMITH  |  960 |    2 |
| ALLEN  | 1600 |    7 |
| WARD   | 1250 |    3 |
| JONES  | 3570 |   10 |
| MARTIN | 1250 |    3 |
| BLAKE  | 2850 |    9 |
| CLARK  | 2450 |    8 |
| SCOTT  | 3600 |   11 |
| KING   | 5000 |   12 |
| TURNER | 1500 |    6 |
| ADAMS  | 1320 |    5 |
| JAMES  |  950 |    1 |
| FORD   | 3600 |   11 |
| MILLER | 1300 |    4 |
+--------+------+------+
*/

select *
from emp
where sal in ((select min(sal) from emp),
              (select max(sal) from emp));

/* Output:
+-------+-------+-----------+------+------------+------+------+--------+
| EMPNO | ENAME | JOB       | MGR  | HIREDATE   | SAL  | COMM | DEPTNO |
+-------+-------+-----------+------+------------+------+------+--------+
|  7839 | KING  | PRESIDENT | NULL | 1981-11-17 | 5000 | NULL |     10 |
|  7900 | JAMES | CLERK     | 7698 | 1981-12-03 |  950 | NULL |     30 |
+-------+-------+-----------+------+------------+------+------+--------+
*/

-- Discussion: I realized after the fact, we do not need to have rank to
-- find out what is the employee records with the min and max value.
-- Simple select min/max with sal will be enough.

-- 07. Investiagating future rows

-- Sandbox attempt... Do not work.
select *, 
  (select count(distinct hiredate)
  from emp a 
  where a.hiredate <= b.hiredate) as rank,
  case 
    when b.sal <= (select sal from emp c 
                   where c.rank = b.rank + 1)
    end as "Y" as less
from emp b;

-- Sandbox attemp #2.... Multiple table
create table temp_emp as 
select b.*,
  (select min(hiredate)
   from emp a
   where a.hiredate > b.hiredate) next_hiredate
from emp b;

select a.*
from temp_emp a
  inner join temp_emp b on a.hiredate = b.next_hiredate
where a.sal <= b.sal;

-- Solution from book
select ename, sal, hiredate
from (
  select a.ename, a.sal, a.hiredate,
    (select min(hiredate) from emp b
    where b.hiredate > a.hiredate
    and b.sal > a.sal) as next_sal_grtr,
    (select min(hiredate) from emp b
    where b.hiredate > a.hiredate) as next_hire
  from emp a
  ) x
where next_sal_grtr = next_hire;

/* Output:
+--------+------+------------+
| ename  | sal  | hiredate   |
+--------+------+------------+
| SMITH  |  960 | 1980-12-17 |
| WARD   | 1250 | 1981-02-22 |
| MARTIN | 1250 | 1981-09-28 |
| JAMES  |  950 | 1981-12-03 |
| MILLER | 1300 | 1982-01-23 |
+--------+------+------------+
*/

-- Discussion: You want to find the first hiredate after this employee
-- And then find the next hiredate where the salary is also higher
-- Join them (next_hire and next_hire_grt_sal)
-- The result is exactly what you are looking for. 
-- Comment: This is really smart... I never seen this before.
-- Practiced again with the concept at 5:41PM at home.

-- 08. Shifting Row Values
-- Return each employee's name and salary along with the next highest and 
-- lowest salaries.

select ename, sal,
  coalesce((select max(sal) from emp x
  where x.sal < a.sal), "MIN") as forward,
  coalesce((select min(sal) from emp x
  where x.sal > a.sal), "MAX") as backward
from emp a
order by a.sal;

/* Output:
+--------+------+---------+----------+
| ename  | sal  | forward | backward |
+--------+------+---------+----------+
| JAMES  |  950 | MIN     | 960      |
| SMITH  |  960 | 950     | 1250     |
| WARD   | 1250 | 960     | 1300     |
| MARTIN | 1250 | 960     | 1300     |
| MILLER | 1300 | 1250    | 1320     |
| ADAMS  | 1320 | 1300    | 1500     |
| TURNER | 1500 | 1320    | 1600     |
| ALLEN  | 1600 | 1500    | 2450     |
| CLARK  | 2450 | 1600    | 2850     |
| BLAKE  | 2850 | 2450    | 3570     |
| JONES  | 3570 | 2850    | 3600     |
| FORD   | 3600 | 3570    | 5000     |
| SCOTT  | 3600 | 3570    | 5000     |
| KING   | 5000 | 3600    | MAX      |
+--------+------+---------+----------+
14 rows in set (0.01 sec)
*/

-- Small change base on the book solution:
select ename, sal,
  coalesce(
    (select min(sal) from emp x where x.sal > a.sal),
    (select min(sal) from emp x)) as forward,
  coalesce(
    (select max(sal) from emp x where x.sal < a.sal),
    (select max(sal) from emp x)) as backward
from emp a
order by a.sal;

-- 09. Ranking Result (Classic Interview Problem)
select
  /* Scalar Subquery to get the rank */
  (select count(distinct sal) 
  from emp a where a.sal <= b.sal) as rank, sal
from emp b
order by rank;

/* Output:
+------+------+
| rank | sal  |
+------+------+
|    1 |  950 |
|    2 |  960 |
|    3 | 1250 |
|    3 | 1250 |
|    4 | 1300 |
|    5 | 1320 |
|    6 | 1500 |
|    7 | 1600 |
|    8 | 2450 |
|    9 | 2850 |
|   10 | 3570 |
|   11 | 3600 |
|   11 | 3600 |
|   12 | 5000 |
+------+------+
14 rows in set (0.00 sec)
*/

-- Discussion: This is the same as DENSE_RANK_OVER() in Oracle.

-- 10. Supressing Duplicates
-- This is the easiest thing to do in MySQL, but author has another suggestion.

-- Any additional columns will affect (allow for duplicate job)
select distinct job
from emp;

-- This is another way, not sure if performance will be any siginficance.
select job
from emp
group by job;