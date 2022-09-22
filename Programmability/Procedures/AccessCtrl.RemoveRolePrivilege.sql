SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AccessCtrl].[RemoveRolePrivilege] (@FunctionPointId VARCHAR(64), @RoleName SYSNAME) AS
BEGIN
	DELETE FROM AccessCtrl.FunctionPointRole
	WHERE FunctionPointId = @FunctionPointId
		AND RoleName = @RoleName;
END
GO