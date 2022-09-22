SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListC09LowGFR]( @StudyId INT ) AS
BEGIN
  DECLARE @CalcDate DateTime;
  SET NOCOUNT ON;
  SET @CalcDate = getdate();
  SELECT DISTINCT vcl.PersonId,vcl.DOB,vcl.FullName,vcl.GroupName,
    'GFR = ' + CONVERT(VARCHAR,dbo.GetMDRD(vcl.PersonId,@CalcDate)) +
    ', ' + dt.DrugName AS InfoText
  FROM dbo.ViewActiveCaseListStub vcl
    JOIN dbo.DrugTreatment dt on dt.PersonId=vcl.PersonId
      and ( dt.ATC like 'C09%' ) and ( StopAt IS NULL OR StopAt>getdate())
  WHERE vcl.StudyId=@StudyId AND dbo.GetMDRD(vcl.PersonId,@CalcDate) < 60
  ORDER BY FullName
END
GO