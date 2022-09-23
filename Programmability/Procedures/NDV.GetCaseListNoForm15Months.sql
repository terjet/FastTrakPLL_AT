SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListNoForm15Months] ( @StudyId INT ) AS
BEGIN 
  EXEC GetCaseListNoRecentForm @StudyId,456;
END
GO

GRANT EXECUTE ON [NDV].[GetCaseListNoForm15Months] TO [FastTrak]
GO