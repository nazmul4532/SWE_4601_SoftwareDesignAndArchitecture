alter table vote
rename to rating;

alter table rating
add column rating int default 0;

update rating set rating = 1 where is_up_vote = 0;

update rating set rating = 5 where is_up_vote = 1;

alter table product
change column votes average_rating float;