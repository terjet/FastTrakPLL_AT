SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastQuantities] (@ItemId INT)
RETURNS @LastEnumVals TABLE (
  PersonId INT NOT NULL,
  Quantity DECIMAL(12, 4) NOT NULL
) AS
BEGIN
  INSERT @LastEnumVals
    SELECT a.PersonId, a.Quantity
    FROM (SELECT ce.PersonId, cdp.Quantity, RANK() OVER (PARTITION BY ce.PersonId ORDER BY ce.EventTime DESC) AS OrderNo
      FROM dbo.ClinEvent ce
      JOIN dbo.ClinDataPoint cdp
        ON cdp.EventId = ce.EventId
      WHERE cdp.ItemId = @ItemId
      AND NOT cdp.Quantity IS NULL) a
    WHERE a.OrderNo = 1;
  RETURN;
END
GO