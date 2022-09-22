SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AccessCtrl].[RevokeUserGroupAccess]( @UserGroupAccessId INT ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE AccessCtrl.UserGroupAccess SET RevokedAt = GETDATE(), RevokedBy = USER_ID() WHERE UserGroupAccessId = @UserGroupAccessId;
END;
GO