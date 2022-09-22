SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddUserCenterAccess]( @UserId INT, @CenterId INT, @FromDate DateTime, @ToDate DateTime, @Comment VARCHAR(MAX) ) AS
BEGIN
  INSERT INTO dbo.UserCenterAccess (UserId, CenterId, StartAt, StopAt, Comment)
    VALUES (@UserId, @CenterId, @FromDate, @ToDate, @Comment);
END
GO

GRANT EXECUTE ON [dbo].[AddUserCenterAccess] TO [superuser]
GO