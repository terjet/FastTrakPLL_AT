SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ViewCaseListStub]( PersonId, DOB, FullName, StudyId, GroupId, GroupName, GenderId, StatusId, StatusText ) 
AS
SELECT p.PersonId, p.DOB, p.ReverseName AS FullName, sc.StudyId, sg.GroupId, sg.GroupName, p.GenderId, ss.StatusId, ss.StatusText
FROM dbo.Person p
  JOIN dbo.StudCase sc ON sc.PersonId = p.PersonId
  JOIN dbo.StudyStatus ss ON ss.StudyId = sc.StudyId AND ss.StatusId = sc.FinState
  JOIN dbo.StudyGroup sg ON sg.StudyId = sc.StudyId AND sg.GroupId = sc.GroupId
  JOIN dbo.UserList ul ON ul.CenterId = sg.CenterId AND ul.UserId = USER_ID();
GO

GRANT SELECT ON [dbo].[ViewCaseListStub] TO [FastTrak]
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [dbo].[ViewCaseListStub] TO [public]
GO