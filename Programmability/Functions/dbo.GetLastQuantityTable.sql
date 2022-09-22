SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastQuantityTable]( @ItemId INT, @EndTime DATETIME = NULL )
RETURNS @LastQuantities TABLE (
  PersonId INT NOT NULL,
  EventTime DATETIME NOT NULL,
  Quantity DECIMAL(18, 4) NOT NULL
) AS
BEGIN
  DECLARE @LastEventNum INT;
  SELECT @LastEventNum = dbo.FnEventTimeToNum( ISNULL(@EndTime, GETDATE() + 1 ) );
  INSERT @LastQuantities
    SELECT a.PersonId, a.EventTime, a.Quantity
    FROM (SELECT ce.PersonId, ce.EventTime, cdp.Quantity, ROW_NUMBER()
        OVER (
        PARTITION BY ce.PersonId
        ORDER BY ce.EventNum DESC, ce.EventId DESC) AS ReverseOrder
      FROM dbo.ClinEvent ce
      JOIN dbo.ClinDataPoint cdp
        ON cdp.EventId = ce.EventId AND ce.EventNum < @LastEventNum
      WHERE cdp.ItemId = @ItemId
      AND NOT cdp.Quantity IS NULL) a
    WHERE a.ReverseOrder = 1;
  RETURN;
END
GO

GRANT SELECT ON [dbo].[GetLastQuantityTable] TO [QuickStat]
GO