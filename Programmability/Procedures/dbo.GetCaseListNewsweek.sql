SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListNewsweek]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListNewForms @StudyId,7;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListNewsweek] TO [FastTrak]
GO