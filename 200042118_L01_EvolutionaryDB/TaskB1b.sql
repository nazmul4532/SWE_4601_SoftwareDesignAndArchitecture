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

