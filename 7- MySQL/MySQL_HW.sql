/*------------------------------
|## Unit 10 Assignment - HW SQL |
|	   Lissette Miranda			|	
|-------------------------------|*/
#1a. Display the first and last names of all actors from the table `actor`.
USE sakila;
SELECT first_name, last_name 
FROM actor;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. 
#Name the column `Actor Name`.
SELECT CONCAT (first_name,' ',last_name) AS 'Actor Name'
FROM actor ;

#2a. Find the ID number, first name, and last name of an actor, of whom the first name, "Joe." 
SELECT actor_id, first_name, last_name 
FROM actor WHERE first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters `GEN`:
SELECT actor_id, first_name, last_name 
FROM actor WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. 
      #This time, order the rows by last name and first name, in that order:
SELECT actor_id,first_name,last_name 
FROM actor WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name; -- this orders alphabetically by last name

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: 
	  #Afghanistan, Bangladesh, and China:
SELECT country, country_id
FROM country
WHERE country IN ('Afghanistan','Bangladesh','China');

#3a. Create a column in the table `actor` named `description` and 
#use the data type `BLOB`
ALTER TABLE actor
-- #LM Notes: DROP COLUMN description;
ADD COLUMN description BLOB;
SELECT * FROM actor; -- to show table

-- 3b. Delete the `description` column.
ALTER TABLE actor
DROP COLUMN description;
SELECT * FROM actor; -- to show table

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,
COUNT(*) AS ln_count 
FROM actor
GROUP BY last_name; 

-- 4b. List last names of actors and the number of actors who have that last name, 
      #but only for names that are shared by at least two actors.
SELECT DISTINCT last_name, 
COUNT(*) AS 'name_count' 
FROM actor 
GROUP BY last_name HAVING name_count >= 2;
-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO 
      /* WILLIAMS`. Write a query to fix the record.
	  1.LM notes: Check if there is another GROUCHO in the table*/ 
SELECT COUNT(*) FROM actor WHERE first_name = 'GROUCHO';

   /* 2. LM notes:T here are 3 GROUCHOs, therefore we have to replace specifically the one with 
         lastname Williams*/-- SELECT * FROM actor WHERE last_name = 'WILLIAMS' AND first_name = 'GROUCHO';
UPDATE actor
SET 
	first_name = REPLACE (first_name, 'GROUCHO','HARPO')
WHERE last_name = 'WILLIAMS' AND first_name = 'GROUCHO';

	-- #LM Notes: Check if change was made by running this code
SELECT * FROM actor WHERE last_name = 'WILLIAMS';

/*-- 4d. In a single query, if the first name of the actor is currently 
`HARPO`, change it to `GROUCHO`.*/
-- LM notes: Safe mode needs to be updated due to error when code ran
SET SQL_SAFE_UPDATES=0;
UPDATE actor SET first_name = REPLACE(first_name,'HARPO','GROUCHO');
SELECT * FROM actor WHERE last_name = 'WILLIAMS';
SET SQL_SAFE_UPDATES=1;

#5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
DESCRIBE sakila.address;

/*#6a. Use `JOIN` to display the first and last names, as well as the address, of each staff 
   member. Use the tables `staff` and `address`:*/
USE sakila;
-- #LM Notes: Inspect tables to see what they contain
SELECT * FROM staff; -- 2 rows
SELECT * FROM address; -- 14 rows

-- Use JOIN to return addresses of staff members (should return 2 rows)
SELECT staff.first_name, 
	   staff.last_name, 
	   address.address
FROM staff
	JOIN address ON address.address_id= staff.staff_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
      #Use tables `staff` and `payment`.
      ##LM Notes: Use Aliases. Inspect payment table 
	  -- SELECT * FROM payment;
SELECT s.first_name, 
       s.last_name, 
       SUM(p.amount)
FROM staff AS s 
	JOIN payment AS p ON (p.staff_id= s.staff_id)
		WHERE payment_date >= '2005-08-01' AND payment_date <= '2005-08-30'
		GROUP BY s.first_name, s.last_name;
    
-- 6c. List each film and the number of actors who are listed for that film. Use tables 
      #`film_actor` and `film`. Use inner join.
	  #LM Notes: Inspect required tables 
	  -- SELECT * FROM film_actor;
SELECT * FROM film;
SELECT f.title AS 'Film Titles',
COUNT(DISTINCT a.actor_id) AS 'No. of Actors'
FROM film AS f
	INNER JOIN film_actor AS a ON (a.film_id = f.film_id)
		GROUP BY f.title;
-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT f.title as 'Film Title', COUNT(inventory_id) as 'No. of Film Copies'
FROM film AS f
	INNER JOIN inventory AS i ON (f.film_id = i.film_id)
		WHERE title = 'Hunchback Impossible';

/*-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
List the customers alphabetically by last name:*/
      -- Visualize required tables 
	-- SELECT * FROM payment;
	-- SELECT * FROM customer;

SELECT first_name AS 'First Name',
       last_name AS 'Last Name',
      SUM(amount) AS 'Total Amount Paid'
FROM payment AS p
	INNER JOIN customer AS c ON (p.customer_id=c.customer_id)
		GROUP BY p.customer_id
		ORDER BY last_name;
			  
/*#7a.Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is 
English.*/ -- Query within a query
SELECT title AS 'Movie Title'
FROM film 
WHERE language_id in	
	(SELECT language_id
    FROM language
    WHERE name = 'English')
AND (title LIKE 'K%') OR (title LIKE 'Q%');

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT first_name AS 'First N', 
	   last_name AS 'Last N'
FROM actor
WHERE actor_id in 
	(SELECT actor_id 
    FROM film_actor
    WHERE film_id in 
		(SELECT film_id 
        FROM film
        WHERE title = 'Alone Trip'));

/*7c. You want to run an email marketing campaign in Canada, for which you will need the names and 
email addresses of all Canadian customers. Use joins to retrieve this information.*/
SELECT c.first_name AS 'First N', 
	   c.last_name AS 'Last N', 
       c.email AS 'Email Address'
FROM customer AS c
	INNER JOIN address AS a ON (a.address_id= c.address_id)
	INNER JOIN city AS b ON (b.city_id= a.city_id)
	INNER JOIN country AS d ON (d.country_id= b.country_id)
		WHERE d.country = 'CANADA';

-- 7d. Identify all movies categorized as _family_ films.
	#LM Notes: Inspect table to be used for this query
	-- SELECT * FROM category;
	-- SELECT * FROM film; 
SELECT title, category
FROM film_list
WHERE category = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT i.film_id AS 'Film ID', 
       f.title AS 'Film Title', 
       COUNT(r.inventory_id) AS 'Inventory ID'
FROM inventory AS i
	INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
	INNER JOIN film_text AS f ON i.film_id = f.film_id
		GROUP BY r.inventory_id
		ORDER BY COUNT(r.inventory_id) DESC; -- specify DESC (bc ASC is default)

-- 7f. Write a query to display how much business, in dollars, each store brought in.
# LM Notes: use $ for amount in $$$
SELECT s.store_id AS 'Store ID', 
       CONCAT ('$', FORMAT(SUM(amount),2)) AS 'Amount'
FROM store AS s
	INNER JOIN staff AS st ON s.store_id = st.store_id
	INNER JOIN payment AS p ON p.staff_id = st.staff_id
		GROUP BY s.store_id
		ORDER BY SUM(amount);
    
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id AS 'Store Id', 
	   city AS 'City', 
       country AS 'Country'
FROM store AS s
	INNER JOIN customer AS c ON s.store_id = c.store_id
	INNER JOIN staff AS st ON s.store_id = st.store_id
	INNER JOIN address AS a ON c.address_id = a.address_id
	INNER JOIN city AS ct ON a.city_id = ct.city_id
	INNER JOIN country AS co ON ct.country_id = co.country_id;
    
/*-- 7h. List the top five genres in gross revenue in descending order. 
(**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)*/
#Inspect tables 
-- SELECT * FROM category;
-- SELECT * FROM film_category;
-- SELECT * FROM inventory;
-- SELECT * FROM payment;
-- SELECT * FROM rental;

SELECT c.name AS 'Top 5 Genres', 
	   CONCAT ('$', FORMAT(SUM(p.amount),2)) AS 'Gross Revenue'
FROM category c
	INNER JOIN film_category AS fc ON (c.category_id=fc.category_id)
	INNER JOIN inventory AS i ON (i.film_id = fc.film_id)
	INNER JOIN rental AS r ON (r.inventory_id = i.inventory_id)
	INNER JOIN payment AS p ON (r.rental_id=p.rental_id)
		GROUP BY c.name
		ORDER BY SUM(p.amount) DESC
        LIMIT 5;

/*8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross 
revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute 
another query to create a view.*/
CREATE VIEW Top_Five_Genres AS
SELECT c.name AS 'Top 5 Genres', 
	   CONCAT ('$', FORMAT(SUM(p.amount),2)) AS 'Gross Revenue'
FROM category c
	INNER JOIN film_category AS fc ON (c.category_id=fc.category_id)
	INNER JOIN inventory AS i ON (i.film_id = fc.film_id)
	INNER JOIN rental AS r ON (r.inventory_id = i.inventory_id)
	INNER JOIN payment AS p ON (r.rental_id=p.rental_id)
		GROUP BY c.name
		ORDER BY SUM(p.amount) DESC
        LIMIT 5;
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM Top_Five_Genres;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW Top_Five_Genres;

/*------------------------------
| 			MYSQL_HW			|
|	   		 FINITO				|	
|-------------------------------|*/
