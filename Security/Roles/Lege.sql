CREATE ROLE [Lege]
GO

EXEC sp_addrolemember N'Lege', N'Gruppeleder'
GO

EXEC sp_addrolemember N'Lege', N'Lege1'
GO

EXEC sp_addrolemember N'Lege', N'Lege2'
GO