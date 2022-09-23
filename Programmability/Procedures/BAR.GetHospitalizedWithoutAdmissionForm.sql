SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BAR].[GetHospitalizedWithoutAdmissionForm]( @StudyId INT ) AS
BEGIN  
  SELECT DISTINCT ce.PersonId 
  INTO #temp
  FROM dbo.ClinEvent ce 
  JOIN dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId
  WHERE cdp.ItemId = 8091 AND cdp.EnumVal = 1 AND ce.StudyId = @StudyId
  EXCEPT 
  SELECT DISTINCT ce2.PersonId 
  FROM dbo.ClinEvent ce2 
  JOIN dbo.ClinForm cf2 ON cf2.EventId = ce2.EventId
  WHERE cf2.FormId=655 AND ce2.StudyId = @StudyId;
  SELECT v.PersonId, v.DOB, v.FullName, v.GroupName, 'No FirstAdmission!' AS InfoText
  FROM dbo.ViewActiveCaseListStub v 
  JOIN #temp t ON t.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId
  ORDER BY FullName;
END
GO

GRANT EXECUTE ON [BAR].[GetHospitalizedWithoutAdmissionForm] TO [FastTrak]
GO