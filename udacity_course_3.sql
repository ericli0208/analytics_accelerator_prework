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

