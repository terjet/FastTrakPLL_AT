SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListNoForm24Months] ( @StudyId INT ) AS
BEGIN 
  EXEC GetCaseListNoRecentForm @StudyId,730;
END
GO

GRANT EXECUTE ON [NDV].[GetCaseListNoForm24Months] TO [FastTrak]
GO