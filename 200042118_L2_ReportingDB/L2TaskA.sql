use reporting_kids_shop;
drop procedure if exists get_top_3_products;
delimiter //
create procedure get_top_3_products()
begin
    select name, average_rating
    from dim_product
    order by average_rating desc
    limit 3;
end;//
delimiter ;

insert into change_log (script_name, script_details) values ("012_TaskA","Created a Procedure that gets the top 3 products");

call get_top_3_products();