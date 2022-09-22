SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RevokeUserCenterAccess]( @CenterAccessId INT) AS
	DECLARE @RevokedBy int
	DECLARE @To DateTime
BEGIN
	UPDATE dbo.UserCenterAccess
	SET StopAt = GetDate(), RevokedBy = USER_ID(), RevokedAt = GetDate()
	WHERE CenterAccessId = @CenterAccessId
END
GO

GRANT EXECUTE ON [dbo].[RevokeUserCenterAccess] TO [superuser]
GO