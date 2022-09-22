SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdatePersonTestCase] (@PersonId INT, @TestCase BIT) AS
BEGIN
	UPDATE dbo.Person
	SET TestCase = @TestCase
	WHERE PersonId = @PersonId;
END
GO

GRANT EXECUTE ON [dbo].[UpdatePersonTestCase] TO [superuser]
GO