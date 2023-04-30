-- Task 1

-- Create table
CREATE TABLE orders( 
InvoiceNo VARCHAR(255) NOT NULL, 
StockCode VARCHAR(255) NOT NULL, 
Description VARCHAR(255), 
Quantity INT NOT NULL, 
InvoiceDate DATETIME, 
UnitPrice DECIMAL(15,2), 
CustomerID INT, 
Country VARCHAR(255)
);

-- Import data
LOAD DATA LOCAL INFILE 'OnlineRetail.csv' 
INTO TABLE orders 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES
(InvoiceNo, StockCode, Description, Quantity, @InvoiceDate, UnitPrice, CustomerID, Country)
SET InvoiceDate = STR_TO_DATE(@InvoiceDate, '%m/%d/%Y %H:%i');
-- review table
SELECT * FROM ORDERS LIMIT 10;


-- Task 2

-- counts
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM orders WHERE CustomerID=0;
SELECT * FROM orders WHERE CustomerID=0 LIMIT 10;
SELECT COUNT(DISTINCT(InvoiceNo)) FROM orders WHERE CustomerID = 0;
SELECT MIN(CustomerID) FROM orders WHERE CustomerID > 0;



-- Task 3

-- Create table
CREATE TABLE null_customer_ids (
     imputed_id INT AUTO_INCREMENT PRIMARY KEY,
     InvoiceNo VARCHAR(255)
);

-- Insert
INSERT INTO
    null_customer_ids (InvoiceNo)
    SELECT DISTINCT InvoiceNo
    FROM orders
    WHERE CustomerID = 0;

-- Preview table
SELECT * FROM null_customer_ids LIMIT 10;
SELECT MAX(imputed_id) FROM null_customer_ids;

-- Index
CREATE INDEX i ON null_customer_ids (InvoiceNo);
CREATE INDEX i ON orders (InvoiceNo);

-- Inner join
UPDATE orders
    INNER JOIN null_customer_ids ON orders.InvoiceNo = null_customer_ids.InvoiceNo
    SET orders.CustomerID = IF(orders.CustomerID = 0, null_customer_ids.imputed_id, orders.CustomerID);

-- Check
SELECT COUNT(*) FROM orders WHERE CustomerID=0;

--Inspect
SELECT * FROM orders WHERE CustomerID < 12346 LIMIT 10;

-- Task 4

-- Inspect
SELECT * FROM orders ORDER BY UnitPrice DESC LIMIT 20;
SELECT DISTINCT(StockCode) FROM orders WHERE UnitPrice>100.0;
SELECT * FROM orders WHERE UnitPrice <= 0 LIMIT 20;

-- Task 5

-- Drop
DELETE FROM orders WHERE UnitPrice<=0;
DELETE FROM orders WHERE
    StockCode='DOT' OR
    StockCode='M' OR
    StockCode='D' OR
    StockCode='S' OR
    StockCode='POST' OR
    StockCode='BANK CHARGES' OR
    StockCode='C2' OR
    StockCode='AMAZONFEE' OR
    StockCode='CRUK' OR
    StockCode='B';