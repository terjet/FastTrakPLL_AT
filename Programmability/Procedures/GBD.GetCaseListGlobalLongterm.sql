SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListGlobalLongterm]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListGlobalByStatusId @StudyId, 7;
END;
GO

GRANT EXECUTE ON [GBD].[GetCaseListGlobalLongterm] TO [QuickStat]
GO