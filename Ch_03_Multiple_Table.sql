-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Chapter 03: Working with multiple tables

-- 01: Stacking one data rowset atop another
select ename as ename_and_dname, deptno
from emp
where deptno = 10
union all
select '--------', '--------'
union all
select dname, deptno
from dept;

/* Output:
+-----------------+----------+
| ename_and_dname | deptno   |
+-----------------+----------+
| CLARK           | 10       |
| KING            | 10       |
| MILLER          | 10       |
| --------        | -------- |
| ACCOUNTING      | 10       |
| RESEARCH        | 20       |
| SALES           | 30       |
| OPERATIONS      | 40       |
+-----------------+----------+
8 rows in set (0.00 sec)
*/

-- Important Note: Union all will include duplicates if they exits
-- Union will filter out any duplicates.

-- Union is the same as select distinct.
-- If you know in advance there are no duplicates, then please use union all
-- for faster performance.

-- Source: c-sharpcorner.com
-- https://bit.ly/2k4Owzj

select deptno
from emp
union
select deptno
from emp;

-- This will remove any duplicates, I wonder how is SQL implemented in the back
-- Specifying union will most likely result in a sort operation in order to
-- eliminate duplicates. The query about is roughly equivalent to the following

select distinct 
from (
   select deptno
   from emp
   union all
   select deptno
   from emp
);

-- 02. Combining related rows
-- Problem: Get the data from multiple tables, display the name of all the
-- employees in department 10 along with the location of each employee's dept

select e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno
   and e.deptno = 10;

/* Output:
+--------+----------+
| ename  | loc      |
+--------+----------+
| CLARK  | NEW YORK |
| KING   | NEW YORK |
| MILLER | NEW YORK |
+--------+----------+
3 rows in set (0.01 sec)
*/

-- Conceptually, the result set from a join is produced by first creating a
-- cartesian product (all possible combinations), and restrict the result
-- that matches the where expression.

-- equi-join: the join condition is based on an equality condition.
-- Use the join clause if you prefer to have the join logic in from clause
-- rather than the where clause.

-- 03. Finding rows in common between 2 tables
-- Problem: Another example of inner join

create view v as
select ename, job, sal
from emp
where job = 'CLERK';

select e.empno, e.ename, e.job, e.sal, e.deptno
from emp e 
   inner join v on (
      e.ename = v.ename
      and e.job = v.job
      and e.sal = v.sal
   )
;

/* Output:
+-------+--------+-------+------+--------+
| empno | ename  | job   | sal  | deptno |
+-------+--------+-------+------+--------+
|  7369 | SMITH  | CLERK |  800 |     20 |
|  7876 | ADAMS  | CLERK | 1100 |     20 |
|  7900 | JAMES  | CLERK |  950 |     30 |
|  7934 | MILLER | CLERK | 1300 |     10 |
+-------+--------+-------+------+--------+
4 rows in set (0.02 sec)
*/

-- 04. Retrieving values from one table that do not exist in another
-- Problem: Using not in () expression in where clause

-- Note: In DB2 you use set operation (except)
--       In Oracle you use set operation (minus)

-- This is MySQL solution
select deptno 
from dept
where deptno not in (select deptno from emp);

/* Output:
+--------+
| deptno |
+--------+
|     40 |
+--------+
1 row in set (0.01 sec)
*/

/*
(base) Georges-MacBook-Air:~ Study$ export PATH=$PATH:/usr/local/mysql/bin
(base) Georges-MacBook-Air:~ Study$ mysql -u Study -p bank
*/

select deptno
from dept
where deptno in (10, 50, null);

/* Output:
+--------+
| deptno |
+--------+
|     10 |
+--------+
1 row in set (0.01 sec)
*/

-- Note that the following Truth table:
-- T OR NULL  --> NULL
-- NOT (NULL) --> NULL
-- AND (NULL) --> NULL

-- You must keep this in mind in SQL, True or Null is True, but False or Null
-- is Null. You must keep this in mind when using in predicates and when 
-- performing logical or evaluation.

-- To avoid this problem with not in and nulls. Please use a coorelated 
-- subquery in conjunction with not exists. 

select d.deptno
from dept d
where not exists (
   select 1
   from emp e
   where d.deptno = e.deptno
);

/* Output:
+--------+
| deptno |
+--------+
|     40 |
+--------+
1 row in set (0.01 sec)
*/

-- 05. Retrieving rows from one table that do not correspond to rows in another
-- Problem: equi-join only returns condition satisfy, but what if you want to
-- get only items that are not match?

select d.*
from dept d 
   left outer join emp e on (d.deptno = e.deptno)
where e.deptno is null;

/* Output:
+--------+------------+--------+
| DEPTNO | DNAME      | LOC    |
+--------+------------+--------+
|     40 | OPERATIONS | BOSTON |
+--------+------------+--------+
1 row in set (0.02 sec)
*/

-- Discussion: This is the case you want to do a left outer join, and filter
-- or display result only with a null value on the e.deptno column. In other 
-- words, keeping the results with no match.

-- 06. Adding joins to a query without interfering with other join
-- Problem: Return additional results if and only if they are avaiable.

select e.ename, d.loc, eb.received
from emp e
   inner join dept d on (e.deptno = d.deptno)
   left join emp_bonus eb on (e.empno = eb.empno)
order by 2;

-- Discussion: Using left join allows you to show all the employee 
-- with any matched employee bonus received data.

-- 07. Determining whether two table have the same data
-- Problem: You want to know if 2 tables/views have the same data

-- Solution: Use a correlated subquery and union all to find the rows
-- in view V and not in table EMP combined with the rows in the table
-- EMP and not in view V.

select *
from (
   select e.empno, e.ename, e.job, e.mgr, e.hiredate,
          e.sal, e.comm, e.deptno, count(*) as cnt 
   from emp e
   /* .... */
)

-- 08. Identifying and avoiding cartesian products
-- You want the name of each employee in department 10 along
-- with the location of the department.

select e.ename, d.loc
from emp e, detp d
where e.deptno = 10;

-- This has no join and returned a cartesian product!
-- Correct answer is with a join. Because there was no filter
-- all the rows are returned and multiplied.

select e.ename, d.loc
from emp e, dept d
where e.deptno = 10
   and d.deptno = e.deptno;

/* Output:
+--------+----------+
| ename  | loc      |
+--------+----------+
| CLARK  | NEW YORK |
| KING   | NEW YORK |
| MILLER | NEW YORK |
+--------+----------+
3 rows in set (0.02 sec)
*/

-- Discussion: Apply the n-1 rule (represent) the number of minimum number
-- of joins necessary to avoid a Cartesian product. Interestingly if you use
-- the cartesian product properly, it can be used to transpose or pivot.
-- or mimicking a loop.

-- 09. Performing joins when using aggregates
-- Problem: You need to join multiple tables, but also ensure the join
-- do not distrupt the aggregation.

-- Use distinct inside the sum() function
select deptno,
   sum(distinct sal) as total_sal,
   sum(bonus) as total_bonus
from (
   e.empno,
   e.ename,
   e.sal,
   e.deptno,
   e.sal * case when eb.type = 1 then .1
                when eb.type = 2 then .2
                else .3
           end as bonus
   from emp e
      inner join emp_bonus eb
   where e.deptno = 10 
) x /* Inline view */
group by deptno;

-- 10. Performing outer join when using aggregates
-- Problem: You need to use left outer join. Because the problem has changed
-- to where not all employee in department 10 have been given bonus.

select deptno,
       sum(distinct sal) as total_sal,
       sum(bons) as total_bonus
  from (
select e.empno,
       e.ename,
       e.departno,
       e.sal * case when eb.type is null then 0
                    when eb.type = 1 then .1
                    when eb.type = 2 then .2
                    else .3 end as bonus
  from emp e left outer join emp_bonus eb
    on (e.empno = eb.empno)
  where e.deptno = 10
    )
  group by deptno;

-- Discussion : I noticed the author has an neat style of indentation...
-- it is adding extra spaces to line up the selected columns.
-- and within the inline view table, the select also started within the block
-- this has a benefit of not running out of spaces when nesting.
-- I wonder if this can be applied to the working projects.






