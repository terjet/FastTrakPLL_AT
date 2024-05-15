SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [report].[LabClassOverview] AS
  SELECT cl.LabClassId, ISNULL(cl.FriendlyName, 'Uklassifiserte prøver') AS FriendlyName,
    cl.FurstId, cl.VarName, cl.NLK, cl.Loinc, LabStats.LabCount
  FROM (SELECT lc.LabClassId, COUNT(*) AS LabCount
    FROM dbo.LabCode lc
    JOIN dbo.LabData ld
      ON ld.LabCodeId = lc.LabCodeId
    GROUP BY lc.LabClassId) LabStats
  LEFT JOIN dbo.LabClass cl ON cl.LabClassId = LabStats.LabClassId
GO

GRANT SELECT ON [report].[LabClassOverview] TO [FastTrak]
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [report].[LabClassOverview] TO [public]
GO