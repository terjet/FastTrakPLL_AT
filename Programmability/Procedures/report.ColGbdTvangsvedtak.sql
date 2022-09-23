SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[ColGbdTvangsvedtak] AS
BEGIN
  SELECT 
    PersonId, 'TVANG_REST' AS VarName, 
    MAX(DATEDIFF(DD,GETDATE(),EventTime)) AS DpValue, 
    MAX(EventTime) AS MaxEventTime, 
    MAX(ClinFormId) AS MaxClinFormId
  FROM GBD.Tvangsvedtak
  GROUP BY PersonId;
END
GO

GRANT EXECUTE ON [report].[ColGbdTvangsvedtak] TO [QuickStat]
GO