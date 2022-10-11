SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugReactions]( @PersonId INT ) AS
BEGIN
  SELECT * FROM Drug.AdverseReaction 
  WHERE PersonId = @PersonId;
END
GO

GRANT EXECUTE ON [dbo].[GetDrugReactions] TO [FastTrak]
GO