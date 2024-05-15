SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[StudyCaseGroupStatusHistory]
AS 
  SELECT sc.StudyId,s.StudyName,sc.PersonId,sg.CenterId,c.CenterName,scl.NewGroupId as GroupId,sg.GroupName,sg.GroupActive,scl.NewStatusId as StatusId,ss.StatusText,ss.StatusActive,scl.ChangedAt 
  FROM dbo.StudCaseLog scl 
  JOIN dbo.StudCase sc ON sc.StudCaseId = scl.StudCaseId
  JOIN dbo.Study s ON s.StudyId=sc.StudyId  
  LEFT OUTER JOIN dbo.StudyGroup sg ON sg.StudyId=sc.StudyId AND sg.GroupId=scl.NewGroupId
  LEFT OUTER JOIN dbo.StudyCenter c ON c.CenterId=sg.CenterId
  LEFT OUTER JOIN dbo.StudyStatus ss ON ss.StudyId=sc.StudyId AND ss.StatusId=scl.NewStatusId
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [dbo].[StudyCaseGroupStatusHistory] TO [public]
GO