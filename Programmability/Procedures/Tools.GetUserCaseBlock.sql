SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[GetUserCaseBlock]( @UserId INT, @Historic BIT ) AS
BEGIN
  SELECT p.PersonId, p.DOB, p.FullName, ucb.UserCaseBlockId, ucb.AllowedAt, ucb.BlockedAt, ucb.BlockReason
  FROM AccessCtrl.UserCaseBlock ucb
  JOIN dbo.Person p ON p.PersonId = ucb.PersonId
  WHERE ( ucb.UserId = @UserId ) AND ( ucb.AllowedAt IS NULL OR @Historic = 1 );
END;
GO