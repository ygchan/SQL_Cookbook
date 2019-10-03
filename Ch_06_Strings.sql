-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Chapter 06: Working with strings
-- Chapter 06 focuses on string manipulation in SQL. Interestingly author 
-- already stated on the second line, that SQL is not designed to perform
-- complex string manipulation. It makes me wonder if company XYZ is using
-- Java and Python for data processing? (Extract and Transformation).

-- The first and most important fundamental operation: traverse a string
-- one character at a time. (SQL does not have a loop).

-- 01. Walking a string
-- Problem: Traverse a string to return each character as a row.

/* where to download the code */

CREATE TABLE T10 (ID INTEGER);
INSERT INTO T10 VALUES (1);
INSERT INTO T10 VALUES (2);
INSERT INTO T10 VALUES (3);
INSERT INTO T10 VALUES (4);
INSERT INTO T10 VALUES (5);
INSERT INTO T10 VALUES (6);
INSERT INTO T10 VALUES (7);
INSERT INTO T10 VALUES (8);
INSERT INTO T10 VALUES (9);
INSERT INTO T10 VALUES (10);

select substr(e.ename, iter.pos, 1) as c, iter.pos
from (select ename from emp where ename = 'KING') e,
     (select id as pos from t10) iter
where iter.pos <= length(e.ename);

/* Output: 
+------+------+
| c    | pos  |
+------+------+
| K    |    1 |
| I    |    2 |
| N    |    3 |
| G    |    4 |
+------+------+
4 rows in set (0.01 sec)
*/

-- Discussion: Use a cartesian product to generate the number of rows need
-- to return each character of string on its own line.

-- George: First you need to create a t(traverse) table using simple create
-- table statement and insert statement. Then you will use the old ascii join
-- format. Where condition ensure you don't have additional "empty/blank" rows.
-- See there is iter.pos <= length(e.ename). Then the substring method selected
-- that character corresponding to the pos.

-- This is what it looks like without the filer and substr method
select ename, iter.pos
from (select ename from emp where ename = 'KING') e,
     (select id as pos from t10) iter;

/* Output: 
+-------+------+
| ename | pos  |
+-------+------+
| KING  |    1 |
| KING  |    2 |
| KING  |    3 |
| KING  |    4 |
| KING  |    5 |
| KING  |    6 |
| KING  |    7 |
| KING  |    8 |
| KING  |    9 |
| KING  |   10 |
+-------+------+
10 rows in set (0.07 sec)
*/

-- The cartesian product is 10 rows, this is the first step.
-- It is common practice to refer table t10 as pivot table.

-- Step two: limit the outcome to only the length of the word
select ename, iter.pos
from (select ename from emp where ename = 'KING') e,
     (select id as pos from t10) iter
where iter.pos <= length(e.ename); 
/* Instead of hardcode, it find out the length here (4) */

/* Output: 
+-------+------+
| ename | pos  |
+-------+------+
| KING  |    1 |
| KING  |    2 |
| KING  |    3 |
| KING  |    4 |
+-------+------+
4 rows in set (0.02 sec)
*/

-- Another variation
select substr(e.ename, iter.pos) a
       -- This show a different out come, G, NG, ING and KING
       substr(e.ename, length(e.ename)-iter.pos+1) b
from (select ename from emp where ename = 'KING') e,
     (select id pos from t10) tier
where iter.pos <= length(e.ename);

-- TSQL
-- Table creation logic
CREATE TABLE testtable ([col1] [int] NOT NULL primary key,
                        [col2] [int] NULL,
                        [col3] [int] NULL,
                        [col4] [varchar](50) NULL);
                        
-- Populate table
DECLARE @val INT
SELECT @val=1
WHILE @val <= 200000
BEGIN  
   INSERT INTO testtable (col1, col2, col3, col4) 
       VALUES (@val,@val % 10,@val,'TEST' + CAST(@val AS VARCHAR))
   SELECT @val=@val+1
END
GO

SELECT * FROM [testtable] WHERE [col3]=11493
GO
-- End of TSQL

-- 02. Embedding Quotes within string literals
-- Problem: You want to embed quote marks within strings
-- like 'g'day mate'

-- Solution: You need to use two quotes to "escape" one.

select 'apple core', 'apple''s core',
       case when '' is null then 0 else 1 end
from t1;

/* Output:
+------------+--------------+----------------------------------------+
| apple core | apple's core | case when '' is null then 0 else 1 end |
+------------+--------------+----------------------------------------+
| apple core | apple's core |                                      1 |
+------------+--------------+----------------------------------------+
*/

-- Discussion: keep in mind that string literal comprising two quotes
-- alone, with no intervening character is null.

-- 03. Counting the occurrences of a character in a string
-- Problem: You want to count the number of times a character (comma)
-- occured within a given string.

set @my_string = '10,clark,manager';

/*
mysql> set @my_string = '10,clark,manager';
Query OK, 0 rows affected (0.01 sec)

mysql> select @my_string;
+------------------+
| @my_string       |
+------------------+
| 10,clark,manager |
+------------------+
1 row in set (0.01 sec)
*/

select (length(@my_string)-
        length(replace(@my_string, ',', '')))/length(',')
       as cnt
from t1;

/* Output:
+--------+
| cnt    |
+--------+
| 2.0000 |
+--------+
1 row in set (0.00 sec)
*/

/* Quickly creating t1 */
create table t1(
  id int
);
insert into t1(id) values(1);

-- Discussion: It works by
-- Finding the length of the word - 
--         the length of the word replaced the search symbol with nothing
-- And repeate it that many times (t1)

-- 04. Removing unwanted characters from a string.
-- Problem: Remove all the voews and zeros

select 
  ename,
  replace(
  replace(
  replace(
  replace(
  replace(ename, 'A', ''), 'E', ''), 'I', ''), 'O', ''), 'U', '') as stripped1,
  sal,
  replace(sal, 0, '') as stripped2
from EMP;  

-- Translate in other vendor are easier to use. SAS has compress.

-- 05. Separate numeric and character data
-- This solution is not avaliable on MySQL.

-- PostgreSQL solution
select replace(
  translate(data, '0123456789', '0000000000'), '0', ''
  ) as name,
  cast(
  replace(
  translate(lower(data), 'abcd..xyz')), rpad('z', 26, 'z')
  as integer) as sal
from (
  select ename||sal as data
  from emp
) x






