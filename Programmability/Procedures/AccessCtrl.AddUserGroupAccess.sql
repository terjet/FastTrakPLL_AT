SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AccessCtrl].[AddUserGroupAccess]( @UserId INT, @GroupId INT, @FromDate DATETIME, @ToDate DATETIME = NULL, @Comment VARCHAR(MAX) = NULL ) AS
BEGIN
  INSERT INTO AccessCtrl.UserGroupAccess ( UserId, GroupId, StartAt, [StopAt], Comment ) VALUES ( @UserId, @GroupId, @FromDate, @ToDate, @Comment );
END;
GO