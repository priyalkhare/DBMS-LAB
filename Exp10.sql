CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    CustomerName VARCHAR(50),
    City VARCHAR(50),
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    Quantity INT,
    Price DECIMAL(10,2),
    OrderDate DATE,
    Status VARCHAR(20)
);

SET SESSION cte_max_recursion_depth = 10000;

INSERT INTO Orders
(OrderID, CustomerID, CustomerName, City, ProductName,
 Category, Quantity, Price, OrderDate, Status)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10000
)
SELECT
    n,
    1000 + MOD(n, 500),
    CONCAT('Customer', MOD(n, 500)),
    CASE MOD(n, 5)
        WHEN 0 THEN 'Lucknow'
        WHEN 1 THEN 'Delhi'
        WHEN 2 THEN 'Mumbai'
        WHEN 3 THEN 'Jaipur'
        ELSE 'Pune'
    END,
    CONCAT('Product', MOD(n, 100)),
    CASE MOD(n, 4)
        WHEN 0 THEN 'Electronics'
        WHEN 1 THEN 'Clothing'
        WHEN 2 THEN 'Books'
        ELSE 'Furniture'
    END,
    1 + MOD(n, 10),
    100 + MOD(n, 5000),
    DATE_ADD('2025-01-01', INTERVAL MOD(n, 365) DAY),
    CASE MOD(n, 3)
        WHEN 0 THEN 'Delivered'
        WHEN 1 THEN 'Pending'
        ELSE 'Cancelled'
    END
FROM numbers;

SELECT COUNT(*) AS TotalOrders FROM Orders;

-- BEFORE OPTIMIZATION: FIVE QUERY PLANS

EXPLAIN
SELECT * FROM Orders
WHERE City = 'Lucknow';

EXPLAIN
SELECT * FROM Orders
WHERE CustomerID = 1100;

EXPLAIN
SELECT * FROM Orders
WHERE OrderDate BETWEEN '2025-03-01' AND '2025-06-30';

EXPLAIN
SELECT * FROM Orders
WHERE Status = 'Delivered'
AND City = 'Delhi';

EXPLAIN
SELECT Category, SUM(Quantity * Price) AS TotalSales
FROM Orders
GROUP BY Category;

-- CREATE INDEXES

CREATE INDEX idx_city ON Orders(City);
CREATE INDEX idx_customer ON Orders(CustomerID);
CREATE INDEX idx_orderdate ON Orders(OrderDate);
CREATE INDEX idx_status_city ON Orders(Status, City);
CREATE INDEX idx_category ON Orders(Category);

ANALYZE TABLE Orders;

-- VERIFY INDEXES

SHOW INDEX FROM Orders;

-- AFTER OPTIMIZATION: FIVE QUERY PLANS

EXPLAIN
SELECT * FROM Orders
WHERE City = 'Lucknow';

EXPLAIN
SELECT * FROM Orders
WHERE CustomerID = 1100;

EXPLAIN
SELECT * FROM Orders
WHERE OrderDate BETWEEN '2025-03-01' AND '2025-06-30';

EXPLAIN
SELECT * FROM Orders
WHERE Status = 'Delivered'
AND City = 'Delhi';

EXPLAIN
SELECT Category, SUM(Quantity * Price) AS TotalSales
FROM Orders
GROUP BY Category;

-- QUERY REWRITING COMPARISON

EXPLAIN
SELECT * FROM Orders
WHERE YEAR(OrderDate) = 2025;

EXPLAIN
SELECT * FROM Orders
WHERE OrderDate >= '2025-01-01'
AND OrderDate < '2026-01-01';

-- ACTUAL RESULTS

SELECT * FROM Orders
WHERE City = 'Lucknow';

SELECT * FROM Orders
WHERE CustomerID = 1100;

SELECT * FROM Orders
WHERE OrderDate BETWEEN '2025-03-01' AND '2025-06-30';

SELECT * FROM Orders
WHERE Status = 'Delivered'
AND City = 'Delhi';

SELECT Category, SUM(Quantity * Price) AS TotalSales
FROM Orders
GROUP BY Category;