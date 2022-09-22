SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetUserDetails]( @UserNameOrId NVARCHAR(128), @StudyId INT = NULL ) AS
BEGIN
  -- Get UserId if UserNameOrId is a username.
  DECLARE @UserId INT;
  IF ISNUMERIC( @UserNameOrId ) = 1 
    SET @UserId = CONVERT( INT, @UserNameOrId )
  ELSE 
    SET @UserId = USER_ID(@UserNameOrId);
  SELECT u.UserId, su.name AS UserName, su.hasdbaccess, 
     u.UserName AS UserListUserName, 
     p.*, mp.*, c.*, @StudyId AS StudyId, sg.GroupId, sg.GroupName
    FROM dbo.UserList u
      LEFT JOIN sys.sysusers su ON su.uid=u.UserId
      LEFT JOIN dbo.Person p ON p.PersonId=u.PersonId
      LEFT JOIN dbo.MetaProfession mp ON mp.ProfId=u.ProfId
      LEFT JOIN dbo.StudyCenter c ON c.CenterId=u.CenterId
      LEFT JOIN dbo.StudyUser stu ON stu.StudyId=@StudyId AND stu.UserId=su.uid
      LEFT JOIN dbo.StudyGroup sg ON sg.GroupId=stu.GroupId AND sg.StudyId=stu.StudyId
    WHERE u.UserId = @UserId;
END
GO