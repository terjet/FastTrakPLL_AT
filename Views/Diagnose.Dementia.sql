SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [Diagnose].[Dementia] AS
  SELECT cp.PersonId, mni.ItemCode, mni.ItemName, cp.ProbDebut, 
    RANK() OVER ( PARTITION BY cp.PersonId ORDER BY cp.CreatedAt DESC ) AS ReverseOrderNo,
    RANK() OVER ( PARTITION BY cp.PersonId ORDER BY cp.CreatedAt ) AS OrderNo
  FROM dbo.ClinProblem cp
    JOIN dbo.MetaProblemType pt ON pt.ProbType = cp.ProbType AND pt.ProbActive = 1
    JOIN dbo.MetaNomListItem mnli ON mnli.ListItem = cp.ListItem
    JOIN dbo.MetaNomItem mni ON mni.ItemId = mnli.ItemId
  WHERE mni.ItemCode LIKE 'F0[0123]%' OR mni.ItemCode LIKE 'G30%';
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [Diagnose].[Dementia] TO [public]
GO