-- PREWORK 2 ANALYTICS ACCELERATOR

-- BigQuery Data: https://console.cloud.google.com/bigquery?ws=!1m5!1m4!4m3!1stop-sentinel-427221-q7!2sprework!3ssales

/* QUESTIONS:
1. Which product category has the highest number of orders among 31-year olds? Return only the top product category.
2. Of female customers in the U.S. who purchased bike-related products in 2015, what was the average revenue?
3. Categorize all purchases into bike vs. non-bike related purchases. How many purchases were there in each group among male customers in 2016?
4. Among people who purchased socks or caps (use `sub_category`), what was the average profit earned per country per year, ordered by highest average profit to lowest average profit?
5. For male customers who purchased the AWC Logo Cap (use `product`), use a window function to order the purchase dates from oldest to most recent within each gender. */

-- Question 1
SELECT product_category
FROM top-sentinel-427221-q7.prework.sales
WHERE customer_age = 31
GROUP BY 1
ORDER BY 1 DESC
LIMIT 1;

-- Question 2
SELECT AVG(revenue) as avg_revenue
FROM top-sentinel-427221-q7.prework.sales
WHERE customer_gender = 'F'   
  AND product_category LIKE '%Bike%'
  AND country = 'United States'
  AND year = 2015;

-- Question 3
SELECT CASE WHEN product LIKE '%Bike%' THEN 'biker'
  ELSE 'non-biker' END AS biker_nonbiker,
  COUNT(*) as total
FROM top-sentinel-427221-q7.prework.sales
WHERE year = 2016
  AND customer_gender = 'M'
GROUP BY 1;

-- Question 4
SELECT country, 
  year, 
  AVG(profit) AS avg_profit
FROM top-sentinel-427221-q7.prework.sales
WHERE sub_category IN ('Socks', 'Caps')
GROUP BY 1, 2
ORDER BY 3 DESC;

-- Question 5
SELECT *, 
	ROW_NUMBER() OVER (PARTITION BY customer_gender ORDER BY DATE ASC) as date_rank
FROM top-sentinel-427221-q7.prework.sales
WHERE customer_gender = 'M' 
  AND product = 'AWC Logo Cap';
  
