SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddUser]( @UserName NVARCHAR(128), @Password VARCHAR(30) = NULL ) AS
BEGIN
  DECLARE @OldUserName NVARCHAR(128);
  DECLARE @OldUserId INT;
  DECLARE @InsertUser BIT;
  DECLARE @UserId INT;
  /* If this is an SQL login (no backslash in username), check for existing login and create if needed. */
  IF ( CHARINDEX( CHAR(92), @UserName ) = 0 )
  BEGIN
    DECLARE @DbName NVARCHAR(128);
    SET @DbName = DB_NAME();
    IF NOT EXISTS( SELECT name FROM master.dbo.syslogins where name = @UserName )
      EXEC sp_addlogin @UserName, @Password, @DbName;
  END;
  /* Check for existing user with this username */
  IF EXISTS( SELECT name FROM sysusers WHERE name = @UserName )
  BEGIN
    /* Reactivate existing user */ 
    SET @UserId = USER_ID( @UserName );
    IF NOT EXISTS( SELECT UserId FROM dbo.UserList WHERE UserId = @UserId AND UserName = @UserName )
      INSERT INTO dbo.UserList( UserId, UserName, IsActive ) VALUES( @UserId, @UserName, 1)                                                                   
    ELSE  
      UPDATE dbo.UserList SET IsActive = 1 WHERE UserId = @UserId AND UserName = @UserName;
    EXECUTE( 'GRANT CONNECT TO [' + @UserName + ']' );
  END  
  ELSE BEGIN
    /* New user, is created by granting access to the database */
    EXECUTE( 'CREATE USER [' + @UserName + '] WITH DEFAULT_SCHEMA = [dbo]' );
    SET @UserId = USER_ID(@UserName);
    /* Check for existing users (disabled) with this UserId */
    SELECT @OldUserName = UserName, @OldUserId = UserId FROM dbo.UserList WHERE UserId = @UserId;
    IF ( @OldUserId IS NULL )
      INSERT INTO dbo.UserList( UserId,UserName,IsActive ) VALUES( @UserId, @UserName, 1 )                                                                   
    ELSE IF ISNULL( @OldUserName, '' ) = @UserName
      UPDATE dbo.UserList SET IsActive = 1 WHERE UserId = @UserId AND UserName = @UserName;
    ELSE
    BEGIN
      /* Not good, a user with this UserId exists, but the username is different. */
      RAISERROR( 'Brukeren kunne ikke legges til: UserId/UserName konflikt.\nKontakt leverandøren (DIPS AS) snarest!', 16,1 );
      RETURN -1;
    END;
  END;
  EXECUTE ( 'ALTER ROLE [FastTrak] ADD MEMBER [' + @UserName + ']' );
END
GO

GRANT EXECUTE ON [dbo].[AddUser] TO [superuser]
GO