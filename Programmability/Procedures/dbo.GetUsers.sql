SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetUsers] AS
BEGIN
  SELECT 
    su.name AS UserName, su.hasdbaccess, su.uid AS UserId, 
	p.ReverseName, 
	ul.UserName AS UserListUserName, ISNULL(ul.IsActive, 1) AS IsActive, 
    mp.* 
  FROM sys.sysusers su
  LEFT JOIN dbo.UserList ul ON ul.UserId = su.uid
  LEFT JOIN dbo.Person p ON ul.PersonId = p.PersonId
  LEFT JOIN dbo.MetaProfession mp ON mp.ProfId = ul.ProfId
  WHERE (su.islogin = 1)
    AND (su.hasdbaccess = 1)
    AND (su.isntgroup = 0)
    AND ISNULL(ul.IsActive,1) = 1
    AND ( NOT su.name IN ( 'dbo', 'sys', 'guest') )
  ORDER BY su.name;
END
GO