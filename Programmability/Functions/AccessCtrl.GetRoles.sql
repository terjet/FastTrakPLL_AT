SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [AccessCtrl].[GetRoles]()
RETURNS @RoleNames TABLE (
  RoleName SYSNAME NOT NULL
) AS
BEGIN
  INSERT @RoleNames
    SELECT RoleName 
	FROM dbo.UserRoleInfo  
    WHERE ( IsActive = 1 ) AND ( NOT USER_ID(RoleName) IS NULL ); 
  RETURN;
END;
GO