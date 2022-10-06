SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[EnableFMForUser] @UserId INT AS
BEGIN
  DECLARE @UserName NVARCHAR(128)
  SELECT @UserName = USER_NAME(@UserId)
  EXEC dbo.AddRoleMember 'FMUser', @UserName;
END
GO

GRANT EXECUTE ON [AdminTool].[EnableFMForUser] TO [Support]
GO