SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListAntiHTLowBP]( @StudyId INT ) AS
BEGIN
  SET NOCOUNT ON;
  SELECT DISTINCT vcl.PersonId,vcl.DOB,vcl.FullName,vcl.GroupName,
    'Sys BT = ' + CONVERT(VARCHAR,CONVERT(INT,dbo.GetLastQuantity(vcl.PersonId,'SBP_UNSPEC'))) +
    ', ' + dt.DrugName AS InfoText
  FROM dbo.ViewActiveCaseListStub vcl
    JOIN dbo.DrugTreatment dt on dt.PersonId=vcl.PersonId
      and ( dt.ATC like 'C07%' or dt.ATC like 'C09%' or dt.ATC like 'C08%'
        or dt.ATC like 'C02%' OR dt.ATC like 'C03%')
      and ( dt.StopAt IS NULL OR dt.StopAt>getdate())
  WHERE vcl.StudyId=@StudyId AND dbo.GetLastQuantity(vcl.PersonId,'SBP_UNSPEC') < 120
  ORDER BY FullName
END
GO