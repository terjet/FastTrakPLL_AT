SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListEventCount]( @StudyId INT ) AS
BEGIN
  SELECT p.PersonId,p.DOB,p.FullName,
    min(ce.EventTime) as FirstEvent,max(ce.EventTime) as LastEvent, count(*) as EventCount,
    CONVERT(FLOAT,1) as DaysElapsed, CONVERT(FLOAT,1) as EventsPerDay
  INTO #tempList
    FROM dbo.ViewActiveCaseListStub p
    JOIN dbo.ClinEvent ce on ce.PersonId=p.PersonId
  WHERE p.StudyId=@StudyId AND ce.EventTime > getdate()-180
  GROUP BY p.PersonId,p.DOB,p.FullName;
  
  UPDATE #tempList SET DaysElapsed = CONVERT(FLOAT,LastEvent)-CONVERT(FLOAT,FirstEvent)+1.0;
  UPDATE #tempList SET EventsPerDay = CONVERT(FLOAT,EventCount ) / DaysElapsed;
  SELECT vcl.PersonId,vcl.DOB,vcl.FullName,vcl.GroupName,
    'E=' +
    CONVERT(VARCHAR,EventCount) +
    ' D=' +
    CONVERT(VARCHAR,DaysElapsed) +
    ' E/D=' +
    CONVERT(VARCHAR,EventsPerDay) AS InfoText
  FROM #tempList vcl
  WHERE StudyId=@StudyId AND DaysElapsed > 30
  ORDER BY EventsPerDay 
END
GO