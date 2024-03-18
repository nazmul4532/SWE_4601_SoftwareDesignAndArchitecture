
use reporting_kids_shop;
drop procedure if exists get_top_product_by_category;
delimiter //
create procedure get_top_product_by_category(category_id int)
begin
    select p.name, p.average_rating
    from dim_product p join fact_sale fs
    where fs.category_id = category_id and p.product_id = fs.product_id
    order by p.average_rating desc
    limit 1;
end;//
delimiter ;

insert into change_log (script_name, script_details) values ("015_TaskD","Created a Procedure that gets the top product of a certain category");

call get_top_product_by_category(1);