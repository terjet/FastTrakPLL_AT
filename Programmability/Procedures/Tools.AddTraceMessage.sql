SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[AddTraceMessage]( @Sender VARCHAR(64), @TrcLevel TINYINT, @Content VARCHAR(MAX) ) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @TraceEnabled BIT = 0;
  BEGIN TRY
    SELECT TOP 1 @TraceEnabled = s.BitValue
    FROM Config.Setting s
    WHERE s.Section = 'Trace' AND s.KeyName = 'Enabled' AND ( s.UserId = USER_ID() OR s.UserId IS NULL ) ORDER BY s.UserId DESC;
    IF @TraceEnabled = 1
      INSERT INTO Tools.TraceLog( Sender, TrcLevel, Content ) VALUES( @Sender, @TrcLevel, @Content );
  END TRY
  BEGIN CATCH
     PRINT CONCAT( 'Tools.AddTraceMessage failed to append to the trace log: ', ERROR_MESSAGE() );
  END CATCH;
END
GO