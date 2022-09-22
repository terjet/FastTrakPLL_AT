SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[GetContact]( @ContactGuid uniqueidentifier ) AS
BEGIN
  SELECT * FROM Pandemic.AllContacts WHERE ContactGuid = @ContactGuid;
END
GO