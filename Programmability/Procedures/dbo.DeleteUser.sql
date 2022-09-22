SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteUser]( @UserName NVARCHAR(128) ) AS
BEGIN
  DECLARE @UserId INT;           
  DECLARE @SqlCmd NVARCHAR(128);
  SELECT @UserId=UserId from dbo.UserList WHERE (UserName=@UserName) AND ( UserId > 0 );
  IF @UserId IS NULL
  BEGIN
    SET @UserId = USER_ID(@UserName);
    IF @UserId > 0
      INSERT INTO dbo.UserList (UserId,UserName,IsActive) VALUES ( @UserId,@UserName,0 );
    ELSE
      RAISERROR( 'Databasebrukeren "%s" finnes ikke', 16, 1, @UserName )
  END
  ELSE
    UPDATE dbo.UserList SET IsActive=0 WHERE UserId=@UserId;
  EXECUTE( 'DENY CONNECT TO [' + @UserName + ']' );   
END
GO