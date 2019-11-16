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