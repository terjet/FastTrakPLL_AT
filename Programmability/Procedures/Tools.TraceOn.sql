SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[TraceOn]( @UserId INT ) AS
BEGIN
  SET NOCOUNT ON;
  SELECT @UserId = COALESCE( @UserId, USER_ID() );
  EXEC Config.AddBitSetting 'Trace', 'Enabled', 1, @UserId;
END
GO