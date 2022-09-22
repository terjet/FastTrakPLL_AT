SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateCAVE] (@PersonId INT, @CAVE VARCHAR(MAX)) AS
BEGIN
  UPDATE dbo.Person
  SET CAVE = @CAVE
  WHERE PersonId = @PersonId;
  INSERT INTO dbo.CaseLog (PersonId, LogType, LogText)
    VALUES (@PersonId, 'CAVE', 'CAVE redigert  av ' + USER_NAME());
END
GO