CREATE DATABASE BJSS
GO

USE [BJSS]
GO

CREATE TABLE [dbo].[Product]
(   
 [ProductId] [uniqueidentifier] DEFAULT NEWID() NOT NULL,
 [ProductName] [nchar](50) NULL,
 [ProductDescription] [nchar](3000) NULL,
 [ProductPrice] MONEY NULL
) ON [PRIMARY]
GO

WHILE (1=1)
  BEGIN
  TRUNCATE TABLE [BJSS].[dbo].[Product]
  DECLARE @Record INT 
  SET @Record=1
  WHILE @Record<=100
  BEGIN
    INSERT INTO [BJSS].[dbo].[Product]
    ([ProductName] ,[ProductDescription],[ProductPrice])
    VALUES ('Product ' + STR(@Record), 'Description ' + STR(@Record), @Record*100/3)
    SET @RECORD = @RECORD+1
  END
  SELECT COUNT(ProductID) as RecordsCreated FROM [BJSS].[dbo].[Product] 
END