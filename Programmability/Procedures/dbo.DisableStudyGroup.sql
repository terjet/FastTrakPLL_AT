SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DisableStudyGroup]( @StudyGroupId INT ) AS
BEGIN
  DECLARE @GroupMemberCount INTEGER;
  SELECT @GroupMemberCount = COUNT(sc.PersonId)
  FROM dbo.StudCase sc
  JOIN dbo.StudyGroup sg ON sg.StudyId = sc.StudyId AND sg.GroupId = sc.GroupId
  JOIN dbo.Person p ON p.PersonId = sc.PersonId AND p.TestCase = 0
  WHERE sg.StudyGroupId = @StudyGroupId;
  IF @GroupMemberCount > 0
    RAISERROR ('This group has %d people in it and can not be deactivated.', 16, 1, @GroupMemberCount)
  ELSE
    UPDATE dbo.StudyGroup SET GroupActive = 0, DisabledAt = GETDATE(), DisabledBy = USER_ID()
    WHERE StudyGroupId = @StudyGroupId;
END
GO

GRANT EXECUTE ON [dbo].[DisableStudyGroup] TO [superuser]
GO