CREATE ROLE [Journalansvarlig]
GO

EXEC sp_addrolemember N'Journalansvarlig', N'Avdelingsleder'
GO

EXEC sp_addrolemember N'Journalansvarlig', N'Gruppeleder'
GO

EXEC sp_addrolemember N'Journalansvarlig', N'Leder'
GO

EXEC sp_addrolemember N'Journalansvarlig', N'Pandemic'
GO

EXEC sp_addrolemember N'Journalansvarlig', N'superuser'
GO