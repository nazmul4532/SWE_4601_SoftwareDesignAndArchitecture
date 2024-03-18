use kids_shop;
drop procedure if exists get_sale_per_category;
delimiter //
create procedure get_sale_per_category(
	in p_employee_id int)
begin
	select c.name as category_name, sum(s.sale_count) as category_sales
    from sale s,category c
    where s.category_id = c.id and s.seller_id = p_employee_id
    group by c.id;
end;//
delimiter ;

call get_sale_per_category(1);


insert into change_log (script_name, script_details) values ("009_TaskB2b","Added get sale per category stored procedure to calculate employee sales");
