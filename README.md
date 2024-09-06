# Udacity Review Materials
## Course 1 - Basic SQL Recap
### SQL Commands

| Statement  | How to Use It | Other Details |
| ------------- | ------------- | ------------- |
| SELECT | SELECT **Col1, Col2, ...** | Provide the columns you want |
| FROM | FROM **Table** | Provide the table where the columns exist |
| LIMIT | LIMIT **10** | Limits based number of rows returned |
| ORDER BY | ORDER BY **Col** | Orders table based on the column. Used with **DESC**. |
| WHERE | WHERE **Col > 5** | A conditional statement to filter your results |
| LIKE | WHERE **Col LIKE '%me%'** | Only pulls rows where column has 'me' within the text |
| IN | WHERE **Col IN ('Y', 'N')** | A filter for only rows with column of 'Y' or 'N' |
| NOT | WHERE **Col NOT IN ('Y', 'N')**  | NOT is frequently used with **LIKE** and **IN** |
| AND | WHERE **Col1 > 5 AND Col2 < 3** | Filter rows where two or more conditions must be true |
| OR | WHERE **Col1 > 5 OR Col2 < 3** | Filter rows where at least one condition must be true |
| BETWEEN | WHERE **Col BETWEEN 3 AND 5** | Often easier syntax than using an **AND** |

### Other Tips
Though SQL is not case sensitive (it doesn't care if you write your statements as all uppercase or lowercase), we discussed some best practices. The order of the key words does matter! Using what you know so far, you will want to write your statements as:

```
SELECT col1, col2
FROM table1
WHERE col3  > 5 AND col4 LIKE '%os%'
ORDER BY col5
LIMIT 10;
```

Notice, you can retrieve different columns than those being used in the ORDER BY and WHERE statements. Assuming all of these column names existed in this way (col1, col2, col3, col4, col5) within a table called table1, this query would run just fine.

## Course 2 - SQL Joins
### Primary and Foreign Keys

You learned a key element for JOINing tables in a database has to do with primary and foreign keys:

- primary keys - are unique for every row in a table. These are generally the first column in our database (like you saw with the id column for every table in the Parch & Posey database).\
- foreign keys - are the primary key appearing in another table, which allows the rows to be non-unique.

Choosing the set up of data in our database is very important, but not usually the job of a data analyst. This process is known as **Database Normalization**.

### JOINs
In this lesson, you learned how to combine data from multiple tables using JOINs. The three JOIN statements you are most likely to use are:

1. JOIN - an INNER JOIN that only pulls data that exists in both tables.
2. LEFT JOIN - pulls all the data that exists in both tables, as well as all of the rows from the table in the FROM even if they do not exist in the JOIN statement.
3. RIGHT JOIN - pulls all the data that exists in both tables, as well as all of the rows from the table in the JOIN even if they do not exist in the FROM statement.

There are a few more advanced JOINs that we did not cover here, and they are used in very specific use cases. UNION and UNION ALL(opens in a new tab), CROSS JOIN(opens in a new tab), and the tricky SELF JOIN(opens in a new tab). These are more advanced than this course will cover, but it is useful to be aware that they exist, as they are useful in special cases.

### Alias
You learned that you can alias tables and columns using AS or not using it. This allows you to be more efficient in the number of characters you need to write, while at the same time you can assure that your column headings are informative of the data in your table.

## Course 3 - SQL Aggregations

### Aggregation Tips

An important thing to remember: aggregators only aggregate vertically - the values of a column. If you want to perform a calculation across rows, you would do this with [simple arithmetic](https://mode.com/sql-tutorial/sql-operators#arithmetic-in-sql).

| Statement  | How to Use It | Other Details |
| ------------- | ------------- | ------------- |
| COUNT | SELECT **COUNT**(*) | Provide the column you want to COUNT by |
| SUM | SELECT **SUM**(column1) | Provide the columnn you want to SUM by |
| MIN | SELECT **MIN**(column1) | Provide the column you would like to get the minimum value for. Applies for numerical, text, and date values. |
| MAX | SELECT **MAX**(column1) | Provide the column you would like to get the maximum value for. Applies for numerical, text, and date values. |
| AVG | SELECT **AVG**(column1) | Provide the column you would like to get the average value for. Applies for numerical values. |
| GROUP BY | **GROUP BY** (column1), (column2) | Provide the column(s) you would like to group by. Occurs after **FROM** and **JOIN** statements. |
| HAVING | **HAVING** (value1) (logical expression) (condition1), ... | Occurs after **GROUP BY** statement as a subfilter. |
| DATE_TRUNC | SELECT **DATE_TRUNC**('interval', column1) | Provide the interval (desired date_time level) and column you would like to truncate the date value for. |
| DATE_PART | SELECT **DATE_PART**('interval', column1) | Provide the interval (desired date_time leve) and column you would like to grab the date value for. |
| CASE | SELECT **CASE** **WHEN**, **THEN**, **END AS** column_name | May also use **ELSE** as an optional component to catch cases that didn't meet any other previous CASE conditions; Able to make any conditional statements using any conditional operator (like WHERE) between **WHEN** and **THEN** |

### DATE_TRUNC vs DATE_PART
- DATE_TRUNC: truncates (*rounds*) a date to the precision specified (microsecond - millenium)
- DATE_PART: returns a particular part of a datetime value, grouping for that particular value (i.e. days, months, years)

**All intervals & units of time that can be entered:** 
- microsecond
- millisecond
- second
- minute
- hour
- day
- week
- month
- quarter
- year
- decade
- century
- millenium

## Course 4 - Subqueries and Temporary Tables


