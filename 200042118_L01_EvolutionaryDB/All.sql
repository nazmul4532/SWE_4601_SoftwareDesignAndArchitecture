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

-- The 18 starts here
alter table vote
rename to rating;

alter table rating
add column rating int default 0;

update rating set rating = 1 where is_up_vote = 0;

update rating set rating = 5 where is_up_vote = 1;

alter table product
change column votes average_rating float;

-- Task A1
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

alter table product
add column price float;

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



-- Task A2


create table employee (
id int not null auto_increment primary key,
employee_name varchar(100)
);

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


-- Task B1

alter table product
add column sale_count int;

alter table category
add column total_sale int;

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


use kids_shop;
drop procedure if exists add_rating;
delimiter //
create procedure add_rating(
	in p_product_id int,
    in p_rating_value int,
    in p_customer_id int)
begin
	if p_product_id in (select id from product) and p_customer_id in (select id from customer) then
		insert into rating values (p_product_id,p_rating_value,p_customer_id);
    end if;
end;//
delimiter ;

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
set product_average = round(ifnull((select avg(rating) from rating where product_id= new.product_id),0));
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


