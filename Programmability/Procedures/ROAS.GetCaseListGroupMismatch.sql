SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[GetCaseListGroupMismatch]( @StudyId INT ) AS
BEGIN
  SELECT v.*, pr.OptionText AS InfoText
  FROM dbo.GetLastEnumValuesTable( 3008, NULL ) pr
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = pr.PersonId AND v.StudyId = @StudyId
  WHERE pr.OptionText <> v.GroupName AND pr.EnumVal > 0
  ORDER BY PersonId;
END;
GO

GRANT EXECUTE ON [ROAS].[GetCaseListGroupMismatch] TO [FastTrak]
GO