SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[RoleMembership] AS
SELECT 
  ur.RoleName, 
  ul.CenterId, ISNULL(c.CenterName, '(uten arbeidssted)' ) AS CenterName,
  sm.memberuid AS UserId, ISNULL(ul.UserName,USER_NAME(sm.memberuid)) AS UserName,
  ISNULL(p.FullName,'(navn mangler)') AS FullName, p.HPRNo, mp.ProfType, mp.ProfName,
  ur.RoleCaption, ur.RoleInfo, ur.SortOrder
FROM dbo.UserRoleInfo ur 
  JOIN sys.database_principals sp on sp.Name=ur.RoleName
  JOIN sys.sysmembers sm ON sm.groupuid=sp.principal_id
  JOIN sys.sysusers su ON su.uid=sm.memberuid AND su.hasdbaccess=1
  LEFT JOIN dbo.UserList ul ON ul.UserId=sm.memberuid
  LEFT JOIN dbo.MetaProfession mp ON mp.ProfId=ul.ProfId
  LEFT JOIN dbo.StudyCenter c ON c.CenterId=ul.CenterId
  LEFT JOIN dbo.Person p ON p.PersonId=ul.PersonId
GO