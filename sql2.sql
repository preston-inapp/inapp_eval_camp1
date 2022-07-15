-- QUESTION 2
-- OrderDetails {OrderId, OrderDate, OrderPrice, OrderQuantity, customerId}
-- CustomerDetails {customerId, customerName}
-- ProductDetails {Product_id, OrderId, Manufacture_Date, Product_Name, Manufr_id}
-- ManufacturerDetails {Manufr_id, Manufr_name}

CREATE TABLE OrderDetails (
	OrderId INT PRIMARY KEY,
	OrderDate DATE,
	OrderPrice INT,
	OrderQuantity INT,
	CustomerId INT
)

INSERT INTO OrderDetails VALUES
	(1, '2020-12-22', 270, 2, 1),
	(2, '2019-08-10', 280, 4, 2),
	(3, '2019-07-13', 600, 5, 3),
	(4, '2020-07-15', 520, 1, 1),
	(5, '2020-12-22', 1200, 4, 4),
	(6, '2019-10-02', 720, 3, 1),
	(7, '2020-11-03', 3000, 2, 3),
	(8, '2020-12-22', 1100, 4, 4),
	(9, '2019-12-29', 5500, 2, 1)

CREATE TABLE CustomerDetails (
	CustomerId INT PRIMARY KEY,
	CustomerName VARCHAR(20)
)

INSERT INTO CustomerDetails VALUES
	(1, 'Jayesh'),
	(2, 'Abhilash'),
	(3, 'Lily'),
	(4, 'Aswathy')

CREATE TABLE ManufacturerDetails (
	Manufr_id INT PRIMARY KEY,
	Manufr_name VARCHAR(20)
)

INSERT INTO ManufacturerDetails VALUES
	(1, 'Samsung'),
	(2, 'Sony'),
	(3, 'Mi'),
	(4, 'Boat')

CREATE TABLE ProductDetails (
	Product_id INT,
	OrderId INT,
	Manufacture_Date DATE,
	Product_Name VARCHAR(20),
	Manufr_id INT
)

INSERT INTO ProductDetails VALUES
	(145, 2, '2019-12-23', 'MobilePhone', 1),
	(147, 6, '2019-08-15', 'MobilePhone', 3),
	(435, 5, '2018-11-04', 'MobilePhone', 1),
	(783, 1, '2017-11-03', 'LED TV', 2),
	(784, 4, '2019-11-28', 'LED TV', 2),
	(123, 2, '2019-10-03', 'Laptop', 2),
	(267, 5, '2019-03-21', 'Headphone', 4),
	(333, 9, '2017-12-12', 'Laptop', 1),
	(344, 3, '2018-11-03', 'Laptop', 1),
	(233, 3, '2019-11-30', 'PowerBank', 2),
	(567, 6, '2019-09-03', 'PowerBank', 2)

SELECT * FROM ProductDetails

CREATE VIEW CompleteOrderDetails AS
	SELECT 
		OrderDetails.OrderId,
		OrderDate,
		OrderPrice,
		OrderQuantity,
		OrderDetails.CustomerId,
		CustomerName,
		Product_id,
		Manufacture_Date,
		Product_Name,
		ProductDetails.Manufr_id,
		Manufr_name
		FROM
			OrderDetails
			INNER JOIN CustomerDetails ON OrderDetails.CustomerId = CustomerDetails.CustomerId
			INNER JOIN ProductDetails ON OrderDetails.OrderId = ProductDetails.OrderId
			INNER JOIN ManufacturerDetails ON ProductDetails.Manufr_id = ManufacturerDetails.Manufr_id

-- 1) Total number of orders placed in each year.
SELECT year as 'Year', COUNT(OrderId) as 'Orders' FROM (SELECT *, YEAR(OrderDate) AS year FROM CompleteOrderDetails) AS yearwise GROUP BY year

-- 2) Total number of orders placed in each year by Jayesh.
SELECT COUNT(OrderID) AS 'Orders by Jayesh' FROM CompleteOrderDetails WHERE CustomerName = 'Jayesh'

-- 3) Products which are ordered in the same year of its manufacturing year.
SELECT Product_id, Product_Name, YEAR(Manufacture_Date) AS 'Year', Manufr_name FROM CompleteOrderDetails WHERE YEAR(Manufacture_Date) = YEAR(OrderDate)

-- 4) Products which is ordered in the same year of its manufacturing year where the Manufacturer is ‘Samsung’.
SELECT Product_id, Product_Name, YEAR(Manufacture_Date) AS 'Year', Manufr_name FROM CompleteOrderDetails WHERE YEAR(Manufacture_Date) = YEAR(OrderDate) AND Manufr_name = 'Samsung'

-- 5) Total number of products ordered every year.
SELECT year as 'Year', COUNT(OrderId) as 'Products Ordered' FROM (SELECT *, YEAR(OrderDate) AS year FROM CompleteOrderDetails) AS yearwise GROUP BY year

-- 6) Display the total number of products ordered every year made by sony.
SELECT YEAR(OrderDate) AS 'Year', COUNT(OrderId) AS 'Orders made by Sony' FROM (SELECT * FROM CompleteOrderDetails WHERE Manufr_name = 'Sony') AS table1 GROUP BY YEAR(OrderDate)

-- 7) All customers who are ordering mobile phone by samsung.
SELECT DISTINCT CustomerName AS 'Customers that ordered mobile phone by samsung' FROM CompleteOrderDetails WHERE Manufr_name = 'Samsung' AND Product_Name = 'MobilePhone'

-- 8) Total number of orders got by each Manufacturer every year.
SELECT Manufr_name, YEAR(OrderDate) 'Year', COUNT(OrderId) 'No. of Orders' FROM CompleteOrderDetails GROUP BY Manufr_name, YEAR(OrderDate)

-- 9) All Manufacturers whose products were sold more than 1500 Rs every year.
SELECT Manufr_name, YEAR(OrderDate) AS 'Year', COUNT(OrderId) AS 'No. of Orders', SUM(OrderPrice) AS 'Price' FROM CompleteOrderDetails GROUP BY Manufr_name, YEAR(OrderDate) HAVING SUM(OrderPrice) > 1500