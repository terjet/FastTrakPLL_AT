SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AccessCtrl].[RemoveProfessionPrivilege] (@FunctionPointId VARCHAR(64), @ProfType VARCHAR(3)) AS
BEGIN
	DELETE FROM AccessCtrl.FunctionPointProfession
	WHERE FunctionPointId = @FunctionPointId
		AND ProfType = @ProfType;
END
GO