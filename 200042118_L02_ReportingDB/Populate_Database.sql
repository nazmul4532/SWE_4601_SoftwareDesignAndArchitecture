insert into customer(customer_name) values
    ("Nazmul"),
    ("Nafisa"),
    ("Sian"),
    ("Dihan"),
    ("Akash"),
    ("Shanta"),
    ("Jawad");

insert into rating (product_id, rating, rater_id) values
	(1,2,1),
    (2,2,1),
    (3,2,1),
    (3,2,1),
    (5,1,1),
    (6,2,1),
    (1,4,2),
    (2,5,2),
    (5,3,3),
    (2,4,3),
    (6,5,4),
    (3,3,4),
    (3,5,5),
    (2,4,6),
    (5,5,7);
    
call recalculate_product_rating(); 

-- i donot know if i should keep exisiting price fields null or not... 
-- unlike who rated which product... the price field is more important so i am populating it

update product
set price = 69.99
where 1=1;



insert into employee (employee_name) values
	("Shakkhor"),
    ("Dayan"),
    ("Tanzim");
    
insert into invoice (customer_id,seller_id,date_time) values
	(1,1,'2024-02-09'),
    (4,2,'2024-02-09'),
    (3,3,'2024-02-09'),
    (1,2,'2024-02-10'),
    (2,1,'2024-02-10'),
    (5,3,'2024-02-10'),
    (1,3,'2024-02-11'),
    (6,2,'2024-02-11'),
    (7,1,'2024-02-11');
    
insert into sale (product_id,invoice_id,unit_price,sale_count) values
	(1,1,79.99,4),
    (2,4,59.99,2),
    (3,7,89.99,5),
	(4,7,89.99,5),
	(5,4,59.99,2),
	(6,1,59.99,2);
    
insert into sale (product_id,invoice_id,sale_count) values
	(6,2,4),
    (3,2,2),
    (2,3,2),
    (5,3,5),
    (1,5,4),
    (2,5,3),
    (3,6,5),
    (4,6,2),
    (5,6,2),
    (2,8,3),
    (3,8,2),
    (5,9,4),
    (6,9,4);
    
insert into change_log (script_name, script_details) values ("011_PopulateDatabase","Added new data to the Table to test features");
