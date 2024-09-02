/* NULLs are a datatype that specifies where no data exists in SQL. 
They are often ignored in our aggregation functions (like COUNT) 
NULLs are different than a zero - they are cells where data does not exist.
When identifying NULLs in a WHERE clause, we write IS NULL or IS NOT NULL. 
We don't use =, because NULL isn't considered a value in SQL. Rather, it is a property of the data.

There are two common ways in which you are likely to encounter NULLs:
  1. NULLs frequently occur when performing a LEFT or RIGHT JOIN. 
     When some rows in the left table of a left join are not matched with rows in the right table, those rows will contain some NULL values in the result set.
  2. NULLs can also occur from simply missing data in our database.
*/

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

