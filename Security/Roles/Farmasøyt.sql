CREATE ROLE [Farmasøyt]
GO

EXEC sp_addrolemember N'Farmasøyt', N'Provisorfarmasøyt'
GO

EXEC sp_addrolemember N'Farmasøyt', N'Reseptarfarmasøyt'
GO