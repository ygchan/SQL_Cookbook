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