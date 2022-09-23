SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListMyYear]( @StudyId INT ) AS
BEGIN
  DECLARE @UserId INT;
  SET @UserId = USER_ID();
  EXEC dbo.GetCaseListNewForms @StudyId,365,@UserId;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListMyYear] TO [FastTrak]
GO