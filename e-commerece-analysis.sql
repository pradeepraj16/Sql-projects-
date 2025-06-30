#--- create database---
create database if not exists Ecommerce_analysis;

# ---insert datazip file into Ecommerce_analysis

#---select table---
show databases;
use Ecommerce_analysis;
show tables;

#---chenge name of dataset---

rename table `list of orders` to list_of_orders;
rename table `order of detailse` to order_of_details;
show tables;

alter table list_of_orders
rename  column  `order ID` to  order_id;
alter table order_of_details 
rename column `order id` to order_id

#---select tables---

select*from list_of_orders;
select*from order_of_details;

#---ALTER table ADD  COLOUM TIME---

alter table list_of_orders
add column order_time time;
select*from list_of_orders;


#---set random timestamp---
set sql_safe_updates = 0;
update list_of_orders
set order_time = 
case floor(1 + RAND()*4)
when 1 then '08:00:00'
when 2 then '13:00:00'
when 3 then '18:00:00'
when 4 then '21:00:00'
end;

#---unique cities--- 
select distinct city from list_of_orders;

#---list_of_ orders join orders_details---
SELECT lo.Order_id, lo.CustomerName, od.Category, od.Amount, lo.order_time
FROM list_of_orders lo
JOIN order_of_details od ON lo.Order_id = od.order_id;

#----highest profit product----

select category,sum(profit) as total_revenue
from order_of_details 
group by category
order by total_revenue

#----state with most order -----

select state,count(*) as total_order
from list_of_orders 
group by state 
order by total_order;

#---city with highest revenue---

select city , sum(amount) as revenue
from list_of_orders inner join order_of_details
group  by city
order by revenue;
 
#----top salling category---
select category, sum(amount) as total_sale
from order_of_details
group by category 
order by total_sale ;

#----best time of day sales----
 

 SELECT 
  CASE 
    WHEN lo.order_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
    WHEN lo.order_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
    WHEN lo.order_time BETWEEN '17:00:00' AND '20:59:59' THEN 'Evening'
    ELSE 'Night'
  END AS Time_Slot,
  SUM(od.Amount) AS Total_Sales
FROM list_of_orders lo
JOIN order_of_details od ON lo.order_id = od.order_id
GROUP BY Time_Slot
ORDER BY Total_Sales DESC;