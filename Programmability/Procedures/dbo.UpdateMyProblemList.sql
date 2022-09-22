SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateMyProblemList]( @ListId INT ) AS
BEGIN
  UPDATE UserList SET ProbListId = @ListId WHERE UserId=USER_ID();
  EXEC GetMyProblemList;
END
GO