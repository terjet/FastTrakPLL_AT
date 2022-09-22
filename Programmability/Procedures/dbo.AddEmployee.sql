SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddEmployee]( @EmployeeNumber INT, @UserName VARCHAR(32), @DOB DateTime, @LstName VARCHAR(32), @FstName VARCHAR(32), @GenderId INT, @HPRNo INT, @EmailAddress VARCHAR(64),@GSM VARCHAR(16) ) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @PersonId INT;
  DECLARE @Signature VARCHAR(6);
  -- Use EmployeeNumber as primary identification for employees.
  SELECT @PersonId = PersonId, @Signature = Signature FROM dbo.Person WHERE EmployeeNumber = @EmployeeNumber;
  -- Fallback to HPRNo
  IF @PersonId IS NULL
    SELECT @PersonId = PersonId, @Signature = Signature FROM dbo.Person WHERE HPRNo = @HPRNo;
  -- Fallback to DOB/Name combination.
  IF @PersonId IS NULL
    SELECT @PersonId = PersonId, @Signature = Signature FROM dbo.Person WHERE DOB = @DOB AND FstName = @FstName AND LstName = @LstName;
  IF NOT @PersonId IS NULL 
    PRINT CONCAT( ' -- UPDATING PersonId ', @PersonID,' (', @Signature,') FOR EmployeeNumber ', @EmployeeNumber, '.' )
  ELSE
  BEGIN
    INSERT INTO dbo.Person (DOB, FstName, LstName, GenderId )
	VALUES ( @DOB, @FstName, @LstName, @GenderId );
	SET @PersonId = SCOPE_IDENTITY();
	PRINT CONCAT( ' -- INSERTED PersonId ', @PersonId, ' FOR EmployeeNumber ', @EmployeeNumber );
   END;
   UPDATE dbo.Person SET UserName = @UserName, HPRNo = @HPRNo, EmailAddress = @EmailAddress, GSM = @GSM, EmployeeNumber = @EmployeeNumber WHERE PersonId = @PersonId;
END;
GO