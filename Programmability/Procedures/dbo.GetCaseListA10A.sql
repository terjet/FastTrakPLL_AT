SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListA10A]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'A10A%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10A] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10A] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10A] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10A] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListA10A] TO [Vernepleier]
GO