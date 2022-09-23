SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListMyRelations]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId, v.DOB, v.FullName, v.GroupName, r.RelName AS InfoText, p.NationalId
  FROM dbo.ViewActiveCaseListStub v
    JOIN dbo.Person p ON p.PersonId = v.PersonId     
    JOIN dbo.ClinRelation cr ON cr.PersonId = v.PersonId AND cr.UserId = USER_ID()
    JOIN dbo.UserList ul ON ul.UserId = cr.UserId
    JOIN dbo.MetaRelation r ON r.RelId = cr.RelId
  WHERE v.StudyId = @StudyId AND cr.ExpiresAt > GETDATE() 
  ORDER BY v.FullName;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListMyRelations] TO [FastTrak]
GO