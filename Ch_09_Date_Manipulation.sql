-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Configurate MySQL Database
-- export PATH=$PATH:/usr/local/mysql/bin
-- mysql -u Study -p bank

-- CHAPTER 9: Date Manipulation
-- Let's learn togther how to search and modifying dates.
-- Query involving dates - first of the month, last of the month, last friday
-- etc are very common in order to build reports.

-- 01. Determining if a year is a leap year
-- Please confirm if the current year is a leap year.

/* Step #01. Getting the 12/31 of the previous year */
select date_add(current_date, interval -dayofyear(current_date) day)
from t1;

/* Output:
+---------------------------------------------------------------+
| date_add(current_date, interval -dayofyear(current_date) day) |
+---------------------------------------------------------------+
| 2018-12-31                                                    |
+---------------------------------------------------------------+
1 row in set (0.00 sec)
*/

/* Step #02. Add 1 day to it */
select 
   date_add(
      date_add(current_date, interval -dayofyear(current_date) day),
      interval 1 day
   ) dy -- Shorten the name
from t1;

/* Step #03. Add 1 month to it */
/* Step #04. Get the last day (using last_day) method */
/* Step #05. Get the day of the current day generated */
select year(current_date) year,
   day(
   last_day(
   date_add(
   date_add(
   date_add(current_date, 
      interval -dayofyear(current_date) day),
      interval 1 day),
      interval 1 month))) dy
from t1;

/* Output: 
+------+------+
| year | dy   |
+------+------+
| 2019 |   28 |
+------+------+
1 row in set (0.00 sec)
*/

-- George: We found out that 2019 is not a leap year.

-- In the last example, the author pointed out we should be using x.*
select x.*, case when dy = 28 then 'NOT LEAP YEAR'
            when dy = 29 then 'LEAP YEAR'
            else '' end as Summary
from (
select year(current_date) year,
   day(
   last_day(
   date_add(
   date_add(
   date_add(current_date, 
      interval -dayofyear(current_date) day),
      interval 1 day),
      interval 1 month))) dy
from t1
) x;

/* Output:
+------+------+---------------+
| year | dy   | Summary       |
+------+------+---------------+
| 2019 |   28 | NOT LEAP YEAR |
+------+------+---------------+
1 row in set (0.00 sec)
*/

-- 02. Determining the number of days in the year
-- I would like to find out how many days there are in current year!

-- I have an idea, let's try to get first of this year, and then calculate
-- the difference between end of this year and first of this year.

select date_add(current_date, interval -dayofyear(current_date)+1 day) dy
from t1;

/* Output:
+------------+
| dy         |
+------------+
| 2019-01-01 |
+------------+
1 row in set (0.00 sec)
*/

/* Including the very last day, off by 1 otherwise */
select x.*, datediff(EndOfYear, FirstOfYear)+1 NumOfDay
from (
select date_add(current_date, 
                interval -dayofyear(current_date)+1 day) as FirstOfYear,
       date_add(
       date_add(current_date,
                interval 1 year),
                interval -dayofyear(current_date)-1 day) as EndOfYear
from t1
) x ; 

/* Output:
+-------------+------------+----------+
| FirstOfYear | EndOfYear  | NumOfDay |
+-------------+------------+----------+
| 2019-01-01  | 2019-12-31 |      365 |
+-------------+------------+----------+
1 row in set (0.00 sec)
*/

-- 03. Extracting the units of a time from a date

select date_format(current_timestamp, '%k') hr,
       date_format(current_timestamp, '%i') min,
       date_format(current_timestamp, '%s') sec,
       date_format(current_timestamp, '%d') dy,
       date_format(current_timestamp, '%m') mon,
       date_format(current_timestamp, '%Y') yr
from t1;

/* Output:
+------+------+------+------+------+------+
| hr   | min  | sec  | dy   | mon  | yr   |
+------+------+------+------+------+------+
| 21   | 10   | 10   | 14   | 11   | 2019 |
+------+------+------+------+------+------+
1 row in set (0.01 sec)
*/