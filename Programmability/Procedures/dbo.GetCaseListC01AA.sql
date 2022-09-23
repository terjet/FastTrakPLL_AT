SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListC01AA]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'C01AA%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListC01AA] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListC01AA] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListC01AA] TO [Lege]
GO