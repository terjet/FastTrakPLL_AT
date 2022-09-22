SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListDrugCombo]( @StudyId INT, @ATC1 VARCHAR(7), @ATC2 VARCHAR(7) ) AS
BEGIN
  SET NOCOUNT ON;
  SELECT DISTINCT vcl.PersonId,vcl.DOB,vcl.FullName,sg.GroupName,d1.DrugName + ' - ' + d2.DrugName AS InfoText
  FROM dbo.OngoingTreatment dt
    JOIN ViewActiveCaseListStub vcl ON vcl.PersonId=dt.PersonId AND vcl.StudyId=@StudyId
    JOIN dbo.StudCase sc on sc.PersonId=vcl.PersonId and sc.StudyId=@StudyId
    JOIN dbo.StudyGroup sg on sg.GroupId=sc.GroupId and sg.StudyId=@StudyId
    JOIN dbo.OngoingTreatment d1 on d1.PersonId=vcl.PersonId and d1.ATC like @ATC1
    JOIN dbo.OngoingTreatment d2 on d2.PersonId=vcl.PersonId and d2.ATC like @ATC2
  ORDER BY FullName
END;
GO