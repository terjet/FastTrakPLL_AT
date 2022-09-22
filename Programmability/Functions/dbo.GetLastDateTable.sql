SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastDateTable]( @ItemId INT, @EndTime DATETIME = NULL )
RETURNS @LastDates TABLE (
  PersonId INT NOT NULL,
  EventTime DATETIME NOT NULL,
  DTVal DateTime NOT NULL
) AS
BEGIN
  DECLARE @LastEventNum INT;
  SELECT @LastEventNum = dbo.FnEventTimeToNum( ISNULL(@EndTime, GETDATE() + 1 ) );
  INSERT @LastDates
    SELECT a.PersonId, a.EventTime, a.DTVal
    FROM (SELECT ce.PersonId, ce.EventTime, cdp.DTVal, ROW_NUMBER()
        OVER (
        PARTITION BY ce.PersonId
        ORDER BY ce.EventNum DESC, ce.EventId DESC) AS ReverseOrder
      FROM dbo.ClinEvent ce
      JOIN dbo.ClinDataPoint cdp
        ON cdp.EventId = ce.EventId AND ce.EventNum < @LastEventNum
      WHERE cdp.ItemId = @ItemId
      AND NOT cdp.DTVal IS NULL ) a
    WHERE a.ReverseOrder = 1;
  RETURN;
END
GO