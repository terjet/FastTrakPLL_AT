SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[UpdatePreliminaryIdentification]( 
  @ContactGuid uniqueidentifier, 
  @DOB DateTime, @GenderId INT, @FirstName VARCHAR(32), @LastName VARCHAR(32), 
  @PersonDescription VARCHAR(MAX) ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE Pandemic.Contact SET DOB = @DOB, GenderId = @GenderId, FirstName = @FirstName, LastName = @LastName, 
    PersonDescription = @PersonDescription 
  WHERE ContactGuid = @ContactGuid AND ContactPersonId IS NULL;
  IF @@ROWCOUNT = 0
    RAISERROR( 'Du kan ikke oppdatere navn på en person som allerede er fullt identifisert.', 16, 1 );
END
GO