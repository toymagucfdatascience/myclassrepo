USE sakila;
SHOW tables;
desc country;
show databases 1000;   
-- 1a. Display the first and last names of all actors from  the table actor. 
SELECT first_name, last_name FROM actor; 
  
-- 1b. Display the first and last name of each actor in a single column in upper case letters .Name the column Actor Name .
SELECT UPPER (CONCAT(first_name, ' ', last_name)) AS "Actor Name" FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor 
WHERE first_name = "joe";

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE "%GEN%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT first_name, last_name FROM actor WHERE last_name LIKE "%LI%"
ORDER BY last_name ASC, first_name ASC;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
 SELECT country_id, country FROM country WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).            
-- Add a middle_name column  to the  actor. position it between first_name and last_name.

ALTER TABLE actor
ADD COLUMN middle_name VARCHAR (50);

ALTER TABLE actor MODIFY middle_name VARCHAR (50) AFTER first_name;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;

-- now delete the `middle_name` column
ALTER TABLE actor DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(last_name)as multiples
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) AS last_name_count
FROM actor
GROUP BY last_name
HAVING last_name_count > 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "williams";

 -- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name = IF(first_name="HARPO", "GROUCHO", "MUCHO GROUCHO")
WHERE actor_id = 172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
SHOW CREATE TABLE address;
  CREATE TABLE `address` (
   `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
   `address` varchar(50) NOT NULL,
    `address2` varchar(50) DEFAULT NULL,
   `district` varchar(20) NOT NULL,
    `city_id` smallint(5) unsigned NOT NULL,
   `postal_code` varchar(10) DEFAULT NULL,
   `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
   SPATIAL KEY `idx_location`(`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
  ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8
    

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT s.first_name, s.last_name, a.address, c.city, co.country
FROM staff AS s
LEFT JOIN address AS a
ON s.address_id = a.address_id
LEFT JOIN city AS c
ON a.city_id = c.city_id
LEFT JOIN country as co
ON c.country_id = co.country_id;


-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT * from payment;

SELECT * from  staff;

SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) as total_sales
FROM payment AS p
INNER JOIN staff AS s
ON p.staff_id = s.staff_id
WHERE Payment_date BETWEEN  "20050801" AND "20050901"
GROUP BY s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT * FROM film_actor;
SELECT * FROM film;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title, COUNT(F.title) AS num FROM film AS f
INNER JOIN inventory AS I
ON f.film_id = i.film_id
WHERE f.title = "Hunchbank Impossible"
GROUP BY f.title;
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT * from payment;
SELECT * from customer;

SELECT c.first_name, c.last_name, sum(p.amount) AS total_paid FROM payment AS P
INNER JOIN CUSTOMET AS c
ON p.customer_id = c.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name, c.first_name;

SELECT * from payment;
SELECT * from customer;

SELECT c.first_name, c.last_name, sum(p.amount) AS total_paid FROM payment AS P
INNER JOIN customer AS c
ON p.customer_id = c.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name, c.first_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

select * from language;
SELECT  title FROM FILM
WHERE title LIKE "Q%" OR title LIKE "K%"
AND language_id = (
  sELECT language_id FROM language
WHERE name = "English");

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT * from actor;

SELECT first_name, last_name FROM actor 
WHERE actor_id IN (
		SELECT actor_id FROM film_actor
WHERE film_id = (
	   SELECT film_id FROM film
WHERE title = "Alone Trip"));


-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT c.first_name, c.last_name, c.email
FROM customer AS c 
INNER JOIN address AS a 
    ON c.address_id = a.address_id
INNER JOIN city AS cy
    ON a.city_id = cy.city_id
INNER JOIN country AS co 
    ON cy.country_id = co.country_id
WHERE co.country = "Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT  title
FROM FILM 
WHERE film_id IN (

SELECT film_id
FROM film_category
WHERE category_id = (

	SELECT category_id
    FROM category
    WHERE name = "Family"
    )
);

--- 7e.Display the most frequently rented movies in descending ordet.
SELECT f.title, COUNT(f.title) AS rent_count
FROM rental AS r
INNER JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
INNER JOIN film AS f
    ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rent_count DESC;

--- 7F. Write a query to display how much business, in dollars, each store brought in.
SELECT a.address, cy.city, co.country, SUM(p.amount) AS total_revenue
FROM store AS s
INNER JOIN address AS a
    ON s.address_id = a.address_id
INNER JOIN customer AS c
    ON s.store_id=c.store_id
INNER JOIN payment AS p
    ON p.customer_id = c.customer_id
INNER JOIN city AS cy
    ON cy.city_id = a.city_id
INNER JOIN country AS co
    ON co.country_id = cy.country_id
GROUP BY a.address, cy.city, co.country;

   
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, a.address, cy.city, co.country
FROM store AS s
INNER JOIN address AS a
   ON s.address_id = a.address_id
INNER JOIN city AS cy 
   ON cy.city_id = a.city_id
INNER JOIN country AS co
   ON co.country_id = cy.country_id;


-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name, SUM(p.amount) AS gross_revenue
FROM category AS c
INNER JOIN film_category AS fc
    ON c.category_id = fc.category_id
INNER JOIN inventory AS i
    ON fc.film_id = i.film_id
INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
INNER JOIN payment AS p
    ON r.rental_id = p.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top5_genre_gross_revenue AS
SELECT c.name, SUM(p.amount) AS gross_revenue
FROM category AS c
INNER JOIN film_category AS fc
    ON c.category_id = fc.category_id
INNER JOIN inventory AS i
    ON fc.film_id = i.film_id
INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
INNER JOIN payment AS p
    ON r.rental_id = p.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;


   
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top5_genre_gross_revenue;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW IF EXISTS top5_genre_gross_revenue;
































SELECT 
  address as a,
  city as cy,
  country as co,
  SUM (p.amount) AS total_revenue
FROM store AS s
INNER JOIN  address AS a
   ON s.address_id = a.address_id
   INNER JOIN customer AS c
   ON s.store_id = c.store_id
   INNER JOIN payment AS p
   ON p.customer_id =c.customer_id
   INNER JIN  city AS cy
   ON cy.city_id = a.city_id
   INNER JOIN country AS co 
   ON co.country_id = cy.country_id
   GROUP BY a.address, cy.city, co.country













