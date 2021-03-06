-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Configurate MySQL Database
-- export PATH=$PATH:/usr/local/mysql/bin
-- mysql -u Study -p bank

-- CHAPTER 8: Date Arithmetics

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

-- Inline solution to get the two hiring dates together
select ward_hd, allen_hd
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
+------------+------------+
| ward_hd    | allen_hd   |
+------------+------------+
| 1981-02-22 | 1981-02-20 |
+------------+------------+
1 row in set (0.00 sec)
*/

-- Cartesian product is created, because there are no join specified.
-- To get the difference in days, simply subtract one from the two values
-- returned and using the method (function) appropriate for your database.

-- 03. Determining the number of business days between two days
-- Given two dates, find how many days that are not (Saturday, Sunday).

select max(case when ename = 'BLAKE'
                then hiredate
           end) as blake_hd,
       max(case when ename = 'JONES'
                then hiredate
           end) as joines_hd
from emp
where ename in ('BLAKE', 'JONES');

/* Output 
+------------+------------+
| blake_hd   | joines_hd  |
+------------+------------+
| 1981-05-01 | 1981-04-02 |
+------------+------------+
1 row in set (0.00 sec)
*/

/* Missing code from source */

CREATE TABLE T500 (ID INTEGER);
INSERT INTO T500 VALUES (1);
INSERT INTO T500 VALUES (2);
INSERT INTO T500 VALUES (3);
INSERT INTO T500 VALUES (4);
INSERT INTO T500 VALUES (5);
INSERT INTO T500 VALUES (6);
INSERT INTO T500 VALUES (7);
INSERT INTO T500 VALUES (8);
INSERT INTO T500 VALUES (9);
INSERT INTO T500 VALUES (10);
INSERT INTO T500 VALUES (11);
INSERT INTO T500 VALUES (12);
INSERT INTO T500 VALUES (13);
INSERT INTO T500 VALUES (14);
INSERT INTO T500 VALUES (15);
INSERT INTO T500 VALUES (16);
INSERT INTO T500 VALUES (17);
INSERT INTO T500 VALUES (18);
INSERT INTO T500 VALUES (19);
INSERT INTO T500 VALUES (20);
INSERT INTO T500 VALUES (21);
INSERT INTO T500 VALUES (22);
INSERT INTO T500 VALUES (23);
INSERT INTO T500 VALUES (24);
INSERT INTO T500 VALUES (25);
INSERT INTO T500 VALUES (26);
INSERT INTO T500 VALUES (27);
INSERT INTO T500 VALUES (28);
INSERT INTO T500 VALUES (29);
INSERT INTO T500 VALUES (30);
INSERT INTO T500 VALUES (31);
INSERT INTO T500 VALUES (32);
INSERT INTO T500 VALUES (33);
INSERT INTO T500 VALUES (34);
INSERT INTO T500 VALUES (35);
INSERT INTO T500 VALUES (36);
INSERT INTO T500 VALUES (37);
INSERT INTO T500 VALUES (38);
INSERT INTO T500 VALUES (39);
INSERT INTO T500 VALUES (40);
INSERT INTO T500 VALUES (41);
INSERT INTO T500 VALUES (42);
INSERT INTO T500 VALUES (43);
INSERT INTO T500 VALUES (44);
INSERT INTO T500 VALUES (45);
INSERT INTO T500 VALUES (46);
INSERT INTO T500 VALUES (47);
INSERT INTO T500 VALUES (48);
INSERT INTO T500 VALUES (49);
INSERT INTO T500 VALUES (50);
INSERT INTO T500 VALUES (51);
INSERT INTO T500 VALUES (52);
INSERT INTO T500 VALUES (53);
INSERT INTO T500 VALUES (54);
INSERT INTO T500 VALUES (55);
INSERT INTO T500 VALUES (56);
INSERT INTO T500 VALUES (57);
INSERT INTO T500 VALUES (58);
INSERT INTO T500 VALUES (59);
INSERT INTO T500 VALUES (60);
INSERT INTO T500 VALUES (61);
INSERT INTO T500 VALUES (62);
INSERT INTO T500 VALUES (63);
INSERT INTO T500 VALUES (64);
INSERT INTO T500 VALUES (65);
INSERT INTO T500 VALUES (66);
INSERT INTO T500 VALUES (67);
INSERT INTO T500 VALUES (68);
INSERT INTO T500 VALUES (69);
INSERT INTO T500 VALUES (70);
INSERT INTO T500 VALUES (71);
INSERT INTO T500 VALUES (72);
INSERT INTO T500 VALUES (73);
INSERT INTO T500 VALUES (74);
INSERT INTO T500 VALUES (75);
INSERT INTO T500 VALUES (76);
INSERT INTO T500 VALUES (77);
INSERT INTO T500 VALUES (78);
INSERT INTO T500 VALUES (79);
INSERT INTO T500 VALUES (80);
INSERT INTO T500 VALUES (81);
INSERT INTO T500 VALUES (82);
INSERT INTO T500 VALUES (83);
INSERT INTO T500 VALUES (84);
INSERT INTO T500 VALUES (85);
INSERT INTO T500 VALUES (86);
INSERT INTO T500 VALUES (87);
INSERT INTO T500 VALUES (88);
INSERT INTO T500 VALUES (89);
INSERT INTO T500 VALUES (90);
INSERT INTO T500 VALUES (91);
INSERT INTO T500 VALUES (92);
INSERT INTO T500 VALUES (93);
INSERT INTO T500 VALUES (94);
INSERT INTO T500 VALUES (95);
INSERT INTO T500 VALUES (96);
INSERT INTO T500 VALUES (97);
INSERT INTO T500 VALUES (98);
INSERT INTO T500 VALUES (99);
INSERT INTO T500 VALUES (100);
INSERT INTO T500 VALUES (101);
INSERT INTO T500 VALUES (102);
INSERT INTO T500 VALUES (103);
INSERT INTO T500 VALUES (104);
INSERT INTO T500 VALUES (105);
INSERT INTO T500 VALUES (106);
INSERT INTO T500 VALUES (107);
INSERT INTO T500 VALUES (108);
INSERT INTO T500 VALUES (109);
INSERT INTO T500 VALUES (110);
INSERT INTO T500 VALUES (111);
INSERT INTO T500 VALUES (112);
INSERT INTO T500 VALUES (113);
INSERT INTO T500 VALUES (114);
INSERT INTO T500 VALUES (115);
INSERT INTO T500 VALUES (116);
INSERT INTO T500 VALUES (117);
INSERT INTO T500 VALUES (118);
INSERT INTO T500 VALUES (119);
INSERT INTO T500 VALUES (120);
INSERT INTO T500 VALUES (121);
INSERT INTO T500 VALUES (122);
INSERT INTO T500 VALUES (123);
INSERT INTO T500 VALUES (124);
INSERT INTO T500 VALUES (125);
INSERT INTO T500 VALUES (126);
INSERT INTO T500 VALUES (127);
INSERT INTO T500 VALUES (128);
INSERT INTO T500 VALUES (129);
INSERT INTO T500 VALUES (130);
INSERT INTO T500 VALUES (131);
INSERT INTO T500 VALUES (132);
INSERT INTO T500 VALUES (133);
INSERT INTO T500 VALUES (134);
INSERT INTO T500 VALUES (135);
INSERT INTO T500 VALUES (136);
INSERT INTO T500 VALUES (137);
INSERT INTO T500 VALUES (138);
INSERT INTO T500 VALUES (139);
INSERT INTO T500 VALUES (140);
INSERT INTO T500 VALUES (141);
INSERT INTO T500 VALUES (142);
INSERT INTO T500 VALUES (143);
INSERT INTO T500 VALUES (144);
INSERT INTO T500 VALUES (145);
INSERT INTO T500 VALUES (146);
INSERT INTO T500 VALUES (147);
INSERT INTO T500 VALUES (148);
INSERT INTO T500 VALUES (149);
INSERT INTO T500 VALUES (150);
INSERT INTO T500 VALUES (151);
INSERT INTO T500 VALUES (152);
INSERT INTO T500 VALUES (153);
INSERT INTO T500 VALUES (154);
INSERT INTO T500 VALUES (155);
INSERT INTO T500 VALUES (156);
INSERT INTO T500 VALUES (157);
INSERT INTO T500 VALUES (158);
INSERT INTO T500 VALUES (159);
INSERT INTO T500 VALUES (160);
INSERT INTO T500 VALUES (161);
INSERT INTO T500 VALUES (162);
INSERT INTO T500 VALUES (163);
INSERT INTO T500 VALUES (164);
INSERT INTO T500 VALUES (165);
INSERT INTO T500 VALUES (166);
INSERT INTO T500 VALUES (167);
INSERT INTO T500 VALUES (168);
INSERT INTO T500 VALUES (169);
INSERT INTO T500 VALUES (170);
INSERT INTO T500 VALUES (171);
INSERT INTO T500 VALUES (172);
INSERT INTO T500 VALUES (173);
INSERT INTO T500 VALUES (174);
INSERT INTO T500 VALUES (175);
INSERT INTO T500 VALUES (176);
INSERT INTO T500 VALUES (177);
INSERT INTO T500 VALUES (178);
INSERT INTO T500 VALUES (179);
INSERT INTO T500 VALUES (180);
INSERT INTO T500 VALUES (181);
INSERT INTO T500 VALUES (182);
INSERT INTO T500 VALUES (183);
INSERT INTO T500 VALUES (184);
INSERT INTO T500 VALUES (185);
INSERT INTO T500 VALUES (186);
INSERT INTO T500 VALUES (187);
INSERT INTO T500 VALUES (188);
INSERT INTO T500 VALUES (189);
INSERT INTO T500 VALUES (190);
INSERT INTO T500 VALUES (191);
INSERT INTO T500 VALUES (192);
INSERT INTO T500 VALUES (193);
INSERT INTO T500 VALUES (194);
INSERT INTO T500 VALUES (195);
INSERT INTO T500 VALUES (196);
INSERT INTO T500 VALUES (197);
INSERT INTO T500 VALUES (198);
INSERT INTO T500 VALUES (199);
INSERT INTO T500 VALUES (200);
INSERT INTO T500 VALUES (201);
INSERT INTO T500 VALUES (202);
INSERT INTO T500 VALUES (203);
INSERT INTO T500 VALUES (204);
INSERT INTO T500 VALUES (205);
INSERT INTO T500 VALUES (206);
INSERT INTO T500 VALUES (207);
INSERT INTO T500 VALUES (208);
INSERT INTO T500 VALUES (209);
INSERT INTO T500 VALUES (210);
INSERT INTO T500 VALUES (211);
INSERT INTO T500 VALUES (212);
INSERT INTO T500 VALUES (213);
INSERT INTO T500 VALUES (214);
INSERT INTO T500 VALUES (215);
INSERT INTO T500 VALUES (216);
INSERT INTO T500 VALUES (217);
INSERT INTO T500 VALUES (218);
INSERT INTO T500 VALUES (219);
INSERT INTO T500 VALUES (220);
INSERT INTO T500 VALUES (221);
INSERT INTO T500 VALUES (222);
INSERT INTO T500 VALUES (223);
INSERT INTO T500 VALUES (224);
INSERT INTO T500 VALUES (225);
INSERT INTO T500 VALUES (226);
INSERT INTO T500 VALUES (227);
INSERT INTO T500 VALUES (228);
INSERT INTO T500 VALUES (229);
INSERT INTO T500 VALUES (230);
INSERT INTO T500 VALUES (231);
INSERT INTO T500 VALUES (232);
INSERT INTO T500 VALUES (233);
INSERT INTO T500 VALUES (234);
INSERT INTO T500 VALUES (235);
INSERT INTO T500 VALUES (236);
INSERT INTO T500 VALUES (237);
INSERT INTO T500 VALUES (238);
INSERT INTO T500 VALUES (239);
INSERT INTO T500 VALUES (240);
INSERT INTO T500 VALUES (241);
INSERT INTO T500 VALUES (242);
INSERT INTO T500 VALUES (243);
INSERT INTO T500 VALUES (244);
INSERT INTO T500 VALUES (245);
INSERT INTO T500 VALUES (246);
INSERT INTO T500 VALUES (247);
INSERT INTO T500 VALUES (248);
INSERT INTO T500 VALUES (249);
INSERT INTO T500 VALUES (250);
INSERT INTO T500 VALUES (251);
INSERT INTO T500 VALUES (252);
INSERT INTO T500 VALUES (253);
INSERT INTO T500 VALUES (254);
INSERT INTO T500 VALUES (255);
INSERT INTO T500 VALUES (256);
INSERT INTO T500 VALUES (257);
INSERT INTO T500 VALUES (258);
INSERT INTO T500 VALUES (259);
INSERT INTO T500 VALUES (260);
INSERT INTO T500 VALUES (261);
INSERT INTO T500 VALUES (262);
INSERT INTO T500 VALUES (263);
INSERT INTO T500 VALUES (264);
INSERT INTO T500 VALUES (265);
INSERT INTO T500 VALUES (266);
INSERT INTO T500 VALUES (267);
INSERT INTO T500 VALUES (268);
INSERT INTO T500 VALUES (269);
INSERT INTO T500 VALUES (270);
INSERT INTO T500 VALUES (271);
INSERT INTO T500 VALUES (272);
INSERT INTO T500 VALUES (273);
INSERT INTO T500 VALUES (274);
INSERT INTO T500 VALUES (275);
INSERT INTO T500 VALUES (276);
INSERT INTO T500 VALUES (277);
INSERT INTO T500 VALUES (278);
INSERT INTO T500 VALUES (279);
INSERT INTO T500 VALUES (280);
INSERT INTO T500 VALUES (281);
INSERT INTO T500 VALUES (282);
INSERT INTO T500 VALUES (283);
INSERT INTO T500 VALUES (284);
INSERT INTO T500 VALUES (285);
INSERT INTO T500 VALUES (286);
INSERT INTO T500 VALUES (287);
INSERT INTO T500 VALUES (288);
INSERT INTO T500 VALUES (289);
INSERT INTO T500 VALUES (290);
INSERT INTO T500 VALUES (291);
INSERT INTO T500 VALUES (292);
INSERT INTO T500 VALUES (293);
INSERT INTO T500 VALUES (294);
INSERT INTO T500 VALUES (295);
INSERT INTO T500 VALUES (296);
INSERT INTO T500 VALUES (297);
INSERT INTO T500 VALUES (298);
INSERT INTO T500 VALUES (299);
INSERT INTO T500 VALUES (300);
INSERT INTO T500 VALUES (301);
INSERT INTO T500 VALUES (302);
INSERT INTO T500 VALUES (303);
INSERT INTO T500 VALUES (304);
INSERT INTO T500 VALUES (305);
INSERT INTO T500 VALUES (306);
INSERT INTO T500 VALUES (307);
INSERT INTO T500 VALUES (308);
INSERT INTO T500 VALUES (309);
INSERT INTO T500 VALUES (310);
INSERT INTO T500 VALUES (311);
INSERT INTO T500 VALUES (312);
INSERT INTO T500 VALUES (313);
INSERT INTO T500 VALUES (314);
INSERT INTO T500 VALUES (315);
INSERT INTO T500 VALUES (316);
INSERT INTO T500 VALUES (317);
INSERT INTO T500 VALUES (318);
INSERT INTO T500 VALUES (319);
INSERT INTO T500 VALUES (320);
INSERT INTO T500 VALUES (321);
INSERT INTO T500 VALUES (322);
INSERT INTO T500 VALUES (323);
INSERT INTO T500 VALUES (324);
INSERT INTO T500 VALUES (325);
INSERT INTO T500 VALUES (326);
INSERT INTO T500 VALUES (327);
INSERT INTO T500 VALUES (328);
INSERT INTO T500 VALUES (329);
INSERT INTO T500 VALUES (330);
INSERT INTO T500 VALUES (331);
INSERT INTO T500 VALUES (332);
INSERT INTO T500 VALUES (333);
INSERT INTO T500 VALUES (334);
INSERT INTO T500 VALUES (335);
INSERT INTO T500 VALUES (336);
INSERT INTO T500 VALUES (337);
INSERT INTO T500 VALUES (338);
INSERT INTO T500 VALUES (339);
INSERT INTO T500 VALUES (340);
INSERT INTO T500 VALUES (341);
INSERT INTO T500 VALUES (342);
INSERT INTO T500 VALUES (343);
INSERT INTO T500 VALUES (344);
INSERT INTO T500 VALUES (345);
INSERT INTO T500 VALUES (346);
INSERT INTO T500 VALUES (347);
INSERT INTO T500 VALUES (348);
INSERT INTO T500 VALUES (349);
INSERT INTO T500 VALUES (350);
INSERT INTO T500 VALUES (351);
INSERT INTO T500 VALUES (352);
INSERT INTO T500 VALUES (353);
INSERT INTO T500 VALUES (354);
INSERT INTO T500 VALUES (355);
INSERT INTO T500 VALUES (356);
INSERT INTO T500 VALUES (357);
INSERT INTO T500 VALUES (358);
INSERT INTO T500 VALUES (359);
INSERT INTO T500 VALUES (360);
INSERT INTO T500 VALUES (361);
INSERT INTO T500 VALUES (362);
INSERT INTO T500 VALUES (363);
INSERT INTO T500 VALUES (364);
INSERT INTO T500 VALUES (365);
INSERT INTO T500 VALUES (366);
INSERT INTO T500 VALUES (367);
INSERT INTO T500 VALUES (368);
INSERT INTO T500 VALUES (369);
INSERT INTO T500 VALUES (370);
INSERT INTO T500 VALUES (371);
INSERT INTO T500 VALUES (372);
INSERT INTO T500 VALUES (373);
INSERT INTO T500 VALUES (374);
INSERT INTO T500 VALUES (375);
INSERT INTO T500 VALUES (376);
INSERT INTO T500 VALUES (377);
INSERT INTO T500 VALUES (378);
INSERT INTO T500 VALUES (379);
INSERT INTO T500 VALUES (380);
INSERT INTO T500 VALUES (381);
INSERT INTO T500 VALUES (382);
INSERT INTO T500 VALUES (383);
INSERT INTO T500 VALUES (384);
INSERT INTO T500 VALUES (385);
INSERT INTO T500 VALUES (386);
INSERT INTO T500 VALUES (387);
INSERT INTO T500 VALUES (388);
INSERT INTO T500 VALUES (389);
INSERT INTO T500 VALUES (390);
INSERT INTO T500 VALUES (391);
INSERT INTO T500 VALUES (392);
INSERT INTO T500 VALUES (393);
INSERT INTO T500 VALUES (394);
INSERT INTO T500 VALUES (395);
INSERT INTO T500 VALUES (396);
INSERT INTO T500 VALUES (397);
INSERT INTO T500 VALUES (398);
INSERT INTO T500 VALUES (399);
INSERT INTO T500 VALUES (400);
INSERT INTO T500 VALUES (401);
INSERT INTO T500 VALUES (402);
INSERT INTO T500 VALUES (403);
INSERT INTO T500 VALUES (404);
INSERT INTO T500 VALUES (405);
INSERT INTO T500 VALUES (406);
INSERT INTO T500 VALUES (407);
INSERT INTO T500 VALUES (408);
INSERT INTO T500 VALUES (409);
INSERT INTO T500 VALUES (410);
INSERT INTO T500 VALUES (411);
INSERT INTO T500 VALUES (412);
INSERT INTO T500 VALUES (413);
INSERT INTO T500 VALUES (414);
INSERT INTO T500 VALUES (415);
INSERT INTO T500 VALUES (416);
INSERT INTO T500 VALUES (417);
INSERT INTO T500 VALUES (418);
INSERT INTO T500 VALUES (419);
INSERT INTO T500 VALUES (420);
INSERT INTO T500 VALUES (421);
INSERT INTO T500 VALUES (422);
INSERT INTO T500 VALUES (423);
INSERT INTO T500 VALUES (424);
INSERT INTO T500 VALUES (425);
INSERT INTO T500 VALUES (426);
INSERT INTO T500 VALUES (427);
INSERT INTO T500 VALUES (428);
INSERT INTO T500 VALUES (429);
INSERT INTO T500 VALUES (430);
INSERT INTO T500 VALUES (431);
INSERT INTO T500 VALUES (432);
INSERT INTO T500 VALUES (433);
INSERT INTO T500 VALUES (434);
INSERT INTO T500 VALUES (435);
INSERT INTO T500 VALUES (436);
INSERT INTO T500 VALUES (437);
INSERT INTO T500 VALUES (438);
INSERT INTO T500 VALUES (439);
INSERT INTO T500 VALUES (440);
INSERT INTO T500 VALUES (441);
INSERT INTO T500 VALUES (442);
INSERT INTO T500 VALUES (443);
INSERT INTO T500 VALUES (444);
INSERT INTO T500 VALUES (445);
INSERT INTO T500 VALUES (446);
INSERT INTO T500 VALUES (447);
INSERT INTO T500 VALUES (448);
INSERT INTO T500 VALUES (449);
INSERT INTO T500 VALUES (450);
INSERT INTO T500 VALUES (451);
INSERT INTO T500 VALUES (452);
INSERT INTO T500 VALUES (453);
INSERT INTO T500 VALUES (454);
INSERT INTO T500 VALUES (455);
INSERT INTO T500 VALUES (456);
INSERT INTO T500 VALUES (457);
INSERT INTO T500 VALUES (458);
INSERT INTO T500 VALUES (459);
INSERT INTO T500 VALUES (460);
INSERT INTO T500 VALUES (461);
INSERT INTO T500 VALUES (462);
INSERT INTO T500 VALUES (463);
INSERT INTO T500 VALUES (464);
INSERT INTO T500 VALUES (465);
INSERT INTO T500 VALUES (466);
INSERT INTO T500 VALUES (467);
INSERT INTO T500 VALUES (468);
INSERT INTO T500 VALUES (469);
INSERT INTO T500 VALUES (470);
INSERT INTO T500 VALUES (471);
INSERT INTO T500 VALUES (472);
INSERT INTO T500 VALUES (473);
INSERT INTO T500 VALUES (474);
INSERT INTO T500 VALUES (475);
INSERT INTO T500 VALUES (476);
INSERT INTO T500 VALUES (477);
INSERT INTO T500 VALUES (478);
INSERT INTO T500 VALUES (479);
INSERT INTO T500 VALUES (480);
INSERT INTO T500 VALUES (481);
INSERT INTO T500 VALUES (482);
INSERT INTO T500 VALUES (483);
INSERT INTO T500 VALUES (484);
INSERT INTO T500 VALUES (485);
INSERT INTO T500 VALUES (486);
INSERT INTO T500 VALUES (487);
INSERT INTO T500 VALUES (488);
INSERT INTO T500 VALUES (489);
INSERT INTO T500 VALUES (490);
INSERT INTO T500 VALUES (491);
INSERT INTO T500 VALUES (492);
INSERT INTO T500 VALUES (493);
INSERT INTO T500 VALUES (494);
INSERT INTO T500 VALUES (495);
INSERT INTO T500 VALUES (496);
INSERT INTO T500 VALUES (497);
INSERT INTO T500 VALUES (498);
INSERT INTO T500 VALUES (499);
INSERT INTO T500 VALUES (500);

/* And the do this */

select sum(case when date_format(
                     date_add(jones_hd,
                              interval t500.id-1 DAY), '%a')
                in ('Sat', 'Sun')
                then 0 else 1 end
          ) as days
from (
select max(case when ename = 'BLAKE'
                then hiredate
           end) as blake_hd,
       max(case when ename = 'JONES'
                then hiredate
           end) as jones_hd
from emp
where ename in ('BLAKE', 'JONES')
) x,
t500
where t500.id <= datediff(blake_hd, jones_hd) + 1;

/* Output: Harray!!
+------+
| days |
+------+
|   22 |
+------+
1 row in set (0.01 sec)
*/

-- 04. Determining the number of months or years between the 2 dates
-- Find the difference between two dates in terms of either month/year

-- I think this rounding issue might be why Linkedin has a funny way
-- of calculating how long you have been working in a company.
-- Round up, or Round down?

-- Getting the min and max
select min(hiredate) as min_hd, max(hiredate) as max_hd
from emp;

/* Output:
+------------+------------+
| min_hd     | max_hd     |
+------------+------------+
| 1980-12-17 | 1983-01-12 |
+------------+------------+
1 row in set (0.00 sec)
*/

select (year(max_hd) - year(min_hd)) * 12 +
       (month(max_hd) - month(min_hd)) as mnth
from (
select min(hiredate) as min_hd, max(hiredate) as max_hd
from emp
) x;

/* Output:
+------+
| mnth |
+------+
|   25 |
+------+
1 row in set (0.00 sec)
*/

select mnth, mnth/12
from (
   select (year(max_hd) - year(min_hd)) * 12 +
          (month(max_hd) - month(min_hd)) as mnth
   from (
   select min(hiredate) as min_hd, max(hiredate) as max_hd
   from emp
   ) x
) y;

/* Output:
+------+---------+
| mnth | mnth/12 |
+------+---------+
|   25 |  2.0833 |
+------+---------+
1 row in set (0.01 sec)
*/

-- 05. Determining the number of seconds, minutes of hours between 2 dates

select max(case when ename = 'WARD'
                then hiredate
           end) as ward_hd,
       max(case when ename = 'ALLEN'
                then hiredate
           end) as allen_hd
from emp;

/* Output: 
+------------+------------+
| ward_hd    | allen_hd   |
+------------+------------+
| 1981-02-22 | 1981-02-20 |
+------------+------------+
1 row in set (0.01 sec)
*/

select datediff(ward_hd, allen_hd) * 24 hr,
       datediff(ward_hd, allen_hd) * 24 * 60 min,
       datediff(ward_hd, allen_hd) * 24 * 60 * 60 sec
from (
select max(case when ename = 'WARD'
                then hiredate
           end) as ward_hd,
       max(case when ename = 'ALLEN'
                then hiredate
           end) as allen_hd
from emp
) x;

-- In MySQL, unlike SQL Server, you only uses 2 arugment.
-- Please put the "later, or larger date" first.

/* Output:
+------+------+--------+
| hr   | min  | sec    |
+------+------+--------+
|   48 | 2880 | 172800 |
+------+------+--------+
1 row in set (0.00 sec)
*/

-- What about if you want to do abs()? Will that give the same
-- result or not? YES! It does!!

select abs(datediff(allen_hd, ward_hd)) * 24 hr,
       abs(datediff(allen_hd, ward_hd)) * 24 * 60 min,
       abs(datediff(allen_hd, ward_hd)) * 24 * 60 * 60 sec
from (
select max(case when ename = 'WARD'
                then hiredate
           end) as ward_hd,
       max(case when ename = 'ALLEN'
                then hiredate
           end) as allen_hd
from emp
) x;

/* Output:
+------+------+--------+
| hr   | min  | sec    |
+------+------+--------+
|   48 | 2880 | 172800 |
+------+------+--------+
1 row in set (0.00 sec)
*/

-- 06. Counting the occurrences of weekdays in a year 
-- Give a particular year, find out how many weekdays occured.

-- Step #01. Generate all the possible dates
-- Step #02. Format the dates such that they resolve to the name (Monday)
-- Step #03. Count the occurence of each weekday name

select concat(year(current_date), '-01-01')
from t1;

/* Output:
+--------------------------------------+
| concat(year(current_date), '-01-01') |
+--------------------------------------+
| 2019-01-01                           |
+--------------------------------------+
1 row in set (0.02 sec)
*/

-- Remember it is date_format(), not format()
-- Reference: https://www.w3schools.com/sql/func_mysql_date_format.asp
select date_format(
          date_add(
              cast(concat(year(current_date), '-01-01') as date),
                   interval t10.id-1 day),
                   '%W') day
from t10;

/* Output:
+-----------+
| day       |
+-----------+
| Tuesday   |
| Wednesday |
| Thursday  |
| Friday    |
| Saturday  |
| Sunday    |
| Monday    |
| Tuesday   |
| Wednesday |
| Thursday  |
+-----------+
10 rows in set (0.01 sec)
*/

select date_format(
          date_add(
              cast(concat(year(current_date), '-01-01') as date),
                   interval t500.id-1 day),
                   '%W') day,
       count(*)
from t500
where t500.id <= datediff(
                     cast(
                   concat(year(current_date)+1, '-01-01')
                          as date),
                     cast(
                   concat(year(current_date), '-01-01')
                          as date))
group by date_format(
            date_add(
                cast(concat(year(current_date), '-01-01') as date),
                     interval t500.id-1 day),
                     '%W');

/* Output:
+-----------+----------+
| day       | count(*) |
+-----------+----------+
| Friday    |       52 |
| Monday    |       52 |
| Saturday  |       52 |
| Sunday    |       52 |
| Thursday  |       52 |
| Tuesday   |       53 |
| Wednesday |       52 |
+-----------+----------+
7 rows in set (0.02 sec)
*/

-- 07. Determining the date difference between the current record
-- and the next. (Specifically dates stored in two different row.)
-- For example, you want to find out the number of days between the 
-- date they were hired and the date the next employee was hired.

-- Hint: Find the earliest hiredate after the current emlpyee was hired.
-- You will need to use scalar subquery to find the next hiredate.

select x.*, datediff(next_hd, hiredate) as diff
from (
select e.deptno, e.ename, e.hiredate,
       /* Very clever use of scalar subquery! */
       /* What is the smallest hiredate that is greater (after)
          your this current hiredate (at this row) */
       (select min(d.hiredate) from emp d
        where d.hiredate > e.hiredate) next_hd
from emp e
where e.deptno = 10
) x;

/* Output:
+--------+--------+------------+------------+
| deptno | ename  | hiredate   | next_hd    |
+--------+--------+------------+------------+
|     10 | CLARK  | 1981-06-09 | 1981-09-08 |
|     10 | KING   | 1981-11-17 | 1981-12-03 |
|     10 | MILLER | 1982-01-23 | 1982-12-09 |
+--------+--------+------------+------------+
3 rows in set (0.11 sec)
*/

-- 08. 