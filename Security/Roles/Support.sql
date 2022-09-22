CREATE ROLE [Support]
GO

EXEC sp_addrolemember N'Support', N'Administrator'
GO

EXEC sp_addrolemember N'Support', N'Systemansvarlig'
GO