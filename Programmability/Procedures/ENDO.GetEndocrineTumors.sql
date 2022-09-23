SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetEndocrineTumors]( @StudyId INT ) AS
BEGIN
  -- Get number of diagnoses
  SELECT ce.PersonId, count(DISTINCT cdp.ItemId ) AS HitCount
  INTO #temp
  FROM dbo.ClinDataPoint cdp
  JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
  WHERE ce.StudyId=@StudyId AND cdp.ItemId IN ( 5732,5733,5742,5745 ) AND cdp.EnumVal = 1
  GROUP BY ce.PersonId;
  -- Get patients
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName, 'Treff = ' + CONVERT(VARCHAR,t.HitCount) AS InfoText
  FROM dbo.ViewCaseListStub v
  JOIN #temp t ON t.PersonId = v.PersonId
  WHERE v.StudyId=@StudyId
  ORDER BY v.FullName;
END
GO

GRANT EXECUTE ON [ENDO].[GetEndocrineTumors] TO [FastTrak]
GO