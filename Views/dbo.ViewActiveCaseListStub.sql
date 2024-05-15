SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ViewActiveCaseListStub]( PersonId, DOB, FullName, StudyId, GroupId, GroupName, GenderId, StatusId, StatusText ) 
AS
SELECT p.PersonId, p.DOB, p.ReverseName AS FullName, sc.StudyId, sg.GroupId, sg.GroupName, p.GenderId, sc.StatusId, ss.StatusText
  FROM dbo.Person p
  JOIN dbo.StudCase sc ON sc.PersonId = p.PersonId
  JOIN dbo.StudyStatus ss ON ss.StudyId = sc.StudyId AND ss.StatusId = sc.FinState AND ss.StatusActive = 1
  JOIN dbo.StudyGroup sg ON sg.StudyId = sc.StudyId AND sg.GroupId = sc.GroupId AND sg.GroupActive = 1
  JOIN dbo.UserList ul ON ul.CenterId = sg.CenterId AND ul.UserId = USER_ID()
  LEFT OUTER JOIN dbo.StudyUser su ON su.UserId = USER_ID() AND su.StudyId = sc.StudyId
  WHERE ( su.GroupId=sc.GroupId ) OR ( su.UserId IS NULL ) OR ( su.GroupId IS NULL ) OR ( su.ShowMyGroup = 0 )
GO

GRANT SELECT ON [dbo].[ViewActiveCaseListStub] TO [FastTrak]
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [dbo].[ViewActiveCaseListStub] TO [public]
GO