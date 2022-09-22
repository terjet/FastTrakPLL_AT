SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AccessCtrl].[BlockUserCaseAccess]( @UserId INT, @PersonId INT, @BlockReason VARCHAR(MAX) = NULL ) AS
BEGIN
  SET NOCOUNT ON;
  IF AccessCtrl.UserHasCaseAccess(@UserId, @PersonId) = 1
  BEGIN
    INSERT INTO AccessCtrl.UserCaseBlock (UserId, PersonId, BlockReason) VALUES (@UserId, @PersonId, @BlockReason);
  END;
END;
GO

GRANT EXECUTE ON [AccessCtrl].[BlockUserCaseAccess] TO [superuser]
GO

GRANT EXECUTE ON [AccessCtrl].[BlockUserCaseAccess] TO [Support]
GO