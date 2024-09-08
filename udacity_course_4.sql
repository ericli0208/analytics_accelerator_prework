/* SUBQUERIES and TABLE EXPRESSIONS are methods for being able to write a query that creates a table, and then write a query that interacts with this newly created table. 
Sometimes the question you are trying to answer doesn't have an answer when working directly with existing tables in database.
However, if we were able to create new tables from the existing tables, we know we could query these new tables to answer our question. */

-- Examples of well-formatted subqueries:
SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
             channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2
      ORDER BY 3 DESC) sub;

SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
             channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;

-- SUBQUERIES in Conditional Logic
SELECT * 
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
  (SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
   FROM orders)
ORDER BY occurred_at

/* Note that you should not include an alias when you write a subquery in a conditional statement. 
This is because the subquery is treated as an individual value (or set of values in the IN case) rather than as a table.
Also, notice the query here compared a single value. 
If we returned an entire column IN would need to be used to perform a logical argument. 
If we are returning an entire table, then we must use an ALIAS for the table, and perform additional logic on the entire table. */ 

/* Questions for Subqueries 
1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
2. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
3. How many accounts had more total purchases 
than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?
4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, 
how many web_events did they have for each channel?
5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
6. What is the lifetime average amount spent in terms of total_amt_usd, 
including only the companies that spent more per order, on average, than the average of all orders. */ 

-- BREAKDOWN FOR QUESTION 1:
-- T1 must reflect all applicable fields (rep_name, region_name, total_amt)
SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
FROM sales_reps s
  JOIN accounts a
  ON a.sales_rep_id = s.id
  JOIN orders o
  ON o.account_id = a.id
  JOIN region r
  ON r.id = s.region_id
GROUP BY 1, 2
ORDER BY 3 DESC; 
-- this returns total sales amounts by all sales reps and their regions
-- T2 must grab the MAX sales from each region, but including sales reps names would return unique value between rep AND region, not giving us the max for each region specifically
SELECT region_name, MAX(total_amt) max_sales
FROM (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
       FROM sales_reps s
          JOIN accounts a
          ON a.sales_rep_id = s.id
          JOIN orders o
          ON o.account_id = a.id
          JOIN region r
          ON r.id = s.region_id
        GROUP BY 1, 2
        ORDER BY 3 DESC) t1
GROUP BY 1; 
-- T3 is the original T1 table values, but will return a match for rep_name, region_name, and total_amt where region name and total amount are equal between t2 (max amounts) and t3
SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
                FROM sales_reps s
                JOIN accounts a
                ON a.sales_rep_id = s.id
                JOIN orders o
                ON o.account_id = a.id
                JOIN region r
                ON r.id = s.region_id
                GROUP BY 1, 2) t1
        GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
        FROM sales_reps s
        JOIN accounts a
        ON a.sales_rep_id = s.id
        JOIN orders o
        ON o.account_id = a.id
        JOIN region r
        ON r.id = s.region_id
        GROUP BY 1,2
        ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt; -- conditional equal statement

-- Breakdown for Question 2: 
-- T1 grabs region name and total sales amount
SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
FROM sales_reps s
  JOIN accounts a
  ON a.sales.rep_id = s.id
  JOIN orders o 
  ON o.account_id = a.id
  JOIN region r 
  ON r.id = s.region_id
GROUP BY r.name; 
-- we then need to grab the max of total sales amount
SELECT MAX(total_amt)
FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
      FROM sales_reps s
        JOIN accounts a
        ON a.sales.rep_id = s.id
        JOIN orders o 
        ON o.account_id = a.id
        JOIN region r 
        ON r.id = s.region_id
      GROUP BY r.name) t1; 
-- Our final query will insert total orders for the region with the amount specified
SELECT r.name region_name, COUNT(o.total) total_orders
FROM sales_reps s
  JOIN accounts a
  ON a.sales.rep_id = s.id
  JOIN orders o 
  ON o.account_id = a.id
  JOIN region r 
  ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
          SELECT MAX(total_amt)
          FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
                FROM sales_reps s
                  JOIN accounts a
                  ON a.sales.rep_id = s.id
                  JOIN orders o 
                  ON o.account_id = a.id
                  JOIN region r 
                  ON r.id = s.region_id
                  GROUP BY r.name) t1); 

-- Breakdown for Question 3:
-- First query should grab the highest standard quantity paper for an account + its total quantity
SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
FROM accounts a 
  JOIN orders o
  ON o.account_id = a.id 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1; 
-- the outside query should have the condition that order total > order total of the first query
SELECT a.name
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total) > (SELECT total 
                       FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                             FROM accounts a
                               JOIN orders o
                               ON o.account_id = a.id
                             GROUP BY 1
                             ORDER BY 2 DESC
                             LIMIT 1) sub);

-- Question 4: 
-- subquery grabs the account with the highest amount of total sales
SELECT a.id, a.name, SUM(o.total_amt_usd) as total_amt
FROM orders o
  JOIN accounts a 
  ON a.id = o.account_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1; 
-- outside query sets up the conditional statement
SELECT a.name account_name, w.channel channel_name, COUNT(*) as total_events
FROM accounts a
  JOIN web_events w
  ON a.id = w.account_id AND a.id = (SELECT id
                                     FROM ( SELECT a.id, a.name account_name, SUM(o.total_amt_usd) as total_amt
                                            FROM orders o
                                              JOIN accounts a
                                              ON a.id = o.account_id
                                            GROUP BY 1, 2
                                            ORDER BY 3 DESC
                                            LIMIT 1) sub)
  GROUP BY 1, 2
  ORDER BY 3 DESC;

-- Question 5:
-- subquery grabs the top 10 total spending accounts
SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
  FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;
-- outer query grabs the average
SELECT AVG(tot_spent)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
        JOIN accounts a
        ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
      LIMIT 10) sub;

-- Question 6:
-- first grab the average
SELECT AVG(o.total_amt_usd) avg_all
FROM orders o
-- outer query should reflect accounts with more than this average amount
SELECT o.account_id, AVG(o.total_amt_usd)
FROM orders o
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
                               FROM orders o); 
-- finally we just want the average of the values (single value)
SELECT AVG(avg_amt)
FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
      FROM orders o 
      GROUP BY 1
      HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
                               FROM orders o)) temp_table; 

/* SUBQUERIES USING 'WITH' (Common Table Expressions) 
Question: You need to find the average number of events for each channel per day
Using the WITH statement, we can create an alias table labeled 'events' */ 

WITH events AS (
    SELECT DATE_TRUNC('day', occurred_at) AS day,
           channel, 
           COUNT(*) as events
    FROM web_events
    GROUP BY 1, 2)
-- and then we can grab our query using the temp table
SELECT channel, AVG(events) AS avg_events
FROM events
GROUP BY channel
ORDER BY 2 DESC; 

/* we can also create a second table or as many tables as needed */ 
WITH table1 AS (
        SELECT *
        FROM web_events),

     table2 AS (
        SELECT *
        FROM accounts)

SELECT *
FROM table1
  JOIN table2
  ON table1.account_id = table2.id; 


/* Questions with WITH (CTEs)
1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
2. For the region with the largest sales total_amt_usd, how many total orders were placed?
3. How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?
4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
6. What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders. */

-- Question 1 (same approach as previous Q1)
WITH t1 AS (
     SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
      FROM sales_reps s
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN orders o
      ON o.account_id = a.id
      JOIN region r
      ON r.id = s.region_id
      GROUP BY 1,2
      ORDER BY 3 DESC), 
t2 AS (
      SELECT region_name, MAX(total_amt) total_amt
      FROM t1
      GROUP BY 1)
SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;

-- Question 2
WITH t1 AS (
      SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
      FROM sales_reps s
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN orders o
      ON o.account_id = a.id
      JOIN region r
      ON r.id = s.region_id
      GROUP BY r.name), 
     t2 AS (
      SELECT MAX(total_amt)
      FROM t1)
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);

-- Question 3
WITH t1 AS (
      SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
      FROM accounts a
      JOIN orders o
      ON o.account_id = a.id
      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 1), 
     t2 AS (
      SELECT a.name
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY 1
      HAVING SUM(o.total) > (SELECT total FROM t1))
SELECT COUNT(*)
FROM t2;
            
-- Question 4
WITH t1 AS (
      SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
      LIMIT 1)
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
  JOIN web_events w
  ON a.id = w.account_id AND a.id = (SELECT id FROM t1)
GROUP BY 1, 2
ORDER BY 3 DESC; 

-- Question 5
WITH t1 AS (
      SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
        JOIN accounts a
        ON a.id = o.account_id
      GROUP BY 1, 2
      ORDER BY 3 DESC
      LIMIT 10)
SELECT avg(tot_spent)
FROM t1; 

-- Question 6
WITH t1 AS (
      SELECT AVG(o.total_amt_usd) avg_all
      FROM orders o
      JOIN accounts a 
      ON a.id = o.account_id),
     t2 AS (
      SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
      FROM orders o
      GROUP BY 1
      HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(avg_amt)
FROM t2; 
