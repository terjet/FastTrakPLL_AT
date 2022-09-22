SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListMyWeek]( @StudyId INT ) AS
BEGIN
  DECLARE @UserId INT;
  SET @UserId = USER_ID();
  EXEC GetCaseListNewForms @StudyId,7,@UserId;
END
GO