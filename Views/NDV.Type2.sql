SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [NDV].[Type2] AS
SELECT v.*, DATEDIFF( dd, v.DOB, GETDATE() ) / 365 AS Age
FROM 
(
  SELECT ce.PersonId, dp.EnumVal AS NDV_TYPE,
  ROW_NUMBER() OVER (PARTITION BY ce.PersonId ORDER BY ce.EventNum DESC, ce.EventId DESC  ) AS OrderBy
  FROM dbo.ClinEvent ce
  JOIN dbo.ClinDataPoint dp ON dp.EventId=ce.EventId
  WHERE dp.ItemId=3196
) a
JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = a.PersonId
JOIN dbo.Study s ON s.StudyId = v.StudyId AND s.StudyName = 'NDV'
WHERE a.OrderBy = 1 AND a.NDV_TYPE = 2;
GO

GRANT SELECT ON [NDV].[Type2] TO [FastTrak]
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [NDV].[Type2] TO [public]
GO