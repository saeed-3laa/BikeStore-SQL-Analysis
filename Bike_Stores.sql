create database BikeStores
use BikeStores


SELECT * 
FROM production.categories;

SELECT * 
FROM production.brands;

SELECT * 
FROM production.products;

SELECT * 
FROM production.stocks;

SELECT * 
FROM sales.customers;

SELECT * 
FROM sales.stores;

SELECT * 
FROM sales.staffs;

SELECT * 
FROM sales.orders;

SELECT * 
FROM sales.order_items;

--------------------------------------------------------------------
-- 1) Which bike is most expensive? What could be the motive behind pricing this 
--bike at the high price?select top 1 product_name , list_price pricefrom production.productsorder by list_price desc-- The most expensive bikes often feature premium materials, such as --carbon fiber frames, advanced braking systems, or top-tier gears. ---------------------------------------------------------------------2) How many total customers does BikeStore have? Would you consider 
--people with order status 3 as customers substantiate your answer?

select count(distinct customer_id) #customers
from sales.customers
-------------------------------------------------------------------
--3) How many stores does BikeStore have?

select count(*) Number_Of_Stores
from sales.stores
---------------------------------------------------------------------4) What is the total price spent per order?
--Hint: total price = [list_price] *[quantity]*(1-[discount])select  order_id , sum((list_price) *(quantity)*(1-discount)) Total_pricefrom sales.order_items group by order_id---------------------------------------------------------------------5) What’s the sales/revenue per store?
--Hint: Sales revenue = ([list_price] *[quantity]*(1-[discount]))select o.store_id , sum((list_price) *(quantity)*(1-discount)) 'Sales/revenue'from sales.orders ojoin sales.order_items oion o.order_id = oi.order_idgroup by o.store_idorder by 'Sales/revenue' desc---------------------------------------------------------------------6) Which category is most sold?

select top 1 c.category_id , c.category_name , sum(p.list_price) Total_sales
from production.products p
join production.categories c
on p.category_id = c.category_id
group by c.category_id , c.category_name
order by Total_sales desc
-------------------------------------------------------------------
--7) Which category rejected more orders?

select c.category_id , c.category_name , count(o.order_id) #Rejected_orders
from production.categories c
join production.products p
on c.category_id = p.category_id  
join sales.order_items oion p.product_id = oi.order_id 
join sales.orders o
on oi.order_id = o.order_id
where order_status = 3
group by c.category_id , c.category_name
order by #Rejected_orders desc
-------------------------------------------------------------------
--8) Which bike is the least sold?

select oi.product_id , p.product_name , sum(oi.quantity) Total_sold
from sales.order_items oi
join production.products p
on oi.product_id = p.product_id
group by oi.product_id , p.product_name
order by Total_sold 
--there are 32 product sold only once time
-------------------------------------------------------------------
--9) What’s the full name of a customer with ID 259?

select customer_id , concat(first_name , ' ' , last_name) customer_name
from sales.customers
where customer_id =259
-------------------------------------------------------------------
--10) What did the customer on question 9 buy and when? What’s the status of this order?

select p.product_id , p.product_name , o.order_date , o.order_status
from production.products p
join sales.order_items oi
on p.product_id = oi.product_id
join sales.orders o
on o.order_id = oi.order_id
where o.customer_id = 259
--the status of this order is complete.
-------------------------------------------------------------------
--11) Which staff processed the order of customer 259? And from which store?

select o.customer_id , s.staff_id , concat(s.first_name ,' ',s.last_name) staff_name , st.store_id , st.store_name store_name
from sales.orders o
join sales.staffs s
on o.staff_id = s.staff_id
join sales.stores st
on o.store_id = st.store_id
where customer_id = 259
-------------------------------------------------------------------
--12) How many staff does BikeStore have? Who seems to be the lead Staff at BikeStore?

select count(*) #Staffs
from sales.staffs

select s.staff_id , concat(s.first_name ,' ',s.last_name) as 'staff_name' , count(o.order_id) #orders
from sales.staffs s
join sales.orders o
on s.staff_id = o.staff_id
group by s.staff_id ,  concat(s.first_name ,' ',s.last_name)
order by count(o.order_id) desc
--the staff (Marcelene Boyer) with id(6) is must be leader
-------------------------------------------------------------------
--13) Which brand is the most liked?

select top 1 b.brand_id , b.brand_name , sum(oi.quantity) #sold
from production.brands b
join production.products p
on b.brand_id = p.brand_id
join sales.order_items oi
on p.product_id = oi.product_id
group by b.brand_id , b.brand_name 
order by  #sold desc
-------------------------------------------------------------------
--14) How many categories does BikeStore have, and which one is the least liked?

select count(*)  #categories
from production.categories 

select top 1 c.category_id , c.category_name , sum(oi.quantity) #sold 
from production.categories c
join production.products p
on c.category_id= p.category_id
join sales.order_items oi
on p.product_id = oi.product_id
group by c.category_id , c.category_name
order by #sold 
-------------------------------------------------------------------
--15) Which store still have more products of the most liked brand?

with most_liked_brand as(
select top 1 b.brand_id , b.brand_name , sum(oi.quantity) #sold
from production.brands b
join production.products p
on b.brand_id = p.brand_id
join sales.order_items oi
on p.product_id = oi.product_id
group by b.brand_id , b.brand_name 
order by  #sold desc
)

select s.store_name , s.store_id , sum(st.quantity) #products_in_stock
from sales.stores s
join production.stocks st
on s.store_id = st.store_id
where st.product_id in(
	select p.product_id 
	from production.products p
	where p.brand_id in (select brand_id from most_liked_brand)
)
group by s.store_name , s.store_id
order by #products desc
-------------------------------------------------------------------
--16) Which state is doing better in terms of sales?

select c.state state , sum((list_price) *(quantity)*(1-discount)) Total_Sales
from sales.customers c
join sales.orders o
on c.customer_id = o.customer_id
join sales.order_items oi
on o.order_id = oi.order_id
group by c.state
order by Total_sales desc
-------------------------------------------------------------------
--17) What’s the discounted price of product id 259?
select product_id , list_price * (1-discount)  discounted_Price
from sales.order_items 
where product_id = 259
-------------------------------------------------------------------
--18) What’s the product name, quantity, price, category, model year and brand 
--name of product number 44?
select p.product_id , p.product_name , st.quantity , p.list_price , c.category_name , p.model_year , brand_name
from production.products p
join production.stocks st
on p.product_id = st.product_id
join production.categories c
on p.category_id = c.category_id
join production.brands b
on p.brand_id = b.brand_id
where p.product_id =44
-------------------------------------------------------------------
--19) What’s the zip code of CA?

select state ,zip_code
from sales.stores
where state='ca'
-------------------------------------------------------------------
--20) How many states does BikeStore operate in?

select count(distinct state) #states
from sales.customers
-------------------------------------------------------------------
--21) How many bikes under the children category were sold in the last 8 months?

select max(order_date)  last_order_date
from sales.orders;
--last date 2018-12-28
select c.category_name , sum(oi.quantity) #sold
from production.categories c
join production.products p
on c.category_id = p.category_id
join sales.order_items oi
on p.product_id = oi.product_id
join sales.orders o 
on oi.order_id = o.order_id
where c.category_name = 'children' and o.order_date >= '2018-4-28'
group by c.category_name 
-------------------------------------------------------------------
--22) What’s the shipped date for the order from customer 523

select customer_id , shipped_date
from sales.orders
where customer_id =523
-------------------------------------------------------------------
--23) How many orders are still pending?

select count(*) #orders
from sales.orders
where order_status = 1

-------------------------------------------------------------------
--24) What’s the names of category and brand does "Electra white water 3i -
--2018" fall under?

select c.category_name , b.brand_name
from production.products p
join production.categories c 
on p.category_id = c.category_id
join production.brands b 
on p.brand_id = b.brand_id
where p.product_name ='Electra white water 3i - 2018'
-------------------------------------------------------------------
