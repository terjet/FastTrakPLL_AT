SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [report].[LabTestOverview] AS
  SELECT LabStats.LabCodeId, lc.LabClassId, lc.LabName, cl.FriendlyName, cl.FurstId, cl.VarName, cl.NLK, cl.Loinc,
    LabStats.LabCount, LabStats.MinResult, LabStats.MaxResult, LabStats.AvgResult
  FROM (SELECT ld.LabCodeId,
      COUNT(*) AS LabCount, MIN(ld.NumResult) AS MinResult,
      MAX(ld.NumResult) AS MaxResult, AVG(ld.NumResult) AS AvgResult
    FROM dbo.LabData ld
    WHERE ld.NumResult >= 0
    GROUP BY ld.LabCodeId) LabStats
  JOIN LabCode lc ON lc.LabCodeId = LabStats.LabCodeId
  LEFT JOIN dbo.LabClass cl ON cl.LabClassId = lc.LabClassId
GO