CREATE ROLE [FastTrak]
GO

EXEC sp_addrolemember N'FastTrak', N'DIPS-AD\krm'
GO

EXEC sp_addrolemember N'FastTrak', N'DIPS-AD\moe'
GO

EXEC sp_addrolemember N'FastTrak', N'DIPS-AD\tty'
GO

EXEC sp_addrolemember N'FastTrak', N'Hjelpepleier'
GO

EXEC sp_addrolemember N'FastTrak', N'LabImport'
GO

EXEC sp_addrolemember N'FastTrak', N'Lege1'
GO

EXEC sp_addrolemember N'FastTrak', N'Lege2'
GO

EXEC sp_addrolemember N'FastTrak', N'Sykepleier1'
GO

EXEC sp_addrolemember N'FastTrak', N'Sykepleier2'
GO