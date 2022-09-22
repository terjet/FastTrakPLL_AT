SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetNomMatch]( @MatchString VARCHAR(32), @ListId INT ) AS
BEGIN
  DECLARE @SearchFor VARCHAR(36);
  DECLARE @SubStr VARCHAR(2);
  SET @SubStr=SUBSTRING(@MatchString,2,1);
  IF ISNUMERIC(@SubStr)=1 OR LEN(@MatchString)=1
  BEGIN
    SET @SearchFor = @MatchString + '%';
    SELECT mi.ItemCode,mi.ItemName
      FROM dbo.MetaNomItem mi
      JOIN dbo.MetaNomListItem ml ON ml.ItemId=mi.ItemId AND ml.ListId=@ListId
    WHERE mi.ItemCode LIKE @SearchFor
    ORDER BY mi.ItemCode
  END
  ELSE 
  BEGIN
    SET @SearchFor = '%' + @MatchString + '%';
    SELECT mi.ItemCode,mi.ItemName,CharIndex(@MatchString,mi.ItemName) as FindPos
      FROM dbo.MetaNomItem mi
      JOIN dbo.MetaNomListItem ml ON ml.ItemId=mi.ItemId AND ml.ListId=@ListId
      WHERE mi.ItemName LIKE @SearchFor
    ORDER by FindPos,mi.ItemCode
  END
END
GO

GRANT EXECUTE ON [dbo].[GetNomMatch] TO [FastTrak]
GO