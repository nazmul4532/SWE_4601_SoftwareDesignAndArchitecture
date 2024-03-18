use reporting_kids_shop;
drop procedure if exists get_top_employee_by_duration;
delimiter //

create procedure get_top_employee_by_duration(start_date date, end_date date)
begin
    select e.employee_name, sum(fs.sale_count) as total_sales
    from dim_employee e
    join fact_sale fs on e.employee_id = fs.employee_id
    where fs.date_time between start_date and end_date
    group by e.employee_id
    order by total_sales desc
    limit 1;
end//
delimiter ;

insert into change_log (script_name, script_details) values ("016_TaskE","Created a Procedure that gets the top employee within a certain duration");

call get_top_employee_by_duration('2024-02-01', '2024-02-28');
