SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RapportAtferd]( @PersonId INT, @StartAt DATETIME, @StopAt DATETIME ) AS
BEGIN
  SET LANGUAGE NORWEGIAN;
  SELECT 
    p.wk AS WeekNo, 
    MIN(EventTime) AS FirstForm, MAX(EventTime) AS LastForm,
    p.ItemId, mfi.ItemText, 
    MAX(Monday) AS Monday, MAX(Tuesday) AS Tuesday, MAX(Wednesday) AS Wednesday, 
    MAX(Thursday) AS Thursday,  MAX(Friday) AS Friday,
    MAX(Saturday) AS Saturday, MAX(Sunday) AS Sunday
  FROM 
    (
      SELECT wk, EventTime, ItemId, [1] AS Monday, [2] AS Tuesday, [3] AS Wednesday, [4] AS Thursday, [5] AS Friday, [6] AS Saturday, [7] AS Sunday
      FROM
      (
        SELECT mfi.ItemId, ce.EventTime, mia.ShortCode,
          DATEPART(ISO_WEEK,ce.EventTime) AS wk, 
          DATEPART(WEEKDAY,ce.EventTime) AS wd
        FROM dbo.ClinForm cf 
        JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
        JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId AND mf.FormName = 'GBD_ATFERD'
        JOIN dbo.MetaFormItem mfi ON mfi.FormId = cf.FormId AND mfi.ItemId BETWEEN 1630 AND 1653
        LEFT JOIN dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId AND cdp.ItemId = mfi.ItemId
        LEFT JOIN dbo.MetaItemAnswer mia ON mia.ItemId = cdp.ItemId AND mia.OrderNumber = cdp.EnumVal
        WHERE ce.PersonId = @PersonId
        AND cf.FormStatus = 'L'
        AND ( ce.EventTime >= @StartAt AND ce.EventTime < @StopAt )
      ) AS SourceTable
      PIVOT
      (
        MAX(ShortCode) FOR wd IN ( [1],[2],[3],[4],[5],[6],[7] ) 
      ) AS PivotTable 
    ) p
  JOIN dbo.MetaFormItem mfi ON mfi.FormId IN (923, 1047) AND mfi.ItemId = p.ItemId
  GROUP BY wk, p.ItemId, mfi.ItemText
  ORDER BY FirstForm DESC, p.ItemId;
END
GO

GRANT EXECUTE ON [GBD].[RapportAtferd] TO [FastTrak]
GO