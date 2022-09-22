SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [Diagnose].[ICD10] AS
  SELECT cp.ProbId, cp.PersonId, mni.ItemCode, mni.ItemName, cp.ProbType, cp.ProbDebut, cp.ProbSummary, pt.ProbActive, cp.CreatedAt
  FROM dbo.ClinProblem cp
    JOIN dbo.MetaProblemType pt ON pt.ProbType = cp.ProbType
    JOIN dbo.MetaNomListItem mnli ON mnli.ListItem = cp.ListItem
    JOIN dbo.MetaNomItem mni ON mni.ItemId = mnli.ItemId
	JOIN dbo.MetaNomList ml ON ml.ListId = mnli.ListId 
  WHERE ml.DxSystem = 4
GO

GRANT SELECT ON [Diagnose].[ICD10] TO [QuickStat]
GO