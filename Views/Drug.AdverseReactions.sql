SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE   VIEW [Drug].[AdverseReactions] AS
  SELECT COALESCE( dr.DrugName, dr.LegemiddelNavn, dr.VirkestoffNavn ) AS PreferredName, 
    dr.*, mr.*, ms.*, r.*
  FROM dbo.DrugReaction dr
    JOIN dbo.MetaSeverity ms ON ms.SevId = dr.Severity
    JOIN dbo.MetaRelatedness mr ON mr.RelId = dr.Relatedness
    JOIN dbo.MetaResolution r ON r.ResId = dr.Resolved
GO