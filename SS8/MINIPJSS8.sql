CREATE DATABASE Sales_Management_System;
USE Sales_Management_System;


CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Gender INT DEFAULT 1,
    BirthDate DATE,
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

CREATE TABLE Category (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    CategoryID INT NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    Status VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Order_Detail (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);


INSERT INTO Category (CategoryName)
VALUES 
('Điện tử'),
('Gia dụng'),
('Thời trang'),
('Thực phẩm'),
('Sách');

INSERT INTO Customer (FullName, Email, Gender, BirthDate, Phone, Address)
VALUES
('Nguyễn Văn A', 'a@gmail.com', 1, '1995-03-12', '0901234567', 'Hà Nội'),
('Trần Thị B', 'b@gmail.com', 0, '2000-07-22', '0902345678', 'TP.HCM'),
('Lê Văn C', 'c@gmail.com', 1, '1998-11-05', '0903456789', 'Đà Nẵng'),
('Phạm Thị D', 'd@gmail.com', 0, '1992-01-15', '0904567890', 'Cần Thơ'),
('Hoàng Văn E', 'e@gmail.com', 1, '1999-09-09', '0905678901', 'Huế');

INSERT INTO Product (ProductName, Price, CategoryID)
VALUES
('Điện thoại Samsung Galaxy S24', 22000000, 1),
('Laptop Dell Inspiron', 18000000, 1),
('Máy giặt LG Inverter', 9500000, 2),
('Áo sơ mi nam cao cấp', 450000, 3),
('Bánh quy Oreo', 35000, 4),
('Sách SQL cơ bản', 120000, 5);

INSERT INTO Orders (CustomerID, OrderDate, Status)
VALUES
(1, '2024-12-01', 'Completed'),
(2, '2024-12-05', 'Completed'),
(3, '2024-12-10', 'Pending'),
(4, '2024-12-15', 'Canceled'),
(5, '2024-12-20', 'Completed');

INSERT INTO Order_Detail (OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1, 1, 1, 22000000),
(1, 6, 2, 120000),
(2, 3, 1, 9500000),
(3, 4, 3, 450000),
(5, 5, 10, 35000);

UPDATE Product
SET Price = 23000000
WHERE ProductID = 1;

UPDATE Customer
SET Email = 'newemail@gmail.com'
WHERE CustomerID = 2;


DELETE FROM Order_Detail
WHERE OrderDetailID = 4;


SELECT 
    FullName AS HoTen,
    Email,
    CASE
        WHEN Gender = 1 THEN 'Nam'
        ELSE 'Nữ'
    END AS GioiTinh
FROM Customer;


SELECT 
    FullName,
    BirthDate,
    YEAR(NOW()) - YEAR(BirthDate) AS Age
FROM Customer
ORDER BY Age ASC
LIMIT 3;

SELECT
    o.OrderID,
    c.FullName,
    o.OrderDate,
    o.Status
FROM Orders o
INNER JOIN Customer c
ON o.CustomerID = c.CustomerID;

-- 4. Đếm số lượng sản phẩm theo danh mục
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS TotalProduct
FROM Category c
INNER JOIN Product p
ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName
HAVING COUNT(p.ProductID) >= 2;

-- 5. Scalar Subquery
-- Sản phẩm có giá lớn hơn giá trung bình
SELECT *
FROM Product
WHERE Price > (
    SELECT AVG(Price)
    FROM Product
);

-- 6. Column Subquery
-- Khách hàng chưa từng đặt hàng
SELECT *
FROM Customer
WHERE CustomerID NOT IN (
    SELECT CustomerID
    FROM Orders
);

-- 7. Subquery với hàm tổng hợp
-- Danh mục có doanh thu > 120% doanh thu trung bình

SELECT 
    c.CategoryName,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
FROM Category c
INNER JOIN Product p
ON c.CategoryID = p.CategoryID
INNER JOIN Order_Detail od
ON p.ProductID = od.ProductID
GROUP BY c.CategoryID, c.CategoryName
HAVING SUM(od.Quantity * od.UnitPrice) >
(
    SELECT AVG(CategoryRevenue) * 1.2
    FROM (
        SELECT 
            SUM(od.Quantity * od.UnitPrice) AS CategoryRevenue
        FROM Category c
        INNER JOIN Product p
        ON c.CategoryID = p.CategoryID
        INNER JOIN Order_Detail od
        ON p.ProductID = od.ProductID
        GROUP BY c.CategoryID
    ) AS RevenueTable
);

-- 8. Correlated Subquery
-- Sản phẩm đắt nhất trong từng danh mục

SELECT *
FROM Product p1
WHERE Price =
(
    SELECT MAX(p2.Price)
    FROM Product p2
    WHERE p1.CategoryID = p2.CategoryID
);

-- 9. Truy vấn lồng nhiều cấp
-- Khách hàng VIP từng mua sản phẩm thuộc danh mục Điện tử

SELECT FullName
FROM Customer
WHERE CustomerID IN
(
    SELECT CustomerID
    FROM Orders
    WHERE OrderID IN
    (
        SELECT OrderID
        FROM Order_Detail
        WHERE ProductID IN
        (
            SELECT ProductID
            FROM Product
            WHERE CategoryID =
            (
                SELECT CategoryID
                FROM Category
                WHERE CategoryName = 'Điện tử'
            )
        )
    )
);
