SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AccessCtrl].[AddFunctionPoint] (@FunctionPointId VARCHAR(64), @DefaultAccessState INT) AS
BEGIN
	DECLARE @HasRow INT = 0;
	SELECT TOP 1 @HasRow = 1
	FROM AccessCtrl.FunctionPoint fp
	WHERE FunctionPointId = @FunctionPointId;
	IF @HasRow = 1
		RAISERROR ('Funksjonspunkt allerede definert!', 16, 1)
	ELSE
	BEGIN
		SET @HasRow = 0;
		SELECT TOP 1 @HasRow = 1
		FROM AccessCtrl.MetaAccessState mas
		WHERE mas.AccessStateId = @DefaultAccessState;

		IF @HasRow = 0
			RAISERROR ('Ukjent status!', 16, 1)
		ELSE
			INSERT INTO AccessCtrl.FunctionPoint (FunctionPointId, DefaultAccessState)
				VALUES (@FunctionPointId, @DefaultAccessState);
	END
END
GO