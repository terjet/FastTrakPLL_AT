SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NOM].[GetICD10Diagnoses] ( @StudyId INT, @SearchText VARCHAR(16) )
AS
BEGIN
  DECLARE @NormalizedCodeSearchText VARCHAR(16) = REPLACE(@SearchText, '.', '');
  SELECT mnli.ListItem AS EnumVal, mnli.ListId AS Quantity, 
    CONCAT( mni.ItemCode, ' | ', mni.ItemName ) AS TextVal,
      CASE WHEN LEN(ItemCode) < 4 THEN
        ItemCode
      ELSE 
        STUFF(ItemCode, 4, 0, '.')
      END
      AS V,
      ItemName AS DN, 
    mnl.ListName AS OT
  FROM dbo.MetaNomItem mni 
  JOIN dbo.MetaNomListItem mnli ON mnli.ItemId = mni.ItemId AND mnli.ListId = 4 AND mnli.IsActive = 1
  JOIN dbo.MetaNomList mnl ON mnl.ListId = mnli.ListId
  WHERE mni.ItemName LIKE CONCAT( '%', @SearchText, '%' ) 
  OR mni.ItemCode LIKE CONCAT( '%', @NormalizedCodeSearchText, '%' );    
END;
GO

GRANT EXECUTE ON [NOM].[GetICD10Diagnoses] TO [FastTrak]
GO