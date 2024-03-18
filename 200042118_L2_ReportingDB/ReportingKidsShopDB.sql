drop database if exists reporting_kids_shop;
create database reporting_kids_shop;

use reporting_kids_shop;
drop table if exists change_log;
create table if not exists change_log (
    id int not null auto_increment primary key,
    applied_at datetime default now(),
    created_by varchar(100) default "Nazmul",
    script_name varchar(100),
    script_details varchar (500)
);

create table if not exists fact_sale (
    sale_id int not null auto_increment primary key,
    product_id int not null,
    category_id int not null,
    employee_id int not null,
    sale_count int,
    date_time datetime
);

create table if not exists dim_product (
    product_id int not null primary key,
    name varchar(100),
    average_rating float,
    price float
);

create table if not exists dim_category (
    category_id int not null primary key,
    name varchar(100),
    average_rating float,
    total_sale int
);

create table if not exists dim_employee (
    employee_id int not null primary key,
    employee_name varchar(100)
);


insert into reporting_kids_shop.dim_product (product_id, name, average_rating, price)
select id, name, average_rating, price
from kids_shop.product;

insert into reporting_kids_shop.dim_category (category_id, name, average_rating, total_sale)
select id, name, average_rating, total_sale
from kids_shop.category;

insert into reporting_kids_shop.dim_employee (employee_id, employee_name)
select id, employee_name
from kids_shop.employee;

insert into reporting_kids_shop.fact_sale (product_id, category_id, employee_id, sale_count, date_time)
select product_id, category_id, seller_id, sale_count, date_time
from kids_shop.sale;

insert into change_log (script_name, script_details) values ("011_Task00","Created a Reporting Database Star Schema and inserted Data from operational Database");

