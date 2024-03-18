create table customer (
    id int not null auto_increment primary key,
    customer_name varchar(100)
);

alter table rating
add column rater_id int;

alter table rating
add column  rating_timestamp datetime default now();

alter table rating
drop column is_up_vote;


alter table rating
add constraint fk_rater_id
foreign key (rater_id)
references customer(id);


use kids_shop;
drop procedure if exists recalculate_product_rating;
delimiter //
create procedure recalculate_product_rating()
begin
    update product p
    set average_rating = 
		round(
			ifnull(
				(select avg(rating) 
                from rating 
                where product_id = p.id), 0
			),1
		)
	where 1=1;
end;//
delimiter ;

insert into change_log (script_name, script_details) values ("003_TaskA1","Updated ratings table and created customer table to handle customer Rating submission Added a Procedure to calculate average rating");