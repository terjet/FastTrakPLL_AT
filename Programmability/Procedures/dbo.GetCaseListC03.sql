SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListC03]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'C03%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListC03] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListC03] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListC03] TO [Lege]
GO