
--1 What is the category generating the maximum sales revenue?

select *, round(sum(sales),2) as sales_revenue
from Product
join Sale
on sale.Product_ID=Product.Product_ID
group by Category
order by sales_revenue DESC
-- 2 What about the profit in this category?
select *, round(sum(profit),2) as sales_revenue
from Product
join Sale
on sale.Product_ID=Product.Product_ID
group by Category
order by sales_revenue DESC

-- 3 Are they making a loss in any categroies?
select *, round(sum(Profit),2) as sales_revenue
from Product
join Sale
on sale.Product_ID=Product.Product_ID
group by Category
order by sales_revenue DESC

-- 4 What are 5 states generating the maximum and minimum sales revenue?#
-- Maximum sales
select *, round(sum(sales),2) as sales_revenue
from Customer
join Sale
on sale.Customer_ID=Customer.Customer_ID
join 'Order'
on Customer.Customer_ID='Order'.Customer_ID
join Address
on Address.Order_ID='order'.Order_ID
group by State
order by sales_revenue DESC
limit 5;
--- minimum sales
select *, round(sum(sales),2) as sales_revenue
from Customer
join Sale
on sale.Customer_ID=Customer.Customer_ID
join 'Order'
on Customer.Customer_ID='Order'.Customer_ID
join Address
on Address.Order_ID='order'.Order_ID
group by State
order by sales_revenue 
limit 5;
-- 5 What are the 3 products in each product segment with the highest sales?
select *
from(
select *, 
dense_rank() over (PARTITION by category  order by sales DESC ) as ranking
from Customer
join Sale
on sale.Customer_ID=Customer.Customer_ID
join Product
on sale.Product_ID=Product.Product_ID
group by Product_Name) 
where ranking <4;

-- 6 Are they the 3 most profitable products as well?
select *
from(
select *, 
dense_rank() over (PARTITION by category  order by Profit DESC ) as ranking
from Customer
join Sale
on sale.Customer_ID=Customer.Customer_ID
join Product
on sale.Product_ID=Product.Product_ID
group by Product_Name) 
where ranking <4;

-- 7 What are the 3 best-seller products in each product segment? (Quantity-wise)
drop TABLE if EXISTS temp1;
Create TEMPORARY Table if not exists temp1 as 
select *, 
sum(Quantity) over (PARTITION by Product_Name ) as count_quantity
from Customer
join Sale
on sale.Customer_ID=Customer.Customer_ID 
join Product
on sale.Product_ID=Product.Product_ID;

select *
from(
select *,
dense_rank() over (PARTITION by Category order by count_quantity DESC ) as ranking
from temp1
group by Product_Name)
where ranking <4
order by segment;



-- 8 What are the top 3 worst-selling products in every category? (Quantity-wise)
select *
from(
select *,
dense_rank() over (PARTITION by category order by count_quantity ) as ranking
from temp1
group by Product_Name)
where ranking <4
order by segment;

-- 9 How many unique customers per month are there for the year 2016. (There's a catch here: contrary to other 'heavier'
 -- RDBMS, SQLite does not support the functions YEAR() 
 -- or MONTH() to extract the year or the month in a date. You will have to create two new columns: year and month.)
 select count(distinct customer.Customer_ID) as count_cust,
 strftime('%m' , order_date) as mnth,
 strftime('%Y', order_date) as yr
 from 'order'
 JOIN Customer
on customer.Customer_ID='order'.customer_ID
WHERE  yr = '2016' 
GROUP BY mnth;

create TEMPORARY table temp2  as
select  strftime("%m", FirstOrderDate) as month, strftime("%Y",FirstOrderDate) as year, Customer_ID
from (select Customer_ID, min(Order_Date) as FirstOrderDate
      from 'order' o
      group by Customer_ID
     ) oc;

select count(customer_ID),year,month,Customer_ID
from temp2
Group BY month, year

select count(count_c)
from
(select count(customer_Id) as count_c, Customer_ID,
strftime("%m", Order_Date) as month, strftime("%Y",Order_Date) as year
from 'order'
group by year,Customer_ID)
group by year
