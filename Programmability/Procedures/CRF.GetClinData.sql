SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetClinData]( @StudyId INT, @PersonId INT ) AS
BEGIN
  SELECT 
    cdp.RowId, ce.EventId, ce.EventNum, ce.EventTime, mi.ItemId, mi.VarName, 
    cdp.Quantity, cdp.EnumVal, cdp.DTVal, cdp.TextVal, 
    cdp.ObsDate, cdp.Locked, cdp.ChangeCount, cdp.TouchId
  FROM dbo.ClinDataPoint cdp
    JOIN dbo.ClinEvent ce ON ce.EventId=cdp.EventId 
    JOIN dbo.MetaItem mi ON mi.ItemId=cdp.ItemId
  WHERE ce.PersonId = @PersonId
  ORDER BY ce.EventNum,ce.EventId;
END
GO