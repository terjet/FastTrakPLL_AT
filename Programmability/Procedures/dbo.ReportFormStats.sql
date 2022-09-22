SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ReportFormStats]( @StudyId INT, @StartAt DateTime, @StopAt DateTime )
AS
BEGIN
  DECLARE @DayCount FLOAT;
  SET @DayCount = CONVERT(FLOAT,@StopAt) - CONVERT(FLOAT,@StartAt);
  SELECT c.CenterId,count(*) as BedCount INTO #temp1
  FROM StudyCenter c
  JOIN dbo.StudyGroup sg ON sg.CenterId=c.CenterId AND sg.GroupActive=1 AND sg.StudyId=@StudyId
  JOIN dbo.StudCase sc on sc.GroupId=sg.GroupId and sc.StudyId=sg.StudyId
  JOIN dbo.StudyStatus ss on ss.StatusId=sc.StatusId AND ss.StudyId=sc.StudyId and ss.StatusActive=1
  GROUP BY c.CenterId;
  SELECT sc.CenterId,count(*) AS FormCount INTO #temp2
  FROM StudyCenter sc
    JOIN dbo.UserList ul on ul.CenterId = sc.CenterId
    JOIN ClinForm cf on cf.CreatedBy=ul.UserId
  WHERE cf.CreatedAt > @StartAt AND cf.CreatedAt < @StopAt
  GROUP BY sc.CenterId;
  SELECT c.CenterName,t2.FormCount,t1.BedCount,
    ROUND(CONVERT(FLOAT,t2.FormCount)/CONVERT(FLOAT,t1.BedCount),1) as FormsPerBed,
    7 * ROUND(CONVERT(FLOAT,t2.FormCount)/CONVERT(FLOAT,t1.BedCount)/@DayCount,2) AS PerWeek
  FROM StudyCenter c
  JOIN #temp1 t1 ON t1.CenterId=c.CenterId
  JOIN #temp2 t2 ON t2.CenterId=c.CenterId
  ORDER BY PerWeek DESC
END
GO