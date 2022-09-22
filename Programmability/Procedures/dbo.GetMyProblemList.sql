SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetMyProblemList] AS
BEGIN
  SELECT ml.ListId,ml.ListName FROM UserList ul JOIN MetaNomList ml on ml.ListId=ISNULL(ul.ProbListId,4) WHERE UserId=USER_ID();
END
GO

GRANT EXECUTE ON [dbo].[GetMyProblemList] TO [FastTrak]
GO