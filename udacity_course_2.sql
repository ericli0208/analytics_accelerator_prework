/* Three Main Ideas behind Normalization (how data is stored): 
1. Are the tables storing logical groupings of the data?
2. Can I make changes in a single location, rather than in many tables for the same information?
3. Can I access and manipulate data quickly and efficiently? */

-- Inner Join Example

SELECT orders.*
FROM orders
  JOIN accounts
  ON orders.account_id = accounts.id;

/* Aliases are assigned to tables AND columns for convenience and legibility */ 

/* Practice Questions:
1. Provide a table for all web_events associated with account name of Walmart. There should be three columns. 
   Be sure to include the primary_poc, time of the event, and the channel for each event. 
   Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.

2. Provide a table that provides the region for each sales_rep along with their associated accounts. 
   Your final table should include three columns: the region name, the sales rep name, and the account name. 
   Sort the accounts alphabetically (A-Z) according to account name.

3. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
   Your final table should have 3 columns: region name, account name, and unit price. 
   A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero. */

SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w
  JOIN accounts a
  ON w.account_id = a.id
WHERE a.name = 'Walmart';

SELECT s.name as sales_rep_name, r.name as region_name, a.name as account_name
FROM region r
  JOIN sales_reps s
  ON r.id = s.region_id
  JOIN accounts a
  ON s.id = a.sales_rep_id
ORDER BY account_name;

SELECT r.name region_name, a.name account_name, o.total_amt_usd/(o.total + 0.01) unit_price -- you don't need "as" for column name alias, +0.01 to avoid dividing by 0
FROM region r
  JOIN sales_reps s
  ON r.id = s.region_id
  JOIN accounts a
  ON s.id = a.sales_rep_id
  JOIN orders o
  ON a.id = o.account_id;

-- OUTER JOINs (LEFT, RIGHT, FULL OUTER)
/* Think of the Venn Diagrams - outer joins allow you to include data or rows that don't exist in one table */ 

--  FINAL QUESTIONS

/* 1. Provide a table that provides the region for each sales_rep along with their associated accounts. 
   This time only for the Midwest region. 
   Your final table should include three columns: the region name, the sales rep name, and the account name. 
   Sort the accounts alphabetically (A-Z) according to account name. */ 

SELECT r.name region_name, s.name sales_rep_name, a.name account_name
FROM region r
  JOIN sales_reps s
  ON r.id = s.region_id
  JOIN accounts a
  ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest' 
ORDER BY a.name;

/* 2. Provide a table that provides the region for each sales_rep along with their associated accounts. 
   This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. 
   Your final table should include three columns: the region name, the sales rep name, and the account name. 
   Sort the accounts alphabetically (A-Z) according to account name. */

SELECT r.name region_name, s.name sales_rep_name, a.name account_name
FROM region r
  JOIN sales_reps s
  ON r.id = s.region_id
  JOIN accounts a
  ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest'
  AND s.name LIKE 'S%'
ORDER BY a.name;

/* 3. Provide a table that provides the region for each sales_rep along with their associated accounts. 
   This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
   Your final table should include three columns: the region name, the sales rep name, and the account name. 
   Sort the accounts alphabetically (A-Z) according to account name. */

SELECT r.name region_name, s.name sales_rep_name, a.name account_name
FROM region r
  JOIN sales_reps s
  ON r.id = s.region_id
  JOIN accounts a
  ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest' 
  AND s.name LIKE '% %K'
ORDER BY a.name;

/* 4. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
   However, you should only provide the results if the standard order quantity exceeds 100. 
   Your final table should have 3 columns: region name, account name, and unit price. 
   In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01). */ 

SELECT r.name region_name, a.name account_name, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
  JOIN sales_reps s
  ON r.id = s.region_id
  JOIN accounts a
  ON s.id = a.sales_rep_id
  JOIN orders o
  ON a.id = o.account_id;
WHERE o.standard_qty > 100;

/* 5. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
   However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. 
   Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first. 
   In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01). */

SELECT r.name region_name, a.name account_name, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
  JOIN sales_reps s
  ON r.id = s.region_id
  JOIN accounts a
  ON s.id = a.sales_rep_id
  JOIN orders o
  ON a.id = o.account_id
 WHERE o.standard_qty > 100
  AND o.poster_qty > 50
 ORDER BY unit_price;

/* 6. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. \
   However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. 
   Your final table should have 3 columns: region name, account name, and unit price. 
   Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01). */

SELECT r.name region_name, a.name account_name, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
  JOIN sales_reps s
  ON r.id = s.region_id
  JOIN accounts a
  ON s.id = a.sales_rep_id
  JOIN orders o
  ON a.id = o.account_id
 WHERE o.standard_qty > 100
  AND o.poster_qty > 50
 ORDER BY unit_price DESC;

/* 7. What are the different channels used by account id 1001? 
   Your final table should have only 2 columns: account name and the different channels. 
   You can try SELECT DISTINCT to narrow down the results to only the unique values. */

SELECT DISTINCT a.name account_name, w.channel
FROM accounts a 
  JOIN web_events w
  ON a.id = w.account_id
WHERE a.id = 1001;

/* 8. Find all the orders that occurred in 2015. 
   Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd. */ 

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;
