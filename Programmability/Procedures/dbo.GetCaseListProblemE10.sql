SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListProblemE10]( @StudyId INT ) AS
BEGIN 
  EXECUTE dbo.GetCaseListProblem @StudyId,'E10%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListProblemE10] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListProblemE10] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListProblemE10] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListProblemE10] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListProblemE10] TO [Vernepleier]
GO