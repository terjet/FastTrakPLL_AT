CREATE SYNONYM [dbo].[UpdateClinFormSetTime] FOR [CRF].[UpdateClinFormSetTime]
GO

GRANT EXECUTE ON [dbo].[UpdateClinFormSetTime] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdateClinFormSetTime] TO [ReadOnly]
GO