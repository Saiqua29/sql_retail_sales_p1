# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.
- **Data Import from Excel to SQL**: Make sure to correct the dtypes in excel to make them compatible as per SQL. Choose the 'import/export Data' from left clicking the table in Postgresql and import the csv file, make sure to check 'header'. In MYSQL, choose 'Table Data Import Wizard', engter file path, use existing table & start the import.

```sql
CREATE DATABASE sql_project_1;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write an SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write an SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
-- (a) USING TO_CHAR() 
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4;
```
```sql
-- (b) USING DATE_FORMAT()
  SELECT * FROM retail_sales
 WHERE 
 category = 'Clothing'
 AND
 DATE_FORMAT(sale_date, '%Y-%m')='2022-11'
  AND
    quantity >= 4; 
```

3. **Write an SQL query to calculate the total sales (total_sale) for each category.**:
```sql
 SELECT SUM(total_sale) AS total_sales,
 category
FROM retail_sales
group by 2;
```

4. **Write an SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT avg(age) AS average_age_of_customers
  FROM retail_sales
  WHERE  category='Beauty';
```

5. **Write an SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale>1000;
```

6. **Write an SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT COUNT(transactions_id) AS total_transactions,
gender,category
FROM retail_sales
GROUP BY 2,3;
```

7. **Write an SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
--(a) USING CTE
WITH CTE AS 
	(SELECT EXTRACT(YEAR FROM sale_date ) AS yr,
	EXTRACT(MONTH FROM sale_date ) AS mn,
	AVG(total_sale) AS ag,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date ) ORDER BY AVG(total_sale) ) AS rn
	FROM retail_sales
	GROUP BY 1,2) 
	SELECT yr,mn,ag,rn FROM CTE 
	WHERE rn=1;
 ```   

  ```sql  
 --(b) USING SUBQUERY	
 SELECT 
       yr,
       mn,
    avg_sale,
    rn
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as yr,
    EXTRACT(MONTH FROM sale_date) as mn,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rn
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rn=1;
```

```sql
-- (c) USING TO_CHAR() 
WITH CTE AS 
	(SELECT TO_CHAR(sale_date,'YYYY') AS yr,
	TO_CHAR(sale_date,'mm' ) AS mn,
	AVG(total_sale) AS ag,
	RANK() OVER(PARTITION BY TO_CHAR(sale_date,'YYYY') ORDER BY AVG(total_sale) ) AS rn
	FROM retail_sales
	GROUP BY 1,2) 
	SELECT yr,mn,ag,rn FROM CTE 
	WHERE rn=1;
```

```sql
-- (d) USING DATE_FORMAT()
WITH CTE AS 
	(SELECT DATE_FORMAT(sale_date,'%Y') AS yr,
	DATE_FORMAT(sale_date,'%m' ) AS mn,
	AVG(total_sale) AS ag,
	RANK() OVER(PARTITION BY DATE_FORMAT(sale_date,'%Y') ORDER BY AVG(total_sale) ) AS rn
	FROM retail_sales
	GROUP BY 1,2) 
	SELECT yr,mn,ag,rn FROM CTE 
	WHERE rn=1;
```

8. **Write an SQL query to find the top 5 customers based on the highest total sales.**:
```sql
--(a)USING LIMIT
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```
```sql
--(b)USING ROW_NUMBER()
WITH CTE AS
			(SELECT 
				customer_id,
				SUM(total_sale) as total_sales,
				ROW_NUMBER() OVER(ORDER BY SUM(total_sale) DESC) AS rn
			FROM retail_sales
            GROUP BY customer_id)
            SELECT * FROM CTE
			WHERE rn<6;
```


9. **Write an SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT COUNT(DISTINCT (customer_id)) AS ct_unique,
category
FROM retail_sales
GROUP BY 2;
```

10. **Write an SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database & Run the Queries**: Run the SQL scripts provided in the `retail_sales_project.sql` file to create database, tables and to perform your analysis.
3. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Saiqua29 /

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Connected if you'd like to

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media:

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/saiqua-shaikh-b28682124/)


Thank you for your support, and I look forward to connecting with you!
