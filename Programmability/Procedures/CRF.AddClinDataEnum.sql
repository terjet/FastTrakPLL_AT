SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[AddClinDataEnum] ( @TouchId INT, @ItemId INT, @EnumVal INT )
AS
BEGIN
  DECLARE @Locked INT;
  DECLARE @RowId INT;
  DECLARE @OldEnumVal INT;
  DECLARE @EventId INT;

  SELECT @EventId = EventId FROM dbo.ClinTouch WHERE TouchId=@TouchId;
  -- Get existing data
  SELECT @RowId = RowId, @Locked=Locked, @OldEnumVal=EnumVal
    FROM dbo.ClinDataPoint WHERE EventId=@EventId AND ItemId = @ItemId;
  -- Add if not found
  IF ( @RowId IS NULL )
    INSERT INTO dbo.ClinDataPoint ( TouchId, EventId, ItemId, EnumVal, Quantity ) VALUES ( @TouchId, @EventId, @ItemId, @EnumVal, @EnumVal )
  ELSE IF ( ISNULL( @OldEnumVal, -1 ) <> ISNULL( @EnumVal, -1 ) )
  BEGIN
    -- Need to change
    IF @Locked <> 0
    BEGIN
      RAISERROR( 'Could not save data.  This row is signed.', 16, 1 );
      RETURN -2;
    END;
    UPDATE dbo.ClinDataPoint SET TouchId = @TouchId, EnumVal = @EnumVal, Quantity = @EnumVal, ChangeCount = ChangeCount + 1, ObsDate=GETDATE() 
    WHERE RowId=@RowId;
  END
END
GO

GRANT EXECUTE ON [CRF].[AddClinDataEnum] TO [FastTrak]
GO