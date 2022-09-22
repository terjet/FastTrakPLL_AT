CREATE ROLE [Journalansvarlig]
GO

EXEC sp_addrolemember N'Journalansvarlig', N'Avdelingsleder'
GO

EXEC sp_addrolemember N'Journalansvarlig', N'Gruppeleder'
GO

EXEC sp_addrolemember N'Journalansvarlig', N'Leder'
GO

EXEC sp_addrolemember N'Journalansvarlig', N'Lege'
GO

EXEC sp_addrolemember N'Journalansvarlig', N'Lege1'
GO

EXEC sp_addrolemember N'Journalansvarlig', N'Lege2'
GO

EXEC sp_addrolemember N'Journalansvarlig', N'Pandemic'
GO

EXEC sp_addrolemember N'Journalansvarlig', N'superuser'
GO

EXEC sp_addrolemember N'Journalansvarlig', N'Sykepleier'
GO

EXEC sp_addrolemember N'Journalansvarlig', N'Sykepleier1'
GO

EXEC sp_addrolemember N'Journalansvarlig', N'Vernepleier'
GO