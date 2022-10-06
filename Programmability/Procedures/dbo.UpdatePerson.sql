SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdatePerson]( @PersonId INT, @DOB DateTime, @GenderId TinyInt, @FstName VARCHAR(30), @LstName VARCHAR(30), @NationalId VARCHAR(16) ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.Person SET DOB = @DOB, GenderId = @GenderId, FstName = RTRIM(@FstName), LstName = RTRIM(@LstName), NationalId = NULLIF(@NationalId,'')
  WHERE PersonId = @PersonId 
    AND ( DOB <> @DOB OR GenderId <> @GenderId OR LstName <> RTRIM( @LstName ) OR FstName <> RTRIM( @FstName ) OR ISNULL( NationalId, '' ) <> ISNULL( @NationalId, '' )  );
END
GO

GRANT EXECUTE ON [dbo].[UpdatePerson] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdatePerson] TO [ReadOnly]
GO