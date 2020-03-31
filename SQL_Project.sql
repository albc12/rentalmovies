###Practice Quiz #1

/* Let's start with creating a table that provides the following details: actor's first and last name combined as full_name, film title, film description and length of the movie.
*/

SELECT CONCAT(a.first_name,' ', a.last_name) AS full_name, f.title film_title, f.description film_description, f.length length
 FROM film f
 JOIN film_actor fa
  ON f.film_id = fa.film_id
 JOIN actor a
  ON a.actor_id = fa.actor_id
 GROUP BY a.first_name, a.last_name, f.title, f.description, f.length

 /* Write a query that creates a list of actors and movies where the movie length was more than 60 minutes. How many rows are there in this query result?
 */
 SELECT CONCAT(a.first_name,' ', a.last_name) AS full_name, f.title film_title, f.length length
  FROM film f
  JOIN film_actor fa
   ON f.film_id = fa.film_id
  JOIN actor a
   ON a.actor_id = fa.actor_id
 WHERE f.length > 60
 GROUP BY a.first_name, a.last_name, f.title, f.length;

 /* Write a query that captures the actor id, full name of the actor, and counts the number of movies each actor has made. (HINT: Think about whether you should group by actor id or the full name of the actor.) Identify the actor who has made the maximum number movies.
 */

#OPTION 1

WITH t1 AS (SELECT a.actor_id As a_id, CONCAT(a.first_name,' ', a.last_name) AS full_name, f.film_id AS f_id
     FROM film f
     JOIN film_actor fa
      ON f.film_id = fa.film_id
     JOIN actor a
      ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, a.first_name, a.last_name, f.film_id
    )

SELECT a_id, full_name, COUNT(f_id) AS tot_film
 FROM t1
GROUP BY 1,2
ORDER BY 3 DESC;


###Practice Quiz #2

11. a. /* Write a query that displays a table with 4 columns: actor's full name, film title, length of movie, and a column name "filmlen_groups" that classifies movies based on their length. Filmlen_groups should include 4 categories: 1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours.
*/

SELECT CONCAT(a.first_name,' ', a.last_name) AS full_name,
        f.title film_title,
        f.length length,
        CASE WHEN length <= 60 THEN '1 hour or less'
             WHEN length BETWEEN 61 AND 120 THEN 'Between 1-2 hours'
             WHEN length BETWEEN 121 AND 180 THEN 'Between 2-3 hours'
             ELSE 'More than 3 hours' END AS Filmlen_groups
 FROM film f
 JOIN film_actor fa
  ON f.film_id = fa.film_id
 JOIN actor a
  ON a.actor_id = fa.actor_id
GROUP BY 1,2,3, filmlen_groups
ORDER BY length DESC;

11. b. /* Revise the query you wrote above to create a count of movies in each of the 4 filmlen_groups: 1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours.
*/

WITH t1 AS (SELECT f.title title,
                f.length length,
                CASE WHEN length <= 60 THEN '1 hour or less'
                     WHEN length BETWEEN 61 AND 120 THEN 'Between 1-2 hours'
                     WHEN length BETWEEN 121 AND 180 THEN 'Between 2-3 hours'
                     ELSE 'More than 3 hours' END AS Filmlen_groups
           FROM film f)

SELECT DISTINCT(filmlen_groups),
COUNT(title) OVER (PARTITION BY filmlen_groups) AS filmcount_bylencat
FROM t1
ORDER BY filmlen_groups;

###Question Set 1
12. Q1. /* Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.
For this query, you will need 5 tables: Category, Film_Category, Inventory, Rental and Film. Your solution should have three columns: Film title, Category name and Count of Rentals.
The following table header provides a preview of what the resulting table should look like if you order by category name followed by the film title.
HINT: One way to solve this is to create a count of movies using aggregations, subqueries and Window functions.
*/

SELECT f.title film_title, c.name category_name, count(rental_id) AS rental_count
       FROM film f
       JOIN film_category fc
        ON f.film_id = fc.film_id
       JOIN category c
        ON fc.category_id = c.category_id
       JOIN inventory i
        ON  i.film_id = f.film_id
       JOIN rental r
        ON r.inventory_id = i.inventory_id
      GROUP BY 1,2
      HAVING c.name IN ('Animation','Children','Classics','Comedy','Family','Music')
      ORDER BY 2

12. Q2. /* Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for.
Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%)
of the rental duration for movies across all categories? Make sure to also indicate the category that these family-friendly movies fall into.
*/

SELECT f.title film_title, c.name category_name, f.rental_duration rental_duration,
       NTILE(4) OVER (ORDER BY rental_duration) AS standard_quartile
   FROM film f
   JOIN film_category fc
    ON f.film_id = fc.film_id
   JOIN category c
    ON fc.category_id = c.category_id
WHERE c.name IN ('Animation','Children','Classics','Comedy','Family','Music')
ORDER BY 4

12. Q3. /* Finally, provide a table with the family-friendly film category, each of the quartiles,
and the corresponding count of movies within each combination of film category for each corresponding rental duration category.
The resulting table should have three columns:
    Category
    Rental length category
    Count
*/

WITH t1 AS(SELECT c.name category_name, f.rental_duration rental_duration,
           NTILE(4) OVER (ORDER BY rental_duration) AS standard_quartile
               FROM film f
               JOIN film_category fc
                ON f.film_id = fc.film_id
               JOIN category c
                ON fc.category_id = c.category_id
            WHERE c.name IN ('Animation','Children','Classics','Comedy','Family','Music')
            )

SELECT category_name, standard_quartile, COUNT(category_name)
 FROM t1
GROUP BY 1,2
ORDER BY 1, 2

###Question Set 2

13. Q1. /* We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for. Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.
*/

SELECT DATE_PART('month', r.rental_date) AS rental_month,
    DATE_PART('year', r.rental_date) AS rental_year,
    sto.store_id as Store_id,
    COUNT(*) AS count_rentals
      FROM store sto
      JOIN staff sta
      ON sto.store_id = sta.store_id
      JOIN rental r
      ON sta.staff_id = r.staff_id
      GROUP BY 1, 2,3
      ORDER BY 2, 1


13. Q2. /* We would like to know who were our top 10 paying customers, how many payments they made on a monthly basis during 2007, and what was the amount of the monthly payments. Can you write a query to capture the customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers?
*/

#Top 10 Paying customers

WITH top10 AS(SELECT c.customer_id, CONCAT(c.first_name,' ', c.last_name) fullname, SUM(p.amount) as sum_pay
             FROM payment p
              JOIN customer c
              ON p.customer_id = c.customer_id
           GROUP BY 1,2
           ORDER BY 3 DESC
           LIMIT 10)

SELECT DATE_TRUNC('month', p.payment_date) pay_month,
       top10.fullname,
       COUNT(p.payment_date) pay_countpermon,
       SUM(p.amount) pay_amount
 FROM payment p
 JOIN top10
 ON p.customer_id = top10.customer_id
GROUP BY 1 , 2
ORDER BY 2

13. Q3 /* Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007.
Please go ahead and write a query to compare the payment amounts in each successive month. Repeat this for each of these 10 paying customers.
Also, it will be tremendously helpful if you can identify the customer name who paid the most difference in terms of payments.
*/

WITH top10 AS(SELECT c.customer_id, CONCAT(c.first_name,' ', c.last_name) AS fullname, SUM(p.amount) as sum_pay
             FROM payment p
              JOIN customer c
              ON p.customer_id = c.customer_id
           GROUP BY 1,2
           ORDER BY 3 DESC
           LIMIT 10)

SELECT DATE_TRUNC('month', p.payment_date) pay_month,
       top10.fullname AS top10_fullname,
       COUNT(p.payment_date) pay_countpermon,
       SUM(p.amount) pay_amount,
       LAG(SUM(p.amount)) OVER (PARTITION BY fullname ORDER BY SUM(p.amount)) AS lag,
       SUM(p.amount) - LAG(SUM(p.amount)) OVER (PARTITION BY fullname ORDER BY SUM(p.amount)) AS lag_difference
 FROM payment p
 JOIN top10
 ON p.customer_id = top10.customer_id
GROUP BY 1 , 2
ORDER BY 2
