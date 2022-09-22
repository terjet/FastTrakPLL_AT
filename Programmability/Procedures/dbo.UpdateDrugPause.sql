SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateDrugPause]( @TreatId INTEGER, @PauseStatus INTEGER, @PauseTime DateTime = NULL, @PauseReason VARCHAR(64) = NULL, @SaveThisReason INTEGER = 1, @PauseAuthorizedByName VARCHAR(30) = NULL ) AS
BEGIN

  SET NOCOUNT ON;

  DECLARE @ATC VARCHAR(7);
  DECLARE @NewId INTEGER;
  DECLARE @ErrMsg VARCHAR(512);

  IF @PauseTime IS NULL SET @PauseTime = GETDATE();
  UPDATE dbo.DrugTreatment SET PauseStatus = @PauseStatus
  WHERE TreatId = @TreatId
    AND (StopAt IS NULL OR StopAt > @PauseTime )
    AND (( PauseStatus <> @PauseStatus ) OR ( PauseStatus IS NULL));
  IF @@ROWCOUNT <> 1 
  BEGIN
    RAISERROR( 'Pausetilstand kunne ikke oppdateres for medikamentet.', 16, 1 );
    RETURN -2; 
  END;

  -- Add new entry to DrugPause table
  IF @PauseStatus = 1 
  BEGIN
    INSERT INTO dbo.DrugPause (TreatId, PausedAt, PauseReason, PauseAuthorizedByName) VALUES (@TreatId, @PauseTime, @PauseReason, @PauseAuthorizedByName);
  END
  ELSE IF @PauseStatus = 0 
  BEGIN
    UPDATE dbo.DrugPause SET RestartAt = GETDATE(), RestartBy = USER_ID()
      WHERE TreatId = @TreatId AND RestartAt IS NULL;
    IF @@ROWCOUNT <> 1
    BEGIN
      RAISERROR( 'Ingen aktiv pause ble funnet for medikamentet.', 16, 1 );
      RETURN -3;
    END;
  END
  ELSE
  BEGIN 
    RAISERROR( 'Ugyldig pausetilstand.', 16, 1 );
    RETURN -6; 
  END;
  IF ( ISNULL( @PauseReason, '' ) <> '' AND @SaveThisReason = 1 )
  BEGIN
    SELECT @ATC = ATC FROM dbo.DrugTreatment WHERE TreatId = @TreatId;
    IF DATALENGTH( @ATC ) > 4 EXEC dbo.AddDrugReason @ATC, 3, @PauseReason;
  END;
END;
GO