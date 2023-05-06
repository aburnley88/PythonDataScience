In the accounts table, there is a column holding the website for each company.
The last three digits specify what type of web address they are usin
 A list of extensions (and pricing) is provided here. Pull these extensions an
provide how many of each website type exist in the accounts table.

SELECT  RIGHT(website, 3) as domain, COUNT(*)
FROM accounts
GROUP BY 1

Use the accounts table to pull the first letter of each company name to see the distribution
of company names that begin with each letter (or number).
SELECT LEFT(name, 1) as first_letter, COUNT(*)company_ct
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

Use the accounts table and a CASE statement to create two groups:
one group of company names that start with a number and the second group of those company names that start with a letter.
What proportion of company names start with a letter?

WITH first_char AS(
  SELECT name,  CASE WHEN LEFT(UPPER(name), 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN 1 ELSE 0
  END AS num, CASE WHEN LEFT(UPPER(name), 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN 0 ELSE 1
  END as letter
  FROM accounts
  GROUP BY 1
)
SELECT SUM(letter) ltr_ct, SUM(num) num_ct
FROM first_char

Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel,
and what percent start with anything else?

WITH first_char AS(
  SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A', 'E', 'I', 'O', 'U') THEN 1 ELSE NULL
  END AS is_vowel, CASE WHEN LEFT(UPPER(name), 1) NOT IN ('A', 'E', 'I', 'O', 'U') THEN 1 ELSE NULL
  END AS is_consonant
  FROM accounts
)
SELECT (SUM(is_vowel)*100)/COUNT(*) vowel_pct, (SUM(is_consonant)*100)/COUNT(*) cons_pct
FROM first_char

Suppose the company wants to assess the performance of all the sales representatives.
Each sales representative is assigned to work in a particular region.
To make it easier to understand for the HR team,
display the concatenated sales_reps.id, ‘_’ (underscore), and region.name a
EMP_ID_REGION for each sales representative.
SELECT s.name, CONCAT(s.id, '_', r.name) EMP_ID_REGION
FROM sales_reps s
JOIN region r
ON s.region_id = r.id

From the accounts table, display the name of the client, the coordinate as concatenated (latitude, longitude), email id of the primary point of contact as
<first letter of the primary_poc><last letter of the primary_poc>@<extracted name and domain from the website>
SELECT name, CONCAT(lat, '.', long) coordinates, CONCAT(LEFT(LOWER(primary_poc), 1), RIGHT(primary_poc, 1), '@', LTRIM(website, 'www')) email
FROM accounts;

From the web_events table, display the concatenated value of
account_id, '_' , channel, '_', count of web events of the particular channel

SELECT CONCAT(sub.account_id, '_', sub.channel, '_', sub.num_events)
FROM(
SELECT account_id, channel, COUNT(*) num_events
FROM web_events
GROUP BY 1,2) sub


SELECT SUBSTR(date, 1, 10) AS default
FROM sf_crime_data
LIMIT 10

WITH split_date AS (
  SELECT SUBSTR(sub.default, 7, 4) yr, SUBSTR(sub.default, 1, 2) mnth, SUBSTR(sub.default, 4, 2) dy
  FROM(
        SELECT SUBSTR(date, 1, 10) AS default
        FROM sf_crime_data) sub
        LIMIT 10;
)
SELECT CONCAT(split_date.yr, '-', split_date.mnth, split_date.yr)
FROM split_date

SELECT LEFT(name, STRPOS(name, ' ')-1) f_name, RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) l_name
FROM  sales_reps

SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name,
   RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;

WITH t1 AS (
    SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
    FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM  t1;

WITH t1 AS (
    SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
    FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com'), LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM t1;
