# Walmart Sales Data Analysis using SQL

## Project Overview

**Project Title**: Walmart Sales Data Analysis

**Database**: `Walmart_sales`

This project aims to analyze Walmart sales data to identify the top-performing branches and products, examine sales trends across different product categories, and understand customer behavior. The goal is to gain insights that can help improve and optimize sales strategies.

## Analysis List

**1. Product Analysis**

The analysis focuses on examining the Walmart sales data to understand the performance of various product lines. It aims to identify the different product categories available, determine which product lines are performing best in terms of sales and profitability, and highlight those that are underperforming and may require improvement. The insights gained from this analysis will support better decision-making and help optimize sales strategies.

**2. Sales Analysis**

This analysis aims to explore the sales trends of various products to evaluate how they perform over time. The findings will help assess the effectiveness of the business’s current sales strategies and identify any necessary modifications to improve performance and increase overall sales.

**3. Customer Analysis**

This analysis aims to identify and understand the different customer segments, examine their purchasing trends, and evaluate the profitability associated with each segment.

## Analytical Approach ##

**Data Wrangling**: This is the initial step of the analysis process, where the dataset is inspected to identify any missing or null values, as well as inconsistencies in the data. Appropriate data cleaning and replacement techniques are then applied to handle these issues, ensuring the dataset is complete, accurate, and ready for further analysis.

1. A database was created to store and manage the Walmart sales data efficiently.
2. Tables were designed and populated with the relevant data using SQL commands.
3. The NOT NULL constraint was applied to each field during table creation to ensure data completeness.
4. Columns were checked for null values, and none were found, confirming that the dataset is clean.

**Feature Engineering:** This will help use generate some new columns from existing ones.

1. A new column named time_of_day was added to categorize sales into Morning, Afternoon, and Evening. This helps analyze which part of the day generates the most sales.
2. A new column named day_name was created to extract the day of the week (Mon, Tue, Wed, Thu, Fri) for each transaction. This allows identification of the busiest days for each branch.
3. A new column named month_name was added to extract the month (Jan, Feb, Mar, etc.) from each transaction. This helps determine which months of the year contribute most to sales and profit.

**Exploratory Data Analysis (EDA):** Exploratory data analysis is done to answer the listed questions and aims of this project.

**Database Creation**: Created a database named `Walmart_sales`.

**Table Creation**

```sql
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
```
**Feature Engineering:** 1.  Add the time_of_day column

```sql
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

```
2. Add day_name column

```sql

SELECT 
	TO_CHAR(date, 'Day') AS day_name
FROM sales;


UPDATE sales
SET day_name = TO_CHAR(date, 'Day')
```

3. Add month_name column

```sql
SELECT 
	date,
	TO_CHAR(date, 'month') AS month_name
FROM sales;


AlTER TABLE sales ADD COLUMN month_name VARCHAR(15);

UPDATE sales
SET month_name = TO_CHAR(date, 'month');
```

## Business Questions To Answer ##

 1. How many unique cities does the data have?

```sql
SELECT 
	DISTINCT city,
	branch
FROM sales;
```

2. In which city is each branch?

```sql
SELECT 
	DISTINCT city,
	branch
FROM sales;
```
03. How many unique product lines does the data have?

```sql
SELECT 
	COUNT(DISTINCT product_line)
FROM sales
```

04. What is the most common payment method?

```sql
SELECT 
	payment,
	COUNT(payment) AS most_common_method
FROM sales
GROUP BY 1
ORDER BY most_common_method DESC
LIMIT 1;
```

05. What is the most selling product line?

```sql
SELECT 
	product_line,
	COUNT(product_line) AS most_sell
FROM sales
GROUP BY 1
ORDER BY most_sell DESC
LIMIT 1;
```

06. What is the total revenue by month?

```sql
SELECT 
	month_name AS month,
	SUM(total) AS total_revenue
From sales
GROUP BY month_name
ORDER BY total_revenue DESC;
```

07. What month had the largest COGS?

```sql
SELECT 
	month_name,
	SUM(cogs) AS total_cogs
From sales
GROUP BY 1
ORDER BY total_cogs DESC;
```


08. What product line had the largest revenue?

```sql
SELECT 
	product_line,
	SUM(total) AS total_revenue
FROM sales
GROUP BY 1
ORDER BY total_revenue DESC
LIMIT 1;
```

09. What is the city with the largest revenue?

```sql
SELECT 
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY 1, 2
ORDER BY total_revenue DESC
```
10. What product line had the largest tax?

```sql
SELECT 
	product_line,
	AVG(tax_pct) AS avg_tax
FROM sales
GROUP BY 1
ORDER BY avg_tax DESC;
```

11. Fetch each product line and add a column to those product line showing "Good", "Bad". 
Good if its greater than average sales.

```sql
SELECT 
	product_line,
	CASE
		WHEN AVG(quantity) > 5.5 THEN 'Good'
		ELSE 'Bad'
	END AS remark
FROM sales
GROUP BY 1
```

12. Which branch sold more products than average product sold?

```sql
SELECT 
	branch,
	SUM(quantity) AS total_quantity
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);
```

```sql
13. What is the most common product line by gender

SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;
```
14. What is the average rating of each product line

```sql
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;
```
15. How many unique customer types does the data have?

```sql
SELECT 
	DISTINCT customer_type
FROM sales;
```

16. How many unique payment methods does the data have?

```sql
SELECT 
	DISTINCT payment
FROM sales;
```
17. What is the most common customer type?

```sql
SELECT 
	 customer_type,
	 COUNT(customer_type) AS most_common
FROM sales
GROUP BY 1
ORDER BY most_common DESC;
```
18. What is the gender of most of the customers?

```sql
SELECT 
	gender,
	COUNT(*) AS gender_cus
FROM sales
GROUP BY gender
ORDER BY gender_cus DESC;
```
19. Which time of the day do customers give most ratings?

```sql
SELECT 
	time_of_day,
	ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY 1
ORDER BY avg_rating DESC;
```

20. Number of sales made in each time of the day per weekday 

```sql
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = 'Sunday'
GROUP BY time_of_day 
ORDER BY total_sales DESC;
```
21. Which of the customer types brings the most revenue?

```sql
SELECT 
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY 1
ORDER BY total_revenue DESC;
```
22. Which city has the largest tax/VAT percent?

```sql
SELECT 
	city,
	ROUND(AVG(tax_pct), 2) AS avg_tax
FROM sales
GROUP BY 1
ORDER BY avg_tax;
```

## Conclusion
This project provides a comprehensive foundation in SQL for data analysts, encompassing database setup, data cleaning, exploratory analysis, and the development of business-focused queries. The insights gained from this analysis support data-driven decision-making by revealing sales trends, customer behavior, and product performance.

## Author - Digbijoy Chakroborty

## Email: datawithdigbijoy@gmail.com

This project is part of my portfolio and demonstrates the SQL skills crucial for data analyst roles. I welcome any questions, feedback, or collaboration opportunities—feel free to reach out!

Thank you for your time and support—I look forward to connecting with you!












