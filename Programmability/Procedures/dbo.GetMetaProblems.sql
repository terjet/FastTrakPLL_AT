SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetMetaProblems]( @MatchString VARCHAR(32), @ListId INT ) AS
BEGIN
  DECLARE @SearchFor VARCHAR(36);
  DECLARE @SubStr VARCHAR(2);
  SET @SubStr=SUBSTRING( @MatchString, 2, 1 );
  IF ISNUMERIC( @SubStr ) = 1 OR LEN( @MatchString ) = 1
  BEGIN
    -- Search for ItemCode if positions 2-3 are numeric characters
    SET @SearchFor = @MatchString + '%';
    SELECT mi.ItemCode, mi.ItemName, l.DxSystem
      FROM dbo.MetaNomItem mi
      JOIN dbo.MetaNomListItem ml ON ml.ItemId=mi.ItemId 
	  JOIN dbo.MetaNomList l ON l.ListId = ml.ListId AND l.ListId=@ListId
    WHERE mi.ItemCode LIKE @SearchFor AND ISNULL( ml.IsActive, 1 ) = 1
    ORDER BY mi.ItemCode
  END
  ELSE 
  BEGIN
    -- Search for ItemText if positions 2-3 are non-numeric characters
    SET @SearchFor = '%' + @MatchString + '%';
    SELECT mi.ItemCode, mi.ItemName, l.DxSystem, CHARINDEX( @MatchString, mi.ItemName ) AS FindPos
      FROM dbo.MetaNomItem mi
      JOIN dbo.MetaNomListItem ml ON ml.ItemId=mi.ItemId 
	  JOIN dbo.MetaNomList l ON l.ListId = ml.ListId AND l.ListId=@ListId
      WHERE mi.ItemName LIKE @SearchFor AND ISNULL( ml.IsActive, 1 ) = 1
    ORDER BY FindPos, mi.ItemCode
  END
END
GO