
-- ============================================================
--  RETAILMART — SQL CAPSTONE PROJECT
--  Industry : Retail (3-store chain)
--  Duration : 3 Hours
--  Covers   : DDL, DML, SELECT, JOINs, GROUP BY, Subqueries, 
--             UNION/INTERSECT/EXCEPT, CTEs,
--             Window Functions, PIVOT, Views, Indexes,
--             Stored Procedures
-- ============================================================
--  STORY:
--  You are a data analyst at RetailMart — a retail chain with
--  3 stores across Pakistan. Your job is to build their
--  database from scratch and answer key business questions.
-- ============================================================


-- ============================================================
--  HOUR 1 — BUILD & LOAD
-- ============================================================

-- ============================================================
--  TASK 1: DDL — Create the schema
-- ============================================================

-- ============================================================
--  RETAILMART — CREATE TABLES PRACTICE
--  Task: Fill in the blanks to complete each CREATE TABLE.
--  Table names, column names, and hints are given.
--  You must choose the correct data type and constraints.
-- ============================================================
--  DATA TYPES TO CHOOSE FROM:
--    INT, VARCHAR(n), CHAR(n), DECIMAL(10,2), DATE
--
--  CONSTRAINTS TO CHOOSE FROM:
--    PRIMARY KEY, IDENTITY(1,1), NOT NULL, UNIQUE,
--    DEFAULT, CHECK, REFERENCES
-- ============================================================

-- Create database of Retail Store
CREATE DATABASE retailStore1;

-- Create Schema Retail Mart
CREATE SCHEMA retailmart

--TABLE 1: categories
--  Stores product categories like Electronics, Clothing, etc.
CREATE TABLE retailmart.categories(
category_id INT PRIMARY KEY IDENTITY(1,1),
category_name VARCHAR(100) NOT NULL
);

--  TABLE 2: products
--  Stores all products sold at RetailMart.
CREATE TABLE retailmart.products(
product_id INT PRIMARY KEY IDENTITY(1,1),
product_name VARCHAR(100) NOT NULL,
category_id INT NOT NULL REFERENCES retailmart.categories(category_id),
price DECIMAL(10,2) NOT NULL CHECK (price > 0),
stock_quantity INT NOT NULL DEFAULT 0
);

--  TABLE 3: stores
--  The 3 RetailMart store locations.

CREATE TABLE retailmart.stores(
store_id INT PRIMARY KEY IDENTITY(1,1),
store_name VARCHAR(300) NOT NULL,
city VARCHAR(100) NOT NULL
);


--  TABLE 4: customers
--  Registered customers of RetailMart.


CREATE TABLE retailmart.customers (
customer_id INT PRIMARY KEY IDENTITY(1,1),
full_name VARCHAR(300) NOT NULL,
email VARCHAR(300) NOT NULL UNIQUE,
city VARCHAR(300),
gender  CHAR(1) CHECK(gender IN( 'M' , 'F'))
);

--  TABLE 5: orders
--  Each row = one order placed by a customer at a store.
-- ============================================================

CREATE TABLE retailmart.orders (
order_id INT PRIMARY KEY IDENTITY(1,1),
store_id INT NOT NULL REFERENCES retailmart.stores(store_id),
customer_id INT NOT NULL REFERENCES retailmart.customers(customer_id),
order_date DATE NOT NULL DEFAULT GETDATE(),
status VARCHAR(20) NOT NULL DEFAULT 'Pending'
CHECK(status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

--  TABLE 6: order_items
--  Each row = one product line inside an order.
--  One order can have multiple items.

CREATE TABLE retailmart.order_items (
item_id INT PRIMARY KEY IDENTITY(1,1),
order_id INT NOT NULL REFERENCES retailmart.orders(order_id),
product_id INT NOT NULL REFERENCES retailmart.products(product_id),
quantity INT NOT NULL CHECK (quantity>0),
unit_price DECIMAL(10,2) NOT NULL 
);

--  END OF EXERCISE

-- ============================================================
--  TASK 2: DML — INSERT, UPDATE, DELETE, MERGE
-- ============================================================
-- INSERT categories
INSERT INTO retailmart.categories (category_name) VALUES
('Electronics'), ('Clothing'), ('Groceries'), ('Accessories'), ('Home Appliances');

-- INSERT products
INSERT INTO retailmart.products (product_name, category_id, price, stock_quantity) VALUES
('Samsung 4K TV',        1,  85000, 15),
('iPhone 15',            1, 295000, 10),
('Wireless Earbuds',     4,   4500, 80),
('Leather Jacket',       2,   8500, 40),
('Linen Shirt',          2,   2200, 60),
('Rice 5kg',             3,    950, 200),
('Cooking Oil 3L',       3,    750, 150),
('Sunglasses',           4,   1800, 55),
('Microwave Oven',       5,  18000, 20),
('Electric Kettle',      5,   3200, 35);

-- INSERT stores
INSERT INTO retailmart.stores (store_name, city) VALUES
('RetailMart Karachi',   'Karachi'),
('RetailMart Lahore',    'Lahore'),
('RetailMart Islamabad', 'Islamabad');

-- INSERT customers
INSERT INTO retailmart.customers (full_name, email, city, gender) VALUES
('Ahmed Khan',      'ahmed@gmail.com',   'Karachi',   'M'),
('Sara Malik',      'sara@gmail.com',    'Lahore',    'F'),
('Bilal Hussain',   'bilal@gmail.com',   'Islamabad', 'M'),
('Fatima Nawaz',    'fatima@gmail.com',  'Karachi',   'F'),
('Omar Sheikh',     'omar@gmail.com',    'Lahore',    'M'),
('Nadia Ali',       'nadia@gmail.com',   'Islamabad', 'F'),
('Hamza Raza',      'hamza@gmail.com',   'Karachi',   'M'),
('Zara Qureshi',    'zara@gmail.com',    'Lahore',    'F');


-- INSERT orders
INSERT INTO retailmart.orders (store_id, customer_id, order_date, status) VALUES
(1, 1, '2024-01-10', 'Delivered'),
(1, 4, '2024-01-15', 'Delivered'),
(2, 2, '2024-02-03', 'Delivered'),
(2, 5, '2024-02-20', 'Shipped'),
(3, 3, '2024-03-05', 'Delivered'),
(3, 6, '2024-03-18', 'Pending'),
(1, 7, '2024-04-01', 'Delivered'),
(2, 8, '2024-04-22', 'Cancelled'),
(1, 1, '2024-05-10', 'Delivered'),
(3, 3, '2024-06-01', 'Shipped');

-- INSERT order items
INSERT INTO retailmart.order_items (order_id, product_id, quantity, unit_price) VALUES
(1,  2,  1, 295000),
(1,  3,  2,   4500),
(2,  4,  1,   8500),
(3,  5,  3,   2200),
(3,  8,  1,   1800),
(4,  1,  1,  85000),
(5,  9,  1,  18000),
(5, 10,  2,   3200),
(6,  6,  4,    950),
(7,  3,  1,   4500),
(8,  2,  1, 295000),
(9,  4,  2,   8500),
(10, 9,  1,  18000);

-- UPDATE: Reduce price of Electric Kettle by 10%
UPDATE retailmart.products
SET price = price * 0.90
WHERE product_id = 10;

-- DELETE: Remove the cancelled order's items and the order itself
DELETE FROM retailmart.order_items WHERE order_id = 8;
DELETE FROM retailmart.orders       WHERE order_id = 8;

-- ============================================================
--  HOUR 2 — QUERY & ANALYZE
-- ============================================================

-- ============================================================
--  TASK 3: SELECT, filtering, sorting
-- ============================================================

-- All products under Rs. 5,000
SELECT *
FROM retailmart.products
WHERE price > 500;

-- Customers from Karachi
SELECT *
FROM [retailmart].[customers]
WHERE city = 'Karachi'
-- Orders placed in 2024 sorted by date descending

SELECT *
FROM [retailmart].[orders]
WHERE YEAR(ORDER_DATE) = 2024
ORDER BY ORDER_DATE DESC;


-- ============================================================
--  TASK 4: JOINs — INNER, LEFT, RIGHT
-- ============================================================

-- INNER JOIN: Orders with customer name and product details

SELECT
c.full_name,
o.order_id,
p.product_name
FROM [retailmart].[orders] o
INNER JOIN [retailmart].[customers] c
ON o.customer_id = c.customer_id
INNER JOIN [retailmart].[order_items] oi
ON o.order_id = oi.order_id
INNER JOIN [retailmart].[products] p
ON oi.product_id = p.product_id

-- LEFT JOIN: All customers including those with no orders
SELECT *
FROM[retailmart].[customers] c
LEFT JOIN [retailmart].[orders] o
ON c.customer_id = o.customer_id

-- ============================================================
--  TASK 5: GROUP BY + CASE
-- ============================================================

-- Total revenue by store and category 

SELECT
    c.category_name,
    s.store_name,
    SUM(oi.quantity * oi.unit_price ) AS total_revenue
FROM [retailmart].[orders] o
JOIN [retailmart].[order_items] oi
ON oi.order_id = o.order_id
JOIN [retailmart].[stores] s
ON s.store_id = o.order_id
JOIN [retailmart].[products] p
ON p.product_id = oi.product_id
JOIN [retailmart].[categories] c
ON c.category_id = p.category_id
GROUP BY  c.category_name,s.store_name;

-- Label each product as Budget / Mid-range / Premium using CASE
SELECT 
    product_name,
    price,
    CASE
        WHEN price <10000 THEN 'Budget'
        WHEN price<20000 THEN 'Mid-range'
        ELSE  'Premium'
    END AS price_category
FROM [retailmart].[products] 

-- ============================================================
--  TASK 7: Subqueries 
-- ============================================================

-- Orders where the total exceeds the average order value (subquery in WHERE)
select o.order_id,
       sum(quantity * unit_price) as total
from retailmart.order_items o
group by o.order_id
having sum(quantity * unit_price) >
(
    select avg(quantity * unit_price)
    from retailmart.order_items
);

-- ============================================================
--  TASK 8: Set operators — UNION, INTERSECT, EXCEPT
-- ============================================================

-- UNION: All unique cities where we have customers OR stores
SELECT
    city
FROM [retailmart].[customers]

UNION

SELECT
    city
FROM [retailmart].[stores]


-- INTERSECT: Customers who ordered from BOTH store 1 AND store 2
SELECT
    customer_id
FROM [retailmart].[orders]
WHERE store_id = 1
INTERSECT
SELECT
    customer_id
FROM [retailmart].[orders]
WHERE store_id = 2
    

-- EXCEPT: Customers who have NEVER placed an order
SELECT 
    customer_id
FROM [retailmart].[customers]
EXCEPT 
SELECT
    customer_id
FROM [retailmart].[orders]


-- ============================================================
--  TASK 9: CTEs + Recursive CTE
-- ============================================================

-- Regular CTE: Top 5 customers by total spend
WITH customer_spend AS
(
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.unit_price) AS total_spend
    FROM [retailmart].[orders] o
    JOIN[retailmart].[order_items]  oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT TOP 5
    c.customer_id,
    c.full_name,
    cs.total_spend
FROM customer_spend cs
JOIN [retailmart].[customers] c
    ON cs.customer_id = c.customer_id

    -- ============================================================
--  TASK 10: Window functions
-- ============================================================

-- ROW_NUMBER and RANK: Products ranked by revenue
WITH cte AS
(SELECT
    p.product_id,
    p.product_name,
    sum(oi.quantity * unit_price) AS total_revenue
FROM [retailmart].[products] p
JOIN [retailmart].[order_items] oi
ON p.product_id = oi.product_id
GROUP BY p.product_id,p.product_name
)
SELECT
    product_id,
    product_name,
    total_revenue,
    ROW_NUMBER()OVER(ORDER BY total_revenue) AS RN
    FROM cte

-- Running total of revenue by store
WITH store_revenue AS
(
    SELECT
        o.store_id,
        o.order_id,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM retailmart.orders o
    JOIN retailmart.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.store_id, o.order_id
)
SELECT
    store_id,
    order_id,
    revenue,
    SUM(revenue) OVER ( PARTITION BY store_id ORDER BY order_id) AS running_total
FROM store_revenue
ORDER BY store_id, order_id;

-- ============================================================
--  TASK 12: Views
-- ============================================================

-- Standard view: Order summary

CREATE VIEW order_summary AS 
SELECT
    o.order_id,
    o.order_date,
    c.customer_id,
    c.full_name,
    o.store_id,
    SUM(oi.quantity* oi.unit_price) AS order_total
FROM [retailmart].[orders] o
JOIN [retailmart].[customers] c
ON c.customer_id = o.customer_id
JOIN [retailmart].[order_items] oi
ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date, c.customer_id, c.full_name, o.store_id

SELECT *
FROM order_summary;

-- Indexed (materialized) view: Store revenue totals
-- Note: Requires SCHEMABINDING + unique clustered index
CREATE VIEW retailmart.vw_StoreRevenue
WITH SCHEMABINDING
AS
SELECT
    o.store_id,
    COUNT_BIG(*) AS total_items_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM retailmart.orders o
JOIN retailmart.order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.store_id;

CREATE UNIQUE CLUSTERED INDEX IX_StoreRevenue
ON retailmart.vw_StoreRevenue(store_id);

-- ============================================================
--  TASK 13: Indexes
-- ============================================================

-- Composite index: Speed up queries filtering by customer + date
CREATE INDEX IX_Orders_Customer_Date
ON retailmart.orders (customer_id, order_date);

-- Filtered index: Only index Pending orders (partial index)
CREATE INDEX IX_Orders_Pending
ON retailmart.orders (order_id)
WHERE status = 'Pending';

-- Non-clustered index on customer email for fast lookups
CREATE NONCLUSTERED INDEX IX_Customers_Email
ON retailmart.customers (email);
-- Verify indexes
EXEC sp_helpindex 'retailmart.orders';
EXEC sp_helpindex 'retailmart.customers';

-- ============================================================
--  TASK 14: Stored Procedures + Error Handling
-- ============================================================



-- Procedure 1: Monthly sales report for a store
CREATE PROCEDURE retailmart.sp_MonthlySalesReport
    @StoreID INT,
    @Year INT = NULL
AS
BEGIN
    BEGIN TRY

        -- If year is not provided, use current year
        IF @Year IS NULL
            SET @Year = YEAR(GETDATE());

        -- Main Query: Monthly Sales
        SELECT
            MONTH(o.order_date) AS sale_month,
            DATENAME(MONTH, o.order_date) AS month_name,
            SUM(oi.quantity * oi.unit_price) AS total_sales
        FROM retailmart.orders o
        JOIN retailmart.order_items oi
            ON o.order_id = oi.order_id
        WHERE o.store_id = @StoreID
          AND YEAR(o.order_date) = @Year
          AND o.status <> 'Cancelled'
        GROUP BY MONTH(o.order_date),
                 DATENAME(MONTH, o.order_date)
        ORDER BY sale_month;

    END TRY

    BEGIN CATCH
        SELECT
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;

-- Test the report for Store 1 (Karachi)
EXEC retailmart.sp_MonthlySalesReport @StoreID = 1, @Year = 2024;

-- Test with default year
EXEC retailmart.sp_MonthlySalesReport @StoreID = 2;


-- ============================================================
--  END OF CAPSTONE PROJECT
-- ============================================================


