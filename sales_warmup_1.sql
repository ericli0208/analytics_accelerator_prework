-- PREWORK 1 ANALYTICS ACCELERATOR

-- Relevant data table: https://console.cloud.google.com/bigquery?ws=!1m5!1m4!4m3!1stop-sentinel-427221-q7!2sprework!3ssales

/* QUESTIONS:
1. What is the earliest year of purchase?
2. What is the average customer age per year? Order the years in ascending order.
3. Return all clothing purchases from September 2015 where the cost was at least $70.
4. What are all the different types of product categories that were sold from 2014 to 2016 in France?
5. Within each product category and age group (combined), what is the average order quantity and total profit? */

-- Question 1
SELECT MIN(year) as earliest_year
FROM top-sentinel-427221-q7.prework.sales; 

-- Question 2
SELECT year, 
  AVG(Customer_Age) as avg_age
FROM top-sentinel-427221-q7.prework.sales
GROUP BY year
ORDER BY year;

-- Question 3 
SELECT *
FROM top-sentinel-427221-q7.prework.sales
WHERE month = 'September' 
  AND year = 2015 
  AND cost >= 70;

-- Question 4
SELECT DISTINCT Product_Category
FROM top-sentinel-427221-q7.prework.sales 
WHERE year BETWEEN 2014 AND 2016 
  AND country = 'France'; 

-- Question 5
SELECT product_category, 
  age_group,
  AVG(order_quantity) AS avg_order_quantity, 
  SUM(profit) AS total_profit
FROM top-sentinel-427221-q7.prework.sales
GROUP BY 1,2;
