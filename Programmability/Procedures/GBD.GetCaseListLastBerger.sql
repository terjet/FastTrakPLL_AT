SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListLastBerger]( @StudyId INT ) AS
BEGIN
  EXEC GetCaseListLastForm @StudyId, 'BERGER'
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListLastBerger] TO [FastTrak]
GO