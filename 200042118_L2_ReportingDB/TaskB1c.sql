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

