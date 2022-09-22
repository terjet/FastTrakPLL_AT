SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [NDV].[GetConsentStatusTable] ( @StartTime DATETIME, @EndTime DATETIME )
RETURNS @ConsentStatus TABLE (
  PersonId INT NOT NULL,
  EnumVal INT NOT NULL,
  ShortCode VARCHAR(8) NOT NULL
) AS
BEGIN
  INSERT @ConsentStatus
    SELECT PersonVisits.PersonId, ISNULL(st.EnumVal, -1) AS EnumVal, ISNULL(st.ShortCode, '?') AS ShortCode
    FROM (SELECT ce.PersonId, cdp.EnumVal, COUNT(*) AS n
      FROM dbo.ClinEvent ce
      JOIN dbo.ClinDataPoint cdp
        ON cdp.EventId = ce.EventId
      WHERE cdp.ItemId = 3196
      AND ce.EventTime >= @StartTime
      AND ce.EventTime < @EndTime
      GROUP BY ce.PersonId,
               cdp.EnumVal) PersonVisits
    LEFT JOIN dbo.GetLastEnumValuesTable(3389, @EndTime) st ON st.PersonId = PersonVisits.PersonId;
  RETURN
END
GO