use reporting_kids_shop;
drop procedure if exists get_top_product_by_duration;
delimiter //
create procedure get_top_product_by_duration(start_date date, end_date date)
begin
    select p.name, p.average_rating
    from dim_product p
    join fact_sale fs on p.product_id = fs.product_id
    where fs.date_time between start_date and end_date
    order by p.average_rating desc
    limit 1;
end;//
delimiter ;

insert into change_log (script_name, script_details) values ("014_TaskC","Created a Procedure that gets the top product within a certain duration");

call get_top_product_by_duration('2024-01-01', '2024-02-28');