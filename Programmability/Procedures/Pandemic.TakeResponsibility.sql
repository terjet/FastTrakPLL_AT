SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[TakeResponsibility]( @ContactGuid uniqueidentifier ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE Pandemic.Contact SET CaseTrackedBy = USER_ID() WHERE ContactGuid = @ContactGuid;
  EXEC Pandemic.GetContact @ContactGuid;
END;
GO