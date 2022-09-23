SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListLastHulten]( @StudyId INT ) AS
BEGIN
  EXEC GetCaseListLastForm @StudyId, 'HULTEN'
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListLastHulten] TO [FastTrak]
GO