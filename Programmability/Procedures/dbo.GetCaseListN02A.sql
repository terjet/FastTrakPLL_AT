SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListN02A]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'N02A%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListN02A] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN02A] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN02A] TO [Lege]
GO