alter table sale 
add column date_time datetime default now() ;

alter table sale
add column seller_id int;
alter table sale
add constraint fk_seller_id
foreign key (seller_id)
references employee(id);

alter table sale 
add column category_id int;
alter table sale
add constraint fk_category_id
foreign key (category_id)
references category(id);

alter table category
add column average_rating float;

alter table invoice
add column total_price int;

insert into change_log (script_name, script_details) values ("005_TaskB1a","Added Redundant Columns and Procedures inorder to enable average_rating");
