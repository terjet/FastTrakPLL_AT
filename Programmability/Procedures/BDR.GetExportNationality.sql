SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[GetExportNationality] AS 
BEGIN

  SELECT p.NationalId, agg.ItemId, agg.ItemType, agg.VarName, agg.EnumVal, agg.Quantity, agg.DTVal, agg.TextVal, agg.EventTime
  FROM 
    (
    SELECT ce.PersonId, ce.EventTime, cdp.ItemId, mi.ItemType, mi.VarName, cdp.EnumVal, cdp.Quantity, cdp.DTVal,
      COALESCE( ctr.ItemName, mia.OptionText, cdp.TextVal ) AS TextVal,
      ROW_NUMBER() OVER ( PARTITION BY ce.PersonId, cdp.ItemId ORDER BY ce.EventNum DESC ) AS ReverseOrder
    FROM dbo.ClinDataPoint cdp
      JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
      JOIN dbo.MetaItem mi ON mi.ItemId = cdp.ItemId
      LEFT JOIN dbo.MetaItemAnswer mia ON mia.ItemId = cdp.ItemId AND mia.OrderNumber = cdp.EnumVal
      LEFT JOIN 
      (
        SELECT ItemCode, ItemName 
        FROM dbo.MetaNomListItem mnli 
        JOIN dbo.MetaNomItem mni ON mni.ItemId = mnli.ItemId
        WHERE mnli.ListId = 26
      ) ctr ON ctr.ItemName = cdp.TextVal AND cdp.ItemId IN ( 3400, 3324, 3325 )
    WHERE cdp.ItemId IN ( 2709, 2847, 2859, 3400, 3324, 3325 )
  ) agg 
  JOIN dbo.Person p ON p.PersonId = agg.PersonId
  WHERE agg.ReverseOrder = 1;      
  
END
GO

GRANT EXECUTE ON [BDR].[GetExportNationality] TO [Administrator]
GO