USE sakila;

SHOW TABLES;

-- CORRECTED TYPO. In Challenge 2 - 1.3 exercise I had put "ORDER BY num_films_rating" instead of "ORDER BY rating_num_films".
-- Now is corrected.

-- Challenge 1.

-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
SELECT * FROM sakila.film;
SELECT MAX(length) AS max_dur, MIN(length) AS min_dur
FROM sakila.film;

-- 1.2. Express the average movie duration in hours and minutes. Don't use decimals. Hint: look for floor and round functions.
SELECT
    FLOOR(AVG(length) / 60) AS avg_hours,
    ROUND((AVG(length) % 60),0) AS avg_minutes
FROM sakila.film;

-- 2.1. Calculate the number of days that the company has been operating.
-- Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.
SELECT DATEDIFF(MAX(rental_date), MIN(rental_date))  as date_dif
FROM sakila.rental;

-- 2.2. Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
SELECT *, MONTHNAME(rental_date) AS 'rent_month',
		  DAYNAME(rental_date) AS 'rent_weekday' 
FROM sakila.rental
LIMIT 20;

-- 2.3 Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday',depending on the day of the week.
-- Hint: use a conditional expression.
SELECT *,
CASE
WHEN DAYNAME(rental_date) IN ('Saturday', 'Sunday') then 'weekend'
ELSE 'workday'
END AS 'DAY_TYPE'
FROM sakila.rental;

-- 3. We need to ensure that our customers can easily access information about our movie collection.
-- To achieve this, retrieve the film titles and their rental duration.
-- If any rental duration value is NULL, replace it with the string 'Not Available'.
-- Sort the results by the film title in ascending order.
-- Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.
SELECT title,
CASE
WHEN ISNULL(rental_duration) then 'Not Available'
ELSE rental_duration
END AS rental_duration_2
FROM sakila.film
ORDER BY title ASC;

-- 4. As a marketing team for a movie rental company, we need to create a personalized email campaign for our customers. To achieve this, we want
-- to retrieve the concatenated first and last names of our customers, along with the first 3 characters of their email address,
-- so that we can address them by their first name and use their email address to send personalized recommendations.
-- The results should be ordered by last name in ascending order to make it easier for us to use the data.
SELECT concat(first_name, last_name, left(email,3)) AS name_campaign
FROM sakila.customer
ORDER BY last_name ASC;


-- Challenge 2.
-- 1.1 The total number of films that have been released.
SELECT COUNT(DISTINCT film_id) AS num_films
FROM sakila.film;

-- 1.2 The number of films for each rating.
SELECT rating, COUNT(DISTINCT film_id) AS rating_num_films
FROM sakila.film
GROUP BY rating;

-- 1.3 The number of films for each rating, and sort the results in descending order of the number of films.
-- This will help us better understand the popularity of different film ratings and adjust our purchasing decisions accordingly.
SELECT rating, COUNT(DISTINCT film_id) AS rating_num_films
FROM sakila.film
GROUP BY rating
ORDER BY rating_num_films DESC;

-- 2. We need to track the performance of our employees. Using the rental table, determine the number of rentals processed by each employee.
-- This will help us identify our top-performing employees and areas where additional training may be necessary.
SELECT staff_id, COUNT(DISTINCT rental_id) AS staff_num_rentals
FROM sakila.rental
GROUP BY staff_id;

-- 3.1 The mean film duration for each rating, and sort the results in descending order of the mean duration.
-- Round off the average lengths to two decimal places. This will help us identify popular movie lengths for each category.
SELECT rating, ROUND(AVG(length),2) AS ratings_avg_length
FROM sakila.film
GROUP BY rating
ORDER BY ratings_avg_length DESC;

-- 3.2 Identify which ratings have a mean duration of over two hours, to help us select films for customers who prefer longer movies.
SELECT rating, ROUND(AVG(length),2) AS ratings_avg_length
FROM sakila.film
GROUP BY rating
HAVING ratings_avg_length>120;

-- 4. Determine which last names are not repeated in the table actor.
SELECT last_name, COUNT(last_name) AS count_last_name
FROM sakila.actor
GROUP BY last_name
HAVING count_last_name<2;