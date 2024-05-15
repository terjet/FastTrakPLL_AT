SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [Diagnose].[DiabetesMellitus] AS
  SELECT cp.PersonId, mni.ItemCode, mni.ItemName, cp.ProbDebut,
    RANK() OVER ( PARTITION BY cp.PersonId ORDER BY cp.CreatedAt DESC ) AS ReverseOrderNo,
    RANK() OVER ( PARTITION BY cp.PersonId ORDER BY cp.CreatedAt ) AS OrderNo
  FROM dbo.ClinProblem cp
    JOIN dbo.MetaProblemType pt ON pt.ProbType = cp.ProbType AND pt.ProbActive = 1
    JOIN dbo.MetaNomListItem mnli ON mnli.ListItem = cp.ListItem
    JOIN dbo.MetaNomItem mni ON mni.ItemId = mnli.ItemId
  WHERE mni.ItemCode LIKE 'E1[01234]%';
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [Diagnose].[DiabetesMellitus] TO [public]
GO