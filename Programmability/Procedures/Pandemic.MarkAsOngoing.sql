SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[MarkAsOngoing]( @ContactGuid uniqueidentifier ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE Pandemic.Contact SET StateId = 2 WHERE ContactGuid = @ContactGuid;
  EXEC Pandemic.GetContact @ContactGuid;
END;
GO