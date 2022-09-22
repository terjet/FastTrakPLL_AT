CREATE SYNONYM [dbo].[GetPopulations] FOR [Populations].[GetStudyPopulations]
GO

GRANT EXECUTE ON [dbo].[GetPopulations] TO [FastTrak]
GO