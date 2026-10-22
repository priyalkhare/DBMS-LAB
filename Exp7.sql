CREATE DATABASE DBMS_Exp7;
USE DBMS_Exp7;

CREATE TABLE Sales_UNF (
    SaleID INT,
    SaleDate DATE,
    CustomerID INT,
    CustomerName VARCHAR(50),
    ProductID INT,
    ProductName VARCHAR(50),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    SalespersonID INT,
    SalespersonName VARCHAR(50)
);

INSERT INTO Sales_UNF VALUES
(1, '2026-01-10', 101, 'Aman', 201, 'Laptop', 1, 50000, 301, 'Riya'),
(2, '2026-01-11', 102, 'Neha', 202, 'Mouse', 2, 500, 302, 'Karan'),
(3, '2026-01-12', 101, 'Aman', 202, 'Mouse', 1, 500, 301, 'Riya'),
(4, '2026-01-13', 103, 'Rohit', 203, 'Keyboard', 1, 1500, 302, 'Karan');

SELECT * FROM Sales_UNF;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    UnitPrice DECIMAL(10,2)
);

CREATE TABLE Salespersons (
    SalespersonID INT PRIMARY KEY,
    SalespersonName VARCHAR(50)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    SaleDate DATE,
    CustomerID INT,
    SalespersonID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (SalespersonID) REFERENCES Salespersons(SalespersonID)
);

CREATE TABLE SaleDetails (
    SaleID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (SaleID, ProductID),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Customers VALUES
(101, 'Aman'),
(102, 'Neha'),
(103, 'Rohit');

INSERT INTO Products VALUES
(201, 'Laptop', 50000),
(202, 'Mouse', 500),
(203, 'Keyboard', 1500);

INSERT INTO Salespersons VALUES
(301, 'Riya'),
(302, 'Karan');

INSERT INTO Sales VALUES
(1, '2026-01-10', 101, 301),
(2, '2026-01-11', 102, 302),
(3, '2026-01-12', 101, 301),
(4, '2026-01-13', 103, 302);

INSERT INTO SaleDetails VALUES
(1, 201, 1),
(2, 202, 2),
(3, 202, 1),
(4, 203, 1);

SELECT
    s.SaleID,
    s.SaleDate,
    c.CustomerName,
    p.ProductName,
    sd.Quantity,
    p.UnitPrice,
    sp.SalespersonName
FROM Sales s
JOIN Customers c
    ON s.CustomerID = c.CustomerID
JOIN Salespersons sp
    ON s.SalespersonID = sp.SalespersonID
JOIN SaleDetails sd
    ON s.SaleID = sd.SaleID
JOIN Products p
    ON sd.ProductID = p.ProductID
ORDER BY s.SaleID;

SELECT
    CustomerID,
    COUNT(DISTINCT CustomerName) AS NameCount
FROM Sales_UNF
GROUP BY CustomerID;

SELECT
    ProductID,
    COUNT(DISTINCT ProductName) AS ProductNames,
    COUNT(DISTINCT UnitPrice) AS Prices
FROM Sales_UNF
GROUP BY ProductID;

SELECT
    SalespersonID,
    COUNT(DISTINCT SalespersonName) AS NameCount
FROM Sales_UNF
GROUP BY SalespersonID;

SELECT
    s.SaleID,
    s.SaleDate,
    c.CustomerName,
    p.ProductName,
    sd.Quantity,
    p.UnitPrice,
    sp.SalespersonName
FROM Sales s
JOIN Customers c
    ON s.CustomerID = c.CustomerID
JOIN Salespersons sp
    ON s.SalespersonID = sp.SalespersonID
JOIN SaleDetails sd
    ON s.SaleID = sd.SaleID
JOIN Products p
    ON sd.ProductID = p.ProductID;