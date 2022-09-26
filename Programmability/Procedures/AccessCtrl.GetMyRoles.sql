SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AccessCtrl].[GetMyRoles] AS
BEGIN
  SELECT p.principal_id AS RoleId, p.name AS RoleName, uri.RoleCaption, uri.RoleInfo
  FROM sys.database_principals p
  JOIN dbo.UserRoleInfo uri ON p.name COLLATE SQL_Latin1_General_CP1_CI_AS = uri.RoleName COLLATE SQL_Latin1_General_CP1_CI_AS
  WHERE p.type = 'R' AND uri.IsActive = 1 AND IS_MEMBER(p.name ) = 1
  ORDER BY RoleName;
END
GO

GRANT EXECUTE ON [AccessCtrl].[GetMyRoles] TO [FastTrak]
GO