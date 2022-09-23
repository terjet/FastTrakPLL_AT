SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListType1AndCoeliacDisease]( @StudyId INT ) AS
BEGIN
  SELECT v.*, v.StatusText AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastEnumValuesTable( 3196, NULL ) type1 ON type1.PersonId = v.PersonId
  JOIN dbo.GetLastEnumValuesTable( 3410, NULL ) coeliac ON coeliac.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND type1.EnumVal = 1 AND coeliac.EnumVal = 1
  ORDER BY v.FullName
END
GO

GRANT EXECUTE ON [NDV].[GetCaseListType1AndCoeliacDisease] TO [FastTrak]
GO