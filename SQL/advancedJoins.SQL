Say you're an analyst at Parch & Posey and you want to see:
each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)

SELECT a.id account_id,
       a.name account_name,
       s.name rep_name
FROM accounts a
FULL JOIN sales_reps s
ON a.sales_rep_id = s.id
ORDER BY a.id ASC;


but also each account that does not have a sales rep and each sales rep that
does not have an account (some of the columns in these returned rows will be empty)

SELECT a.id account_id,
       a.name account_name,
       s.name rep_name
FROM accounts a
FULL JOIN sales_reps s
ON a.sales_rep_id = s.id
WHERE a.sales_rep_id IS NULL
ORDER BY a.id ASC;

In the following SQL Explorer, write a query that left joins the accounts table and
the sales_reps tables on each sale rep's ID numbr and joins it using the < comparison operator
on accounts.primary_poc and sales_reps.name, like so:
accounts.primary_poc < sales_reps.name

SELECT *
FROM accounts
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
WHERE accounts.primary_poc < sales_reps.name

self join example

SELECT o1.id AS o1_id, o1.account_id AS o1_account_id, o1.occurred_at AS o1_occurred_at, o2.id AS o2_id, o2.account_id AS o2_account_id, o2.occurred_at AS o2_occurred_at FROM orders o1 LEFT JOIN orders o2 ON o1.account_id = o2.account_id AND o2.occurred_at > o1.occurred_at AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days' ORDER BY o1.account_id, o1.occurred_at

SELECT w1.id AS w1_id,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
       w1.channel AS w1_channel,
       w2.id AS w2_id,
       w2.account_id AS w2_account_id,
       w2.occurred_at AS w2_occurred_at,
       w2.channel AS w2_channel
  FROM web_events w1
 LEFT JOIN web_events w2
   ON w1.account_id = w2.account_id
  AND w2.occurred_at > w1.occurred_at
  AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 day'
ORDER BY w1.account_id, w1.occurred_at
