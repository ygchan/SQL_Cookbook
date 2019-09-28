-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Meta data, find information about a given schema.
-- Such as what tables are there and which foreignt keys are not indexed
-- You may answer all of these question by writing query against metadata.

-- The book assume there is a schema called SMEAGOL.

-- 01. Listing table in a schema
-- Problem: You want to see a list of all tables you have created.

select table_name
from information_schema.tables
where table_schema = 'bank';

/* Output:
+------------------------+
| table_name             |
+------------------------+
| DEPT                   |
| EMP                    |
| account                |
| branch                 |
| branch_avil_balance_vw |
| business               |
| business_customer_vw   |
| claims                 |
| customer               |
| customer_totals        |
| customer_totals_vw     |
| customer_vw            |
| department             |
| dept_2                 |
| emloyee_vw             |
| employee               |
| employee_org_chart_vw  |
| employee_vw            |
| individual             |
| number_tbl             |
| officer                |
| product                |
| product_type           |
| some_transcation       |
| string_tbl             |
| transaction            |
| vw_customer            |
+------------------------+
29 rows in set (0.01 sec)
*/

-- Information schema, a set of views defined by ISO SQL standard

-- 02. Listing a table's columns
-- Problem: You want to list the columns in a table, along with their data
-- types and positions in the table they are in.

select column_name, data_type, ordinal_position
from information_schema.columns
where table_schema = 'bank'
	and table_name = 'emp';

/* Output:
+-------------+-----------+------------------+
| column_name | data_type | ordinal_position |
+-------------+-----------+------------------+
| EMPNO       | int       |                1 |
| ENAME       | varchar   |                2 |
| JOB         | varchar   |                3 |
| MGR         | int       |                4 |
| HIREDATE    | date      |                5 |
| SAL         | int       |                6 |
| COMM        | int       |                7 |
| DEPTNO      | int       |                8 |
+-------------+-----------+------------------+
8 rows in set (0.01 sec)
*/

