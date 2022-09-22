CREATE ROLE [Gruppeleder]
GO

EXEC sp_addrolemember N'Gruppeleder', N'Avdelingsleder'
GO