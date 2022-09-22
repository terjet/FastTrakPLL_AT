SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[MarkAsCompleted]( @ContactGuid uniqueidentifier ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE Pandemic.Contact SET StateId = 3 WHERE ContactGuid = @ContactGuid;
  EXEC Pandemic.GetContact @ContactGuid;
END;
GO