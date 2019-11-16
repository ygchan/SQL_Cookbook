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
