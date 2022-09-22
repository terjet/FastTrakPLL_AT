SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[TraceOff]( @DeleteExisting BIT = 0 ) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @UserId INT;
  SELECT @UserId = USER_ID();
  EXEC Config.AddBitSetting 'Trace', 'Enabled', 0, @UserId;
  IF @DeleteExisting = 1 DELETE FROM Tools.TraceLog WHERE CreatedBy = USER_ID();
END
GO