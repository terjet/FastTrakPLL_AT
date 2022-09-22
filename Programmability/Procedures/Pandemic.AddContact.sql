SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[AddContact]( @ContactGuid uniqueidentifier, @ContextId INT, @IndexPersonId INT, @PersonDescription VARCHAR(MAX) ) AS
BEGIN
  INSERT INTO Pandemic.Contact( ContactGuid, ContextId, IndexPersonId, PersonDescription ) 
  VALUES ( @ContactGuid, @ContextId, @IndexPersonId, @PersonDescription );
END
GO