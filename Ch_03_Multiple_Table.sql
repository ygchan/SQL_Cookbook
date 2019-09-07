-- SQL Cookbook
-- http://shop.oreilly.com/product/9780596009762.do

-- Chapter 03: Working with multiple tables

-- 00: TSQL
create table person
(
	person_id smallint unsigned,
	fname varchar(20),
	lname varchar(20),
	-- gender char(1),
	-- enforce the check of gender
	gender enum('M', 'F'),
	birth_date date,
	street varchar(30),
	city varchar(20),
	state varchar(20),
	country varchar(20),
	postal_code varchar(20),
	constraint pk_person primary key (person_id)
);

-- 01: Stacking one data rowset atop another

