USe Ntesle

--1

SELECT 
	SupplierName, 
	IngredientName,
	[Total Quantity] = SUM(Quantity)
FROM Supplier s
	JOIN HeaderPurchaseTransaction hpt
	ON hpt.SupplierId = s.SupplierId
	JOIN DetailPurchaseTransaction dpt
	ON dpt.PurchaseTransactionId = hpt.PurchaseTransactionId
	JOIN Ingredient i
	ON i.IngredientId = dpt.IngredientId
WHERE IngredientName LIKE '%Sugar%' AND
DATENAME(MONTH, PurchaseDate) = 'May'
GROUP BY SupplierName, IngredientName


--2

SELECT 
	StaffName, 
	StaffGender, 
	x.[Total Transaction] 
FROM Staff s
	JOIN HeaderSalesTransaction hst
	ON hst.StaffId = s.StaffId,
	(SELECT 
		StaffId, 
		[Total Transaction] = COUNT(SalesTransactionId) 
	FROM HeaderSalesTransaction
	GROUP BY StaffId) AS X
WHERE StaffSalary BETWEEN 6000000 AND 7000000 AND
x.[Total Transaction] > 1
GROUP BY StaffName, StaffGender, x.[Total Transaction]

--3

SELECT 
	CustomerName,
	[Customer Phone Number] = REPLACE (CS.CustomerPhoneNumber, '+62', '0'),
	ProductName,
	[Total Transaction] = COUNT( HST.SalesTransactionId),
	[Total Product Price] = SUM(ProductPrice)
FROM Customer CS
	JOIN HeaderSalesTransaction HST ON CS.CustomerId = HST.CustomerId
	JOIN DetailSalesTransaction DST ON HST.SalesTransactionId = DST.SalesTransactionId
	JOIN Product P ON P.ProductId = DST.ProductId
WHERE ProductName LIKE '% %' AND YEAR(ProductExpiredDate) > 2021
GROUP BY CustomerName, CustomerPhoneNumber, ProductName

--4

SELECT
	[Total Price] = SUM(IngredientPrice),
	IngredientName,
	[Total Transaction] = COUNT(HPT.PurchaseTransactionId)
FROM Ingredient IG
	JOIN DetailPurchaseTransaction DPT ON IG.IngredientId = DPT.IngredientId
	JOIN HeaderPurchaseTransaction HPT ON DPT.PurchaseTransactionId = HPT.PurchaseTransactionId
	JOIN Staff S ON S.StaffId = HPT.StaffId
WHERE DATEDIFF(YEAR, StaffDOB, '2020')>19
GROUP BY IngredientName
ORDER BY [Total Price] ASC

--5

SELECT 
	s.StaffName, 
	s.StaffGender, 
	s.StaffDOB, 
	s.StaffSalary, 
	SalesTransactionId
FROM Staff s
JOIN HeaderSalesTransaction hst
ON s.StaffId = hst.StaffId,
	(SELECT 
	[Total Salary] = AVG(StaffSalary) 
	FROM Staff) AS x
WHERE StaffSalary > x.[Total Salary] AND
YEAR(StaffDOB) > 2000
ORDER BY StaffDOB ASC

--6

SELECT 
	[Supplier Number] = RIGHT(s.SupplierId, 3),
	SupplierName,
	IngredientName,
	[Ingredient Price] = 'Rp. ' + CAST(IngredientPrice AS VARCHAR),
	IngredientExpiredDate
FROM Supplier s
	JOIN HeaderPurchaseTransaction hpt
	ON hpt.SupplierId = s.SupplierId
	JOIN DetailPurchaseTransaction dpt
	ON dpt.PurchaseTransactionId = hpt.PurchaseTransactionId
	JOIN Ingredient i
	ON i.IngredientId = dpt.IngredientId,
	(SELECT [Average Price] = AVG(IngredientPrice) 
	FROM Ingredient) AS x
WHERE IngredientPrice>=x.[Average Price] AND
YEAR(IngredientExpiredDate) > 2022


--7
SELECT
	s.SupplierId,
	SupplierName,
	[SupplierPhone] = '+62' + SUBSTRING(SupplierPhoneNumber, 1 , LEN(SupplierPhoneNumber)),
	SupplierAddress,
	x.[Total Price]
From Supplier s
JOIN HeaderPurchaseTransaction hpt
ON hpt.SupplierId = s.SupplierId,
	(SELECT 
	s.SupplierId,
	[Total Price] = SUM(IngredientPrice*Quantity)
	FROM Ingredient i
	JOIN DetailPurchaseTransaction dpt
	ON i.IngredientId = dpt.IngredientId
	JOIN HeaderPurchaseTransaction hpt
	ON hpt.PurchaseTransactionId = dpt.PurchaseTransactionId
	JOIN Supplier s
	ON s.SupplierId = hpt.SupplierId
	GROUP BY s.SupplierId) AS x,
	(SELECT 
	[Average Price] = AVG(IngredientPrice)
	FROM Ingredient
	) AS y
WHERE SupplierName LIKE ('%Food')
GROUP BY s.SupplierId, SupplierName, SupplierPhoneNumber, SupplierAddress, x.[Total Price]
ORDER BY x.[Total Price] DESC

--8

SELECT
	c.CustomerName,
	hst.SalesTransactionId,
	[SalesDate] = CONVERT(VARCHAR, SalesDate, 106),
	[Date Name] =  DATENAME(DW, [SalesDate]),
	[Quantity] =  CONVERT(VARCHAR, Quantity) + ' Piece(s)',
	ProductName,
	[Sales Price] = 'Rp. ' + CONVERT(VARCHAR, ProductPrice),
	x.[Total Price]
FROM Customer c
	JOIN HeaderSalesTransaction hst
	ON c.CustomerId = hst.CustomerId
	JOIN DetailSalesTransaction dst
	ON dst.SalesTransactionId = hst.SalesTransactionId
	JOIN Product p
	ON p.ProductId = dst.ProductId,
	(SELECT 
	[Total Price] = SUM(ProductPrice * Quantity)  FROM Product p
	JOIN DetailSalesTransaction dst
	ON p.ProductId = dst.ProductId
	JOIN HeaderSalesTransaction hst
	ON hst.SalesTransactionId = dst.SalesTransactionId
	JOIN Customer c
	ON c.CustomerId = hst.CustomerId
	) AS x
	GROUP BY c.CustomerName, hst.SalesTransactionId, SalesDate, Quantity, ProductName, ProductPrice, x.[Total Price]
	HAVING Quantity > MIN(Quantity) AND Quantity < MAX(Quantity)
	

--9
CREATE VIEW SalesTransactionView AS 
SELECT 
	StaffName, 
	StaffPhoneNumber,
	x.[Total Transaction],
	[Highest Quantity] = MAX(Quantity)
FROM Staff sf
	JOIN HeaderSalesTransaction hp ON sf.StaffId = hp.StaffId
	JOIN DetailSalesTransaction dp ON hp.SalesTransactionId = dp.SalesTransactionId,
	(
	SELECT COUNT(SalesTransactionId) AS [Total Transaction]
	FROM DetailSalesTransaction
	) AS x
WHERE MONTH(SalesDate) > 8 AND x.[Total Transaction] > 2
GROUP BY StaffName, StaffPhoneNumber, x.[Total Transaction]

--10
CREATE VIEW PruchaseTransactionView AS 
SELECT 
	s.SupplierName, 
	SupplierPhoneNumber, 
	[Total Transaction] = COUNT(hp.PurchaseTransactionId),
	IngredientExpiredDate, 
	IngredientName, 
	IngredientPrice,
	[Total Ingredient Price] = SUM(IngredientPrice*Quantity)
FROM Supplier s
	JOIN HeaderPurchaseTransaction hp ON s.SupplierId = hp.SupplierId
	JOIN DetailPurchaseTransaction dp ON hp.PurchaseTransactionId = dp.PurchaseTransactionId
	JOIN Ingredient ig ON dp.IngredientId = ig.IngredientId
GROUP BY  s.SupplierName, SupplierPhoneNumber, IngredientExpiredDate, IngredientName, IngredientPrice
HAVING DATENAME(YEAR, IngredientExpiredDate) = '2023' AND SUM(IngredientPrice) > 60000



