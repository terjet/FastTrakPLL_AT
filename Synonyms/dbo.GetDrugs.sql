CREATE SYNONYM [dbo].[GetDrugs] FOR [Drug].[GetDrugTreatments]
GO

GRANT EXECUTE ON [dbo].[GetDrugs] TO [FastTrak]
GO