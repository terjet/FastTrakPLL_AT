SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListProblemI48]( @StudyId INT ) AS 
BEGIN
  EXECUTE dbo.GetCaseListProblem @StudyId,'I48%'
END
GO