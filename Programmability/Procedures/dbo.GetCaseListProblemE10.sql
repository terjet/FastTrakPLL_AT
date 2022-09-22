SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListProblemE10]( @StudyId INT ) AS
BEGIN 
  EXECUTE dbo.GetCaseListProblem @StudyId,'E10%'
END
GO