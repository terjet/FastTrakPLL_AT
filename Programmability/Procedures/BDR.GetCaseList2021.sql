SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[GetCaseList2021]( @StudyId INT ) AS
BEGIN
  SELECT DISTINCT p.PersonId, p.DOB, p.FullName, p.GenderId, p.NationalId, sg.GroupId, sg.GroupName
  FROM dbo.ClinEvent ce
  JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND cf.FormId = 1242
  JOIN dbo.StudyGroup sg ON sg.GroupId = ce.GroupId and sg.StudyId = ce.StudyId
  JOIN dbo.UserList ul ON ul.CenterId = sg.CenterId
  JOIN dbo.Person p ON p.PersonId = ce.PersonId AND DATALENGTH( NationalId) = 11 AND p.TestCase = 0
  WHERE ce.StudyId = @StudyId 
  ORDER BY p.PersonId;
END
GO

GRANT EXECUTE ON [BDR].[GetCaseList2021] TO [FastTrak]
GO