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













