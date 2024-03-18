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
