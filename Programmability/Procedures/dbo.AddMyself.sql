SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddMyself](
  @DOB DateTime,
  @GenderId INT,
  @FstName VARCHAR(30),
  @MidName VARCHAR(30),
  @LstName VARCHAR(30),
  @NationalId VARCHAR(16))
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @PersonId INT;
  IF DATALENGTH( @NationalId )<11 SET @NationalId = NULL;
  -- Search for existing person
  IF NOT @NationalId IS NULL
    SELECT @PersonId = PersonId FROM dbo.Person
      WHERE NationalId = @NationalId;
  IF @PersonId IS NULL
    SELECT @PersonId = PersonId FROM dbo.Person
      WHERE ( DOB = @DOB ) AND ( FstName = @FstName )
      AND ( LstName = @LstName ) AND ( GenderId = @GenderId);
  IF @PersonId IS NULL
  BEGIN
    INSERT INTO dbo.Person ( DOB, FstName, MidName, LstName, GenderId, NationalId )
      VALUES( @Dob, @FstName, @MidName, @LstName, @GenderId, @NationalId ) 
    SET @PersonId=SCOPE_IDENTITY();
  END
  ELSE
    UPDATE dbo.Person SET
      DOB = @DOB, FstName = @FstName, LstName = @LstName, MidName = @MidName,
      GenderId = @GenderId, NationalId = @NationalId
    WHERE PersonId = @PersonId;
  -- Make sure UserList is updated */
  IF ( SELECT COUNT(*) FROM UserList WHERE UserId=USER_ID() ) = 0
    INSERT INTO dbo.UserList (UserId,PersonId) VALUES(USER_ID(),@PersonId )
  ELSE
    UPDATE dbo.UserList SET PersonId = @PersonId WHERE UserId = USER_ID() AND PersonId IS NULL
END
GO