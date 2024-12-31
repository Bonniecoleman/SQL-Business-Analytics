# SQL-RFM-Analysis

Introduction
This project is designed to help analyze sales data, customer demographics, and product information using a well-structured relational database. It includes three primary tables: customer, product, and sales. These tables are interconnected to provide a comprehensive view of customer behavior, product performance, and sales trends.

Entity-Relationship Diagram (ERD)
Below is the ERD illustrating the relationships between the tables:
![ERD Diagram](./sales_analysis_ERD.png)


Database Schema

Customer Table

Contains information about the customers.

mem_no: Unique ID for each customer (Primary Key).

gender: Gender of the customer.

birthday: Birthdate of the customer.

addr: Address of the customer.

join_date: Date the customer joined.

Product Table

Holds data about the products.

product_code: Unique identifier for each product (Primary Key).

category: Product category (e.g., electronics, clothing).

type: Product type.

brand: Brand of the product.

product_name: Name of the product.

price: Price of the product.

Sales Table

Records customer purchase details.

order_no: Unique identifier for each order (Primary Key).

mem_no: Links to the customer table (Foreign Key).

order_date: Date the order was placed.

product_code: Links to the product table (Foreign Key).

sales_qty: Quantity of the product purchased.

Relationships

The sales table connects customer and product tables:

mem_no in sales references mem_no in customer (Many-to-One).

product_code in sales references product_code in product (Many-to-One).

How to Use

Clone the repository to your local system.

Import the database schema into your SQL database management system.

Populate the tables with sample data or your own data.

Applications

This database can be utilized for:

Segmenting and analyzing customer data.

Evaluating product sales performance.

Identifying sales trends and patterns.

Future Enhancements

Enrich customer data with additional demographic details.

Expand product attributes to include stock levels.

Integrate sales data with regional metrics for deeper insights.

License

This project is licensed under the MIT License. Feel free to use and modify it as needed.

