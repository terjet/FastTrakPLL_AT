SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListN02BE]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'N02BE%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListN02BE] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN02BE] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN02BE] TO [Lege]
GO