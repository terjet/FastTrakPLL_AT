CREATE ROLE [Sykepleier]
GO

EXEC sp_addrolemember N'Sykepleier', N'Gruppeleder'
GO

EXEC sp_addrolemember N'Sykepleier', N'Sykepleier1'
GO

EXEC sp_addrolemember N'Sykepleier', N'Sykepleier2'
GO