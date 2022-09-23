SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListJ01]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'J01%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListJ01] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListJ01] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListJ01] TO [Lege]
GO