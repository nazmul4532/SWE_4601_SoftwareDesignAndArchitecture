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

