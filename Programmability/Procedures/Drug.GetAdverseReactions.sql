SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Drug].[GetAdverseReactions]( @PersonId INT ) AS
BEGIN
  SELECT * FROM Drug.AdverseReaction 
  WHERE PersonId = @PersonId
  ORDER BY RiskScore DESC;
END
GO