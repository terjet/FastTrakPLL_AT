SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [NDV].[Type1] AS
SELECT v.*, DATEDIFF( dd, v.DOB, GETDATE() ) / 365 AS Age
FROM 
(
  SELECT ce.PersonId, dp.EnumVal AS NDV_TYPE,
  ROW_NUMBER() OVER (PARTITION BY ce.PersonId ORDER BY ce.EventNum DESC, ce.EventId DESC ) AS ReverseOrderBy
  FROM dbo.ClinEvent ce
  JOIN dbo.ClinDataPoint dp ON dp.EventId=ce.EventId
  WHERE dp.ItemId = 3196
) a
JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = a.PersonId
JOIN dbo.Study s ON s.StudyId = v.StudyId AND s.StudyName = 'NDV'
WHERE a.ReverseOrderBy=1 AND a.NDV_TYPE=1;
GO