SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddPerson]( @DOB DateTime, @FstName VARCHAR(30), @MidName VARCHAR(30), @LstName VARCHAR(30), @GenderId INT, @NationalId VARCHAR(16) = NULL ) AS
BEGIN
  DECLARE @MatchCount INT;
  DECLARE @PersonId INT;
  SET NOCOUNT ON;
  SET @FstName = LTRIM(RTRIM(@FstName));
  SET @LstName = LTRIM(RTRIM(@LstName));
  SET @MidName = LTRIM(RTRIM(@MidName));
  IF DATALENGTH( @NationalId ) < 11 SET @NationalId = NULL;
  IF NOT @NationalId IS NULL SELECT @MatchCount = COUNT(*) FROM dbo.Person WHERE NationalId = @NationalId;
  IF @MatchCount = 1
    SELECT @PersonId = PersonId FROM dbo.Person WHERE NationalId=@NationalId
  ELSE IF @MatchCount > 1
    SET @PersonId = -@MatchCount
  ELSE BEGIN
    SELECT @MatchCount = COUNT(*) FROM dbo.Person WHERE DOB = @DOB AND FstName = @FstName AND LstName = @LstName AND GenderId = @GenderId;
    IF @MatchCount = 1
      SELECT @PersonId = PersonId FROM dbo.Person WHERE DOB = @DOB AND FstName = @FstName AND LstName = @LstName AND GenderId = @GenderId;
    ELSE IF @MatchCount > 1
      SET @PersonId = -@MatchCount
    ELSE BEGIN
      INSERT INTO dbo.Person ( DOB, FstName, MidName, LstName, GenderId, NationalId )
        VALUES( @DOB, @FstName, @MidName, @LstName, @GenderId, @NationalId );
      SET @PersonId = SCOPE_IDENTITY();
    END;
  END;
  SELECT @PersonId AS PersonId;
  RETURN ISNULL(@PersonId,-1);
END
GO