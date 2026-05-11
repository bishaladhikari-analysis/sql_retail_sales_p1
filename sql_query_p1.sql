-- Create Table
Drop Table if exists retail_Sales;
create Table retail_Sales(
transaction_id varchar(10) primary key,
sale_date date,
sale_time time,
customer_id varchar(10),
gender varchar(10),
age int,
category varchar(15),
quantity int,
price_per_unit DECIMAL(10,2),
cogs DECIMAL(10,2),	
Total_sales float
)
 select * from retail_Sales
 limit 10;

 -- count total data 
 select count(*) from retail_Sales
 
-- data cleaning:-
 -- find null value exist or not 
select * from retail_Sales
where
transaction_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or 
price_per_unit is null
or 
cogs is null
or 
Total_sales is null;

-- Delete null value exist 
delete from retail_Sales
where
transaction_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or 
price_per_unit is null
or 
cogs is null
or 
Total_sales is null

-- data explorations

-- how many sales we have ?
select count(*) as Total_sales from retail_Sales;

-- how many unique customer we have?
select count( distinct customer_id) as Total_sales from retail_Sales;

-- how many unique Category with name 
select distinct category  from retail_Sales;

-- data analysis and business key problems 

-- 1) write a sql query to retrieve all columns for sales made on '2022-11-05'
select * from retail_Sales
where 
sale_date = '2025-09-05';

--2)write a sql query to retrieve all transactioons where the category is 'clothing' and the quantity sold is more than 7 in the month of nov-2025
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 7
  AND sale_date >= '2025-11-01'
  AND sale_date < '2025-12-01'; 
--alternative
  SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 7
  AND 
  to_char(sale_date,'yyyy-mm') ='2025-11'

--3) rite a sql query to calculate the total sales(net_sale) and total_orders for each category.
select category ,
sum(Total_sales) as net_sales,
count(*) as total_orders
from retail_sales
group by 1 

--4)write a sql query to find the average age if customers who purchased items  from the 'beauty' category
select 
round(avg(age),2) as customer_age
from retail_sales
where 
category = 'Beauty'

--5)write a sql query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where
Total_sales > 1000;

--6)write a sql query to find tha total number of transaction(transaction_id) made by each gender in each category.
select 
gender,
category,
count(transaction_id) as Total_transaction
from retail_sales
group by
category,
gender
order by 1

-- alternative

SELECT 
    gender,
    category,
    COUNT(transaction_id) AS total_transaction
FROM retail_sales
GROUP BY 
    gender,
    category
ORDER BY 
    category,
    gender;

--7)write a sql query to calculate the average sale for each month, find out best selling onth in each years
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sales) AS avg_sale
FROM retail_sales
GROUP BY 
    EXTRACT(YEAR FROM sale_date),
    EXTRACT(MONTH FROM sale_date)
ORDER BY 
    year,
    month;

--alternative:
SELECT 
year,
month,
avg_sale 
FROM (
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sales) AS avg_sale,
	RANK() OVER( PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(Total_sales) DESC)
FROM retail_sales
GROUP BY 1,2
) AS t1
WHERE RANK = 1
--ORDER BY 1, 3 DESC

--8)write a sql query to  find the top 5 customer based on the highest total sales
select 
customer_id,
sum(Total_sales) as total_sales
from retail_sales
group by 1 
order by 2 Desc
limit 5 

--9) write a sql query to find the number of unique customer who purchased items from each category 
select 
category,
count(distinct customer_id) as unique_customer
from retail_sales
group by category


--10) write a sql query to create each shift and number of orders(example morm=ning <=12, afternoon between 12 and 17, evening >12)
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    
    COUNT(transaction_id) AS number_of_orders

FROM retail_sales

GROUP BY 
    CASE 
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END

ORDER BY number_of_orders DESC;


-- The End
 