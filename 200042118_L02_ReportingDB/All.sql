-- kids_shop_init

/*
-- CLEAN UP
-- run the following lines to clean up the database
drop table category;
drop table product;
drop table vote;
*/

/*
If you already have the database, do not run the next two lines
*/
drop database kids_shop;
create database kids_shop;


use kids_shop;
create table change_log (
    id int not null auto_increment primary key,
    applied_at datetime default now(),
    created_by varchar(100) default "Nazmul",
    script_name varchar(100),
    script_details varchar (500)
);

use kids_shop;

create table category (
    id int not null auto_increment primary key,
    name varchar(100)
);

create table product (
    id int not null auto_increment primary key,
    name varchar(100),
    category_id int not null,
    votes int not null default 0
);

create table vote (
    id int not null auto_increment primary key,
    product_id int not null,
    is_up_vote bit
);

delimiter //
create procedure recalculate_product_votes()
begin
    update product p
        set votes =
            (select count(*) from vote where product_id = p.id and is_up_vote = true)
            - (select count(*) from vote where product_id = p.id and is_up_vote = false)
    where 1 = 1;
end;//
delimiter ;

insert into change_log (script_name, script_details) values ("000_kids_shop_init","Created the Database change_log table and Created the initial database schema");

-- kids_shop_seed
use kids_shop;

insert into category (name) values
    ('toys'),
    ('cloths'),
    ('diaper');

insert into product (name, category_id) values
    ('light ball', 1),
    ('blocks', 1),
    ('cool red shirt', 2),
    ('long blue skirt', 2),
    ('nice green pants', 2),
    ('kids comfi', 3);

insert into vote(product_id, is_up_vote) values
    (1, true),
    (1, true),
    (1, false),
    (2, false),
    (2, false),
    (3, true),
    (3, true),
    (5, false),
    (5, true),
    (5, true),
    (5, true);

call recalculate_product_votes(); 
insert into change_log (script_name, script_details) values ("001_kids_shop_seed","Feed data to populate the database");

-- 18

alter table vote
rename to rating;

alter table rating
add column rating int default 0;

update rating set rating = 1 where is_up_vote = 0;

update rating set rating = 5 where is_up_vote = 1;

alter table product
change column votes average_rating float;

insert into change_log (script_name, script_details) values ("002_18","altered voting products and ratings table and updated ratings and votes accordingly");


-- TaskA1

create table customer (
    id int not null auto_increment primary key,
    customer_name varchar(100)
);

alter table rating
add column rater_id int;

alter table rating
add column  rating_timestamp datetime default now();

alter table rating
drop column is_up_vote;


alter table rating
add constraint fk_rater_id
foreign key (rater_id)
references customer(id);


use kids_shop;
drop procedure if exists recalculate_product_rating;
delimiter //
create procedure recalculate_product_rating()
begin
    update product p
    set average_rating = 
		round(
			ifnull(
				(select avg(rating) 
                from rating 
                where product_id = p.id), 0
			),1
		)
	where 1=1;
end;//
delimiter ;

insert into change_log (script_name, script_details) values ("003_TaskA1","Updated ratings table and created customer table to handle customer Rating submission Added a Procedure to calculate average rating");


-- TaskA2
create table employee (
id int not null auto_increment primary key,
employee_name varchar(100)
);

alter table product
add column price float;

create table invoice (
id int not null auto_increment primary key,
customer_id int not null,
seller_id int not null,
date_time date,
foreign key (customer_id) references customer(id),
foreign key (seller_id) references employee(id)
);

create table sale (
id int not null auto_increment primary key,
product_id int not null,
invoice_id int not null,
unit_price float,
sale_count int,
foreign key (product_id) references product(id),
foreign key (invoice_id) references invoice(id)
);

drop trigger if exists before_insert_sale
delimiter //
create trigger before_insert_sale
before insert on sale
for each row
	if new.unit_price is null then
		set new.unit_price = (select price from product where id = new.product_id);
	end if;
//
delimiter ;

insert into change_log (script_name, script_details) values ("004_TaskA2","Created Employee Invoice and Sale Table and altered Product table to add a price column and added a trigger that brings the price from the product table");


-- TaskB1a
alter table sale 
add column date_time datetime default now() ;

alter table sale
add column seller_id int;
alter table sale
add constraint fk_seller_id
foreign key (seller_id)
references employee(id);

alter table sale 
add column category_id int;
alter table sale
add constraint fk_category_id
foreign key (category_id)
references category(id);

alter table category
add column average_rating float;

alter table invoice
add column total_price int;

insert into change_log (script_name, script_details) values ("005_TaskB1a","Added Redundant Columns and Procedures inorder to enable average_rating");

-- TaskB1b

use kids_shop;
drop procedure if exists add_rating;
delimiter //
create procedure add_rating(
	in p_product_id int,
    in p_rating_value int,
    in p_customer_id int)
begin
	if p_product_id in (select id from product) and p_customer_id in (select id from customer) then
		insert into rating (product_id, rating, rater_id ) values (p_product_id,p_rating_value,p_customer_id);
    end if;
end;//
delimiter ;


drop procedure if exists category_avg_rating;
delimiter //
create procedure category_avg_rating(
	in p_category_id int,
    out p_average_rating decimal(10, 2))
begin
	set p_average_rating = round(
			ifnull(
				(select avg(average_rating) 
                from product 
                where category_id = p_category_id), 0
			),1
		);
end;//
delimiter ;

drop trigger if exists update_product_average_rating
delimiter //
create trigger update_product_average_rating
after insert on rating
for each row
begin
declare product_average decimal(10,2);
declare category_average decimal(10,2);
declare cat int;
set product_average = round(ifnull((select avg(rating) from rating where product_id = new.product_id),0));
update product 
set average_rating = product_average
where id = new.product_id;

select category_id into cat from product where id=new.product_id;
call category_avg_rating(cat,category_average);
update category
set average_rating = category_average
where id = cat;
end;
//
delimiter ;

-- call add_rating(1,5,1);

select * from rating;

insert into change_log (script_name, script_details) values ("006_TaskB1b","Added stored procedure add_rating and trigger to keep product and category consisten when insert on rating table");

-- TaskB1c
use kids_shop;
drop procedure if exists product_avg_rating;
delimiter //
create procedure product_avg_rating(
	in p_product_id int,
    out p_average_rating decimal(10, 2))
begin
	set p_average_rating = round(
			ifnull(
				(select avg(rating) 
                from rating 
                where product_id = p_product_id), 0
			),1
		);
end;//
delimiter ;

set @average_rating = 0;
call product_avg_rating(1, @average_rating);
select @average_rating as result;

insert into change_log (script_name, script_details) values ("007_TaskB1c","Added stored procedure add_rating and trigger to keep product and category consisten when insert on rating table");

-- TaskB2a
alter table product
add column sale_count int;

alter table category
add column total_sale int;

use kids_shop;
drop trigger if exists update_sales
delimiter //
create trigger update_sales
before insert on sale
for each row
begin
	declare product_sales int;
    declare cat int;
    declare old_total float;
    declare category_sales int;
    select sale_count, category_id into product_sales, cat from product where id = new.product_id;
    select total_sale into category_sales from category where id = cat;
    update product
    set sale_count = ifnull(product_sales,0) + ifnull(new.sale_count,0)
    where id = new.product_id;
    update category
    set total_sale = ifnull(category_sales,0) + ifnull(new.sale_count,0)
    where id = cat;
    set new.category_id=cat;
    set new.seller_id = (select seller_id from invoice where id = new.invoice_id);
    
    select total_price into old_total from invoice where id = new.invoice_id;
    
    update invoice 
    set total_price = ifnull(old_total,0) + ifnull((new.unit_price * new.sale_count),0)
    where id = new.invoice_id;
    
end;
//
delimiter ;

insert into change_log (script_name, script_details) values ("008_TaskB2a","Altered Product and Category table to handle redundant columns for total sales per category query");

-- TaskB2b
use kids_shop;
drop procedure if exists get_sale_per_category;
delimiter //
create procedure get_sale_per_category(
	in p_employee_id int)
begin
	select c.name as category_name, sum(s.sale_count) as category_sales
    from sale s,category c
    where s.category_id = c.id and s.seller_id = p_employee_id
    group by c.id;
end;//
delimiter ;

call get_sale_per_category(1);


insert into change_log (script_name, script_details) values ("009_TaskB2b","Added get sale per category stored procedure to calculate employee sales");


-- TaskB2c

use kids_shop;
drop procedure if exists set_product_category;
delimiter //
create procedure set_product_category(
    in p_product_id int,
    in p_category_id int
)
begin
    update product
    set category_id = p_category_id
    where id = p_product_id;
    
    update sale
    set category_id = p_category_id
    where product_id = p_product_id;
    
    update category
    set total_sale = ifnull((select sum(sale_count) from product where category_id = category.id),0);
    
    update category
    set average_rating = round(ifnull((select avg(average_rating) from product where category_id = category.id),0),1);
end //
delimiter ;

call set_product_category(2,1);

select * from sale;


insert into change_log (script_name, script_details) values ("010_TaskB2c","Added stored procedure set product category and handled rating update to keep columns consistent");

-- Populate Database
insert into customer(customer_name) values
    ("Nazmul"),
    ("Nafisa"),
    ("Sian"),
    ("Dihan"),
    ("Akash"),
    ("Shanta"),
    ("Jawad");

insert into rating (product_id, rating, rater_id) values
	(1,2,1),
    (2,2,1),
    (3,2,1),
    (3,2,1),
    (5,1,1),
    (6,2,1),
    (1,4,2),
    (2,5,2),
    (5,3,3),
    (2,4,3),
    (6,5,4),
    (3,3,4),
    (3,5,5),
    (2,4,6),
    (5,5,7);
    
call recalculate_product_rating(); 

-- i donot know if i should keep exisiting price fields null or not... 
-- unlike who rated which product... the price field is more important so i am populating it

update product
set price = 69.99
where 1=1;



insert into employee (employee_name) values
	("Shakkhor"),
    ("Dayan"),
    ("Tanzim");
    
insert into invoice (customer_id,seller_id,date_time) values
	(1,1,'2024-02-09'),
    (4,2,'2024-02-09'),
    (3,3,'2024-02-09'),
    (1,2,'2024-02-10'),
    (2,1,'2024-02-10'),
    (5,3,'2024-02-10'),
    (1,3,'2024-02-11'),
    (6,2,'2024-02-11'),
    (7,1,'2024-02-11');
    
insert into sale (product_id,invoice_id,unit_price,sale_count) values
	(1,1,79.99,4),
    (2,4,59.99,2),
    (3,7,89.99,5),
	(4,7,89.99,5),
	(5,4,59.99,2),
	(6,1,59.99,2);
    
insert into sale (product_id,invoice_id,sale_count) values
	(6,2,4),
    (3,2,2),
    (2,3,2),
    (5,3,5),
    (1,5,4),
    (2,5,3),
    (3,6,5),
    (4,6,2),
    (5,6,2),
    (2,8,3),
    (3,8,2),
    (5,9,4),
    (6,9,4);
    
insert into change_log (script_name, script_details) values ("011_PopulateDatabase","Added new data to the Table to test features");
