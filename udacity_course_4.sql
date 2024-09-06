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
