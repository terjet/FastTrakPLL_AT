SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[GetUsers] AS
BEGIN
    SELECT su.name AS UserName,
        su.uid AS UserId,
        ul.UserName AS UserListUserName,
        ul.CenterId,
        ISNULL(ul.IsActive, 1) AS IsActive,
        p.ReverseName,
        mp.ProfName,
        sc.CenterName
    FROM sys.sysusers su
    LEFT JOIN dbo.UserList ul ON ul.UserId = su.uid
    LEFT JOIN dbo.Person p ON ul.PersonId = p.PersonId
    LEFT JOIN dbo.MetaProfession mp ON mp.ProfId = ul.ProfId
    LEFT JOIN dbo.StudyCenter sc ON sc.CenterId = ul.CenterId
    WHERE (su.islogin = 1)
    AND (su.hasdbaccess = 1)
    AND (su.isntgroup = 0)
    AND ISNULL(ul.IsActive, 1) = 1
    AND (NOT su.name IN ('dbo', 'sys', 'guest'))
    ORDER BY su.name;
END;
GO