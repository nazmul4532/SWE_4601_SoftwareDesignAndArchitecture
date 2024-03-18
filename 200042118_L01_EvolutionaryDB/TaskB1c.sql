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


