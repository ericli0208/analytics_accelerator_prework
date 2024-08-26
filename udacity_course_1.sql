-- Setting Up Parch & Posey Data
createdb parch
psql parch < parch_and_posey.sql

-- LIMIT 
/* We have already seen the SELECT (to choose columns) and FROM (to choose tables) statements. 
The LIMIT statement is useful when you want to see just the first few rows of a table. 
This can be much faster for loading than if we load the entire dataset.
The LIMIT command is always the very last part of a query. 
An example of showing just the first 10 rows of the orders table with all of the columns might look like the following: */
SELECT *
FROM orders
LIMIT 10;
-- We could also change the number of rows by changing the 10 to any other number of rows.

-- ORDER BY
/* The ORDER BY statement allows us to sort our results using the data in any column. 
If you are familiar with Excel or Google Sheets, using ORDER BY is similar to sorting a sheet using a column. 
A key difference, however, is that using ORDER BY in a SQL query only has temporary effects, 
for the results of that query, unlike sorting a sheet by column in Excel or Sheets. 

The ORDER BY statement always comes in a query after the SELECT and FROM statements, but before the LIMIT statement. 
If you are using the LIMIT statement, it will always appear last. 
As you learn additional commands, the order of these statements will matter more.
Remember DESC can be added after the column in your ORDER BY statement to sort in descending order, as the default is to sort in ascending order.
*/ 
-- 1. Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10; 

-- 2. Write a query to return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5; 

-- 3. Write a query to return the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd, 
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

-- Practice with multiple Order By conditions
-- 1. Write a query that displays the order ID, account ID, and total dollar amount for all the orders, sorted first by the account ID (in ascending order), and then by the total dollar amount (in descending order).
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

-- 2. Now write a query that again displays order ID, account ID, and total dollar amount for each order, but this time sorted first by total dollar amount (in descending order), and then by account ID (in ascending order).
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

-- 3. Compare the results of these two queries above. How are the results different when you switch the column you sort on first?
/* In query #1, all of the orders for each account ID are grouped together, and then within each of those groupings, the orders appear from the greatest order amount to the least. 
In query #2, since you sorted by the total dollar amount first, the orders appear from greatest to least regardless of which account ID they were from. 
Then they are sorted by account ID next. 
(The secondary sorting by account ID is difficult to see here, since only if there were two orders with equal total dollar amounts would there need to be any sorting by account ID.) */ 

-- WHERE 
/* Using the WHERE statement, we can display subsets of tables based on conditions that must be met. 
You can also think of the WHERE command as filtering the data.
Common symbols in WHERE statements include: 
> (greater than), < (less than), 
>= (greater than or equal to), <= (less than or equal to),
= (equal to), != (not equal to) 
Questions:
1. Pulls the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
2. Pulls the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.
*/ 
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5; 

SELECT *
FROM orders
WHERE gloss_amt_usd < 500
LIMIT 10; 
-- ORDER BY is not needed here, unless we want to actually order our data.
/* The WHERE statement can also be used with non-numeric data. We can use the = and != operators here, as well as LIKE, NOT, or IN. 
You need to be sure to use single quotes (just be careful if you have quotes in the original text) with the text data, not double quotes.
Question:
1. Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) just for the Exxon Mobil company in the accounts table. */ 
SELECT name, website, primary_poc
FROM accounts 
WHERE name = 'Exxon Mobil';

-- DERIVED COLUMNS (CALCULATED/COMPUTED)
-- Example:
SELECT id, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
FROM orders
LIMIT 10;
/* Questions:
1. Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. 
Limit the results to the first 10 orders, and include the id and account_id fields. */
SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;

-- LOGICAL OPERATORS
/* - LIKE This allows you to perform operations similar to using WHERE and =, but for cases when you might not know exactly what you are looking for.
- IN This allows you to perform operations similar to using WHERE and =, but for more than one condition.
- NOT This is used with IN and LIKE to select all of the rows NOT LIKE or NOT IN a certain condition.
- AND & BETWEEN These allow you to combine operations where all combined conditions must be true.
- OR This allows you to combine operations where at least one of the combined conditions must be true. */

/* Questions with LIKE 
1. All the companies whose names start with 'C'.
2. All companies whose names contain the string 'one' somewhere in the name.
3. All companies whose names end with 's'. */ 

SELECT * 
FROM accounts
WHERE name like 'C%'; 

SELECT name
FROM accounts
WHERE name LIKE '%one%';

SELECT name
FROM accounts
WHERE name LIKE '%s';

/* Questions with IN 
1. Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
2. Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords. */ 

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart, Target, Nordstrom');

SELECT * 
FROM web_events
WHERE channel IN ('organic', 'adwords');

/* Questions with NOT 
1. Use the accounts table to find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.
2. Use the web_events table to find all information regarding individuals who were contacted via any method except using organic or adwords methods.
Use the accounts table to find:
3. All the companies whose names do not start with 'C'.
4. All companies whose names do not contain the string 'one' somewhere in the name.
5. All companies whose names do not end with 's'. */ 

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
WHERE name NOT LIKE '%one%';

SELECT name
FROM accounts
WHERE name NOT LIKE '%s';

/* Questions with AND and BETWEEN
1. Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.
2. Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'.
3. When you use the BETWEEN operator in SQL, do the results include the values of your endpoints, or not? 
    Figure out the answer to this important question by writing a query that displays the order date and gloss_qty data for all orders where gloss_qty is between 24 and 29. 
    Then look at your output to see if the BETWEEN operator included the begin and end values or not.
4. Use the web_events table to find all information regarding individuals who were contacted via the organic or adwords channels, and started their account at any point in 2016, sorted from newest to oldest. */ 

SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

SELECT occurred_at, gloss_qty 
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;
-- yes, BETWEEN is inclusive, and endpoint values are included. It is similar to writing "WHERE gloss_qty>=24 AND gloss_qty<=29"

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;
-- we used the right-side endpoint of 2017-01-01 to include the last date of 2016 (due to assumption that time is at 00:00:00 for dates) 


/* Questions with OR
1. Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.
2. Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.
3. Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'. */ 

SELECT id 
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;



