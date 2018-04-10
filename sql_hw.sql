use sakila;

-- 1a --
SELECT first_name, last_name
FROM actor;

-- 1b --
SELECT CONCAT(first_name, ' ', last_name) as `Actor Name`
FROM actor;

-- 2a --
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name LIKE 'JOE';

-- 2b --
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c --
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name ASC;

-- 2d --
SELECT country_id, country 
FROM country
WHERE country IN ('Bangladesh','China','Afghanistan');

-- 3a --
ALTER TABLE actor
ADD middle_name VARCHAR(30)
AFTER first_name;

-- 3b --
ALTER TABLE actor
MODIFY middle_name BLOB;

-- 3c --
ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a --
SELECT last_name, COUNT(last_name) AS freq
FROM actor
GROUP BY last_name
ORDER BY freq DESC;

-- 4b --
SELECT last_name, COUNT(last_name) AS freq
FROM actor
GROUP BY last_name HAVING freq > 1
ORDER BY freq DESC;

-- 4c --
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name LIKE 'GROUCHO' AND last_name LIKE 'WILLIAMS';

-- 4d --
-- UPDATE actor
-- IF first_name = 'HARPO'
-- WHERE last_name LIKE 'WILLIAMS'
-- 	BEGIN
--     SET first_name = 'GROUCHO'
--     END;

-- 5a ---
SHOW CREATE TABLE address;

-- 6a --
SELECT staff.first_name, staff.last_name, address.address 
FROM staff JOIN address
ON staff.address_id = address.address_id;

-- 6b --
SELECT SUM(payment.amount) AS august_rev, staff.first_name, staff.last_name
FROM payment JOIN staff
ON staff.staff_id = payment.staff_id
WHERE payment.payment_date >= '2005-08-01' AND payment.payment_date <= '2005-08-31'
GROUP BY payment.staff_id;

-- 6c --
SELECT COUNT(film_actor.actor_id) AS num_actors, film.title, film.film_id 
FROM film JOIN film_actor
ON film_actor.film_id = film.film_id
GROUP BY film_actor.film_id;

-- 6d --
SELECT COUNT(inventory.inventory_id) AS num_copies, film.title
FROM inventory JOIN film
ON inventory.film_id = film.film_id
WHERE film.title LIKE 'HUNCHBACK IMPOSSIBLE';

-- 6e --
SELECT SUM(payment.amount) AS total_spent, customer.first_name, customer.last_name
FROM payment JOIN customer
ON payment.customer_id = customer.customer_id
GROUP BY payment.customer_id
ORDER BY customer.last_name;

-- 7a --
SELECT film.title
FROM film
WHERE (film.title LIKE 'K%' or film.title LIKE 'Q%') AND film.language_id = 1;

-- 7b --
SELECT actor.first_name, actor.last_name, actor.actor_id
FROM actor
WHERE actor.actor_id IN (SELECT film_actor.actor_id FROM
						film_actor JOIN film
						ON film_actor.film_id = film.film_id
						WHERE film.title LIKE 'ALONE TRIP');

-- 7c --
SELECT customer.first_name,customer.last_name,customer.email
FROM customer JOIN address
ON customer.address_id = address.address_id
WHERE address.city_id IN(
						SELECT city.city_id
						FROM city JOIN country
						ON city.country_id = country.country_id
						WHERE country.country LIKE 'Canada'
);

-- 7d --
SELECT title, film_id
FROM film
WHERE film_id IN(
			SELECT film_category.film_id 
			FROM category JOIN film_category
			ON category.category_id = film_category.category_id
			WHERE category.name LIKE 'Family'
);

-- 7e --
SELECT COUNT(rental.inventory_id) as num_rentals, inventory.film_id, film.title 
FROM rental JOIN inventory
ON rental.inventory_id = inventory.inventory_id
JOIN film
ON inventory.film_id = film.film_id
GROUP BY inventory.film_id
ORDER BY num_rentals DESC;

-- 7f --
SELECT SUM(payment.amount) AS total_rev, store.store_id
FROM payment JOIN staff
ON payment.staff_id = staff.staff_id
JOIN store
ON staff.store_id = store.store_id
GROUP BY store.store_id;

-- 7g --
SELECT address.address, city.city, country.country, store.store_id 
FROM address JOIN store
ON address.address_id = store.address_id
JOIN city
ON address.city_id = city.city_id
JOIN country
on city.country_id = country.country_id;

-- 7h --
SELECT SUM(payment.amount) as genre_rev, category.name
FROM rental JOIN payment
ON rental.rental_id = payment.rental_id
JOIN inventory
ON inventory.inventory_id = rental.inventory_id
JOIN film_category
ON inventory.film_id = film_category.film_id
JOIN category
ON category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY genre_rev DESC
LIMIT 5;

-- 8a --
CREATE VIEW top_five_genres AS
SELECT SUM(payment.amount) as genre_rev, category.name
FROM rental JOIN payment
ON rental.rental_id = payment.rental_id
JOIN inventory
ON inventory.inventory_id = rental.inventory_id
JOIN film_category
ON inventory.film_id = film_category.film_id
JOIN category
ON category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY genre_rev DESC
LIMIT 5;

-- 8b --
SELECT * FROM top_five_genres;

-- 8c --
DROP VIEW top_five_genres;