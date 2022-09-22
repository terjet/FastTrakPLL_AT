SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetFormDiagnosesICD10]( @PersonId INT ) AS
BEGIN
  SELECT ce.EventTime, cdp.EnumVal, cdp.ItemId, mia.AnswerId, mia.ICD10, 4 AS ListId 
  FROM dbo.ClinEvent ce 
  JOIN dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId 
  JOIN dbo.MetaItemAnswer mia ON mia.ItemId = cdp.ItemId AND cdp.EnumVal = mia.OrderNumber 
  WHERE ce.PersonId = @PersonId AND NOT mia.ICD10 IS NULL
  ORDER BY mia.ICD10, ce.EventTime DESC;
END
GO