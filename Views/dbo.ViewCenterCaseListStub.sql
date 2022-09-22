SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ViewCenterCaseListStub] AS
    SELECT p.PersonId, p.DOB, p.ReverseName AS FullName, p.NationalId, p.GenderId, sc.StudyId, sc.FinState, sg.GroupId, sg.GroupName
    FROM dbo.StudCase sc
    JOIN dbo.Person p ON p.PersonId = sc.PersonId
    JOIN 
      ( 
         SELECT StudyId, PersonId, ISNULL(GroupId,NewGroupId) AS LastGroupId
         FROM 
           (
             SELECT sc.StudyId, sc.PersonId, sc.GroupId, scl.NewGroupId, 
               ROW_NUMBER() OVER (PARTITION BY sc.StudyId, sc.PersonId ORDER BY scl.ChangedAt DESC, scl.StudCaseLogId DESC ) AS ReverseOrder
            FROM dbo.StudCase sc
            JOIN dbo.StudCaseLog scl ON scl.StudCaseId = sc.StudCaseId AND scl.NewGroupId IS NOT NULL
           ) a
          WHERE a.ReverseOrder = 1 
      ) lsg ON lsg.StudyId = sc.StudyId AND lsg.PersonId = sc.PersonId
    JOIN dbo.StudyGroup sg ON sg.StudyId = sc.StudyId AND sg.GroupId = lsg.LastGroupId
    JOIN dbo.UserList ul ON ul.CenterId = sg.CenterId AND ul.UserId = USER_ID()
    LEFT OUTER JOIN dbo.StudyUser su ON su.UserId = USER_ID() AND su.StudyId = sc.StudyId
    WHERE ( su.GroupId=sc.GroupId ) OR ( su.UserId IS NULL ) OR ( su.GroupId IS NULL ) OR ( su.ShowMyGroup = 0 )
GO