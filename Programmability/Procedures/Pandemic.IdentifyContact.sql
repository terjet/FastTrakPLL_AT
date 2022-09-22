SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[IdentifyContact]( @ContactGuid uniqueidentifier, @PersonId INT ) AS
BEGIN
  -- Creates a link between the contact and a fully identified person already in the database
  BEGIN TRY
    UPDATE Pandemic.Contact SET ContactPersonId = @PersonId WHERE ContactGuid = @ContactGuid;
	EXEC Pandemic.GetContact @ContactGuid;
  END TRY
  BEGIN CATCH
    -- Todo. Check for error type
    RAISERROR( 'Denne personen kunne ikke kobles mot smittekontakten, vanligvis på grunn av det finnes en annen kontakt som er koblet mot personen.', 16, 1 );
  END CATCH;
END
GO