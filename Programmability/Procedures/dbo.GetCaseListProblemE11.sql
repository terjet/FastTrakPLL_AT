SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListProblemE11]( @StudyId INT ) AS 
BEGIN
 EXECUTE dbo.GetCaseListProblem @StudyId,'E11%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListProblemE11] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListProblemE11] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListProblemE11] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListProblemE11] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListProblemE11] TO [Vernepleier]
GO