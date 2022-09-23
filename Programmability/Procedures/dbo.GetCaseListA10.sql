SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListA10]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'A10%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10] TO [Vernepleier]
GO