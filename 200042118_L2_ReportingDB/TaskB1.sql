alter table product
add column sale_count int;

alter table category
add column average_rating float;

alter table category
add column total_sale int;

alter table sale 
add column date_time date;

alter table sale
add column seller_id int;

-- alter table sale
-- drop constraint fk_seller_id;

alter table sale
add constraint fk_seller_id
foreign key (seller_id)
references employee(id);

alter table sale 
add column category_id int;

-- alter table sale
-- drop constraint fk_category_id;

alter table sale
add constraint fk_category_id
foreign key (category_id)
references category(id);

alter table invoice
add column total_price int;

-- add the stored procedure in ratings column sir time nai pari nai korte time dile partam

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
call product_avg_rating(new.product_id,average);
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
after insert on sales
for each row
begin
	declare product_sales int;
    declare cat int;
    declare category_sales int;
    select sale_count, category_id into product_sales, cat from product where id = new.product_id;
    select total_sale into category_sales from category where id = cat;
    update product
    set sale_count = product_sales + new.sale_count
    where id = new.product_id;
    update category
    set total_sale = category_sales + new.sale_count
    where id = cat;
end;
//
delimiter ;

insert into change_log (script_name, script_details) values ("005_TaskB1","");







