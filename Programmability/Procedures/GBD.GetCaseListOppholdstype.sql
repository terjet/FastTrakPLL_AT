SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListOppholdstype]( @StudyId INT ) AS
BEGIN
  SELECT v.*, v.StatusText AS InfoText, p.BestId
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.Person p ON p.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId
  ORDER BY v.FullName;
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListOppholdstype] TO [FastTrak]
GO