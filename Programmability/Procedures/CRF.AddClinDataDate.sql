SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[AddClinDataDate] ( @TouchId INT, @ItemId INT, @DTVal DateTime )
AS
BEGIN
  DECLARE @Locked INT;
  DECLARE @RowId INT;
  DECLARE @OldDTVal DateTime;
  DECLARE @EventId INT;
  SELECT @EventId = EventId FROM dbo.ClinTouch WHERE TouchId=@TouchId;
  -- Get existing data
  SELECT @RowId = RowId, @Locked=Locked, @OldDTVal=DTVal
    FROM dbo.ClinDataPoint WHERE EventId=@EventId AND ItemId = @ItemId;
  -- Add if not found
  IF ( @RowId IS NULL )
    INSERT INTO dbo.ClinDataPoint ( TouchId, EventId, ItemId, DTVal ) VALUES ( @TouchId, @EventId, @ItemId, @DTVal )
  ELSE IF ( @OldDTVal <> @DTVal ) OR ( @OldDTVal IS NULL AND NOT @DTVal IS NULL ) OR ( @DTVal IS NULL AND NOT @OldDTVal IS NULL )
  BEGIN
    -- Need to change
    IF @Locked <> 0
    BEGIN
      RAISERROR( 'Could not save data.  This row is signed.', 16, 1 );
      RETURN -2;
    END;
    -- Set new value
    UPDATE dbo.ClinDataPoint SET TouchId=@TouchId, DTVal=@DTVal, ChangeCount=ChangeCount + 1, ObsDate=GETDATE() 
    WHERE RowId=@RowId;
  END
END
GO