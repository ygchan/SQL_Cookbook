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
















