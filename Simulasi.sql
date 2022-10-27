USE Ntesle

INSERT INTO Customer
VALUES 
	('CS026', 'Ilham', '+628123435613', 'Duri Kencana'),
	('CS027', 'Windah', '+628123435613', 'Puri indah')
GO

INSERT INTO Staff
VALUES
	('ST011', 'Kevin', 'Male', '+621445213668', '17 June 1991','6000000'),
	('ST012', 'Astra', 'Male', '+621247742461', '15 May 2003','7000000'),
	('ST013', 'Jasson', 'Male', '+62124724321', '15 April 2002','7000000')
GO

INSERT INTO Supplier
VALUES 
	('SU016', 'Jason Food', '+624456521345', 'Jl Duri Nirmala')
GO

INSERT INTO ProductType
VALUES
	('PT001', 'Biscuits'),
	('PT010', 'Candy')
GO

INSERT INTO Product
VALUES
	('PD011', 'PT001', 'Biscuit Roma', '13000', '2023 April 13'),
	('PD012', 'PT010', 'Permen sugus', '43000', '2024 April 13')
GO

INSERT INTO HeaderSalesTransaction 
VALUES
	('SL016', 'ST011', 'CS026', '2021 September 12'),
	('SL017', 'ST011', 'CS027', '2021 October 13'),
	('SL018', 'ST012', 'CS027', '2021 November 14')
GO

INSERT INTO DetailSalesTransaction
VALUES
	('SL016', 'PD011', '20'),
	('SL016', 'PD012', '30'),
	('SL017', 'PD011', '20'),
	('SL017', 'PD012', '40'),
	('SL018', 'PD011', '10')
GO

INSERT INTO Ingredient
VALUES
	('IG011', 'Sugar', '80000', '2023-01-02')

INSERT INTO HeaderPurchaseTransaction
VALUES 
	('PU016', 'ST002', 'SU001', '2020-May-05'),
	('PU017', 'ST001', 'SU005', '2020-May-08')

INSERT INTO DetailPurchaseTransaction
VALUES
	('PU006', 'IG011', '200'),
	('PU005', 'IG011', '20'),
	('PU016', 'IG011', '40'),
	('PU017', 'IG011', '70')
