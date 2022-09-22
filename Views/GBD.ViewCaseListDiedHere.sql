SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [GBD].[ViewCaseListDiedHere] AS
SELECT PersonId,DOB,FullName,StudyId,GroupName,GenderId,NationalId,ChangedAt AS DeathRegisteredAt FROM 
  (
  SELECT p.PersonId, p.DOB, p.ReverseName AS FullName, sc.StudyId, sg.GroupName AS GroupName, p.GenderId, p.NationalId, scl.ChangedAt,
    RANK() OVER ( PARTITION BY p.PersonId ORDER BY scl.ChangedAt ASC ) AS OrderNo
    FROM dbo.StudCase sc
    JOIN dbo.StudCaseLog scl ON scl.StudCaseId = sc.StudCaseId AND scl.NewStatusId = 5 AND scl.OldStatusId <> 5 
    JOIN dbo.Person p ON p.PersonId = sc.PersonId  
    JOIN dbo.StudyGroup sg ON sg.StudyId = sc.StudyId AND sg.GroupId=scl.OldGroupId 
    LEFT OUTER JOIN dbo.StudyUser su ON su.UserId = USER_ID() AND su.StudyId=sc.StudyId
    WHERE ( su.GroupId=scl.OldGroupId ) OR ( su.UserId IS NULL ) OR ( su.GroupId IS NULL ) OR ( su.ShowMyGroup = 0 )
  ) deaths
WHERE OrderNo = 1
GO