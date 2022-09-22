SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetStudyUser]( @StudyId INT, @UserId INT ) AS
BEGIN
  SELECT 
    @StudyId AS StudyId, @UserId AS UserId, u.UserName, 
    su.hasdbaccess, 
    p.*, mp.*, c.*, 
    sg.GroupId, sg.GroupName
  FROM dbo.UserList u
    LEFT JOIN sys.sysusers su ON su.uid = u.UserId
    LEFT JOIN dbo.Person p ON p.PersonId = u.PersonId
    LEFT JOIN dbo.MetaProfession mp ON mp.ProfId = u.ProfId
    LEFT JOIN dbo.StudyCenter c ON c.CenterId = u.CenterId
    LEFT JOIN dbo.StudyUser stu ON stu.StudyId = @StudyId AND stu.UserId = su.uid
    LEFT JOIN dbo.StudyGroup sg ON sg.GroupId=stu.GroupId AND sg.StudyId = stu.StudyId
  WHERE u.UserId = @UserId 
END
GO

GRANT EXECUTE ON [dbo].[GetStudyUser] TO [superuser]
GO