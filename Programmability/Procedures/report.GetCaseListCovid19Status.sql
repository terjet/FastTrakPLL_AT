SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetCaseListCovid19Status] ( @StudyId INT, @StatusId INT ) AS
BEGIN
  SELECT v.*, ss.StatusText AS InfoText 
  FROM dbo.ViewCenterCaseListStub v
  JOIN dbo.StudyStatus ss ON ss.StatusId = v.FinState AND ss.StudyId = v.StudyId
  WHERE v.StudyId = @StudyId AND ss.StatusId = @StatusId;
END
GO

GRANT EXECUTE ON [report].[GetCaseListCovid19Status] TO [FastTrak]
GO