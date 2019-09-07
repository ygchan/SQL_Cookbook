-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Chapter 02: Sorting Query Results

-- Why do we sort the result set?
-- By understanding how you can control and modify your result sets
-- you can provide more readable and meaningful data.

-- 01. Returning results in a specific order
-- Problem: Sort the data by salary (from lowest to highest)

select ename, job, sal
from emp
where deptno = 10
order by sal asc;

-- Discussion: There are 2 type, ascending (asc) or descending (desc)
-- You can also specify the number representing the column.

select ename, job, sal
from emp
where deptno = 10
order by 3 desc;

/* Output:
+--------+-----------+------+
| ename  | job       | sal  |
+--------+-----------+------+
| KING   | PRESIDENT | 5000 |
| CLARK  | MANAGER   | 2450 |
| MILLER | CLERK     | 1300 |
+--------+-----------+------+
3 rows in set (0.00 sec)
*/

-- 02. Sort by multiple fields
-- Problem: Sort by department number ascending and then salary descending

select empno, deptno, ename, job
from emp
order by deptno, sal desc;

-- Discussion: You are generally allowed to sort by columns not selected.
-- But you must reference the column by (name), and you are not follow 
-- to group by items not selected.

-- 03. Sorting by substrings
-- Problem: Sort by the last 2 characters in the job field

select ename, job, substr(job, length(job)-1)
from emp
order by substr(job, length(job)-1);

/* Output:
+--------+-----------+----------------------------+
| ename  | job       | substr(job, length(job)-1) |
+--------+-----------+----------------------------+
| TURNER | SALESMAN  | AN                         |
| ALLEN  | SALESMAN  | AN                         |
| WARD   | SALESMAN  | AN                         |
| MARTIN | SALESMAN  | AN                         |
| CLARK  | MANAGER   | ER                         |
| BLAKE  | MANAGER   | ER                         |
| JONES  | MANAGER   | ER                         |
| KING   | PRESIDENT | NT                         |
| JAMES  | CLERK     | RK                         |
| SMITH  | CLERK     | RK                         |
| ADAMS  | CLERK     | RK                         |
| MILLER | CLERK     | RK                         |
| FORD   | ANALYST   | ST                         |
| SCOTT  | ANALYST   | ST                         |
+--------+-----------+----------------------------+
14 rows in set (0.01 sec)
*/

-- 04. Sorting Mixed Alphanumeric Data
-- Problem: You have a mixed alphanumeric data and want to sort by either
-- the numeric or character portion of the data.

-- MySQL doesn't have this implementation solution
-- But it is using replace / translate in Oracle.

-- 05. Dealing with Nulls when sorting
-- Problem: You are dealing with column with null values, you
-- might to sort null first (to the top), or sort null last (to the bottom)

/* Non-null commission sorted ascending, all nulls last */
select ename, sal, comm, is_null
from (
    select ename, sal, comm,
        case when comm is null then 0 else 1 end as is_null
    from emp
) x
order by is_null desc, comm;

SET ANSI_WARNINGS ON;

/* Output:
+--------+------+------+---------+
| ename  | sal  | comm | is_null |
+--------+------+------+---------+
| TURNER | 1500 |    0 |       1 |
| ALLEN  | 1600 |  300 |       1 |
| WARD   | 1250 |  500 |       1 |
| MARTIN | 1250 | 1400 |       1 |
| SMITH  |  800 | NULL |       0 |
| KING   | 5000 | NULL |       0 |
| ADAMS  | 1100 | NULL |       0 |
| JONES  | 2975 | NULL |       0 |
| JAMES  |  950 | NULL |       0 |
| FORD   | 3000 | NULL |       0 |
| BLAKE  | 2850 | NULL |       0 |
| MILLER | 1300 | NULL |       0 |
| CLARK  | 2450 | NULL |       0 |
| SCOTT  | 3000 | NULL |       0 |
+--------+------+------+---------+
14 rows in set (0.00 sec)
*/

-- Discussion: Calculate an is_null field within the inline view,
-- then sort it (but don't bring it into the select). This is a great example
-- of order by a column that is not selected.
-- With this case (when) else end as, all happened in one line.

-- 06. Sorting on data dependent key (!!!)
-- Problem: You want to sort by conditional logic.
-- For example, if job title = sales man, sort by commission
--              if job title = other    , sort by salary.

select job, ename, sal, comm
from emp
order by case when job = 'SALESMAN' then comm else sal end;

/* Output:
+-----------+--------+------+------+
| job       | ename  | sal  | comm |
+-----------+--------+------+------+
| SALESMAN  | TURNER | 1500 |    0 |
| SALESMAN  | ALLEN  | 1600 |  300 |
| SALESMAN  | WARD   | 1250 |  500 |
| CLERK     | SMITH  |  800 | NULL |
| CLERK     | JAMES  |  950 | NULL |
| CLERK     | ADAMS  | 1100 | NULL |
| CLERK     | MILLER | 1300 | NULL |
| SALESMAN  | MARTIN | 1250 | 1400 |
| MANAGER   | CLARK  | 2450 | NULL |
| MANAGER   | BLAKE  | 2850 | NULL |
| MANAGER   | JONES  | 2975 | NULL |
| ANALYST   | FORD   | 3000 | NULL |
| ANALYST   | SCOTT  | 3000 | NULL |
| PRESIDENT | KING   | 5000 | NULL |
+-----------+--------+------+------+
14 rows in set (0.00 sec)
*/

-- This is extremely interesting, I have never done this.
-- I wonder if this can be used in SAS at work??
-- Use a CASE expression in the order by clause.

-- Or another way, this is more easy to understand.
-- But a little bit less efficient (sorting extra column).
select ename, sal, job, comm,
    case when job = 'SALESMAN' then comm else sal end as ordered
from emp
order by 5;

/* Output:
+--------+------+-----------+------+---------+
| ename  | sal  | job       | comm | ordered |
+--------+------+-----------+------+---------+
| TURNER | 1500 | SALESMAN  |    0 |       0 |
| ALLEN  | 1600 | SALESMAN  |  300 |     300 |
| WARD   | 1250 | SALESMAN  |  500 |     500 |
| SMITH  |  800 | CLERK     | NULL |     800 |
| JAMES  |  950 | CLERK     | NULL |     950 |
| ADAMS  | 1100 | CLERK     | NULL |    1100 |
| MILLER | 1300 | CLERK     | NULL |    1300 |
| MARTIN | 1250 | SALESMAN  | 1400 |    1400 |
| CLARK  | 2450 | MANAGER   | NULL |    2450 |
| BLAKE  | 2850 | MANAGER   | NULL |    2850 |
| JONES  | 2975 | MANAGER   | NULL |    2975 |
| FORD   | 3000 | ANALYST   | NULL |    3000 |
| SCOTT  | 3000 | ANALYST   | NULL |    3000 |
| KING   | 5000 | PRESIDENT | NULL |    5000 |
+--------+------+-----------+------+---------+
14 rows in set (0.00 sec)
*/