SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ViewFullCaseListStub] AS
  SELECT p.PersonId, p.DOB, p.ReverseName AS FullName, a.StudyId, ISNULL(sg.GroupName, '(ingen)') AS GroupName, p.GenderId, ISNULL(ss.StatusText, '(ukjent)') AS InfoText
  FROM (SELECT DISTINCT sc.StudyId, sc.PersonId
    FROM dbo.StudCase sc
    JOIN dbo.StudyGroup sg
      ON sg.StudyId = sg.StudyId AND sg.GroupId = sc.GroupId
    JOIN dbo.UserList ul
      ON ul.CenterId = sg.CenterId AND ul.UserId = USER_ID()
    UNION
    SELECT DISTINCT sc.StudyId, sc.PersonId
    FROM dbo.StudCase sc
    JOIN dbo.StudCaseLog scl
      ON scl.StudCaseId = sc.StudCaseId
    JOIN dbo.StudyGroup sg
      ON sg.StudyId = sc.StudyId AND sg.GroupId = scl.OldGroupId
    JOIN dbo.UserList ul
      ON ul.CenterId = sg.CenterId AND ul.UserId = USER_ID()) a
  JOIN dbo.StudCase sc ON sc.StudyId = a.StudyId AND sc.PersonId = a.PersonId
  JOIN dbo.Person p ON p.PersonId = sc.PersonId
  LEFT JOIN dbo.StudyGroup sg ON sg.StudyId = sc.StudyId AND sg.GroupId = sc.GroupId
  LEFT JOIN dbo.StudyStatus ss ON ss.StudyId = sc.StudyId AND ss.StatusId = sc.StatusId
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [dbo].[ViewFullCaseListStub] TO [public]
GO