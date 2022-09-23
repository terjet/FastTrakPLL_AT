SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[LabClassList]( @MinCount INT = 0 ) AS
BEGIN
  SELECT 
    cl.LabClassId, cl.FriendlyName,
    cl.UnitStr, cl.ManualEntry, cl.MinValid, cl.MaxValid,
    cl.NLK, cl.Loinc, LabStats.LabCount, LabStats.ActualMin, LabStats.ActualMax
  FROM dbo.LabClass cl 
  LEFT JOIN 
  (SELECT lc.LabClassId, 
    COUNT(*) AS LabCount, MIN(ld.NumResult ) AS ActualMin, MAX(ld.NumResult) AS ActualMax
    FROM dbo.LabCode lc
    JOIN dbo.LabData ld
      ON ld.LabCodeId = lc.LabCodeId
    WHERE ld.NumResult >= 0
    GROUP BY lc.LabClassId) LabStats
  ON LabStats.LabClassId = cl.LabClassId
  WHERE ISNULL( cl.ManualEntry, 1 ) = 1 AND ISNULL( LabStats.LabCount, 0 ) >= @MinCount
  ORDER BY LabStats.LabCount DESC, cl.LabClassId;
END
GO

GRANT EXECUTE ON [report].[LabClassList] TO [FastTrak]
GO