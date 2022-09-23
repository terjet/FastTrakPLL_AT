SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListJournalansvarlig]( @StudyId INT ) AS
BEGIN
  SELECT v.*, 'Journalansvarlig: ' + p.FullName AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.StudCase sc ON sc.PersonId = v.PersonId AND sc.StudyId = @StudyId
  JOIN dbo.UserList ul ON ul.UserId = sc.Journalansvarlig
  JOIN dbo.Person p ON p.PersonId = ul.PersonId
  WHERE v.StudyId = @StudyId
  ORDER BY p.FullName, v.FullName
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListJournalansvarlig] TO [FastTrak]
GO