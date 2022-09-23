SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[GetCaseListAdultConsentNeeded]( @StudyId INT ) AS
BEGIN
  SELECT v.*, s.OptionText AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastEnumValuesTable( 2143, NULL ) s ON s.PersonId = v.PersonId
  WHERE s.EnumVal IN (2,6) 
    AND DATEDIFF( YEAR, v.DOB, GETDATE()) >= 16 
    AND v.StudyId=@StudyId;
END
GO

GRANT EXECUTE ON [ROAS].[GetCaseListAdultConsentNeeded] TO [FastTrak]
GO