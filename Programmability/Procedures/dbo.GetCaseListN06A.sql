SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListN06A]( @StudyId INT ) AS  
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'N06A%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListN06A] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN06A] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN06A] TO [Lege]
GO