

-- ================================================================================
-- HOMEWORK: CLASS 4 - MODIFYING DATA, DDL, DATA TYPES & CONSTRAINTS

-- ================================================================================
-- SECTION A: DATA TYPES & CONSTRAINTS (Conceptual Questions)
-- ================================================================================

-- Q1: What data type would you use for a product's weight (e.g., 2.5 kg)?

weight DECIMAL(5,2)

-- Q2: In the sales.stores table, the zip_code is VARCHAR(5). Why not use INT?
ZIP code is stored as VARCHAR(5) rather than INT because postal codes are identifiers, not numeric values used in calculations.


-- Q3: Look at sales.orders.order_status. The comment says 1=Pending,2=Processing,3=Rejected,4=Completed.
--     Is TINYINT a good choice? Why not use INT?
Yes, TINYINT is a good choice because it requires less storage space than INT, making it more efficient for storing small numeric values.

-- Q4: If you add a CHECK constraint that rating must be BETWEEN 1 AND 5, what happens if you try to INSERT rating = 0?
The INSERT operation will fail because a rating of 0 violates the CHECK constraint, which only allows values between 1 and 5.

-- Q5: Why does sales.staffs have UNIQUE constraint on email but not on phone?
Each staff member must have a unique email address, but phone numbers are not always unique and can be updated.

-- Q6: Create a new table called sales.loyalty_programs with the following columns:
--     - program_id (INT, auto-increment starting 1, PRIMARY KEY)
--     - program_name (VARCHAR(100), NOT NULL, UNIQUE)
--     - discount_rate (DECIMAL(3,2), NOT NULL, DEFAULT 0.05, CHECK between 0.00 and 0.50)
--     - start_date (DATE, NOT NULL, DEFAULT GETDATE())
--     - end_date (DATE, NULL)

CREATE TABLE sales.loyalty_program(
program_id INT IDENTITY(1,1) PRIMARY KEY,
program_name VARCHAR(50) NOT NULL UNIQUE,
discount_rate DECIMAL(3,2) NOT NULL
	DEFAULT(0.05)
	CHECK (discount_rate BETWEEN 0.00 AND 0.50),
start_date DATE NOT NULL DEFAUlT GETDATE(),
end_date DATE NULL
);

-- Q7: Add a new column 'loyalty_program_id' (INT, NULL) to the sales.customers table.

ALTER TABLE [sales].[customers]
ADD loyalty_program_id INT NULL;

-- Q8: Add a FOREIGN KEY constraint to sales.customers.loyalty_program_id that references 
--     sales.loyalty_programs.program_id.
ALTER TABLE [sales].[customers]
ADD CONSTRAINT fk_customer_loyalty
FOREIGN KEY (loyalty_program_id )
REFERENCES sales.loyalty_programs(program_id);

-- Q9: Change the data type of sales.customers.zip_code from VARCHAR(5) to VARCHAR(10).
ALTER TABLE [sales].[customers]
ALTER COLUMN zip_code VARCHAR(10);

-- Q10: Drop the column 'birth_date' from sales.customers (first add it if it doesn't exist, then drop it).
-- add column 
ALTER TABLE [sales].[customers]
ADD date_of_birth DATE;

--Drop Column
ALTER TABLE [sales].[customers]
DROP COLUMN date_of_birth;

-- Q11: Create a new table production.product_reviews with appropriate columns and constraints:
--      - review_id (PK, auto-increment)
--      - product_id (FK to production.products)
--      - customer_id (FK to sales.customers)
--      - rating (TINYINT, 1-5)
--      - review_text (VARCHAR(1000))
--      - review_date (DATE, default today)

CREATE TABLE production.product_reviews(
review_id INT IDENTITY(1,1)PRIMARY KEY,
product_id INT,
customer_id INT,
rating TINYINT CHECK(rating BETWEEN 1 AND 5),
review_text VARCHAR(1000),
review_date DATE DEFAULT GETDATE(),

FOREIGN KEY (product_id)REFERENCES [production].[products](product_id),
FOREIGN KEY (customer_id)REFERENCES [sales].[customers](customer_id)
);

-- Q12: Insert a new brand called 'Santa Cruz' into production.brands.        
       
SET IDENTITY_INSERT production.brands ON;

INSERT INTO production.brands
(brand_id, brand_name)
VALUES (12, 'Santa Cruz');

SET IDENTITY_INSERT production.brands OFF;

-- Q13: Insert three new categories at once: 'Mountain', 'Road', 'Hybrid'.
select * from [production].[categories]

INSERT INTO [production].[categories]
    (category_name)
VALUES('Mountain'),('Road'),('Hybrid')

-- Q14: Insert a new product with the following details:
--      product_name = 'Santa Cruz Bronson'
--      brand_id = (the brand_id of 'Santa Cruz' from Q12)
--      category_id = (category_id of 'Mountain' from Q13)
--      model_year = 2025
--      list_price = 4299.99

INSERT INTO production.products (
    product_name,
    brand_id,
    category_id,
    model_year,
    list_price
)
VALUES (
    'Santa Cruz Bronson',
    12,
    8,
    2025,
    4299.99
);


-- Q15: Copy all customers from California (state = 'CA') into a new table called sales.ca_customers_backup.
--      (Create the table first with the same structure as sales.customers)
-- Step 1: Create backup table with same structure
SELECT *
INTO sales.ca_customers_backup
FROM sales.customers
WHERE 1 = 0;

-- Step 2: Copy California customers into backup table
INSERT INTO sales.ca_customers_backup
SELECT *
FROM sales.customers
WHERE state = 'CA';

-- Step 1: Create backup table
SELECT *
INTO sales.ca_customers_backup
FROM sales.customers
WHERE 1 = 0;

-- Step 2: Insert data without identity column
INSERT INTO sales.ca_customers_backup
(
    first_name,
    last_name,
    phone,
    email,
    street,
    city,
    state,
    zip_code
)
SELECT
    first_name,
    last_name,
    phone,
    email,
    street,
    city,
    state,
    zip_code
FROM sales.customers
WHERE state = 'CA';

-- Q16: Update the phone number of customer with customer_id = 10 to '(555) 123-4567'.
UPDATE sales.customers
SET phone = '(555) 123-4567'
WHERE customer_id = 10;

-- Q17: Increase the list price of all products in the 'Road' category by 8%.
UPDATE production.products
SET list_price = list_price * 1.08
WHERE category_id = (
    SELECT category_id
    FROM production.categories
    WHERE category_name = 'Road'
);

-- Q18: Mark all orders that have status = 4 (Completed) and shipped_date IS NULL 
--      to set shipped_date = order_date + 3 days.
UPDATE sales.orders
SET shipped_date = DATEADD(DAY, 3, order_date)
WHERE order_status = 4
  AND shipped_date IS NULL;

-- Q19: Set the manager_id of all staffs working at store_id = 1 to staff_id = 5 
--      (assume staff_id 5 is the manager of that store).
UPDATE sales.staffs
SET manager_id = 5
WHERE store_id = 1;

-- Q20: Update the discount for order_items where order_id = 100 and item_id = 2 to 0.15 (15%).
UPDATE sales.order_items
SET discount = 0.15
WHERE order_id = 100
  AND item_id = 2;

-- Q21: Delete the brand 'Santa Cruz' you inserted in Q12.
DELETE FROM production.brands
WHERE brand_name = 'Santa Cruz';


-- Q22: Delete all order_items that have quantity = 0.
DELETE FROM sales.order_items
WHERE quantity = 0;

-- Q23: Delete all customers who have never placed an order (use subquery with NOT EXISTS).
DELETE FROM sales.customers
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = sales.customers.customer_id
);

-- Q24: Delete all products that have list_price > 10000 and model_year < 2020.
DELETE FROM production.products
WHERE list_price > 10000
  AND model_year < 2020;

-- Q25: Delete the loyalty_programs table you created in Q6 (clean up).
DROP TABLE sales.loyalty_program

-- Q26: Write a single transaction that:
--      1. Creates a new store called 'Downtown LA'
--      2. Adds 3 new staff members to that store
--      3. Inserts 100 units of product_id = 1 into stocks for that store
--      (ROLLBACK if any step fails)[sales].[stores]

-- Step 1: Creates a new store called 'Downtown LA'
USE [BikeStores]
GO
INSERT INTO [sales].[stores]
           ([store_name]
           ,[phone]
           ,[email]
           ,[street]
           ,[city]
           ,[state]
           ,[zip_code])
     VALUES
        ('Downtown LA','2135551000','downtownla@store.com','100 Main St','Los Angeles','CA','90001');
GO
USE [BikeStores]
GO
-- Step 2: Adds 3 new staff members to that store
INSERT INTO [sales].[staffs]
           ([first_name]
           ,[last_name]
           ,[email]
           ,[phone]
           ,[active]
           ,[store_id]
           ,[manager_id])
     VALUES
        ('John', 'Smith', 'john.smith@email.com', '1111111111', 1 , 4, 1),
        ('Sara', 'Brown', 'sara.brown@email.com', '2222222222', 1 , 4, 1),
        ('Mike', 'Davis', 'mike.davis@email.com', '3333333333', 1 , 4, 1);

GO

-- Step 3: Inserts 100 units of product_id = 1 into stocks for that store
--select * from [production].[stocks]
USE [BikeStores]
GO

INSERT INTO [production].[stocks]
           ([store_id]
           ,[product_id]
           ,[quantity])
     VALUES
           (4, 2 , 100 )
GO


-- Q27: Change the schema of sales.order_items: add a new column 'tax_amount' DECIMAL(8,2) DEFAULT 0.00,
--      then update it to be (list_price * quantity * discount * 0.08) for all existing rows.
ALTER TABLE sales.order_items
ADD tax_amount DECIMAL(8,2) DEFAULT 0.00;

-- Q28: Identify and delete duplicate email addresses in sales.customers (keeping the smallest customer_id).
WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY email ORDER BY customer_id) AS rn
    FROM sales.customers
)
DELETE FROM cte
WHERE rn > 1;

-- Q29: Archive all orders from year 2020 or older: 
--      Insert them into a new table sales.orders_archive, then delete from sales.orders.
SELECT *
INTO sales.orders_archive
FROM sales.orders
WHERE 1 = 0;

-- Q30: Add a CHECK constraint to production.products ensuring list_price >= 0 AND model_year BETWEEN 1900 AND YEAR(GETDATE())+1.
ALTER TABLE production.products
ADD CONSTRAINT CK_products_price_year
CHECK (
    list_price >= 0
    AND model_year BETWEEN 1900 AND YEAR(GETDATE()) + 1
);
Assignment4.sql
Displaying Assignment4.sql.