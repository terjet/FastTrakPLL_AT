SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListMyMonth]( @StudyId INT ) AS
BEGIN
  DECLARE @UserId INT;
  SET @UserId = USER_ID();
  EXEC GetCaseListNewForms @StudyId,30,@UserId;
END
GO