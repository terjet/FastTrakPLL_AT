SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetStudyGroups] ( @StudyId INT, @UserId INT = NULL ) AS
BEGIN
  SET @UserId = ISNULL( @UserId, USER_ID() );
  IF dbo.IsRoleMember( 'SingleGroup', @UserId ) = 1
    SELECT sg.GroupId, sg.GroupName, sg.StudyGroupId
    FROM dbo.StudyGroup sg
    JOIN dbo.UserList ul ON ul.CenterId = sg.CenterId AND ul.UserId = @UserId
    JOIN AccessCtrl.UserGroupAccess uga ON ( uga.GroupId = sg.GroupId )
      AND ( uga.UserId = @UserId )
      AND ( uga.[StopAt] IS NULL OR uga.[StopAt] > GETDATE() )
      AND ( uga.RevokedBy IS NULL )
    WHERE sg.StudyId = @StudyId
    AND sg.DisabledAt IS NULL
    ORDER BY sg.GroupName;
  ELSE
    SELECT sg.GroupId, sg.GroupName, sg.StudyGroupId
    FROM dbo.StudyGroup sg 
      JOIN dbo.UserList ul ON ul.CenterId = sg.CenterId AND ul.UserId = @UserId
    WHERE sg.StudyId = @StudyId AND sg.DisabledAt IS NULL
    ORDER BY sg.GroupName;
END;
GO

DENY EXECUTE ON [dbo].[GetStudyGroups] TO [SingleGroup]
GO