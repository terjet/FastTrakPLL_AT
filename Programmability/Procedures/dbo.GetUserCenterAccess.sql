SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetUserCenterAccess]( @UserId INT = NULL, @Historic BIT = 0 ) AS
BEGIN
       IF (@UserId IS NULL)
             SELECT        dbo.UserCenterAccess.CenterAccessId, granted.UserName AS GrantedBy, revoked.UserName AS RevokedBy, dbo.UserCenterAccess.StartAt, dbo.UserCenterAccess.StopAt, dbo.StudyCenter.CenterId, dbo.StudyCenter.CenterName, dbo.UserCenterAccess.Comment
             FROM            dbo.UserCenterAccess INNER JOIN
                                            dbo.StudyCenter ON dbo.UserCenterAccess.CenterId = dbo.StudyCenter.CenterId INNER JOIN
                                                 dbo.UserList AS granted ON dbo.UserCenterAccess.GrantedBy = granted.UserId LEFT JOIN
                                                      dbo.UserList AS revoked ON dbo.UserCenterAccess.RevokedBy = revoked.UserId
             WHERE dbo.UserCenterAccess.StopAt > GetDate() OR @Historic = 1
       ELSE
             SELECT        dbo.UserCenterAccess.CenterAccessId, granted.UserName AS GrantedBy, revoked.UserName AS RevokedBy, dbo.UserCenterAccess.StartAt, dbo.UserCenterAccess.StopAt, dbo.StudyCenter.CenterId, dbo.StudyCenter.CenterName, dbo.UserCenterAccess.Comment
             FROM            dbo.UserCenterAccess INNER JOIN
                                            dbo.StudyCenter ON dbo.UserCenterAccess.CenterId = dbo.StudyCenter.CenterId INNER JOIN
                                                 dbo.UserList AS granted ON dbo.UserCenterAccess.GrantedBy = granted.UserId LEFT JOIN
                                                      dbo.UserList AS revoked ON dbo.UserCenterAccess.RevokedBy = revoked.UserId
             WHERE dbo.UserCenterAccess.UserId = @UserId AND (dbo.UserCenterAccess.StopAt > GetDate() OR @Historic = 1)
END
GO

GRANT EXECUTE ON [dbo].[GetUserCenterAccess] TO [superuser]
GO