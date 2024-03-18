use reporting_kids_shop;
drop procedure if exists get_top_2_categories;
delimiter //
create procedure get_top_2_categories()
begin
    select name, average_rating
    from dim_category
    order by average_rating desc
    limit 2;
end;//
delimiter ;

insert into change_log (script_name, script_details) values ("013_TaskB","Created a Procedure that gets the top 2 categories");

call get_top_2_categories();