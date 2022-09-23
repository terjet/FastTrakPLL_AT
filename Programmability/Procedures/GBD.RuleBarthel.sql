SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleBarthel]( @StudyId INT, @PersonId INT ) AS
BEGIN
  EXEC dbo.RulePeriodicForm @StudyId,@PersonId,'BARTHEL',180,2;
END;
GO

GRANT EXECUTE ON [GBD].[RuleBarthel] TO [FastTrak]
GO