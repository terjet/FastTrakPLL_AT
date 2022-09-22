SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastTextValuesTable]( @ItemId INT, @EndTime DATETIME = NULL )
RETURNS @LastTextVals TABLE (
  PersonId INT NOT NULL PRIMARY KEY,
  EventTime DATETIME NOT NULL,
  TextVal VARCHAR(MAX) NOT NULL
) AS
BEGIN
  DECLARE @LastEventNum INT;
  SELECT @LastEventNum = dbo.FnEventTimeToNum( ISNULL(@EndTime, GETDATE() + 1 ) );
  INSERT @LastTextVals
    SELECT a.PersonId, a.EventTime, a.TextVal
    FROM (SELECT ce.PersonId, ce.EventTime, cdp.TextVal, ROW_NUMBER()
        OVER (
        PARTITION BY ce.PersonId
        ORDER BY ce.EventNum DESC, ce.EventId DESC) AS ReverseOrder
      FROM dbo.ClinEvent ce
      JOIN dbo.ClinDataPoint cdp
        ON cdp.EventId = ce.EventId AND ce.EventNum < @LastEventNum
      WHERE cdp.ItemId = @ItemId
      AND DATALENGTH(cdp.TextVal) > 0) a
    WHERE a.ReverseOrder = 1;
  RETURN;
END
GO