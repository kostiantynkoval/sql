-- AGGREGATE
/* 1. Write a query that determines how many times each vendor has rented a booth 
at the farmer’s market by counting the vendor booth assignments per vendor_id. */
SELECT v.vendor_name, COUNT(vba.booth_number) as booth_assignments
FROM vendor_booth_assignments AS vba
JOIN vendor AS v ON v.vendor_id = vba.vendor_id
GROUP BY v.vendor_id, v.vendor_name;


/* 2. The Farmer’s Market Customer Appreciation Committee wants to give a bumper 
sticker to everyone who has ever spent more than $2000 at the market. Write a query that generates a list 
of customers for them to give stickers to, sorted by last name, then first name. 

HINT: This query requires you to join two tables, use an aggregate function, and use the HAVING keyword. */
SELECT customer_last_name, customer_first_name, price FROM customer c JOIN (
SELECT customer_id, SUM(cost_to_customer_per_qty * quantity) AS price 
FROM customer_purchases
GROUP BY customer_id 
HAVING price >= 2000
) x on c.customer_id=x.customer_id
ORDER by customer_last_name, customer_first_name


--Temp Table
/* 1. Insert the original vendor table into a temp.new_vendor and then add a 10th vendor: 
Thomass Superfood Store, a Fresh Focused store, owned by Thomas Rosenthal

HINT: This is two total queries -- first create the table from the original, then insert the new 10th vendor. 
When inserting the new vendor, you need to appropriately align the columns to be inserted 
(there are five columns to be inserted, I've given you the details, but not the syntax) 

-> To insert the new row use VALUES, specifying the value you want for each column:
VALUES(col1,col2,col3,col4,col5) 
*/
DROP TABLE IF EXISTS temp.new_vendor;
CREATE TEMPORARY TABLE temp.new_vendor AS SELECT * FROM vendor;
INSERT INTO temp.new_vendor (vendor_name, vendor_id, vendor_type, vendor_owner_first_name, vendor_owner_last_name)
 VALUES ('Thomass Superfood Store', 10, 'Fresh Focused store', 'Thomass', 'Rosenthal');


-- Date
/*1. Get the customer_id, month, and year (in separate columns) of every purchase in the customer_purchases table.

HINT: you might need to search for strfrtime modifers sqlite on the web to know what the modifers for month 
and year are! */
SELECT DISTINCT 
customer_id, 
strftime('%Y', market_date) AS year,
strftime('%m', market_date) AS months,
strftime('%d', market_date) AS day
FROM customer_purchases

/* 2. Using the previous query as a base, determine how much money each customer spent in April 2019. 
Remember that money spent is quantity*cost_to_customer_per_qty. 

HINTS: you will need to AGGREGATE, GROUP BY, and filter...
but remember, STRFTIME returns a STRING for your WHERE statement!! */
SELECT DISTINCT 
customer_id, 
SUM(cost_to_customer_per_qty * quantity) AS money_spent_in_2019_04
FROM customer_purchases 
WHERE strftime('%Y', market_date)='2019' 
AND strftime('%m', market_date)='04'
GROUP BY customer_id;
