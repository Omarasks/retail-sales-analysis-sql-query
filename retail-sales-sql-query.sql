-- Create sales schema 
drop table if exists  retail_DB;
create table retail_DB (
	transactions_id INT primary key,
	sale_date DATE,
	sale_time TIME, 
	customer_id INT, 
	gender VARCHAR(20),
	age INT,
	category VARCHAR(40),
	quantity INT, 
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale INT
);

select * from retail_DB
order by transactions_id asc 
limit 10;

-- count number of records in schema 
select 
	count(*)
from retail_DB;

-- Data cleaning 
select * from retail_DB 
where 
	transactions_id is null
	or
	sale_date is null
	or 
	sale_time is null 
	or 
	customer_id is null 
	or 
	gender is null 
	or 
	category is null 
	or 
	quantity is null 
	or 
	price_per_unit is null 
	or 
	cogs is null 
	or 
	total_sale is null;

-- delete tables with null values

delete from retail_DB 
where 
	transactions_id is null
	or
	sale_date is null
	or 
	sale_time is null 
	or 
	customer_id is null 
	or 
	gender is null 
	or 
	category is null 
	or 
	quantity is null 
	or 
	price_per_unit is null 
	or 
	cogs is null 
	or 
	total_sale is null;

-- Data exploration 

-- total number of sales record 
select 
	count(*) as total_sale
from retail_DB;

-- total number of unique customers 
select 
	count(distinct customer_id) as no_of_customer
from retail_DB;

-- total number of product category 
select 
	count(distinct category) as no_of_category
from retail_DB;

-- mention category 
select 
	distinct category
from retail_DB;

-- total sales value 
select 
	sum(total_sale) as total_sales_value 
from retail_DB;

-- solving business problems 
-- Q.1 write a SQL query to retreive all columns for sales made on '2022-11-05'
-- Q.2 write a SQL query to retrieve all transactions where the category is 'Clothing ' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 write a SQL query to calculate the total sales (total_sale) for each category 
-- Q.4 write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
-- Q.5 write a SQL query to find all transactions where the total_sale is greater than 1000 
-- Q.6 write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 write a SQL query to calculate the average sale for each month. Find out best selling month in each year 
-- Q.8 write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 write a SQL query to find the number of unique customers who purchased items from each category 
-- Q.10 write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening > 17)


-- Q.1 write a SQL query to retreive all columns for sales made on '2022-11-05'
select * 
from retail_DB 
where sale_date = '2022-11-05'; 

-- Q.2 write a SQL query to retrieve all transactions where the category is 'Clothing ' and the quantity sold is more than 10 in the month of Nov-2022
select * 
from retail_DB 
where
	category = 'Clothing'
	and 
	to_char(sale_date, 'yyyy-mm') = '2022-11'
	and 
	quantity >= 4;

-- Q.3 write a SQL query to calculate the total sales (total_sale) for each category 
select
	category,
	sum(total_sale) as total_sale_val, 
	count(*) as total_orders
from retail_DB 
group by category; 

-- Q.4 write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
select 
	 round(avg(age), 2) as avg_age
from retail_DB
where
	category = 'Beauty'; 

-- Q.5 write a SQL query to find all transactions where the total_sale is greater than 1000 
select 
	count(*)
from retail_DB 
where
	total_sale >= 1000; 

-- Q.6 write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
	count(*)transactions_id,
	gender,
	category
from retail_DB 
group by gender, category
order by 1 desc; 

-- Q.7 write a SQL query to calculate the average sale for each month. Find out best selling month in each year 
select * from (
select 
	extract(month from sale_date) as month,
	extract(year from sale_date) as year,
	avg(total_sale) as avg_sale,
	rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank 
from retail_DB
group by year, month
) as rank_table 
where rank = 1; 

-- Q.8 write a SQL query to find the top 5 customers based on the highest total sales 
select
	customer_id, 
	sum(total_sale) as total_sales 
from retail_DB 
group by customer_id
order by total_sales desc
limit 5; 

-- Q.9 write a SQL query to find the number of unique customers who purchased items from each category 
select 
	count(distinct customer_id) as unique_customers, 
	category
from retail_DB 
group by category; 

-- Q.10 write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening > 17)
with hourly_sale 
as 
(
select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning' 
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_DB
) 
select
	shift,
	count(*) as total_orders
from hourly_sale 
group by shift;

-- End of project 





	