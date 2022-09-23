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
  FROM dbo.DrugTreatment dt
    JOIN dbo.ViewActiveCaseListStub p ON p.PersonId=dt.PersonId
    JOIN dbo.Study s ON s.StudyId=p.StudyId AND s.StudyName='GBD'
    JOIN dbo.UserList ul ON ul.UserId=dt.CreatedBy
    JOIN dbo.UserList my ON my.UserId=USER_ID()
    JOIN dbo.Person up ON up.PersonId=ul.PersonId
  WHERE dt.ATC LIKE 'J01%' AND ATC<>'J01XX05'
    AND dt.StartAt >= @StartAt AND dt.StartAt < @StopAt 
    AND ABS(DATEDIFF(day,dt.StopAt,dt.StartAt )) > 1 
  ORDER BY MonthNo,MonthName,dt.StartAt
END
GO

GRANT EXECUTE ON [GBD].[AntibioticReport] TO [Farmasøyt]
GO

GRANT EXECUTE ON [GBD].[AntibioticReport] TO [FastTrak]
GO

GRANT EXECUTE ON [GBD].[AntibioticReport] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[AntibioticReport] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[AntibioticReport] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[AntibioticReport] TO [Vernepleier]
GO