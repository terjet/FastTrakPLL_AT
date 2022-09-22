SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ReportLabUsage]( @StudyId INT, @StatusActive INT = 1 ) AS
BEGIN
SELECT lc.LabCodeId,lc.LabName,count(ld.ResultId) as UseCount,min(LabDate) as FirstUse,max(LabDate) as LastUse,
  CONVERT(DECIMAL(12,1),AVG(ld.NumResult)) as AvgVal,min(ld.Numresult) as MinVal, max(ld.NumResult) AS MaxVal
  FROM LabData ld JOIN LabCode lc ON lc.LabCodeId=ld.LabCodeId
  JOIN dbo.StudCase sc ON sc.PersonId=ld.PersonId AND StudyId=@StudyId 
  JOIN dbo.StudyStatus ss ON ss.StudyId=sc.StudyId AND ss.StatusId=sc.FinState AND StatusActive=@StatusActive
  WHERE ld.NumResult>=0
  GROUP By lc.LabCodeId, lc.LabName
  ORDER BY count(ld.ResultId) DESC
END
GO