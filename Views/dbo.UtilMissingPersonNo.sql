SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[UtilMissingPersonNo] AS
  SELECT p.PersonId,p.FullName,sg.GroupName,c.CenterName FROM Person p
    JOIN StudCase sc ON sc.PersonId=p.PersonId
    LEFT OUTER JOIN StudyGroup sg ON sg.GroupId=sc.GroupId AND sg.StudyId=sc.StudyId
    LEFT OUTER JOIN StudyStatus ss ON ss.StatusId=sc.StatusId AND ss.StudyId=sc.StudyId
    LEFT OUTER JOIN StudyCenter c ON c.CenterId=sg.CenterId
  WHERE ( p.NationalId IS NULL ) and sg.GroupName <> 'Testpasienter' AND ss.StatusActive=1
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [dbo].[UtilMissingPersonNo] TO [public]
GO