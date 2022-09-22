CREATE ROLE [Innskriving]
GO

EXEC sp_addrolemember N'Innskriving', N'Avdelingsleder'
GO

EXEC sp_addrolemember N'Innskriving', N'Gruppeleder'
GO

EXEC sp_addrolemember N'Innskriving', N'Leder'
GO

EXEC sp_addrolemember N'Innskriving', N'Pandemic'
GO

EXEC sp_addrolemember N'Innskriving', N'superuser'
GO