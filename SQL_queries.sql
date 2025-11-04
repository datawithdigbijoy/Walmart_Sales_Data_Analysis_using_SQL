
DROP TABLE IF EXISTS sales;

-- Create table
CREATE TABLE sales (
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct NUMERIC(6,4) NOT NULL,
    total NUMERIC(12,4) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs NUMERIC(10,2) NOT NULL,
    gross_margin_pct NUMERIC(11,9),
    gross_income NUMERIC(12,4),
    rating NUMERIC(2,1)
);


--Altering table 

ALTER TABLE sales
ALTER COLUMN rating TYPE NUMERIC(3,1);

SELECT * FROM sales;


-- Feature Engineering:
1. /*Add a new column named time_of_day to give insight of sales in the Morning, 
Afternoon and Evening. This will help answer the question on 
which part of the day most sales are made.*/

SELECT 
	time,
		CASE 
			WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
			WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
		ELSE 'Evening'
		END AS time_of_day
FROM sales;


ALTER TABLE sales
ADD column time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (

		CASE 
			WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
			WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
		ELSE 'Evening'
		END 
);

/* 2.Add a new column named day_name that contains the extracted days of the 
week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). 
This will help answer the question on which week of the day each branch is busiest.*/

SELECT 
	TO_CHAR(date, 'Day') AS day_name
FROM sales;


UPDATE sales
SET day_name = TO_CHAR(date, 'Day') 

				
/* 03. Add a new column named month_name that contains the extracted months of the 
year on which the given transaction took place (Jan, Feb, Mar). 
Help determine which month of the year has the most sales and profit.*/


SELECT 
	date,
	TO_CHAR(date, 'month') AS month_name
FROM sales;


AlTER TABLE sales ADD COLUMN month_name VARCHAR(15);

UPDATE sales
SET month_name = TO_CHAR(date, 'month');


SELECT * FROM sales


--------------- Business Questions ------------

-- 1. How many unique cities does the data have?

SELECT 
	DISTINCT city 
FROM sales;

-- 2. In which city is each branch?

SELECT 
	DISTINCT city,
	branch
FROM sales;

-- 03. How many unique product lines does the data have?

SELECT 
	COUNT(DISTINCT product_line)
FROM sales

-- 04. What is the most common payment method?

SELECT 
	payment,
	COUNT(payment) AS most_common_method
FROM sales
GROUP BY 1
ORDER BY most_common_method DESC
LIMIT 1;


-- 05. What is the most selling product line?

SELECT 
	product_line,
	COUNT(product_line) AS most_sell
FROM sales
GROUP BY 1
ORDER BY most_sell DESC
LIMIT 1;


--06. What is the total revenue by month?

SELECT 
	month_name AS month,
	SUM(total) AS total_revenue
From sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- 07. What month had the largest COGS?

SELECT 
	month_name,
	SUM(cogs) AS total_cogs
From sales
GROUP BY 1
ORDER BY total_cogs DESC;

--08. What product line had the largest revenue?

SELECT 
	product_line,
	SUM(total) AS total_revenue
FROM sales
GROUP BY 1
ORDER BY total_revenue DESC
LIMIT 1;


-- 09. What is the city with the largest revenue?

SELECT 
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY 1, 2
ORDER BY total_revenue DESC

-- 10. What product line had the largest tax?

SELECT 
	product_line,
	AVG(tax_pct) AS avg_tax
FROM sales
GROUP BY 1
ORDER BY avg_tax DESC;

/* 11. Fetch each product line and add a column to those product line showing "Good", "Bad". 
Good if its greater than average sales */

SELECT 
	product_line,
	CASE
		WHEN AVG(quantity) > 5.5 THEN 'Good'
		ELSE 'Bad'
	END AS remark
FROM sales
GROUP BY 1


-- 12. Which branch sold more products than average product sold?

SELECT 
	branch,
	SUM(quantity) AS total_quantity
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- 13. What is the most common product line by gender

SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;



-- 14. What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


--15. How many unique customer types does the data have?

SELECT 
	DISTINCT customer_type
FROM sales;

--16. How many unique payment methods does the data have?

SELECT 
	DISTINCT payment
FROM sales;

--17. What is the most common customer type?

SELECT 
	 customer_type,
	 COUNT(customer_type) AS most_common
FROM sales
GROUP BY 1
ORDER BY most_common DESC;

-- 18. What is the gender of most of the customers?

SELECT 
	gender,
	COUNT(*) AS gender_cus
FROM sales
GROUP BY gender
ORDER BY gender_cus DESC;
	
-- 19. Which time of the day do customers give most ratings?

SELECT 
	time_of_day,
	ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY 1
ORDER BY avg_rating DESC;

--20. Number of sales made in each time of the day per weekday 

SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = 'Sunday'
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- 21. Which of the customer types brings the most revenue?

SELECT 
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY 1
ORDER BY total_revenue DESC;

-- 22. Which city has the largest tax/VAT percent?

SELECT 
	city,
	ROUND(AVG(tax_pct), 2) AS avg_tax
FROM sales
GROUP BY 1
ORDER BY avg_tax;








