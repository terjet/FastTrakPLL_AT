SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ChangePassword]( @oldpassword NVARCHAR(30),@newpassword varchar(30) )
AS
BEGIN
  DECLARE @UserName NVARCHAR(128);
  DECLARE @SqlCmd NVARCHAR(512);  
  SET @UserName =USER_NAME();
  IF CHARINDEX( '\', @UserName ) > 1
    RAISERROR( 'Password must be changed in Windows', 16, 1 )
  ELSE
  BEGIN                             
    SET @SqlCmd='ALTER LOGIN ' + @UserName + ' WITH Password=''' + @newpassword + ''' OLD_PASSWORD=''' + @oldpassword + '''';      
    EXEC sp_executesql @SqlCmd;
  END
END
GO