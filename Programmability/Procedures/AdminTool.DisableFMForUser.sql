SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[DisableFMForUser](  @UserId INT ) AS
BEGIN
  DECLARE @UserName SYSNAME;
  SELECT @UserName = USER_NAME(@UserId);
  EXEC dbo.DropRoleMember 'FMUser', @UserName;
END
GO

GRANT EXECUTE ON [AdminTool].[DisableFMForUser] TO [Support]
GO