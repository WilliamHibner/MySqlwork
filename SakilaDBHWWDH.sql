use sakila;

# 1a. Display the first and last names of all actors from the table `actor`.
select * from actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
select first_name, last_name from actor;
select concat(first_name, " ", last_name) 
as full_name from actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, 
#"Joe." What is one query would you use to obtain this information?
select * from actor 
where first_name = 'Joe';

# 2b. Find all actors whose last name contain the letters `GEN`:
select * from actor 
where last_name like '%GEN%';

# 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select * from actor where last_name like '%LI%'
order by first_name, last_name;

# 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

# 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
select * from actor;

ALTER TABLE actor
ADD COLUMN descR BLOB
AFTER last_name;

# 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
select * from actor;

ALTER TABLE actor
DROP COLUMN descR;
# 4a. List the last names of actors, as well as how many actors have that last name.
select * from actor;
select last_name, Count(last_name) as "Last Name"
from actor
group by last_name
having Count(last_name) > 1;

# 4b. List last names of actors and the number of actors who have that last name, 
#but only for names that are shared by at least two actors

select last_name, 
Count(last_name) as "Same Last Name"
from actor
group by last_name
having Count(last_name) => 2;


# 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor 
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

# 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct 
# name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor 
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';


# 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
describe sakila.address;
  # Hint: <https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html>

# 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT *
FROM staff;
SELECT *
FROM address;

SELECT first_name, last_name, address
FROM staff
INNER JOIN address
USING (address_id);
# 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.

SELECT *
FROM staff;
SELECT *
FROM payment;

SELECT first_name, last_name, address
FROM staff
INNER JOIN address
USING (address_id);

# 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT *
FROM film_actor;
SELECT *
FROM film;

SELECT title, COUNT(actor_id)
FROM film
INNER JOIN film_actor
USING (film_id)
GROUP BY(actor_id);

# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT *
FROM inventory;
SELECT *
FROM film;

SELECT lt.film_id, rt.title, count(lt.film_id) AS film_counts
FROM inventory AS lt
INNER JOIN film AS rt
USING(film_id)
GROUP BY lt.film_id
Having rt.title = "Hunchback Impossible";

# 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT *
FROM payment;
SELECT *
FROM customer;

SELECT lt.cusomer_id, rt.title, sum(lt.film_id) AS film_counts
FROM inventory AS lt
INNER JOIN film AS rt
USING(film_id)
GROUP BY lt.film_id
Having rt.title = "Hunchback Impossible";

# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters `K` and `Q` 
#have also soared in popularity. Use subqueries to display the titles of movies 
#starting with the letters `K` and `Q` whose language is English.

SELECT title FROM film
WHERE language_id in
	(SELECT language_id 
	FROM language
	WHERE name = "English" )
AND (title LIKE "K%") OR (title LIKE "Q%");

# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

SELECT last_name, first_name
FROM actor
WHERE actor_id in
	(SELECT actor_id FROM film_actor
	WHERE film_id in 
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));

# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT country, last_name, first_name, email
FROM country c
LEFT JOIN customer cu
ON c.country_id = cu.customer_id
WHERE country = 'Canada';

# 7d. Sales have been lagging among young families, and you wish to target all family
# movies for a promotion. Identify all movies categorized as family films.
SELECT title, category
FROM film_list
WHERE category = 'Family'

# 7e. Display the most frequently rented movies in descending order.
SELECT total_sales
FROM sales_by_film_category
ORDER BY total_sales DESC;

# 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, SUM(amount)
FROM store
INNER JOIN staff

# 8a. In your new role as an executive, you would like to have an easy way of viewing 
#the Top five genres by gross revenue. Use the solution from the problem above to 
#create a view. If you haven't solved 7h, you can substitute another query 
#to create a view.

CREATE VIEW top_five_genres AS

SELECT name, SUM(p.amount)
FROM category c
INNER JOIN film_category fc
INNER JOIN inventory i
ON i.film_id = fc.film_id
INNER JOIN rental r
ON r.inventory_id = i.inventory_id
INNER JOIN payment p
GROUP BY name
LIMIT 5;

# 8b. How would you display the view that you created in 8a?

SELECT  *  FROM top_five_genres;

# 8c. You find that you no longer need the view `top_five_genres`. 
DROP VIEW top_five_genres;




