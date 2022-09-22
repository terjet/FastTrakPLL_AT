SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateUserAccess]( @Username sysname, @GiveAccess bit )
AS
BEGIN
  IF @GiveAccess=1 EXEC sp_grantdbaccess @username
  ELSE EXEC sp_revokedbaccess @username
END
GO

DENY EXECUTE ON [dbo].[UpdateUserAccess] TO [ReadOnly]
GO