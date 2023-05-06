Create a running total of standard_amt_usd (in the orders table) over order time with no date truncation. Your final table should have two columns: 
one with the amount being added for each new row, and a second with the running total.

SELECT  standard_amt_usd, SUM(standard_amt_usd) OVER
        (ORDER BY occurred_at)
        AS running_total_standard
FROM orders;

Now, modify your query from the previous quiz to include partitions. Still create a running total of standard_amt_usd
(in the orders table) over order time, but this time, date truncate occurred_at by year and partition by that same year-truncated occurred_at variable.

SELECT standard_amt_usd, DATE_TRUNC('year', occurred_at) yr, SUM(standard_amt_usd) OVER
(PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders

Example

SELECT id, account_id, standard_qty, DATE_TRUNC('month', occurred_at) AS month,
DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS dense_rank,
SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS sum_standard_qty,
COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS count_standard_qty,
AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS avg_standard_qty,
MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS min_standard_qty,
MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS max_standard_qty FROM orders


Select the id, account_id, and total variable from the orders table,
then create a column called total_rank that ranks this total amount of paper ordered
(from highest to lowest) for each account using a partition. Your final table should have these four columns.

SELECT id, account_id, total, DENSE_RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM ORDERS

LEAD Example
SELECT account_id,
       standard_sum,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead
FROM   (
        SELECT   account_id,
                 SUM(standard_qty) AS standard_sum
        FROM     orders
        GROUP BY 1
       ) sub
In the previous video, Derek outlines how to compare a row to a previous or subsequent row.
This technique can be useful when analyzing time-based events. Imagine youre an analyst at Parch & Posey
and you want to determine how the current orders total revenue ("total" meaning from sales of all types of paper)
compares to the next orders total revenue.

Modify Dereks query from the previous video in the SQL Explorer below to perform this analysis.
Youll need to use occurred_at and total_amt_usd in the orders table along with LEAD to do so.
In your query results, there should be four columns: occurred_at, total_amt_usd, lead, and lead_difference.

SELECT occurred_at,
       total,
       LEAD(total) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total) OVER (ORDER BY occurred_at) - total AS lead_difference
FROM(
  SELECT occurred_at, SUM(total_amt_usd) AS total
  FROM orders
  GROUP BY 1
) sub


Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders.
Your resulting table should have the account_id, the occurred_at time for each order, the total amount of standard_qty paper purchased,
and one of four levels in a standard_quartile column.

SELECT account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER  (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
FROM orders
ORDER BY account_id desc


Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty for their orders.
Your resulting table should have the account_id, the occurred_at time for each order, the total amount of gloss_qty paper purchased,
and one of two levels in a gloss_half column.

SELECT account_id,
       occurred_at,
       gloss_qty,
       NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS standard_percentile
FROM orders
ORDER BY 1 DESC

Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the amount of total_amt_usd for their orders.
Your resulting table should have the account_id, the occurred_at time for each order,
the total amount of total_amt_usd paper purchased, and one of 100 levels in a total_percentile column.
SELECT account_id,
       occurred_at,
       total_amt_usd,
       NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd)
FROM orders
ORDER BY 1 DESC





       SELECT account_id,
       standard_sum,
       LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
       standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM (
SELECT account_id,
       SUM(standard_qty) AS standard_sum
  FROM orders
 GROUP BY 1
 ) sub
