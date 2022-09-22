SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[AntibioticReport]( @StartAt DateTime, @StopAt DateTime )
AS
BEGIN
  SET LANGUAGE Norwegian;
  SELECT 
    p.PersonId,p.GroupName,DATEPART(month,StartAt) as MonthNo,
    dbo.MonthYear(StartAt) as MonthName,StartAt,StopAt,
    dt.StartReason,dt.StopReason,dt.ATC,dt.DrugName,dt.DrugForm,dt.Dose24hDD,up.FullName 
  FROM DrugTreatment dt
    JOIN ViewActiveCaseListStub p ON p.PersonId=dt.PersonId
    JOIN Study s ON s.StudyId=p.StudyId AND s.StudyName='GBD'
    JOIN UserList ul ON ul.UserId=dt.CreatedBy
    JOIN UserList my ON my.UserId=USER_ID()
    JOIN Person up ON up.PersonId=ul.PersonId
  WHERE dt.ATC LIKE 'J01%' AND ATC<>'J01XX05'
    AND dt.StartAt >= @StartAt AND dt.StartAt < @StopAt 
    AND ABS(DATEDIFF(day,dt.StopAt,dt.StartAt )) > 1 
  ORDER BY MonthNo,MonthName,dt.StartAt
END
GO

GRANT EXECUTE ON [GBD].[AntibioticReport] TO [FastTrak]
GO