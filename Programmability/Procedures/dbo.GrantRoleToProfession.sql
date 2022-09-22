SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GrantRoleToProfession]( @RoleName sysname,@OID9060 VARCHAR(3) )
AS
BEGIN
  DECLARE @UserName sysname;
  DECLARE user_cursor CURSOR FOR 
    SELECT su.name FROM sysusers su
    JOIN UserList ul ON ul.UserId=su.uid 
    JOIN MetaProfession mp ON mp.ProfId=ul.ProfId 
    WHERE (mp.OID9060=@OID9060) AND (su.name<>'dbo') AND (su.hasdbaccess=1);
  OPEN user_cursor;
  FETCH NEXT FROM user_cursor INTO @UserName;
  WHILE @@FETCH_STATUS=0
  BEGIN
     EXEC sp_addrolemember @RoleName,@UserName;
     FETCH NEXT FROM user_cursor INTO @UserName;
  END
  CLOSE user_cursor;
  DEALLOCATE user_cursor;
END;
GO