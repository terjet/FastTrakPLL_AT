SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetClinProblems]( @PersonId INT ) AS
BEGIN
  SELECT cp.ProbId,mi.ItemCode,mi.ItemName,cp.ProbType,cp.ProbSummary,
    cp.CreatedAt,cp.CreatedBy,
    cp.ProbDebut,cp.Priority,
    ml.DxSystem,cp.FamilyStatus
  FROM dbo.ClinProblem cp
  JOIN dbo.MetaNomListItem mli ON mli.ListItem=cp.ListItem
  JOIN dbo.MetaNomList ml ON ml.ListId=mli.ListId
  JOIN dbo.MetaNomItem mi on mi.ItemId=mli.ItemId
  WHERE cp.PersonId=@PersonId;
END
GO