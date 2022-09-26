CREATE ROLE [DrugEditor]
GO

EXEC sp_addrolemember N'DrugEditor', N'Lege'
GO

EXEC sp_addrolemember N'DrugEditor', N'PrintPrescription'
GO

EXEC sp_addrolemember N'DrugEditor', N'Sykepleier'
GO

EXEC sp_addrolemember N'DrugEditor', N'Vernepleier'
GO