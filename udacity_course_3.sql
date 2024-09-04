/* NULLs are a datatype that specifies where no data exists in SQL. 
They are often ignored in our aggregation functions (like COUNT) 
NULLs are different than a zero - they are cells where data does not exist.
When identifying NULLs in a WHERE clause, we write IS NULL or IS NOT NULL. 
We don't use =, because NULL isn't considered a value in SQL. Rather, it is a property of the data.

There are two common ways in which you are likely to encounter NULLs:
  1. NULLs frequently occur when performing a LEFT or RIGHT JOIN. 
     When some rows in the left table of a left join are not matched with rows in the right table, those rows will contain some NULL values in the result set.
  2. NULLs can also occur from simply missing data in our database. */

-- COUNT the Number of Rows in a Table
SELECT COUNT(*)
FROM accounts;

-- or use a Column Name
SELECT COUNT(accounts.id)
FROM accounts;

/* COUNT does not consider rows that have NULL values. 
Therefore, this can be useful for quickly identifying which rows have missing data. 
You will learn GROUP BY in an upcoming concept, and then each of these aggregators will become much more useful. */

/* SUM
Unlike COUNT, you can only use SUM on numeric columns.
SUM will also ignore NULL values. */

/* QUESTIONS for SUM
1. Find the total amount of poster_qty paper ordered in the orders table.
2. Find the total amount of standard_qty paper ordered in the orders table.
3. Find the total dollar amount of sales using the total_amt_usd in the orders table.
4. Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.
5. Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator. */


SELECT SUM(poster_qty) AS total_poster_sales
FROM orders;

SELECT SUM(standard_qty) AS total_standard_sales
FROM orders; 

SELECT SUM(total_amt_usd) AS total_dollar_sales
FROM orders;

SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;

/* MIN and MAX are aggregators that again ignore NULL values. 
Functionally, MIN and MAX are similar to COUNT in that they can be used on non-numerical columns. 
Depending on the column type, MIN will return the lowest number, earliest date, or non-numerical value as early in the alphabet as possible. 
As you might suspect, MAX does the opposite—it returns the highest number, the latest date, or the non-numerical value closest alphabetically to “Z.” */

/* AVG returns the mean of the data - that is the sum of all of the values in the column divided by the number of values in a column. 
This aggregate function again ignores the NULL values in both the numerator and the denominator.
If you want to count NULLs as zero, you will need to use SUM and COUNT. 
However, this is probably not a good idea if the NULL values truly just represent unknown values for a cell. */

/* QUESTIONS for MIN, MAX, AVG 
1. When was the earliest order ever placed? You only need to return the date.
2. Try performing the same query as in question 1 without using an aggregation function.
3. When did the most recent (latest) web_event occur?
4. Try to perform the result of the previous query without using an aggregation function.
5. Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. 
Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
6. Via the video, you might be interested in how to calculate the MEDIAN. 
Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders? */

SELECT MIN(occurred_at)
FROM orders;

SELECT occurred_at 
FROM orders 
ORDER BY occurred_at
LIMIT 1;

SELECT MAX(occurred_at)
FROM web_events;

SELECT occurred_at 
FROM orders 
ORDER BY occurred_at DESC
LIMIT 1;

SELECT AVG(standard_qty) mean_standard, 
       AVG(gloss_qty) mean_gloss, 
       AVG(poster_qty) mean_poster, 
       AVG(standard_amt_usd) mean_standard_usd, 
       AVG(gloss_amt_usd) mean_gloss_usd, 
       AVG(poster_amt_usd) mean_poster_usd
FROM orders;

SELECT *
FROM (SELECT total_amt_usd
         FROM orders
         ORDER BY total_amt_usd
         LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

/* Since there are 6912 orders - we want the average of the 3457 and 3456 order amounts when ordered. 
This is the average of 2483.16 and 2482.55. This gives the median of 2482.855. 
This obviously isn't an ideal way to compute. 
If we obtain new orders, we would have to change the limit. 
SQL didn't even calculate the median for us. 
The above used a SUBQUERY, but you could use any method to find the two necessary values, and then you just need the average of them. */ 


-- GROUP BY
/* GROUP BY can be used to aggregate data within subsets of the data. 
For example, grouping for different accounts, different regions, or different sales representatives.
Any column in the SELECT statement that is not within an aggregator must be in the GROUP BY clause.
The GROUP BY always goes between WHERE and ORDER BY.
ORDER BY works like SORT in spreadsheet software. */

/* Before we dive deeper into aggregations using GROUP BY statements, it is worth noting that SQL evaluates the aggregations before the LIMIT clause. 
If you don’t group by any columns, you’ll get a 1-row result—no problem there. 
If you group by a column with enough unique values that it exceeds the LIMIT number, the aggregates will be calculated, and then some rows will simply be omitted from the results.

This is actually a nice way to do things because you know you’re going to get the correct aggregates. 
If SQL cuts the table down to 100 rows, then performed the aggregations, your results would be substantially different. 
The above query’s results exceed 100 rows, so it’s a perfect example. 
In the next concept, use the SQL environment to try removing the LIMIT and running it again to see what changes. */ 

/* Questions for Group By Part I
1. Which account (by name) placed the earliest order? 
Your solution should have the account name and the date of the order.
2. Find the total sales in usd for each account. 
You should include two columns - the total sales for each company's orders in usd and the company name.
3. Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
Your query should return only three values - the date, channel, and account name.
4. Find the total number of times each type of channel from the web_events was used. 
Your final table should have two columns - the channel and the number of times the channel was used.
5. Who was the primary contact associated with the earliest web_event?
6. What was the smallest order placed by each account in terms of total usd. 
Provide only two columns - the account name and the total usd. 
Order from smallest dollar amounts to largest.
7. Find the number of sales reps in each region. 
Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps. */

SELECT a.name, o.occurred_at
FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;

SELECT a.name, SUM(total_amt_usd) total_sales
FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
GROUP BY a.name;

SELECT w.occurred_at, w.channel, a.name
FROM web_events w
  JOIN accounts a
  ON w.account_id = a.id 
ORDER BY w.occurred_at DESC
LIMIT 1;

SELECT channel, COUNT(channel) as channel_count
FROM web_events
GROUP BY channel
ORDER BY channel_count DESC;

SELECT a.primary_poc, w.occurred_at
FROM web_events w
  JOIN accounts a
  ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

SELECT a.name, MIN(total_amt_usd) as smallest_order
FROM accounts a
  JOIN orders o 
  ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;

SELECT r.name, COUNT(s.id) as num_reps
FROM region r
  JOIN sales_reps s
  ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;

/* - You can GROUP BY multiple columns at once. This is often useful to aggregate across a number of different segments.
- The order of columns listed in the ORDER BY clause does make a difference. You are ordering the columns from left to right. 
- The order of column names in your GROUP BY clause doesn’t matter—the results will be the same regardless. 
  If we run the same query and reverse the order in the GROUP BY clause, you can see we get the same results.
- As with ORDER BY, you can substitute numbers for column names in the GROUP BY clause. 
  It’s generally recommended to do this only when you’re grouping many columns, or if something else is causing the text in the GROUP BY clause to be excessively long.
- A reminder here that any column that is not within an aggregation must show up in your GROUP BY statement.  
  If you forget, you will likely get an error. However, in the off chance that your query does work, you might not like the results! */

/* Questions for Group By Part II
1. For each account, determine the average amount of each type of paper they purchased across their orders. 
   Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
2. For each account, determine the average amount spent per order on each paper type. 
   Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
3. Determine the number of times a particular channel was used in the web_events table for each sales rep. 
   Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
4. Determine the number of times a particular channel was used in the web_events table for each region. 
   Your final table should have three columns - the region name, the channel, and the number of occurrences. 
   Order your table with the highest number of occurrences first. */ 

SELECT 
  a.name, 
  AVG(o.standard_qty) as avg_standard,
  AVG(o.gloss_qty) as avg_gloss,
  AVG(o.poster_qty) as avg_poster
FROM accounts a 
  JOIN orders o
  ON a.id = o.account_id
GROUP BY a.name; 

SELECT 
  a.name, 
  AVG(o.standard_amt_usd) avg_stand, 
  AVG(o.gloss_amt_usd) avg_gloss, 
  AVG(o.poster_amt_usd) avg_post
FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
GROUP BY a.name;

SELECT 
  s.name, 
  w.channel, 
  COUNT(*) num_events
FROM accounts a
  JOIN web_events w
  ON a.id = w.account_id
  JOIN sales_reps s
  ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY num_events DESC;

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

/* DISTINCT
DISTINCT is always used in SELECT statements, and it provides the unique rows for all columns written in the SELECT statement. 
Therefore, you only use DISTINCT once in any particular SELECT statement. */

-- You could write:
SELECT DISTINCT column1, column2, column3
FROM table1;
-- which would return the unique (or DISTINCT) rows across all three columns.

-- You would not write:
SELECT DISTINCT column1, DISTINCT column2, DISTINCT column3
FROM table1;
-- You can think of DISTINCT the same way you might think of the statement "unique".

-- It’s worth noting that using DISTINCT, particularly in aggregations, can slow your queries down quite a bit.

/* Questions for DISTINCT
1. Use DISTINCT to test if there are any accounts associated with more than one region.
2. Have any sales reps worked on more than one account? */

-- The below two queries have the same number of resulting rows (351), so we know that every account is associated with only one region. 
-- If each account was associated with more than one region, the first query should have returned more rows than the second query.
SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
  JOIN sales_reps s
  ON s.id = a.sales_rep_id
  JOIN region r
  ON r.id = s.region_id;
-- AND 
SELECT DISTINCT id, name
FROM accounts;

SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
  JOIN sales_reps s
  ON a.sales_rep_id = s.id
GROUP BY s.id, s.name
ORDER BY num_accounts;
-- AND
SELECT DISTINCT id, name
FROM sales_reps

/* HAVING
HAVING is the “clean” way to filter a query that has been aggregated, but this is also commonly done using a subquery. 
Essentially, any time you want to perform a WHERE on an element of your query that was created by an aggregate, you need to use HAVING instead. */

/* Questions for HAVING
1. How many of the sales reps have more than 5 accounts that they manage?
2. How many accounts have more than 20 orders?
3. Which account has the most orders?
4. Which accounts spent more than 30,000 usd total across all orders?
5. Which accounts spent less than 1,000 usd total across all orders?
6. Which account has spent the most with us?
7. Which account has spent the least with us?
8. Which accounts used facebook as a channel to contact customers more than 6 times?
9. Which account used facebook most as a channel?
10. Which channel was most frequently used by most accounts? */ 

SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
  JOIN sales_reps s
  ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;
-- OR, to return one figure, use a subquery
SELECT COUNT(*) num_reps_above5
FROM(SELECT s.id, s.name, COUNT(*) num_accounts
        FROM accounts a
          JOIN sales_reps s
          ON s.id = a.sales_rep_id
        GROUP BY s.id, s.name
        HAVING COUNT(*) > 5
        ORDER BY num_accounts) AS Table1;

SELECT a.id, a.name, COUNT(*) as num_orders
FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;

SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_orders DESC
LIMIT 1;

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent;

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent 
LIMIT 1;

SELECT a.id, a.name, w.channel, COUNT(*) as num_channel_use
FROM accounts a
  JOIN web_events w
  ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY num_channel_use;
-- OR you can use WHERE
SELECT a.id, a.name, w.channel, COUNT(*) as num_channel_use
FROM accounts a
  JOIN web_events w
  ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 
ORDER BY num_channel_use;

SELECT a.id, a.name, w.channel, COUNT(*) num_channel_use
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY num_channel_use DESC
LIMIT 1;

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;

/* DATE 
DATE_TRUNC allows you to truncate your date to a particular part of your date-time column. 
Common trunctions are day, month, and year.

DATE_PART can be useful for pulling a specific portion of a date, but notice pulling month or day of the week (dow) means that you are no longer keeping the years in order. 
Rather you are grouping for certain components regardless of which year they belonged in.

For additional functions you can use with dates, check out the documentation here
(https://www.postgresql.org/docs/9.1/functions-datetime.html), 
but the DATE_TRUNC and DATE_PART functions definitely give you a great start!

You can reference the columns in your select statement in GROUP BY and ORDER BY clauses with numbers that follow the order they appear in the select statement. */

/* Questions for DATE
1. Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. 
   Do you notice any trends in the yearly sales totals?
2. Which month did Parch & Posey have the greatest sales in terms of total dollars? 
   Are all months evenly represented by the dataset?
3. Which year did Parch & Posey have the greatest sales in terms of total number of orders? 
   Are all years evenly represented by the dataset?
4. Which month did Parch & Posey have the greatest sales in terms of total number of orders? 
   Are all months evenly represented by the dataset?
5. In which month of which year did Walmart spend the most on gloss paper in terms of dollars? */

SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
/* When we look at the yearly totals, you might notice that 2013 and 2017 have much smaller totals than all other years. 
If we look further at the monthly data, we see that for 2013 and 2017 there is only one month of sales for each of these years (12 for 2013 and 1 for 2017). 
Therefore, neither of these are evenly represented. 
Sales have been increasing year over year, with 2016 being the largest sales to date. 
At this rate, we might expect 2017 to have the largest sales. */

SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 
-- In order for this to be 'fair', we should remove the sales from 2013 and 2017. For the same reasons as discussed above.
-- The greatest sales amounts occur in December (12).

SELECT DATE_PART('year', occurred_at) ord_year,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

SELECT DATE_PART('month', occurred_at) ord_month, COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;
-- December still has the most sales, but interestingly, November has the second most sales (but not the most dollar sales). 
-- To make a fair comparison from one month to another 2017 and 2013 data were removed.

SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) tot_spent
FROM orders o 
  JOIN accounts a
  ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
-- May 2016 was when Walmart spent the most on gloss paper.

/* CASE
1. The CASE statement always goes in the SELECT clause.
2. CASE must include the following components: WHEN, THEN, and END. ELSE is an optional component to catch cases that didn’t meet any of the other previous CASE conditions.
3. You can make any conditional statement using any conditional operator (like WHERE(opens in a new tab)) between WHEN and THEN. 
   This includes stringing together multiple conditional statements using AND and OR.
4. You can include multiple WHEN statements, as well as an ELSE statement again, to deal with any unaddressed conditions.

Example from previous question: Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. 
Limit the results to the first 10 orders, and include the id and account_id fields. 
NOTE - you will be thrown an error with the correct solution to this question. 
This is for a division by zero. */ 

SELECT account_id, 
       CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
       ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;

/* Questions for CASE
1. Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.
2. Write a query to display the number of orders in each of three categories, based on the total number of items in each order. 
   The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
3. We would like to understand 3 different levels of customers based on the amount associated with their purchases. 
   The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. 
   The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. 
   Provide a table that includes the level associated with each account. 
   You should provide the account name, the total sales of all orders for the customer, and the level. 
   Order with the top spending customers listed first.
4. We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. 
   Keep the same levels as in the previous question. 
   Order with the top spending customers listed first.
5. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
   Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. 
   Place the top sales people first in your final table.
6. The previous didn't account for the middle, nor the dollar amount associated with the sales. 
   Management decides they want to see these characteristics represented as well. 
   We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. 
   The middle group has any rep with more than 150 orders or 500000 in sales. 
   Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. 
   Place the top sales people based on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria! */

SELECT account_id, total_amt_usd,
       CASE WHEN total_amt_usd >= 3000 THEN 'Large'
       ELSE 'Small' END AS order_level
FROM orders;

SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
	     WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
       ELSE 'Less than 1000' END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY 1;
