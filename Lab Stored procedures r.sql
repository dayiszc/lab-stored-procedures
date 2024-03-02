use sakila;

-- In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
-- Convert the query into a simple stored procedure. Use the following query:
select first_name, last_name, email
from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = "Action"
group by first_name, last_name, email;

drop procedure if exists get_customers;
delimiter //
create procedure get_customers()
begin
	select first_name, last_name, email
	  from customer
	  join rental on customer.customer_id = rental.customer_id
	  join inventory on rental.inventory_id = inventory.inventory_id
	  join film on film.film_id = inventory.film_id
	  join film_category on film_category.film_id = film.film_id
	  join category on category.category_id = film_category.category_id
	  where category.name = "Action"
	  group by first_name, last_name, email
      order by customer.customer_id;
end //
delimiter ;

call get_customers;


-- Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string argument 
-- for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.

drop procedure if exists get_customers;

delimiter //
create procedure get_customers(in category varchar(10))
begin
	select first_name, last_name, email
	  from customer
	  join rental on customer.customer_id = rental.customer_id
	  join inventory on rental.inventory_id = inventory.inventory_id
	  join film on film.film_id = inventory.film_id
	  join film_category on film_category.film_id = film.film_id
	  join category on category.category_id = film_category.category_id
	  where category.name = category
	  group by first_name, last_name, email
      order by customer.customer_id;
end //
delimiter ;

call get_customers("animation");

-- Write a query to check the number of movies released in each movie category
select name, count(f.film_id) number_of_films
from film_category f
inner join category c
using (category_id)
group by f.category_id;

-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number
drop procedure if exists get_films_in_category;
delimiter //
create procedure get_films_in_category()
begin
	select name, count(f.film_id) number_of_films
	from film_category f
	join category c
	using (category_id)
	group by f.category_id
	having number_of_films > 50;
end //
delimiter ;

call get_films_in_category;


-- Pass that number as an argument in the stored procedure
drop procedure if exists get_films_in_category;
delimiter //
create procedure get_films_in_category(in low_limit smallint)
begin
	select name, count(f.film_id) number_of_films
	from film_category f
	join category c
	using (category_id)
	group by f.category_id
	having number_of_films > low_limit;
end //
delimiter ;

call get_films_in_category(50);