alter table vote
rename to rating;

alter table rating
add column rating int default 0;

update rating set rating = 1 where is_up_vote = 0;

update rating set rating = 5 where is_up_vote = 1;

alter table product
change column votes average_rating float;

insert into change_log (script_name, script_details) values ("002_18","altered voting products and ratings table and updated ratings and votes accordingly");
