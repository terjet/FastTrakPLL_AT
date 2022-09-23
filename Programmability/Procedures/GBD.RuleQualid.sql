SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleQualid]( @StudyId INT, @PersonId INT ) AS
BEGIN
  EXEC dbo.RulePeriodicForm @StudyId,@PersonId,'QUALID',180,2
END;
GO

GRANT EXECUTE ON [GBD].[RuleQualid] TO [FastTrak]
GO