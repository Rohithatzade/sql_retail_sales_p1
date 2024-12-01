-- sql retail sales analysis p1
create database sql_project_p1;
-- create table
create table retail_sales(
transactions_id	int primary key,
sale_date date,	
sale_time time,	
customer_id	int,
gender varchar(15),	
age	int,
category varchar(15),	
quantiy	int,
price_per_unit float,	
cogs float,	
total_sale float

);
use sql_project_p1;
select * from retail_sales;
-- check for null values
select * from retail_sales
where total_sale is null;
-- delete null values
delete from retail_sales
where transaction_id is null;

-- data exploration
-- how many sales we have
select count(*) from retail_sales; 
-- how many unique customers we have
select count(distinct customer_id) from retail_sales;
-- how many unique category we have
select count(distinct category) from retail_sales;

-- data analysis & bussiness key problems and answer
-- Q1 write a sql query to retrieve all columns for sales on '2022-11-05'
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';
-- Q2 write a sql query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 10 in the month of nov-2022
SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'clothing'
        AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
        AND quantiy >= 4;

-- Q3 write a sql query to calculate the total sales (total_sales) for each category
SELECT 
    category, SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY category;
-- write a sql query to find the average age of ccustomers who purchased items from the beuty category
SELECT 
    ROUND(AVG(age), 0)
FROM
    retail_sales
WHERE
    category = 'beauty';
-- Q5 write a query to find all transactions wher ethe total_sale is greater than 1000
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;
-- Q6 write a query to find the total number of transactions made by eaach gender in each category
SELECT 
    COUNT(transactions_id) AS total, gender, category
FROM
    retail_sales
GROUP BY gender , category
ORDER BY total DESC;
-- Q7 write a query to calculate the average sale for each month.find out best selling month in each year 
select year,msale,sale from(
SELECT 
    AVG(total_sale) AS sale,
    MONTH(sale_date) AS msale,
    YEAR(sale_date) AS year,
    rank() over(partition by YEAR(sale_date) order by  AVG(total_sale) desc) as rnk
FROM
    retail_sales
    
GROUP BY msale , year) as t1
where rnk=1;
 -- ORDER BY rnk desc;

-- Q5 write query to find top 5 customers based on the highest total sales
select * from retail_sales;
SELECT 
    customer_id, SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
 -- Q6 write query to find number of unique customers who purchased items from each category
 SELECT DISTINCT
    COUNT(DISTINCT customer_id) AS un_cust, category
FROM
    retail_sales
GROUP BY category;
 
 -- Q10 write a query to create each shift and number of orders (exa.morning <=12,afternoon between 12 & 17,evening>17)
 with hourly_sale
 as(
 select * ,
 case 
 when hour(sale_time)<12 then 'morning'
 when hour(sale_time) between 12 and 17 then 'afternoon'
 else 'evening'
 end as shift
 from retail_sales)
 select shift,count(*) from hourly_sale group by shift;
