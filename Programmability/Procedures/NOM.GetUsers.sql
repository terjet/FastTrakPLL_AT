SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NOM].[GetUsers]( @StudyId INT, @SearchText VARCHAR(16) ) AS
BEGIN
  SELECT ul.UserId AS EnumVal, p.HPRNo AS Quantity,
    p.ReverseName AS TextVal, p.HPRNo AS V, p.ReverseName AS DN, ul.UserName AS OT 
  FROM dbo.UserList  ul
  LEFT JOIN dbo.Person p ON p.PersonId = ul.PersonId
  WHERE ul.UserName LIKE CONCAT( '%', @SearchText,'%' ) AND ul.UserId > 0;
END
GO