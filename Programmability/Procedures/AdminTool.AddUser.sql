SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[AddUser]( @UserName SYSNAME, @ProfId INT, @CenterId INT ) AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	-- Make sure that the user is not already present as a FastTrak user.
	IF EXISTS ( SELECT 1 FROM dbo.UserList WHERE UserName = @UserName AND UserId > 1 )
		RAISERROR ( 'Denne brukeren finnes allerede.', 16, 1 );
	EXEC dbo.AddUser @UserName, NULL;
	DECLARE @UserId INT;
	SET @UserId = USER_ID( @UserName );
	IF @UserId IS NULL
		RAISERROR ( 'Brukeren kunne ikke opprettes.', 16, 1 );
	EXEC dbo.UpdateUserCenter @UserId, @CenterId;
	EXEC dbo.UpdateUserProfession @UserId, @ProfId;
	EXEC dbo.UpdateUserPersonFromUserName @UserId;
END;
GO