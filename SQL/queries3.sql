Finding Max channels using subqueries

FIRST: get all accounts and the channels they have been contacted by
SELECT a.id, a.name, we.channel
FROM accounts a
JOIN web_events we
ON a.id = we.account_id;

Next get a count of those channels (how often they have been used by each account)
SELECT a.id, a.name, we.channel, Count(*)
FROM accounts a
JOIN web_events we
ON a.id = we.account_id
GROUP BY 1,2,3
ORDER BY 1

Next get the max channel count for each channel
SELECT t1.id, t1.name, MAX(ct)
FROM (SELECT a.id, a.name, we.channel, Count(*) ct
FROM accounts a
JOIN web_events we
ON a.id = we.account_id
GROUP BY 1,2,3) AS t1
GROUP BY 1,2
ORDER BY 1;

Finally find all rows where the channel matches the max for each channel


SELECT t3.id, t3.name, t3.channel, t3.ct
FROM (SELECT a.id, a.name, we.channel, COUNT(*) ct
      FROM accounts a
      JOIN web_events we
      ON a.id = we.account_id
      GROUP BY a.id, a.name, we.channel) T3
JOIN (SELECT t1.id, t1.name, MAX(ct) max_use
      FROM (SELECT a.id, a.name, COUNT(*) ct
            FROM accounts a
            Join web_events we
            on a.id = we.account_id
            GROUP BY a.id, a.name, we.channel)t1
      GROUP BY t1.id, t1.name) t2
 ON t2.id = t3.id AND t2.max_use = t3.ct
 ORDER BY t3.id



Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

Here are the each sales reps and their numbers for each region

Select s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
GROUP BY rep_name, region_name

Now I should get the highest amt for each region

SELECT  t1.region_name, MAX(t1.total) highest
FROM(Select s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
GROUP BY rep_name, region_name) t1
GROUP BY t1.region_name

oh shit that worked. Now I should join these two tables

SELECT t3.rep_name, t3.region_name, t3.total
FROM(Select s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total
      FROM region r
      JOIN sales_reps s
      ON r.id = s.region_id
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN orders o
      ON a.id = o.account_id
      GROUP BY rep_name, region_name
) t3
JOIN (SELECT t1.region_name, MAX(t1.total) highest
        FROM(Select s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total
            FROM region r
            JOIN sales_reps s
            ON r.id = s.region_id
            JOIN accounts a
            ON a.sales_rep_id = s.id
            JOIN orders o
            ON a.id = o.account_id
            GROUP BY rep_name, region_name) t1
          GROUP BY t1.region_name) t2
ON t3.region_name = t2.region_name
AND t3.total = t2.highest
ORDER BY total DESC;




For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

SELECT  t1.region_name, MAX(t1.total) highest, t1.order_ct
FROM(Select s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total, COUNT(*) order_ct
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
GROUP BY rep_name, region_name) t1
GROUP BY t1.region_name, t1.order_ct
ORDER BY highest DESC LIMIT 1

How many accounts had more total purchases than the account name
which has bought the most standard_qty paper throughout their lifetime as a customer?

First get the lifetime order value for std paper for each account:
SELECT a.name account_name, SUM(o.standard_qty) lifetime_standard, SUM(o.total) total_orders
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY account_name;


For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders?
