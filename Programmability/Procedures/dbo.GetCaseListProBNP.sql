SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListProBNP]( @StudyId INT ) AS
BEGIN
  DECLARE @CalcDate DateTime;
  SET NOCOUNT ON;
  SET @CalcDate = getdate();
  SELECT PersonId,DOB,FullName,GroupName,
    'ProBNP = ' + CONVERT(VARCHAR,dbo.GetLastLab(vcl.PersonId,'PROBNP')) AS InfoText
  FROM dbo.ViewActiveCaseListStub vcl
  WHERE StudyId=@StudyId 
    AND dbo.GetLastLab(vcl.PersonId,'PROBNP') > 223
    AND ( SELECT COUNT(*) FROM DrugTreatment dt WHERE dt.PersonId=vcl.PersonId AND dt.ATC LIKE 'C09%') = 0
  ORDER BY FullName
END
GO