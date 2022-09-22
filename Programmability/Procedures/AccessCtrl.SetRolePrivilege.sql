SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AccessCtrl].[SetRolePrivilege]( @FunctionPointId VARCHAR(64), @RoleName SYSNAME, @AccessState INT) AS
BEGIN
  SET NOCOUNT ON;
  MERGE INTO AccessCtrl.FunctionPointRole trg
  USING (SELECT @FunctionPointId AS FunctionPointId, @RoleName AS RoleName) src
  ON (trg.FunctionPointId = src.FunctionPointId AND trg.RoleName = src.RoleName )
  WHEN NOT MATCHED THEN 
    INSERT VALUES ( @FunctionPointId, @RoleName, @AccessState )
  WHEN MATCHED THEN 
    UPDATE SET AccessStateId = @AccessState;
END
GO