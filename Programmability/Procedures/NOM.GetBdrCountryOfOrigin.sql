SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NOM].[GetBdrCountryOfOrigin] ( @StudyId INT, @SearchText VARCHAR(16) ) AS
BEGIN
  SELECT CONVERT(INT,ItemCode) AS EnumVal, ListItem AS Quantity, ItemName AS TextVal, ItemCode AS V, ItemName AS DN, NULL AS OT
  FROM dbo.MetaNomItem mni
  JOIN dbo.MetaNomListItem mnli ON mnli.ItemId = mni.ItemId AND mnli.ListId = 26
  WHERE ItemName LIKE CONCAT( @SearchText,'%' )
  ORDER BY ItemName;
END
GO

GRANT EXECUTE ON [NOM].[GetBdrCountryOfOrigin] TO [FastTrak]
GO