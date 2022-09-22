SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[AddPersonToUser] (@UserId INT, @DOB DATETIME, @FstName VARCHAR(30), @MidName VARCHAR(30), @LstName VARCHAR(30), @GenderId INT, @NationalId VARCHAR(16)) AS
BEGIN
	DECLARE @PersonId INT;
	DECLARE @AddPersonTable TABLE (
		PersonId INT
	);
	INSERT INTO @AddPersonTable
	EXEC dbo.AddPerson @DOB = @DOB, @FstName = @FstName, @MidName = @MidName, @LstName = @LstName, @GenderId = @GenderId, @NationalId = @NationalId

	SELECT @PersonId = PersonId
	FROM @AddPersonTable;

	IF (@PersonId > 0)
	BEGIN
		EXEC dbo.UpdateUserPerson @UserId = @UserId, @PersonId = @PersonId;
	END;
END;
GO