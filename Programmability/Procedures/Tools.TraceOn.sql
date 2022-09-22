SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[TraceOn] AS
BEGIN
  DECLARE @UserId INT;
  SELECT @UserId = USER_ID();
  EXEC Config.AddBitSetting 'Trace', 'Enabled', 1, @UserId;
END
GO