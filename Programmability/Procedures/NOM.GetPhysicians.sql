﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NOM].[GetPhysicians] ( @StudyId INT, @SearchText VARCHAR(16) ) AS
BEGIN
  SELECT ul.UserId AS EnumVal, p.HPRNo AS Quantity, p.ReverseName AS TextVal, p.HPRNo AS V, p.ReverseName AS DN, ul.UserName AS OT
  FROM dbo.UserList  ul
  JOIN dbo.MetaProfession mp ON mp.ProfId = ul.ProfId
  JOIN dbo.Person p ON p.PersonId = ul.PersonId
  WHERE ul.UserName LIKE CONCAT( '%', @SearchText,'%' )
  AND ( ul.UserId > 0 AND mp.ProfType = 'LE' )
  AND P.HPRNo IS NOT NULL;
END
GO

GRANT EXECUTE ON [NOM].[GetPhysicians] TO [FastTrak]
GO