CREATE ROLE [PrintPrescription]
GO

EXEC sp_addrolemember N'PrintPrescription', N'Gruppeleder'
GO

EXEC sp_addrolemember N'PrintPrescription', N'Lege'
GO

EXEC sp_addrolemember N'PrintPrescription', N'Lege1'
GO

EXEC sp_addrolemember N'PrintPrescription', N'Lege2'
GO