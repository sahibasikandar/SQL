-- HOMEWORK: Indexes & Stored Procedures 
-- Topic : SQL Indexes + Stored Procedures 

-- ============================================================
--  PART A: INDEXES
-- ============================================================


-- Q1.
-- Write a query to create a non-clustered index on the
-- last_name column of sales.customers.
-- Then write a SELECT statement that would benefit from it.
-- Hint: Think about which queries filter by last name.
CREATE NONCLUSTERED INDEX IX_Customers_LastName
ON sales.customers(last_name);

SELECT *
FROM sales.customers
WHERE last_name = 'Smith';

-- Q2.
-- Create a composite index on sales.orders using
-- customer_id and order_date.
-- Write a query that filters on both columns and benefits
-- from this index.
-- Hint: Composite indexes work best when you filter on both columns.

CREATE NONCLUSTERED INDEX IX_Orders_CustomerID_OrderDate
ON sales.orders(customer_id, order_date);

SELECT *
FROM sales.orders
WHERE customer_id = 5
  AND order_date >= '2024-01-01'
  AND order_date <= '2024-12-31';

  -- Q3.
-- A teammate suggests adding a unique index on
-- sales.customers(phone_number).
-- What could go wrong with this?
-- What assumption must be true for this to be safe?
-- Hint: Think about duplicate or missing (NULL) values.

-- A unique index on the phone_number field may not work if there are already duplicate phone numbers in the table.
-- It can also cause issues if more than one customer is allowed to use the same phone number, such as family members sharing a number.
-- Therefore, a unique index should only be used when each customer has a different and unique phone number.


-- Q4.
-- Look at the columns below from a sales.orders table.
-- Decide which columns SHOULD have an index and which should NOT.
-- Explain your reasoning for each as a comment.
--
--   order_id     (Primary Key)
--   status       (only 3 values: Pending, Shipped, Delivered)
--   customer_id  (Foreign Key)
--   notes        (free text, rarely searched)

-- order_id: Should have an index because it is the Primary Key and is often used to find specific orders quickly.
-- status: Usually does not need an index because it has only a few possible values (Pending, Shipped, Delivered). An index would not improve performance much.
-- customer_id: Should have an index because it is a Foreign Key and is often used in joins and searches.
-- notes: Should not have a regular index because it contains long text and is not searched often. If searching notes is needed, a full-text index is a better option.

-- Q5.
-- Write the command to check existing indexes on production.products.
-- Then describe (as a comment) what the output columns tell you.
-- Hint: Use sp_helpindex.

EXEC sp_helpindex 'production.products';

-- ============================================================
--  PART B: STORED PROCEDURES
-- ============================================================

-- Q6.
-- Create a stored procedure called sp_GetCustomerOrders
-- that accepts a @CustomerID parameter and returns all orders
-- for that customer showing: order_id, order_date, order_status.
-- Test it using EXEC after you create it.

CREATE PROCEDURE sp_GetCustomerOrders
    @CustomerID INT
AS
BEGIN
    SELECT
        order_id,
        order_date,
        order_status
    FROM sales.orders
    WHERE customer_id = @CustomerID;
END;
GO
EXEC sp_GetCustomerOrders @CustomerID = 1;

-- Q7.
-- Modify sp_GetCustomerOrders from Q6 so that if no orders
-- are found for the given customer, it returns the message:
-- 'No orders found for this customer'
-- Hint: Use IF EXISTS or check @@ROWCOUNT.

ALTER PROCEDURE sp_GetCustomerOrders
    @CustomerID INT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM sales.orders
        WHERE customer_id = @CustomerID
    )
    BEGIN
        SELECT
            order_id,
            order_date,
            order_status
        FROM sales.orders
        WHERE customer_id = @CustomerID;
    END
    ELSE
    BEGIN
        PRINT 'No orders found for this customer';
    END
END;
GO


-- Q8.
-- Create a stored procedure sp_ProductsByCategory that accepts:
--   @CategoryID  INT
--   @MaxPrice    DECIMAL(10,2)  with a default value of 9999
-- It should return all matching products ordered by price (low to high).
-- Hint: Use a default parameter value like you saw with @threshold.
CREATE PROCEDURE sp_ProductsByCategory
    @CategoryID INT,
    @MaxPrice DECIMAL(10,2) = 9999
AS
BEGIN
    SELECT
        product_id,
        product_name,
        list_price
    FROM production.products
    WHERE category_id = @CategoryID
      AND list_price <= @MaxPrice
    ORDER BY list_price ASC;
END;
GO

-- ============================================================
--  PART C: MIXED / THINK QUESTIONS
-- ============================================================

-- Q9.
-- You have a sales.orders table with 2 million rows.
-- A stored procedure filters by store_id and order_date.
-- It runs very slowly.
-- What TWO things would you do to fix it, and why?
-- Hint: Think about both indexes and procedure logic.

-- 1. Create an index on (store_id, order_date) because these columns are used in the search conditions of the procedure. 
-- This helps SQL Server find the required records more quickly.
-- 2. Improve the stored procedure by avoiding SELECT *, unnecessary functions on indexed columns, and inefficient joins.
-- Selecting only the needed columns can improve performance and reduce processing time.


-- Q10.
-- A junior developer creates indexes on EVERY column of a table
-- to "make everything faster".
-- Write a short explanation (3-5 sentences) of why this is
-- actually a bad idea.
-- Hint: Think about how INSERT, UPDATE, and DELETE are affected.

-- Creating indexes on every column is not recommended because indexes use extra storage and can slow down INSERT, UPDATE, and DELETE operations. 
-- Indexes should only be created on columns that are frequently used in searches, filters, joins, or sorting.
