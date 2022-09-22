SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugReactions]( @PersonId INT ) AS
BEGIN
  SELECT dr.*, mr.*, ms.*, r.*
  FROM dbo.DrugReaction dr
    JOIN dbo.MetaSeverity ms ON ms.SevId = dr.Severity
    JOIN dbo.MetaRelatedness mr ON mr.RelId = dr.Relatedness
    JOIN dbo.MetaResolution r ON r.ResId = dr.Resolved
  WHERE PersonId = @PersonId AND dr.DeletedAt IS NULL AND dr.Avkreftet = 0 AND mr.RelId > 0;
END
GO

GRANT EXECUTE ON [dbo].[GetDrugReactions] TO [FastTrak]
GO