SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[UpdateDescription]( @ContactGuid uniqueidentifier, @PersonDescription VARCHAR(MAX) ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE Pandemic.Contact SET PersonDescription = @PersonDescription 
  WHERE ContactGuid = @ContactGuid; -- AND TIMESTAMP
END
GO