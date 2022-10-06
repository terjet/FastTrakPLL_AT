CREATE ROLE [DrugEditor]
GO

EXEC sp_addrolemember N'DrugEditor', N'Gruppeleder'
GO

EXEC sp_addrolemember N'DrugEditor', N'Lege'
GO

EXEC sp_addrolemember N'DrugEditor', N'Lege1'
GO

EXEC sp_addrolemember N'DrugEditor', N'Lege2'
GO

EXEC sp_addrolemember N'DrugEditor', N'Lege3'
GO

EXEC sp_addrolemember N'DrugEditor', N'PrintPrescription'
GO

EXEC sp_addrolemember N'DrugEditor', N'Sykepleier'
GO

EXEC sp_addrolemember N'DrugEditor', N'Sykepleier1'
GO

EXEC sp_addrolemember N'DrugEditor', N'Sykepleier2'
GO

EXEC sp_addrolemember N'DrugEditor', N'Vernepleier'
GO