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



 -- checking for nulls
SELECT * FROM retail_sales
WHERE
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL	
OR
gender IS NULL
OR 
age IS NULL
OR 
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;


 -- deleting nulls
DELETE FROM retail_sales
WHERE
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL	
OR
gender IS NULL
OR 
age IS NULL
OR 
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;


 -- Data exploration

  -- how many customers do we have?
  SELECT COUNT(DISTINCT customer_id) AS ct FROM retail_sales;

  -- how many unqiue categories
 SELECT DISTINCT (category) AS unique_categories FROM retail_sales;


 -- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write an SQL query to retrieve all columns for sales made on '2022-11-05'
 SELECT * FROM retail_sales
 WHERE sale_date = '2022-11-05';

 -- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
  -- and the quantity sold is more than 4 in the month of Nov-2022
 SELECT * FROM retail_sales
 WHERE 
 category = 'Clothing'
 AND
 TO_CHAR(sale_date, 'YYYY-MM')='2022-11'
  AND
    quantity >= 4;
	
 -- Q.3 Write an SQL query to calculate the total sales (total_sale) for each category.

 SELECT SUM(total_sale) AS total_sales,
 category
FROM retail_sales
group by 2;

-- Q.4 Write an SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT avg(age) AS average_age_of_customers
  FROM retail_sales
  WHERE  category='Beauty';

 -- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale>1000;

-- Q.6 Write an SQL query to find 
-- the total number of transactions (transaction_id) made by each gender in each category.

SELECT COUNT(transactions_id) AS total_transactions,
gender,category
FROM all_info
GROUP BY 2,3;


-- Q.7 Write an SQL query to calculate the average sale for each month.
 -- Find out best selling month in each year

--(a) USING CTE
WITH CTE AS 
	(SELECT EXTRACT(YEAR FROM sale_date ) AS yr,
	EXTRACT(MONTH FROM sale_date ) AS mn,
	AVG(total_sale) AS ag,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date ) ORDER BY AVG(total_sale) ) AS rn
	FROM all_info
	GROUP BY 1,2) 
	SELECT yr,mn,ag,rn FROM CTE 
	WHERE rn=1;
    
    
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

-- Q.8 Write an SQL query to find the top 5 customers based on the highest total sales 

--(a)USING LIMIT
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

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



-- Q.9 Write a SQL query to find 
--the number of unique customers who purchased items from each category.

SELECT COUNT(DISTINCT (customer_id)) AS ct_unique,
category
FROM all_info
GROUP BY 2;


-- Q.10 Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17)


-- (a) USING EXTRACT()
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
GROUP BY shift;

-- End of project
	