-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Chapter 01: Retrieving Records

-- Setup the database
CREATE TABLE EMP
       (EMPNO integer NOT NULL,
        ENAME VARCHAR(10),
        JOB VARCHAR(9),
        MGR integer,
        HIREDATE DATE,
        SAL integer,
        COMM integer,
        DEPTNO integer);

INSERT INTO EMP VALUES
        (7369, 'SMITH',  'CLERK',     7902,
        '1980-12-17',  800, NULL, 20);
INSERT INTO EMP VALUES
        (7499, 'ALLEN',  'SALESMAN',  7698,
        '1981-2-20', 1600,  300, 30);
INSERT INTO EMP VALUES
        (7521, 'WARD',   'SALESMAN',  7698,
        '1981-2-22', 1250,  500, 30);
INSERT INTO EMP VALUES
        (7566, 'JONES',  'MANAGER',   7839,
        '1981-4-2',  2975, NULL, 20);
INSERT INTO EMP VALUES
        (7654, 'MARTIN', 'SALESMAN',  7698,
        '1981-9-28', 1250, 1400, 30);
INSERT INTO EMP VALUES
        (7698, 'BLAKE',  'MANAGER',   7839,
        '1981-5-1',  2850, NULL, 30);
INSERT INTO EMP VALUES
        (7782, 'CLARK',  'MANAGER',   7839,
        '1981-6-9',  2450, NULL, 10);
INSERT INTO EMP VALUES
        (7788, 'SCOTT',  'ANALYST',   7566,
        '1982-12-9', 3000, NULL, 20);
INSERT INTO EMP VALUES
        (7839, 'KING',   'PRESIDENT', NULL,
        '1981-11-17', 5000, NULL, 10);
INSERT INTO EMP VALUES
        (7844, 'TURNER', 'SALESMAN',  7698,
        '1981-9-8',  1500,    0, 30);
INSERT INTO EMP VALUES
        (7876, 'ADAMS',  'CLERK',     7788,
        '1983-1-12', 1100, NULL, 20);
INSERT INTO EMP VALUES
        (7900, 'JAMES',  'CLERK',     7698,
        '1981-12-3',   950, NULL, 30);
INSERT INTO EMP VALUES
        (7902, 'FORD',   'ANALYST',   7566,
        '1981-12-3',  3000, NULL, 20);
INSERT INTO EMP VALUES
        (7934, 'MILLER', 'CLERK',     7782,
        '1982-1-23', 1300, NULL, 10);

CREATE TABLE DEPT
       (DEPTNO integer,
        DNAME VARCHAR(14),
        LOC VARCHAR(13) );

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');

-- 01. You have a table and want to see all the data out of it
-- Problem: Select all the columns and all the rows
select *
from emp;

-- Discussion: the special character * has a special meaning in SQL.
-- The '*' character select every columns of the table.
-- Because we do not have a where clause in this statement, we will be
-- selecting every rows as well. Author noted, it is better to write out each
-- columns that you are selecting, because then for anyone else who is not 
-- familiar with what are the columns avaiable, they will know what columns
-- your query is selecting.

-- 02. Retrieving a subset of rows from a table.
-- Problem: Select rows that met a certain condition
select *
from emp
where deptno = 10;

-- Discussion: the where clause allow you to retrieve only rows you are 
-- interested in. If the expression in the where clause is true for any rows, 
-- then that row is returned.

-- You can also use operators such as: =, !=, >, >=, <, <=
-- Along with condition operators such as: and, or, not (!)

/* Output:
+-------+--------+-----------+------+------------+------+------+--------+
| EMPNO | ENAME  | JOB       | MGR  | HIREDATE   | SAL  | COMM | DEPTNO |
+-------+--------+-----------+------+------------+------+------+--------+
|  7782 | CLARK  | MANAGER   | 7839 | 1981-06-09 | 2450 | NULL |     10 |
|  7839 | KING   | PRESIDENT | NULL | 1981-11-17 | 5000 | NULL |     10 |
|  7934 | MILLER | CLERK     | 7782 | 1982-01-23 | 1300 | NULL |     10 |
+-------+--------+-----------+------+------------+------+------+--------+
3 rows in set (0.01 sec)
*/

-- 03. Finding rows that satisfy multiple conditions
-- Problem: Select rows that met multiple conditions
select *
from emp
where deptno = 10
   or comm is not null
   or (sal <= 2000 and deptno = 20);

-- Parenthese affect greatly how the condition is evaluated.
-- Think about how different the query will be for this
select *
from emp
where (deptno = 10 
   or comm is not null
   or sal <= 2000
   ) and deptno = 20



























