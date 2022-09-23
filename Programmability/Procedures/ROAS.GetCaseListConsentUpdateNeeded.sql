SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[GetCaseListConsentUpdateNeeded]( @StudyId INT ) AS
BEGIN
  SELECT v.*, s.OptionText AS InfoText 
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastEnumValuesTable( 2143, NULL ) s ON s.PersonId = v.PersonId
  WHERE s.EnumVal = 3 AND v.StudyId = @StudyId; 
END;
GO

GRANT EXECUTE ON [ROAS].[GetCaseListConsentUpdateNeeded] TO [FastTrak]
GO