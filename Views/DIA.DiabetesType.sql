SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [DIA].[DiabetesType] AS
SELECT a.PersonId, a.DiaType FROM
  (
    SELECT ce.PersonId, dp.EnumVal AS DiaType,
    RANK() OVER (PARTITION BY ce.PersonId ORDER BY EventNum DESC ) AS ReverseOrder
    FROM dbo.ClinEvent ce
    JOIN dbo.ClinDataPoint dp ON dp.EventId = ce.EventId AND NOT ( dp.EnumVal IS NULL )
    WHERE dp.ItemId = 3196
  ) a
WHERE ReverseOrder = 1
GO