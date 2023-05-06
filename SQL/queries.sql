SELECT id, account_id, total_amt_usd
FROM orders
Order BY account_id ASC, total_amt_usd DESC;

SELECT id, account_id, total_amt_usd
FROM orders
Order BY total_amt_usd DESC, account_id ASC;

SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10


SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;

SELECT id, account_id,
poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) * 100 AS post_per
FROM orders
LIMIT 10;

SELECT name
FROM accounts
WHERE name LIKE 'C%'

SELECT name
FROM accounts
WHERE name LIKE '%one%'


SELECT name
FROM accounts
WHERE name LIKE '%s'

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%';

SELECT name
FROM accounts
WHERE name NOT LIKE '%one%'

SELECT name
FROM accounts
WHERE name NOT LIKE '%s';

SELECT *
FROM orders
WHERE occurred_at BETWEEN '2016-04-01' AND '2016-10-01'
ORDER BY occurred_at;

SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

SELECT id
FROM orders
WHERE (gloss_qty> 4000 OR poster_qty > 4000);

SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

SELECT name, primary_poc
FROM accounts
WHERE name like 'C%' OR name LIKE 'W%'
AND (primary_poc LIKE 'ana'
OR primary_poc LIKE 'ANA')
AND primary_poc NOT LIKE 'eana';

SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
           AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
           AND primary_poc NOT LIKE '%eana%');

           select r.name as region, s.name as rep,  a.name as act_name
           FROM sales_reps s
           JOIN region r
           ON s.region_id = r.id
           AND r.name = 'Midwest'
           JOIN accounts a
           ON s.id = a.sales_rep_id
           ORDER BY act_name ASC;

           select r.name as region, s.name as rep,  a.name as act_name
           FROM sales_reps s
           JOIN region r
           ON s.region_id = r.id
           AND r.name = 'Midwest'
           AND s.name LIKE 'S%'
           JOIN accounts a
           ON s.id = a.sales_rep_id
           ORDER BY act_name ASC;

           SELECT r.name as region, s.name as rep,  a.name as act_name
           FROM sales_reps s
           JOIN region r
           ON s.region_id = r.id
           AND r.name = 'Midwest'
           AND s.name LIKE '% K%'
           JOIN accounts a
           ON s.id = a.sales_rep_id
           ORDER BY act_name ASC;

           SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
           FROM region r
           JOIN sales_reps s
           ON s.region_id = r.id
           JOIN accounts a
           ON a.sales_rep_id = s.id
           JOIN orders o
           ON o.account_id = a.id
           WHERE o.standard_qty > 100;

           SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
           FROM region r
           JOIN sales_reps s
           ON s.region_id = r.id
           JOIN accounts a
           ON a.sales_rep_id = s.id
           JOIN orders o
           ON o.account_id = a.id
           WHERE o.standard_qty > 100
           AND o.poster_qty > 50
           ORDER BY unit_price ASC;

           SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
           FROM region r
           JOIN sales_reps s
           ON s.region_id = r.id
           JOIN accounts a
           ON a.sales_rep_id = s.id
           JOIN orders o
           ON o.account_id = a.id
           WHERE o.standard_qty > 100
           AND o.poster_qty > 50
           ORDER BY unit_price DESC;

SELECT DISTINCT a.name, w.channel
FROM accounts a
JOIN web_events w
on a.id = w.account_id
AND a.id = 1001

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders o
JOIN accounts a
on a.id = o.account_id
AND occurred_at BETWEEN '2015-1-1' AND '2016-1-1'

SELECT SUM(standard_qty) AS standard,
       SUM(gloss_qty) AS gloss,
       SUM(poster_qty) AS poster
FROM orders

SELECT SUM(poster_qty)
FROM orders

SELECT SUM(standard_qty)
FROM orders;

SELECT SUM(total_amt_usd)
FROM orders

SELECT a.name, SUM(standard_amt_usd) + SUM(gloss_amt_usd) AS total_amt_spent
FROM orders
JOIN accounts a
ON a.id = orders.account_id
GROUP BY a.name
ORDER BY total_amt_spent DESC;

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_amt_per_unit
FROM orders

SELECT AVG(standard_qty) AS standard_avg,
       AVG(gloss_qty) AS gloss_avg,
       AVG(poster_qty) AS poster_avg
FROM orders

SELECT MIN(occurred_at) AS earliest_order
FROM orders

SELECT occurred_at
FROM orders
ORDER BY occurred_at ASC
LIMIT 1;

SELECT MAX(occurred_at) AS most_recent
FROM web_events;

SELECT occurred_at, channel
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

SELECT AVG(standard_qty) AS standard_avg,
       AVG(gloss_qty) AS gloss_avg,
       AVG(poster_qty) AS poster_avg,
       AVG(standard_amt_usd) AS std_amt_avg,
       AVG(gloss_amt_usd) AS gls_amt_avg,
       AVG(poster_amt_usd) AS pst_amt_avg
FROM orders

hard code median
SELECT *
FROM (SELECT total_amt_usd
   FROM orders
   ORDER BY total_amt_usd
   LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT a.name, MIN(o.occurred_at) AS earliest_order
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY earliest_order ASC
LIMT 1;

Find the total sales in usd for each account. You should include two columns - the total sales for each companys orders in usd and the company name.

SELECT a.name AS account_name, SUM(total_amt_usd) AS total_sales_usd
FROM orders
JOIN accounts a
ON a.id = orders.account_id
GROUP BY a.name
ORDER BY total_sales_usd DESC;

Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.
SELECT a.name AS account_name, MAX(occurred_at) AS date, channel
FROM web_events
JOIN accounts a
ON a.id = web_events.account_id
GROUP BY account_name, channel
ORDER BY date DESC
LIMIT 1;

Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.
SELECT channel, COUNT(channel) AS num_of_times_used
FROM web_events
GROUP BY channel
ORDER BY num_of_times_used desc;

Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at ASC
LIMIT 1;

What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT a.name AS account_name, MIN(o.total_amt_usd) AS smallest_order
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY account_name
ORDER BY smallest_order ASC;

Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from the fewest reps to most reps.
SELECT r.name AS region, COUNT(s.id) AS num_of_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY region
ORDER BY num_of_reps ASC;


How many of the sales reps have more than 5 accounts that they manage? (34)
SELECT s.name, a.sales_rep_id, COUNT(a.sales_rep_id)
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY sales_rep_id, s.name
HAVING COUNT(sales_rep_id) >5
ORDER BY COUNT ASC;

How many accounts have more than 20 orders?
SELECT a.name, COUNT(o.account_id) count
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY name
HAVING COUNT(o.account_id) >20
ORDER BY count DESC;

Which account has the most orders?
SELECT a.name, COUNT(o.account_id) count
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY name
HAVING COUNT(o.account_id) >20
ORDER BY count DESC
LIMIT 1;

Which accounts spent more than 30,000 usd total across all orders?
SELECT a.name, SUM(o.total_amt_usd) total
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total DESC;

Which accounts spent less than 1,000 usd total across all orders?
SELECT a.name, SUM(o.total_amt_usd) total
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total DESC;

Which account has spent the most with us?
SELECT a.name, SUM(o.total_amt_usd) total
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total DESC
LIMIT 1;

Which account has spent the least with us?
SELECT a.name, SUM(o.total_amt_usd) total
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total ASC
LIMIT 1;

Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT a.name, w.channel, COUNT(w.channel) as num_of_times
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
WHERE w.channel LIKE '%book'
GROUP BY a.name , w.channel
HAVING COUNT(w.channel) > 6
ORDER BY num_of_times DESC

Which account used facebook most as a channel?
SELECT a.name, w.channel, COUNT(w.channel) as num_of_times
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
WHERE w.channel LIKE '%book'
GROUP BY a.name , w.channel
HAVING COUNT(w.channel) > 6
ORDER BY num_of_times DESC
LIMIT 1;

Which channel was most frequently used by most accounts?
SELECT DISTINCT COUNT(account_id) count, channel
FROM web_events
GROUP BY channel
ORDER BY count DESC
LIMIT 1

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;

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
