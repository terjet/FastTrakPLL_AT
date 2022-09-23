SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListN04BA]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'N04BA%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListN04BA] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN04BA] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN04BA] TO [Lege]
GO