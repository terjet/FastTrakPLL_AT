CREATE ROLE [superuser]
GO

EXEC sp_addrolemember N'superuser', N'Administrator'
GO

EXEC sp_addrolemember N'superuser', N'Avdelingsleder'
GO

EXEC sp_addrolemember N'superuser', N'Gruppeleder'
GO

EXEC sp_addrolemember N'superuser', N'Leder'
GO

EXEC sp_addrolemember N'superuser', N'Support'
GO