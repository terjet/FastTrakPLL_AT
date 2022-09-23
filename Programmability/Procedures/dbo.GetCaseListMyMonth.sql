SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListMyMonth]( @StudyId INT ) AS
BEGIN
  DECLARE @UserId INT;
  SET @UserId = USER_ID();
  EXEC dbo.GetCaseListNewForms @StudyId,30,@UserId;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListMyMonth] TO [FastTrak]
GO