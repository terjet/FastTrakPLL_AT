SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListN06D]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'N06D%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListN06D] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN06D] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN06D] TO [Lege]
GO