SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetLatestClinicalData]( @StudyId INT, @PersonId INT, @StartAt DATETIME, @StopAt DATETIME ) AS
BEGIN
  SELECT ItemId, ItemType, ItemHeader, ItemText, Quantity, DTVal, EnumVal, TextVal, OptionText, UnitStr, Decimals
  FROM
  ( 
    SELECT 
	  cdp.ItemId, cdp.DTVal, cdp.Quantity, cdp.EnumVal, cdp.TextVal,
	  mfi.ItemHeader, mfi.ItemText, mfi.Decimals, 
	  mi.ItemType, mi.UnitStr, mia.OptionText, 
      ROW_NUMBER() OVER ( PARTITION BY ce.PersonId, cdp.ItemId ORDER BY ce.EventNum DESC ) AS ReverseOrder
    FROM dbo.ClinDataPoint cdp 
    JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
    JOIN dbo.MetaItem mi ON mi.ItemId = cdp.ItemId
    JOIN dbo.MetaFormItem mfi ON mfi.ItemId = cdp.ItemId
    JOIN dbo.MetaForm mf ON mf.FormId = mfi.FormId
	JOIN dbo.MetaStudyForm msf ON msf.FormId = mf.FormId AND msf.StudyId = @StudyId
    LEFT JOIN dbo.MetaItemAnswer mia ON mia.ItemId = cdp.ItemId AND mia.OrderNumber = cdp.EnumVal
    WHERE ce.PersonId = @PersonId AND ce.EventTime >= @StartAt AND EventTime < @StopAt
      AND ( ISNULL(cdp.Quantity,-1) >= 0 OR ISNULL( cdp.DTVal, 0 ) > 0 OR DATALENGTH(cdp.TextVal) > 0 )
  ) agg
  WHERE ReverseOrder = 1;
END;
GO