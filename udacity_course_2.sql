/* Three Main Ideas behind Normalization (how data is stored): 
1. Are the tables storing logical groupings of the data?
2. Can I make changes in a single location, rather than in many tables for the same information?
3. Can I access and manipulate data quickly and efficiently? */

-- Join Example

SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/* Aliases are assigned to tables AND columns for convenience and legibility */ 

/* Practice Questions:
1. 
