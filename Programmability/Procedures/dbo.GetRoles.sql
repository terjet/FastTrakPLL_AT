SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetRoles] AS
BEGIN
  SELECT principal_id AS RoleId, uri.RoleName, uri.RoleCaption, uri.RoleInfo
  FROM sys.database_principals 
  JOIN dbo.UserRoleInfo uri ON name COLLATE SQL_Latin1_General_CP1_CI_AS = uri.RoleName COLLATE SQL_Latin1_General_CP1_CI_AS
  WHERE type='R' AND uri.IsActive=1 
  ORDER BY uri.SortOrder;
END
GO

GRANT EXECUTE ON [dbo].[GetRoles] TO [FastTrak]
GO

GRANT EXECUTE ON [dbo].[GetRoles] TO [superuser]
GO