SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CloseSession] (@SessId INT, @Updates INT, @Inserts INT) AS
BEGIN

  SET NOCOUNT ON;

  -- Close this session

  UPDATE dbo.UserLog
    SET ClosedAt = GETDATE(), Updates = @Updates, Inserts = @Inserts, ClosedBy = USER_ID(), DirtyClose = 0
  WHERE SessId = @SessId  AND ClosedAt IS NULL AND UserId = USER_ID();

  -- Close stale sessions (e.g. more than 3 days since creation or last ping).

  UPDATE dbo.UserLog
    SET ClosedAt = GETDATE(), ClosedBy = USER_ID(), DirtyClose = 1
  WHERE ( ClosedAt IS NULL ) AND ( UserId = USER_ID() ) AND ( ISNULL( LastPingTime, CompTime ) < GETDATE() - 3 );

  -- Look for and run protocol-specific cleanup routines

  DECLARE @ProcName VARCHAR(32);
  SELECT @ProcName = CONCAT( s.StudyName COLLATE SQL_Latin1_General_CP1_CI_AS, '.', r.ROUTINE_NAME COLLATE SQL_Latin1_General_CP1_CI_AS )
  FROM dbo.UserLog ul
    JOIN dbo.Study s ON s.StudyId = ul.StudyId 
    JOIN INFORMATION_SCHEMA.ROUTINES r 
      ON r.SPECIFIC_SCHEMA COLLATE SQL_Latin1_General_CP1_CI_AS = s.StudName COLLATE SQL_Latin1_General_CP1_CI_AS AND r.ROUTINE_NAME = 'CloseSession'
  WHERE ul.SessId = @SessId;

  IF NOT @ProcName IS NULL EXECUTE( @ProcName +  ' ' + @SessId );

END
GO

GRANT EXECUTE ON [dbo].[CloseSession] TO [DataImport]
GO

GRANT EXECUTE ON [dbo].[CloseSession] TO [FastTrak]
GO