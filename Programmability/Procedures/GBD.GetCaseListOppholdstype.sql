SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListOppholdstype]( @StudyId INT ) AS
BEGIN
  SELECT p.PersonId,p.DOB,p.ReverseName as FullName,sg.GroupName,ss.StatusText as InfoText, p.BestId
  FROM Person p
  JOIN StudCase sc ON sc.PersonId=p.PersonId
  JOIN StudyStatus ss ON ss.StudyId=sc.StudyId AND ss.StatusId=sc.StatusId AND ss.StatusActive=1
  JOIN StudyGroup sg ON sg.StudyId=sc.StudyId AND sg.GroupId=sc.GroupId AND sg.GroupActive=1
  JOIN UserList ul ON ul.UserId=USER_ID() AND ul.CenterId=sg.CenterId
  WHERE sc.StudyId=@StudyId
  ORDER BY p.ReverseName
END
GO