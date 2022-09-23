SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseList]( @StudyId INT ) AS
BEGIN
  SELECT vcl.PersonId, vcl.DOB, vcl.FullName, vcl.GroupName, ss.StatusText AS InfoText,
    sc.HandledBy, up.Signature AS PrimaryContactSign, up.FullName AS PrimaryContactName,
    p.GenderId, p.NationalId
  FROM dbo.StudCase sc
    JOIN dbo.ViewActiveCaseListStub vcl ON sc.PersonId = vcl.PersonId AND vcl.StudyId = sc.StudyId
    JOIN dbo.Person p ON p.PersonId = vcl.PersonId
    LEFT OUTER JOIN dbo.StudyStatus ss ON ss.StatusId = sc.FinState AND ss.StudyId = sc.StudyId
    LEFT OUTER JOIN dbo.UserList ul ON ul.UserId = sc.HandledBy
    LEFT OUTER JOIN dbo.Person up ON up.PersonId = ul.PersonId 
  WHERE sc.StudyId = @StudyId
  ORDER BY vcl.FullName;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseList] TO [FastTrak]
GO