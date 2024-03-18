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