SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[GetContacts]( @ContextId INT, @IndexPersonId INT ) AS
BEGIN
  SELECT * FROM Pandemic.AllContacts WHERE ContextId = @ContextId AND IndexPersonId = @IndexPersonId;
END;
GO