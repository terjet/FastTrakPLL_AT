SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NOM].[GetRoasDiagnoses]( @StudyId INT, @SearchText VARCHAR(16) ) AS
BEGIN
  SELECT mnli.ListItem AS EnumVal, mnli.ListId AS Quantity, 
    CONCAT( mni.ItemCode, ' | ', mni.ItemName ) AS TextVal, ItemCode AS V, ItemName AS DN, mnl.ListName AS OT
  FROM dbo.MetaNomItem mni 
  JOIN dbo.MetaNomListItem mnli ON mnli.ItemId = mni.ItemId AND mnli.ListId = 11 
  JOIN dbo.MetaNomList mnl ON mnl.ListId = mnli.ListId
  WHERE mni.ItemName LIKE CONCAT( '%', @SearchText,'%' ) 
  OR mni.ItemCode LIKE CONCAT( '%', @SearchText,'%' );
END
GO