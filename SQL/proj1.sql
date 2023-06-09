 /*Create a query that lists each movie, the film category it is classified
 in, and the number of times it has been rented out.*/

 SELECT f.title film_title
       ,c.name category
       ,COUNT(*) AS rental_count
 FROM category AS c
 JOIN film_category AS fc
 ON c.category_id = fc.category_id
 AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
 JOIN film AS f
 ON f.film_id = fc.film_id
 JOIN inventory AS i
 ON f.film_id = i.film_id
 JOIN rental AS r
 ON i.inventory_id = r.inventory_id
 GROUP BY 1,2
 ORDER BY 2,1

/*Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that
all movies are rented for. Can you provide a table with the movie titles and divide them into 4 levels
(first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%)
of the average rental duration(in the number of days) for movies across all categories?
Make sure to also indicate the category that these family-friendly movies fall into. */

SELECT *,
       NTILE(4) OVER(ORDER BY AVG(t1.rental_duration)) AS standard_quartile
  FROM (SELECT f.title,
			         c.name,
	  		       f.rental_duration
          FROM category AS c
	             JOIN film_category AS fc
	              ON 	c.category_id = fc.category_id
                AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')

               JOIN film AS f
	              ON f.film_id = fc.film_id
	       ORDER BY 2, 1) t1
		   GROUP BY 1,2,3

       /*
       Question 3:
       Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category.
       */

       SELECT t.name,
              t.standard_quartile,
              COUNT(*)
         FROM (SELECT c.name,
                      f.rental_duration,
                      NTILE(4) OVER(ORDER BY f.rental_duration) AS standard_quartile
                 FROM category AS c
                      JOIN film_category AS fc
                       ON c.category_id = fc.category_id
                       AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
                      JOIN film AS f
                       ON f.film_id = fc.film_id) AS t
        GROUP BY 1, 2
        ORDER BY 1, 2;
/*We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for. Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the
following: year, month, store ID and count of rental orders fulfilled during that month. */
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
