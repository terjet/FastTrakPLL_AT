SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListN03]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'N03%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListN03] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN03] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN03] TO [Lege]
GO