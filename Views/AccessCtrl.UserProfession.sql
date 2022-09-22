SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [AccessCtrl].[UserProfession] AS
SELECT mp.ProfId, mp.ProfName, mp.ProfType
FROM dbo.UserList ul
  LEFT JOIN dbo.MetaProfession userprof ON userprof.ProfId = ul.BaseProfId
  JOIN dbo.MetaProfession mp ON ( mp.ProfLevel BETWEEN  0 AND userprof.ProfLevel - 1 ) 
    OR ( ul.ProfId IS NULL) OR ( mp.ProfId = ul.BaseProfId )
WHERE ( mp.DisabledBy IS NULL ) AND ( ul.UserId = USER_ID() );
GO