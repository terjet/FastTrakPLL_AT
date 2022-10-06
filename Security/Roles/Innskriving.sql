CREATE ROLE [Innskriving]
GO

EXEC sp_addrolemember N'Innskriving', N'Avdelingsleder'
GO

EXEC sp_addrolemember N'Innskriving', N'Gruppeleder'
GO

EXEC sp_addrolemember N'Innskriving', N'Helsesekretær'
GO

EXEC sp_addrolemember N'Innskriving', N'Leder'
GO

EXEC sp_addrolemember N'Innskriving', N'Lege'
GO

EXEC sp_addrolemember N'Innskriving', N'Lege1'
GO

EXEC sp_addrolemember N'Innskriving', N'Lege2'
GO

EXEC sp_addrolemember N'Innskriving', N'Lege3'
GO

EXEC sp_addrolemember N'Innskriving', N'Pandemic'
GO

EXEC sp_addrolemember N'Innskriving', N'superuser'
GO

EXEC sp_addrolemember N'Innskriving', N'Sykepleier'
GO

EXEC sp_addrolemember N'Innskriving', N'Sykepleier1'
GO

EXEC sp_addrolemember N'Innskriving', N'Sykepleier2'
GO

EXEC sp_addrolemember N'Innskriving', N'Vernepleier'
GO