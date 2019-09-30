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












