SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListNewsweek]( @StudyId INT ) AS
BEGIN
  EXEC GetCaseListNewForms @StudyId,7
END
GO