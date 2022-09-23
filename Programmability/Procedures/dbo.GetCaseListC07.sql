SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListC07]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'C07%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListC07] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListC07] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListC07] TO [Lege]
GO