SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastEnumValuesTable]( @ItemId INT, @EndTime DATETIME = NULL )
RETURNS @LastEnumVals TABLE (
  PersonId INT NOT NULL,
  EventTime DATETIME NOT NULL,
  EnumVal INT NOT NULL,
  ShortCode VARCHAR(5),
  OptionText VARCHAR(MAX)
) AS
BEGIN
  DECLARE @LastEventNum INT;
  SELECT @LastEventNum = dbo.FnEventTimeToNum( ISNULL(@EndTime, GETDATE() + 1 ) );
  INSERT @LastEnumVals
    SELECT a.PersonId, a.EventTime, a.EnumVal, ISNULL(mia.ShortCode, 'n/a') AS ShortCode, ISNULL(mia.OptionText, 'Ubesvart') AS OptionText
    FROM (SELECT ce.PersonId, ce.EventTime, cdp.EnumVal, ROW_NUMBER()
        OVER (
        PARTITION BY ce.PersonId
        ORDER BY ce.EventTime DESC) AS ReverseOrder
      FROM dbo.ClinEvent ce
      JOIN dbo.ClinDataPoint cdp
        ON cdp.EventId = ce.EventId AND ce.EventNum < @LastEventNum
      WHERE cdp.ItemId = @ItemId
      AND ISNULL(cdp.EnumVal, -1) >= 0) a
    LEFT JOIN dbo.MetaItemAnswer mia ON mia.ItemId = @ItemId AND mia.OrderNumber = a.EnumVal
    WHERE a.ReverseOrder = 1;
  RETURN;
END
GO

GRANT SELECT ON [dbo].[GetLastEnumValuesTable] TO [QuickStat]
GO