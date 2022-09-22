SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AccessCtrl].[GetUserGroupAccess]( @StudyId INT, @UserId INT, @Historic BIT = 0 ) AS
BEGIN
  SELECT
    uga.UserGroupAccessId,
    uga.GroupId,
    uga.Comment,
    uga.RevokedAt,
    uga.StartAt,
    uga.[StopAt],
    uga.UserId,
    sg.GroupName,
    ul1.UserName AS GrantedBy,
    ul2.UserName AS RevokedBy
  FROM AccessCtrl.UserGroupAccess uga
  JOIN dbo.UserList ul ON ul.UserId = uga.UserId
  JOIN dbo.StudyGroup sg ON sg.GroupId = uga.GroupId AND ul.CenterId = sg.CenterId
  JOIN dbo.UserList ul1 ON ul1.UserId = uga.GrantedBy
  LEFT JOIN dbo.UserList ul2 ON ul2.UserId = uga.RevokedBy
  WHERE uga.UserId = @UserId
  AND sg.StudyId = @StudyId
  AND ( ( uga.RevokedBy IS NULL AND ( uga.[StopAt] > GETDATE() OR uga.[StopAt] IS NULL ) ) OR @Historic = 1)
END;
GO