SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListB01AF]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'B01AF%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListB01AF] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListB01AF] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListB01AF] TO [Lege]
GO