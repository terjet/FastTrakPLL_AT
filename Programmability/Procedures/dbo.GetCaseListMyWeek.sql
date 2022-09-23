SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListMyWeek]( @StudyId INT ) AS
BEGIN
  DECLARE @UserId INT;
  SET @UserId = USER_ID();
  EXEC dbo.GetCaseListNewForms @StudyId,7,@UserId;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListMyWeek] TO [FastTrak]
GO