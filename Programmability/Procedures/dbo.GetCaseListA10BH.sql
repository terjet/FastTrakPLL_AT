SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListA10BH]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'A10BH%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10BH] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10BH] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10BH] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10BH] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10BH] TO [Vernepleier]
GO