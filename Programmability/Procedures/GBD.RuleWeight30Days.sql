SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleWeight30Days]( @StudyId INT, @PersonId INT ) AS
BEGIN
  EXEC dbo.RulePeriodicData @StudyId,@PersonId,'WEIGHT',30,2
END
GO

GRANT EXECUTE ON [GBD].[RuleWeight30Days] TO [FastTrak]
GO