create table employee (
id int not null auto_increment primary key,
employee_name varchar(100)
);

create table invoice (
id int not null auto_increment primary key,
customer_id int not null,
seller_id int not null,
date_time date,
foreign key (customer_id) references customer(id),
foreign key (seller_id) references employee(id)
);

create table sale (
id int not null auto_increment primary key,
product_id int not null,
invoice_id int not null,
unit_price float,
sale_count int,
foreign key (product_id) references product(id),
foreign key (invoice_id) references invoice(id)
);

drop trigger if exists before_insert_sale
delimiter //
create trigger before_insert_sale
before insert on sale
for each row
	if new.unit_price is null then
		set new.unit_price = (select price from product where id = new.product_id);
	end if;
//
delimiter ;