SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListC09]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'C09%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListC09] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListC09] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListC09] TO [Lege]
GO