SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListA10BX]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'A10BX%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10BX] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10BX] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10BX] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10BX] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10BX] TO [Vernepleier]
GO