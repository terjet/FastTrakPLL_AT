SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[AddReverseContact]( @ContextId INT, @IndexPersonId INT, @ContactPersonId INT ) AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    INSERT INTO Pandemic.Contact( ContextId, ContactGuid, IndexPersonId, ContactPersonId  )
    SELECT ContextId, NEWID(), ContactPersonId, IndexPersonId 
      FROM Pandemic.Contact 
	  WHERE ContextId = @ContextId AND ContactPersonId = @ContactPersonId AND IndexPersonId = @IndexPersonId;
  END TRY
  BEGIN CATCH
    RAISERROR( 'Denne koblingen eksisterer allerede, kan ikke legges til på nytt.', 16, 1 );
  END CATCH;
END
GO