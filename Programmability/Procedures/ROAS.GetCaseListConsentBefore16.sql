SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[GetCaseListConsentBefore16]( @StudyId INT )  AS
BEGIN
  SELECT v.*,s.OptionText AS InfoText  FROM dbo.GetLastEnumValuesTable( 2143, NULL ) s
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = s.PersonId
  WHERE s.EnumVal IN (2,6) AND v.StudyId = @StudyId
  ORDER BY DOB DESC;
END
GO

GRANT EXECUTE ON [ROAS].[GetCaseListConsentBefore16] TO [FastTrak]
GO