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


