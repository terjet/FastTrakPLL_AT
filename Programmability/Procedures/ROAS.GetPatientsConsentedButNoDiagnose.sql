SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[GetPatientsConsentedButNoDiagnose]( @StudyId INT ) AS
BEGIN 
  SELECT DISTINCT v.PersonId, v.DOB, v.FullName, v.GenderId
  FROM dbo.ViewActiveCaseListStub v
  LEFT JOIN 
    (
	  SELECT ce.PersonId, cdp.Quantity
	  FROM dbo.ClinEvent ce
	  JOIN dbo.ClinDataPoint cdp
	    ON cdp.EventId = ce.EventId
	  WHERE cdp.ItemId = 1484
    ) glevt1484 ON glevt1484.PersonId = v.PersonId
  JOIN dbo.GetLastEnumValuesTable(6605, NULL) glevt6605 ON glevt6605.PersonId = v.PersonId AND glevt6605.EnumVal = 1
  LEFT JOIN dbo.GetLastEnumValuesTable(6321, NULL) glevt6321 ON glevt6321.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable(6299, NULL) glevt6299 ON glevt6299.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable(6312, NULL) glevt6312 ON glevt6312.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId 
    AND NOT 
    (
      glevt1484.Quantity IS NOT NULL OR
      (glevt6321.EnumVal IS NOT NULL AND glevt6321.EnumVal = 1) OR
      (glevt6299.EnumVal IS NOT NULL AND glevt6299.EnumVal = 1) OR
      (glevt6312.EnumVal IS NOT NULL AND glevt6312.EnumVal = 1)
    )
  ORDER BY v.FullName;
  
END
GO

GRANT EXECUTE ON [ROAS].[GetPatientsConsentedButNoDiagnose] TO [FastTrak]
GO