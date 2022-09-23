SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListProblemI50]( @StudyId INT ) AS
BEGIN 
  EXECUTE dbo.GetCaseListProblem @StudyId,'I50%'
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListProblemI50] TO [Farmasøyt]
GO

GRANT EXECUTE ON [GBD].[GetCaseListProblemI50] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[GetCaseListProblemI50] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[GetCaseListProblemI50] TO [Vernepleier]
GO