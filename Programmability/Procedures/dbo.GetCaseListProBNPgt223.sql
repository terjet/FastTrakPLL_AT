SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListProBNPgt223]( @StudyId INT ) AS
BEGIN
  DECLARE @CalcDate DateTime;
  SET @CalcDate = getdate();
  SELECT PersonId,DOB,FullName,GroupName,
    'ProBNP = ' + CONVERT(VARCHAR,dbo.GetLastLab(PersonId,'PROBNP')) AS InfoText
  FROM dbo.ViewActiveCaseListStub vcl
  WHERE StudyId=@StudyId AND dbo.GetLastLab(PersonId,'PROBNP') > 223
  ORDER BY FullName
END
GO