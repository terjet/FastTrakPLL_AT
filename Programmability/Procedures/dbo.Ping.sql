SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Ping]( @SessId INT ) AS
BEGIN
  SET NOCOUNT ON;
  -- If session is closed then error
  IF EXISTS (SELECT 1
    FROM dbo.UserLog
    WHERE SessId = @sessId AND ClosedAt IS NOT NULL)
  BEGIN
     SELECT CAST('false' AS BIT) AS Result, 'Your session has been closed! Please restart the application.' AS Msg;
     RETURN -1;
  END;

  UPDATE dbo.UserLog
  SET LastPingTime = GETDATE()
  WHERE SessId = @sessId;

  -- If no rows where found to update then error
  IF @@ROWCOUNT = 0
  BEGIN
    SELECT CAST('false' AS BIT) AS Result, 'No session registered! Please restart the application.' AS Msg;
    RETURN -1;
  END;
  SELECT CAST('true' AS BIT) AS Result, 'Your FastTrak session is still valid.' AS Msg;
END;
GO