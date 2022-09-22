SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AccessCtrl].[SetProfessionPrivilege] (@FunctionPointId VARCHAR(64), @ProfType VARCHAR(3), @AccessState INT) AS
BEGIN

    /*	Set a privilege for a profession. FunctionPointId, ProfType and AccessState must be valid (i.e. exist). 
	    If FunctionPoint/Profession exists it is updated with the given value */
	DECLARE @HasRow INT = 0;

	/* Check if functionpoint exists */
	SELECT TOP 1 @HasRow = 1
	FROM AccessCtrl.FunctionPoint fp
	WHERE FunctionPointId = @FunctionPointId;
	IF @HasRow = 0
		RAISERROR ('Ukjent funksjonspunkt!', 16, 1)
	ELSE
	BEGIN
		/* Check if profession exists */
		SET @HasRow = 0;
		SELECT TOP 1 @HasRow = 1
		FROM dbo.MetaProfession mp
		WHERE mp.ProfType = @ProfType;

		IF @HasRow = 0
			RAISERROR ('Ukjent yrke!', 16, 1)
		ELSE
		BEGIN
			/* Check if access-state exists */
			SET @HasRow = 0;
			SELECT TOP 1 @HasRow = 1
			FROM AccessCtrl.MetaAccessState mas
			WHERE mas.AccessStateId = @AccessState;

			IF @HasRow = 0
				RAISERROR ('Ukjent status!', 16, 1)
			ELSE
			BEGIN
				/* Insert if new profession for function, otherwise update */
				MERGE
				INTO AccessCtrl.FunctionPointProfession a
				USING (SELECT @FunctionPointId AS FunctionPointId, @ProfType AS ProfType) b
				ON (a.FunctionPointId = b.FunctionPointId
					AND a.ProfType = b.ProfType)
				WHEN NOT MATCHED
					THEN INSERT
							VALUES (@FunctionPointId, @ProfType, @AccessState)
				WHEN MATCHED
					THEN UPDATE
						SET AccessStateId = @AccessState;
			END
		END
	END
END
GO