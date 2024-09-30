BikeStore Database Analysis 🚴

Project Overview
This project involves querying and analyzing the BikeStore Database to gain insights into the company's sales, customers,
stores, and products. The SQL scripts provided answer key business questions such as identifying the most expensive bike,
calculating store revenues, and analyzing customer order statuses.

Key Insights
Most Expensive Bike:

We identified the priciest bike in the database and examined the possible reasons for its premium pricing.
Customer Analysis:

Total customers were counted, and their purchasing behaviors were analyzed based on order status.
Store Performance:

Calculated the total sales revenue per store.
Category and Product Analysis:

Analyzed which product categories sold the most and faced the most rejected orders.
Staff and Store Analysis:

Examined the number of staff members, identified lead staff, and connected stores with higher inventory and sales.

Database Schema
The BikeStore database consists of multiple tables:

production.categories: Contains product categories like mountain bikes, road bikes, etc.
production.brands: Contains brand names like Trek, Electra, etc.
production.products: Contains product details like name, price, brand, and category.
sales.customers: Contains customer information.
sales.stores: Stores and their respective details.
sales.orders: Order details including order status, dates, and the staff responsible.
sales.order_items: Products within each order, with price, quantity, and discount information.
production.stocks: Inventory levels for each store.

Tech Stack
SQL: Structured Query Language (SQL) for querying the database.
SSMS: SQL Server Management Studio for running queries.
