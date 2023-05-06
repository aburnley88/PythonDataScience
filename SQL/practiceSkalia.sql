What are the film categories in inventory?

SELECT f.title
      ,c.name category
      ,f.release_year
      ,f.rating
FROM film f
JOIN  film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
ORDER BY release_year ASC


What is the lifetime range of the dataset?
SELECT rental_id
      ,rental_date
      ,return_date
FROM rental r

We want to understand more about the movies that families are watching.
The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.
Wth rating not NC-17 or R

family movies with appropriate ratings =

WITH family_films AS(
SELECT i.inventory_id
	  ,f.title
      ,c.name
      ,f.rating
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
JOIN inventory i
ON f.film_id = i.film_id
WHERE f.rating NOT IN ('NC-17', 'R')
AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
ORDER BY 2, 1 ASC),
all_rentals_with_title AS(
SELECT r.rental_id
      ,f.title
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
on f.film_id = i.film_id
ORDER BY rental_id ASC)
SELECT family_films.title
      ,family_films.name
FROM family_films f
JOIN all_rentals_with_title a
ON f.title = a.title


family films with rental duraiton

WITH t1 AS(
  SELECT AVG(rental_duration) avg
  FROM film
)
SELECT f.title
      ,c.name
	    ,f.rental_duration
      ,NTILE(4) OVER (PARTITION BY c.name ORDER BY t1.avg )   standard_quartile
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
WHERE f.rating NOT IN ('NC-17', 'R')
AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
ORDER BY 2, 1 ASC


Now we need to know how the length of rental duration of these family-friendly movies compares to the duration
that all movies are rented for. Can you provide a table with the movie titles and divide them in
to 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%)
of the average rental duration(in the number of days) for movies across all categories?
Make sure to also indicate the category that these family-friendly movies fall into.


WHERE t3.title IN ('Sweethearts Suspects', 'Bilko Anonymous', 'Wait Cider', 'Daughter Madigan', 'Turn Star', 'Rush Goodfellas')

WITH T1 AS(
SELECT f.title
      ,c.name
      ,f.rental_duration
      ,f.rating
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON c.category_id = fc.category_id),
T2 AS (
   SELECT AVG(t1.rental_duration) AS avg_duration
   FROM film),
T3 AS(
SELECT t1.title
      ,t1.name
      ,t1.rental_duration
      ,t2.avg_duration
      ,NTILE(4) OVER (PARTITION BY t1.title ORDER BY t2.avg_duration) standard_quartile
FROM t1
JOIN t2
ON t1.rental_duration <= t2.avg_duration OR t1.rental_duration >= t2.avg_duration
WHERE t1.rating NOT IN ('NC-17', 'R')
AND t1.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 1,2,3,4 )
SELECT t3.title
      ,t3.name
      ,t3.rental_duration
      ,t3.standard_quartile
FROM t3

Are rentals trending up or down over time

SELECT DATE_TRUNC('month', r.rental_date) rental_month
      ,COUNT(*) OVER (ORDER BY DATE_TRUNC('month', rental_date))
FROM rental

We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for.
Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month.
Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.


SELECT DATE_PART('month', DATE_TRUNC('month', rental_date)) rental_month
      ,DATE_PART('year', DATE_TRUNC('year', rental_date)) rental_year
      ,s.store_id
      ,COUNT(*) rental_count
FROM store s
JOIN staff sf
ON s.store_id = sf.store_id
JOIN rental r
ON sf.staff_id = r.staff_id
GROUP BY 1,2,3


SELECT DATE_PART('month', r1.rental_date) AS rental_month,
       DATE_PART('year', r1.rental_date) AS rental_year,
       ('Store ' || s1.store_id) AS store,
       COUNT(*)
  FROM store AS s1
       JOIN staff AS s2
        ON s1.store_id = s2.store_id
       JOIN rental r1
        ON s2.staff_id = r1.staff_id
 GROUP BY 1, 2, 3
 ORDER BY 2, 1;
