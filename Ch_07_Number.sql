-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Common operations with numbers, such as numeric computations.
-- Think about use of aggregate functions and the group by clause.

-- 01. Computing an average
-- Please compute the average salary for all employees
-- and average salary for each department.

-- Average salary for all employees
select avg(sal) avg_sal
from emp;

/* Output:
mysql> select avg(sal) from emp;
+-----------+
| avg_sal   |
+-----------+
| 2228.5714 |
+-----------+
1 row in set (0.02 sec)
*/

-- Average salary for each department
select deptno, avg(sal) as avg_sal
from emp
group by deptno;

/* Output:
+--------+-----------+
| deptno | avg_sal   |
+--------+-----------+
|     10 | 2916.6667 |
|     20 | 2610.0000 |
|     30 | 1566.6667 |
+--------+-----------+
3 rows in set (0.00 sec)
*/

-- Discussion: It is important to note that the function avg ignores nulls
create table t2(sal integer);
insert into t2 values (10);
insert into t2 values (20);
insert into t2 values (null);

select avg(sal) from t2;
select distinct 30/2 from t2;

-- they both equal to t2. So the take away point is: avg() function will 
-- ignore null values and only consider 2 values in t2 sample table.

-- Author provided a tip to use coalesce function to handle this situation
-- for example, if you want to count missing value into average.
-- Then you would do avg(coalesec(sal, 0)).

select avg(coalesce(sal, 0)) avg_sal from t2;

/* Output:
+---------+
| avg_sal |
+---------+
| 10.0000 |
+---------+
1 row in set (0.00 sec)
*/

-- Finally, it is not a requirement to put deptno in your groupby.
-- But it is a requirement (or strong recommendation) to NOT put columns in
-- your select if they are not in groupby, calculations are excluded.

-- 02. Finding the min/max value in a column
-- Please find the highest and lowest values in a given column. Such as 
-- highest and lowest salary for all employees.

-- Solution: Simply use the min() and max() function respectively
select min(sal) as min_sal, max(sal) as max_sal
from emp;

/* Output:
+---------+---------+
| min_sal | max_sal |
+---------+---------+
|     950 |    5000 |
+---------+---------+
1 row in set (0.06 sec)
*/

-- When you want to get min and max for each department. You can use the 
-- groupby clause.

select deptno, min(sal) as min_sal, max(sal) as max_sal
from emp
group by deptno;

/* Output:
+--------+---------+---------+
| deptno | min_sal | max_sal |
+--------+---------+---------+
|     10 |    1300 |    5000 |
|     20 |     960 |    3600 |
|     30 |     950 |    2850 |
+--------+---------+---------+
3 rows in set (0.01 sec)
*/

-- Also as a reminder, the min/max ignores null value. If you have a min/max
-- that from a table with null values. Please replace the null with 0 first.
-- Otherwise it will returns a null as the min value.

select deptno, comm
from emp
where deptno in (10, 30)
order by 1;

/* Output:
+--------+------+
| deptno | comm |
+--------+------+
|     10 | NULL |
|     10 | NULL |
|     10 | NULL |
|     30 |  300 |
|     30 |  500 |
|     30 | 1400 |
|     30 | NULL |
|     30 |    0 |
|     30 | NULL |
+--------+------+
9 rows in set (0.01 sec)
*/

select deptno, min(comm), max(comm)
from emp
group by deptno;

/* Ouput:
+--------+-----------+-----------+
| deptno | min(comm) | max(comm) |
+--------+-----------+-----------+
|     10 |      NULL |      NULL |
|     20 |      NULL |      NULL |
|     30 |         0 |      1400 |
+--------+-----------+-----------+
3 rows in set (0.00 sec)
*/

-- 03. Summing the values in a column
-- Please compute the sum of all values, such as all employee salaries.

select sum(sal)
from emp;

-- If you need to sum by department, simply use groupby deptno.

select deptno, sum(sal) as total_for_dept
from emp
group by deptno;
                    
-- 04. Counting rows in a Table
-- Please write a SQL query to count the number of rows in a table

select count(*)
from emp;

-- Or counting by department number
select deptno, count(*) as count_num
from emp
group by deptno;

-- 05. Counting Values in a Column
-- Please count the number of non-Null values in a columns

select count(comm)
from emp;

-- When you count star, you are counting rows (regardless of values).
-- Count(*) returns number of rows cotaining null and non-null values.
-- But when you count (column), you are counting how many rows that are NOT nulls.  
          
-- 06. Generating a running total
-- Please write a SQL query to calculate the running total

select e.ename, e.sal,
   (select sum(d.sal) from emp d
    where d.empno <= e.empno) as running_total
from emp e
order by 3;

/* Output: 
+--------+------+---------------+
| ename  | sal  | running_total |
+--------+------+---------------+
| SMITH  |  960 |           960 |
| ALLEN  | 1600 |          2560 |
| WARD   | 1250 |          3810 |
| JONES  | 3570 |          7380 |
| MARTIN | 1250 |          8630 |
| BLAKE  | 2850 |         11480 |
| CLARK  | 2450 |         13930 |
| SCOTT  | 3600 |         17530 |
| KING   | 5000 |         22530 |
| TURNER | 1500 |         24030 |
| ADAMS  | 1320 |         25350 |
| JAMES  |  950 |         26300 |
| FORD   | 3600 |         29900 |
| MILLER | 1300 |         31200 |
+--------+------+---------------+
14 rows in set (0.01 sec)
*/

-- The solution requires you to use the scalar subquery to compute a running total.
-- Please note this only works if each of the emp is distinctive.
-- Because less than or equal join condition will otherwise duplicates. 

-- Scalar subquery: joining one column and returning one row.
-- This has been reviewed multiple times.
-- https://docs.actian.com/actianx/11.1/index.html#page/SQLRef/Scalar_Subqueries.htm

-- 07. Generating a Running Product
-- Compute a running product on a numeric column.

select e.ename, e.sal,
   (select round(exp(sum(ln(d.sal)))) from emp d
    where d.empno <= e.empno
      and e.deptno = d.deptno) as running_product
from emp e
where e.deptno = 10;

/* Output:
+--------+------+-----------------+
| ename  | sal  | running_product |
+--------+------+-----------------+
| CLARK  | 2450 |            2450 |
| KING   | 5000 |        12250000 |
| MILLER | 1300 |     15925000000 |
+--------+------+-----------------+
3 rows in set (0.01 sec)
*/

-- Discussion: exp() - base of natural logarithm number
--             sum() - calculate the total value
--              ln() - natural logarithm

-- To calculate the running product in MySQL,
-- Please sum the natural logarithm, and then take the base of ln.

-- 08. Calculate a running difference
-- Compute a running difference on values in a numeric column.

select a.empno, a.ename, a.sal,
   (select case when a.empno = min(b.empno) then sum(b.sal)
                else sum(-b.sal) 
         end
    from emp b
    where b.empno <= a.empno
      and b.deptno = a.deptno) as rnk
from emp a
where a.deptno = 10;

/* Output:
+-------+--------+------+--------+
| empno | ename  | sal  | rnk    |
+-------+--------+------+--------+
|  7369 | SMITH  |  960 |    960 |
|  7499 | ALLEN  | 1600 |   1600 |
|  7521 | WARD   | 1250 |  -2850 |
|  7566 | JONES  | 3570 |  -4530 |
|  7654 | MARTIN | 1250 |  -4100 |
|  7698 | BLAKE  | 2850 |  -6950 |
|  7782 | CLARK  | 2450 |   2450 |
|  7788 | SCOTT  | 3600 |  -8130 |
|  7839 | KING   | 5000 |  -7450 |
|  7844 | TURNER | 1500 |  -8450 |
|  7876 | ADAMS  | 1320 |  -9450 |
|  7900 | JAMES  |  950 |  -9400 |
|  7902 | FORD   | 3600 | -13050 |
|  7934 | MILLER | 1300 |  -8750 |
+-------+--------+------+--------+
14 rows in set (0.01 sec)
*/

-- Discussion: The main difference is sum vs. sum of difference,
-- you would return the values as negative with the exception of the first.

-- case if min(b.empno) << this is the first value then sum(b.sal)
-- else sum(-b.sal). I did not know you can multiple negative by adding just -.

-- 09. Calculating a Mode.
-- Mode is the element that appears most frequently for a given set of data.
-- Please find the mode of the salaries in the deptno 20.

select sal
from emp
where deptno = 20
order by sal;

/* Output:
+------+
| sal  |
+------+
|  960 |
| 1320 |
| 3570 |
| 3600 |
| 3600 |
+------+
5 rows in set (0.00 sec)
*/

-- The output of mode should be $3600.

-- George's attempt, what if there are two modes...
-- This probably do not work well.
select sal, count(*) as count
from emp
where deptno = 20
group by sal
order by count(*) desc
limit 1;

-- Book's answer
select sal
from emp
where deptno = 20
group by sal
having count(*) >= all (
select count(*) as count
from emp
where deptno = 20
group by sal
);

/* Output: 
+------+
| sal  |
+------+
| 3600 |
+------+
1 row in set (0.00 sec)
*/

-- Discussion: The subquery returns the number of times each sal
-- occurs. The outer query returns any sal that a number generates
-- greater than or equal to all. In other words, it returns the most
-- common salary count for department number 20.

-- Note in DB2 and SQL server: dense_Rank()over(order by ctn desc) as rank.

-- 10. Calculating a Median.
-- Median is the value of the middle number for a set of ordered elements.

-- Solution: Use a self-join.
select avg(sal)
from (
select e.sal
from emp e, emp d
where e.deptno = d.deptno
   and e.deptno = 20
group by e.sal
having sum(case when e.sal = d.sal then 1 else 0 end)
   >= abs(sum(sign(e.sal - d.sal)))
);

)