CREATE DATABASE Ntesle
GO
USE Ntesle

CREATE TABLE Customer(
	CustomerId CHAR(5) PRIMARY KEY CHECK (CustomerId LIKE 'CS[0-9][0-9][0-9]'),
	[CustomerName] VARCHAR(255),
	CustomerPhoneNumber VARCHAR(100) CHECK (CustomerPhoneNumber LIKE '+62%'),
	CustomerAddress VARCHAR(255)
)

CREATE TABLE Staff(
	StaffId CHAR(5) PRIMARY KEY CHECK (StaffId LIKE 'ST[0-9][0-9][0-9]'),
	StaffName VARCHAR(255),
	StaffGender VARCHAR(6) CHECK (StaffGender LIKE 'Male' OR StaffGender LIKE 'Female'),
	StaffPhoneNumber VARCHAR (100),
	StaffDOB DATE,
	StaffSalary INT CHECK (StaffSalary BETWEEN 1000000 AND 10000000)
)

CREATE TABLE HeaderSalesTransaction(
	SalesTransactionId CHAR(5) PRIMARY KEY CHECK (SalesTransactionId LIKE 'SL[0-9][0-9][0-9]'),
	StaffId CHAR(5) NOT NULL FOREIGN KEY REFERENCES Staff(StaffId),
	CustomerId CHAR(5) NOT NULL FOREIGN KEY REFERENCES Customer(CustomerId),
	SalesDate DATE
)

CREATE TABLE ProductType(
	ProductTypeId CHAR(5) PRIMARY KEY CHECK (ProductTypeId LIKE 'PT[0-9][0-9][0-9]'),
	ProductTypeName VARCHAR(255) 
)

CREATE TABLE Product(
	ProductId CHAR (5) PRIMARY KEY CHECK (ProductId LIKE 'PD[0-9][0-9][0-9]'),
	ProductTypeId	CHAR(5) NOT NULL FOREIGN KEY REFERENCES ProductType(ProductTypeId),
	ProductName VARCHAR(255) CHECK (LEN(ProductName)>4),
	ProductPrice INT CHECK (ProductPrice>=5000),
	ProductExpiredDate DATE CHECK (DATENAME(YEAR, ProductExpiredDate)>2020)
)

CREATE TABLE DetailSalesTransaction(
	SalesTransactionId CHAR(5) FOREIGN KEY REFERENCES HeaderSalesTransaction(SalesTransactionId),
	ProductId CHAR(5) FOREIGN KEY REFERENCES Product(ProductId),
	Quantity INT,
	PRIMARY KEY(SalesTransactionId, ProductId)
)

CREATE TABLE Supplier(
	SupplierId CHAR(5) PRIMARY KEY CHECK (SupplierId LIKE 'SU[0-9][0-9][0-9]'),
	SupplierName VARCHAR(255),
	SupplierPhoneNumber VARCHAR(100),
	SupplierAddress VARCHAR(255)
)

CREATE TABLE Ingredient(
	IngredientId CHAR(5) PRIMARY KEY CHECK (IngredientId LIKE 'IG[0-9][0-9][0-9]'),
	IngredientName VARCHAR(255),
	IngredientPrice INT,
	IngredientExpiredDate DATE CHECK (DATENAME(YEAR, IngredientExpiredDate)>2022)
)

CREATE TABLE HeaderPurchaseTransaction(
	PurchaseTransactionId CHAR(5) PRIMARY KEY CHECK (PurchaseTransactionId LIKE 'PU[0-9][0-9][0-9]'),
	StaffId CHAR(5) NOT NULL FOREIGN KEY REFERENCES Staff(StaffId),
	SupplierId CHAR(5) NOT NULL FOREIGN KEY REFERENCES Supplier(SupplierId),
	PurchaseDate DATE
)

CREATE TABLE DetailPurchaseTransaction(	
	PurchaseTransactionId CHAR(5) FOREIGN KEY REFERENCES HeaderPurchaseTransaction(PurchaseTransactionId),
	IngredientId CHAR(5) FOREIGN KEY REFERENCES Ingredient(IngredientId),
	Quantity INT,
	PRIMARY KEY(PurchaseTransactionId, IngredientId)
)

