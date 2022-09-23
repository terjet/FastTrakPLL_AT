SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListDiabetes]( @StudyId INT ) AS
BEGIN 
  EXECUTE dbo.GetCaseListProblem @StudyId,'E1[014]%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListDiabetes] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListDiabetes] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListDiabetes] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListDiabetes] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListDiabetes] TO [Vernepleier]
GO