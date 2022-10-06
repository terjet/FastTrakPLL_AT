SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Test].[AddTestAbelPerson]( @Dob DATE, @FstName VARCHAR(30), @MidName VARCHAR(30), @LstName VARCHAR(30), @GenderId INT, @NationalId  VARCHAR(16) ) AS
BEGIN
  SET NOCOUNT ON;
  SET @MidName = NULLIF(@MidName,'');
  EXEC dbo.AddPerson @DOB, @FstName, @MidName, @LstName, @GenderId, @NationalId;
  UPDATE dbo.Person SET TestCase = 1, FromTestAbel = 1 WHERE NationalId = @NationalId;
END
GO