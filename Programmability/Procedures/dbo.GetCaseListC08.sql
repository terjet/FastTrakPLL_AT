SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListC08]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'C08%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListC08] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListC08] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListC08] TO [Lege]
GO