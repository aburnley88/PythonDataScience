For each account, determine the average amount of each type of paper they purchased across their orders.
Your result should have four columns -
one for the account name and one for the average quantity purchased for each of the paper types for each account.
SELECT a.name, AVG(o.standard_qty) std, AVG(o.gloss_qty) gls, AVG(o.poster_qty) poster
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

For each account, determine the average amount spent per order on each paper type.
Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
SELECT a.name, AVG(o.standard_amt_usd) avg_spent_standard, AVG(o.gloss_amt_usd) avg_amt_spent_gls, AVG(o.poster_amt_usd) avg_amt_spent_poster
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

Determine the number of times a particular channel was used in the web_events table for each sales rep.
Your final table should have three columns -
the name of the sales rep, the channel, and the number of occurrences.
Order your table with the highest number of occurrences first.
SELECT r.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY num_events DESC;

Use DISTINCT to test if there are any accounts associated with more than one region.
SELECT a.id as "account id", r.id as "region id",
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

SELECT DISTINCT id, name
FROM accounts;

Have any sales reps worked on more than one account?
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;

SELECT DISTINCT id, name
FROM sales_reps;

Find the sales in terms of total dollars for all orders in each year,
ordered from greatest to least. Do you notice any trends in the yearly sales totals?
SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

SELECT account_id,
       occurred_at,
       total,
       CASE WHEN total > 500 THEN 'Over 500'
            WHEN total > 300 AND total <= 500 THEN '301 - 500'
            WHEN total > 100 AND total <=300 THEN '101 - 300'
            ELSE '100 or under' END AS total_group
FROM orders

sql SELECT CASE WHEN total > 500
THEN 'OVer 500' ELSE '500 or under' END AS total_group,
COUNT(*) AS order_count FROM orders GROUP BY 1

Write a query to display for each order, the account ID, the total amount of the order, and the level of the order
 ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.

 SELECT account_id, total_amt_usd,
 CASE WHEN total_amt_usd > 3000 THEN 'Large'
      WHEN total_amt_usd < 3000 THEN 'SMALL' END AS level
FROM orders;

Write a query to display the number of orders in each of three categories, based on the total number of items in each order.
The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
SELECT a.name,orders.id,CASE WHEN total >= 2000 THEN 'At Least 2000'
            WHEN total < 2000 AND total > 1000 THEN 'Between 1000 and 2000'
            WHEN total < 1000 THEN 'Less than 1000'
            END AS number_of_orders
FROM orders
JOIN accounts a
ON a.id = orders.account_id;

We would like to understand 3 different levels of customers based on the amount associated with their purchases.
The top-level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd.
The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd.
Provide a table that includes the level associated with each account.
You should provide the account name, the total sales of all orders for the customer, and the level.
Order with the top spending customers listed first.

SELECT a.name AS name, SUM(o.total_amt_usd) lifetime_value,
CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Gold'
     WHEN SUM(o.total_amt_usd) < 200000 AND SUM(o.total_amt_usd)> 100000 THEN 'Silver'
     ELSE 'Bronze'
     END AS customer_tier
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY name
ORDER BY lifetime_value DESC;

We would now like to perform a similar calculation to the first, but we want to obtain the total amount
spent by customers only in 2016 and 2017.
Keep the same levels as in the previous question. Order with the top spending customers listed first.
SELECT a.name AS name, SUM(o.total_amt_usd) lifetime_value,
CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Gold'
     WHEN SUM(o.total_amt_usd) < 200000 AND SUM(o.total_amt_usd)> 100000 THEN 'Silver'
     ELSE 'Bronze'
     END AS customer_tier
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2017-12-31'
GROUP BY name
ORDER BY lifetime_value DESC;

We would like to identify top-performing sales reps, which are sales reps associated with more than 200 orders.
Create a table with the sales rep name, the total number of orders,
and a column with top or not depending on if they have more than 200 orders.
Place the top salespeople first in your final table.
SELECT s.name rep_name, COUNT(o.account_id)  number_of_orders,
CASE WHEN COUNT(o.account_id) > 200 THEN 'Top🏆'
     ELSE 'NOT 🥲'
     END AS performance
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY rep_name
ORDER BY number_of_orders DESC;

The previous didnt account for the middle, nor the dollar amount associated with the sales.
Management decides they want to see these characteristics represented as well.
We would like to identify top-performing sales reps, which are sales reps associated with more than 200 orders or more than 750000
in total sales.
The middle group has any rep with more than 150 orders or 500000 in sales.
Create a table with the sales rep name, the total number of orders, total sales across all orders,
and a column with top, middle, or low depending on these criteria.
Place the top salespeople based on the dollar amount of sales first in your final table.
You might see a few upset salespeople by this criteria!

SELECT s.name AS rep_name, COUNT(o.account_id) total_number_of_orders, SUM(o.total_amt_usd) total_sales_usd,
CASE WHEN COUNT(o.account_id) > 200 OR SUM(o.total_amt_usd) > 750000 THEN '💎'
     WHEN COUNT(o.account_id) > 150 or SUM(o.total_amt_usd) > 50000 THEN '👍'
     ELSE '💩' END AS performance_emoji
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY rep_name
ORDER BY total_sales_usd DESC;

SELECT channel, AVG(event_count) avg_evnt_ct
 FROM(SELECT DATE_TRUNC('day',occurred_at) AS day,
      channel,
      count(*) as event_count
 FROM web_events
 GROUP BY 1,2) sub
 GROUP BY channel
 ORDER BY avg_evnt_ct DESC

 SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
      FROM web_events
      GROUP BY 1,2
      ORDER BY 3 DESC) sub
GROUP BY day, channel, events
ORDER BY 2 DESC;

SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
      FROM web_events
      GROUP BY 1,2
      ORDER BY 3 DESC) sub;

      SELECT *
FROM orders
WHERE DATE_TRUNC('month',occurred_at) =
 (SELECT DATE_TRUNC('month',MIN(occurred_at)) AS min_month
  FROM orders)
ORDER BY occurred_at

SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

     SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst, SUM(total) total
     FROM orders
     WHERE DATE_TRUNC('month', occurred_at) =
          (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);
