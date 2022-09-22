SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetUsersOnline] AS
BEGIN
  SELECT DISTINCT l.SessId,l.UserId,p.FullName,l.ServTime,l.DbUser,u.PersonId,l.AppVer FROM UserLog l
  LEFT OUTER JOIN UserList u ON u.UserId=l.UserId
  LEFT OUTER JOIN Person p on p.PersonId=u.PersonId
  WHERE l.ClosedAt IS NULL
  ORDER BY l.ServTime
END;
GO