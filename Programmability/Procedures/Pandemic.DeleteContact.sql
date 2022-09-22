SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[DeleteContact]( @ContactGuid uniqueidentifier ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE Pandemic.Contact SET DeletedAt = GETDATE(), DeletedBy = USER_ID(), ContactPersonId = NULL WHERE ContactGuid = @ContactGuid;
END;
GO