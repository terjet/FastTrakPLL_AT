SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[UpdateUserDetails] (@UserId INT, @CenterId INT, @ProfId INT, @HPRNo INT, @GSM VARCHAR(16)) AS
BEGIN
	IF @UserId IS NULL
		RAISERROR ('Brukeren er ikke spesifisert.', 16, 1);

	UPDATE dbo.UserList
	SET CenterId = @CenterId
	WHERE UserId = @UserId;

	-- Set ProfId in dbo.UserList, but also add/delete profession based roles.
	EXEC AdminTool.UpdateUserProfession	@UserId, @ProfId;

	DECLARE @PersonId INT;
	SELECT @PersonId = PersonId
	FROM dbo.UserList
	WHERE UserId = @UserId;

	IF @PersonId IS NOT NULL
	BEGIN
		UPDATE dbo.Person
		SET HPRNo = @HPRNo, GSM = @GSM
		WHERE PersonId = @PersonId;
	END;
END;
GO