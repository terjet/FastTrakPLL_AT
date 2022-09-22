SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[AddClinDataTextVal]( @TouchId INT, @ItemId INT, @TextVal VARCHAR(MAX) )
AS
BEGIN
  DECLARE @Locked INT;
  DECLARE @RowId INT;
  DECLARE @OldTextVal VARCHAR(MAX);
  DECLARE @EventId INT;

  SELECT @EventId = EventId FROM dbo.ClinTouch WHERE TouchId=@TouchId;
  -- Get existing data
  SELECT @RowId = RowId, @Locked=Locked, @OldTextVal=TextVal
    FROM dbo.ClinDataPoint WHERE EventId=@EventId AND ItemId = @ItemId;
  -- Add if not found
  IF ( @RowId IS NULL )
    INSERT INTO dbo.ClinDataPoint ( TouchId, EventId, ItemId, TextVal ) VALUES ( @TouchId, @EventId, @ItemId, @TextVal )
  ELSE IF ( ISNULL( @OldTextVal, '' ) <> ISNULL( @TextVal, '' ) )
  BEGIN
    -- Need to change
    IF @Locked <> 0
    BEGIN
      RAISERROR( 'Could not save data.  This row is signed.', 16, 1 );
      RETURN -2;
    END;
    UPDATE dbo.ClinDataPoint SET TouchId = @TouchId, TextVal = @TextVal, ChangeCount = ChangeCount + 1, ObsDate=GETDATE() 
    WHERE RowId=@RowId;
  END
END
GO

GRANT EXECUTE ON [CRF].[AddClinDataTextVal] TO [FastTrak]
GO