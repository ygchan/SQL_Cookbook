-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Configurate MySQL Database
-- export PATH=$PATH:/usr/local/mysql/bin
-- mysql -u Study -p bank

-- Study of common tasks like adding days to date, finding the number of 
-- business day (or how many friday), between dates and finding the 
-- difference between dates in days.

-- 01. Add and subtract days, months, and years
-- Using the hiredate for employee clark to return 6 different dates.
--    D1. 5 days before hiredate
--    D2. 5 days after hiredate
--    D3. 5 months before hiredate
--    D4. 5 months after hiredate
--    D5. 5 years before hiredate
--    D6. 5 years after hiredate

select ename, hiredate
from emp
where deptno = 10;

/* Output:
+--------+------------+
| ename  | hiredate   |
+--------+------------+
| CLARK  | 1981-06-09 |
| KING   | 1981-11-17 |
| MILLER | 1982-01-23 |
+--------+------------+
3 rows in set (0.00 sec)
*/

-- PostgreSQL solution:
select ename, hiredate,
	hiredate - interval '5 day' as hd_minus_5D
from emp
where deptno = 10;

-- MySQL solution, without the quotes
select ename, hiredate,
   hiredate - interval 5 day as hd_minus_5D,
   hiredate + interval 5 day as hd_plus_5D,
   hiredate - interval 5 month as hd_minus_5M,
   hiredate + interval 5 month as hd_plus_5M,
   hiredate - interval 5 year as hd_minus_5Y,
   hiredate + interval 5 year as hd_plus_5Y
from emp
where deptno = 10;

/* Ouput:
+--------+------------+-------------+------------+-------------+------------+-------------+------------+
| ename  | hiredate   | hd_minus_5D | hd_plus_5D | hd_minus_5M | hd_plus_5M | hd_minus_5Y | hd_plus_5Y |
+--------+------------+-------------+------------+-------------+------------+-------------+------------+
| CLARK  | 1981-06-09 | 1981-06-04  | 1981-06-14 | 1981-01-09  | 1981-11-09 | 1976-06-09  | 1986-06-09 |
| KING   | 1981-11-17 | 1981-11-12  | 1981-11-22 | 1981-06-17  | 1982-04-17 | 1976-11-17  | 1986-11-17 |
| MILLER | 1982-01-23 | 1982-01-18  | 1982-01-28 | 1981-08-23  | 1982-06-23 | 1977-01-23  | 1987-01-23 |
+--------+------------+-------------+------------+-------------+------------+-------------+------------+
3 rows in set (0.00 sec)
*/

-- To add/subtract a day/month/year to a date
-- (the variable) -/+ interval (number) (string) as new_column

-- 02. Determining the number of days between two dates
-- Calculate the difference betweeen two dates and represent the result in days

-- hd stands for hire date
select datediff(allen_hd, ward_hd) as difference_in_day
from 
(
select hiredate as ward_hd
from emp
where ename = 'WARD'
) x,
(
select hiredate as allen_hd
from emp
where ename = 'ALLEN'
) y;

/* Output:
+-------------------+
| difference_in_day |
+-------------------+
|                -2 |
+-------------------+
1 row in set (0.00 sec)
*/