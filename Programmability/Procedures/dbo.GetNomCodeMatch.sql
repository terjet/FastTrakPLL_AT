SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetNomCodeMatch]( @MatchString VARCHAR(32), @ListId INT ) AS
BEGIN
  SELECT mi.ItemCode,mi.ItemName
  FROM dbo.MetaNomItem mi   
  JOIN dbo.MetaNomListItem ml ON ml.ItemId=mi.ItemId AND ml.ListId=@ListId
  WHERE mi.ItemCode LIKE @MatchString
  ORDER by mi.ItemCode
END
GO

GRANT EXECUTE ON [dbo].[GetNomCodeMatch] TO [FastTrak]
GO