SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListLastGamma]( @StudyId INT ) AS
BEGIN
  EXEC GetCaseListLastForm @StudyId, 'HofteGamma'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListLastGamma] TO [FastTrak]
GO