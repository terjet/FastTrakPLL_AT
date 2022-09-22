SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[UpdateTrackingUser]( @ContactGuid uniqueidentifier, @UserId INT ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE Pandemic.Contact SET CaseTrackedBy = @UserId WHERE ContactGuid = @ContactGuid;
  EXEC Pandemic.GetContact @ContactGuid;
END;
GO