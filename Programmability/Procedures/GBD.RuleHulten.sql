SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleHulten]( @StudyId INT, @PersonId INT ) AS
BEGIN
  EXEC dbo.RulePeriodicForm @StudyId,@PersonId,'HULTEN',90,2
END;
GO

GRANT EXECUTE ON [GBD].[RuleHulten] TO [FastTrak]
GO