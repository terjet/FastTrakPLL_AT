SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AccessCtrl].[AllowUserCaseAccess]( @UserCaseBlockId INT, @AllowedAt DATETIME = NULL ) AS
BEGIN
  IF @AllowedAt IS NULL
    SET @AllowedAt = GETDATE();
  UPDATE AccessCtrl.UserCaseBlock SET AllowedAt = @AllowedAt, AllowedBy = USER_ID()
  WHERE (UserCaseBlockId = @UserCaseBlockId);
END
GO

GRANT EXECUTE ON [AccessCtrl].[AllowUserCaseAccess] TO [superuser]
GO

GRANT EXECUTE ON [AccessCtrl].[AllowUserCaseAccess] TO [Support]
GO