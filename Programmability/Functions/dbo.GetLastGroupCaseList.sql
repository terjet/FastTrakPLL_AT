SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastGroupCaseList] (@StudyId INT)
RETURNS @CenterCaseList TABLE (
  PersonId INT NOT NULL,
  DOB DATETIME NOT NULL,
  GenderId INT NOT NULL,
  FullName VARCHAR(93) NOT NULL,
  StudyId INT NOT NULL,
  GroupName VARCHAR(24),
  FinState INT
) AS
BEGIN
  INSERT INTO @CenterCaseList (PersonId, DOB, FullName, StudyId, GroupName, GenderId, FinState)
    SELECT v.PersonId, p.DOB, p.ReverseName AS FullName, v.StudyId, sg.GroupName, p.GenderId, v.FinState
    FROM dbo.StudCase v
    JOIN dbo.Person p ON p.PersonId = v.PersonId
    JOIN (SELECT PersonId, NewGroupId
      FROM (SELECT sc.PersonId, scl.NewGroupId, RANK() OVER (PARTITION BY sc.PersonId ORDER BY scl.ChangedAt DESC) AS OrderNo
        FROM dbo.StudCase sc
        JOIN dbo.StudCaseLog scl
          ON scl.StudCaseId = sc.StudCaseId
        WHERE sc.StudyId = @StudyId
        AND scl.NewGroupId IS NOT NULL) a
      WHERE a.OrderNo = 1) lsg ON lsg.PersonId = v.PersonId
    JOIN dbo.StudyGroup sg ON sg.StudyId = v.StudyId AND sg.GroupId = ISNULL(v.GroupId, lsg.NewGroupId)
    JOIN dbo.UserList ul ON ul.CenterId = sg.CenterId AND ul.UserId = USER_ID();
  RETURN;
END;
GO