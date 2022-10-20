SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE   VIEW [Drug].[AdverseReaction] AS
  SELECT COALESCE( dr.DrugName, dr.LegemiddelNavn, dr.VirkestoffNavn ) AS Caption, 
    dr.*, mr.*, ms.*, r.*, COALESCE( dr.ATCName, ai.AtcName ) AS AtcKodeDN
  FROM dbo.DrugReaction dr
    JOIN dbo.MetaSeverity ms ON ms.SevId = dr.Severity
    JOIN dbo.MetaRelatedness mr ON mr.RelId = dr.Relatedness
    LEFT JOIN dbo.MetaResolution r ON r.ResId = dr.Resolved
    LEFT JOIN FEST.AtcIndex ai ON ai.AtcCode = dr.ATC;
GO

GRANT SELECT ON [Drug].[AdverseReaction] TO [FMUser]
GO