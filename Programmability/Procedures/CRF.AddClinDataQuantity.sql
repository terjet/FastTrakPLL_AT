SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[AddClinDataQuantity] ( @TouchId INT, @ItemId INT, @Quantity FLOAT )
AS
BEGIN
  DECLARE @Locked INT;
  DECLARE @RowId INT;
  DECLARE @OldQuantity FLOAT;
  DECLARE @EventId INT;
  SELECT @EventId = EventId FROM dbo.ClinTouch WHERE TouchId=@TouchId;
  -- Get existing data
  SELECT @RowId = RowId, @Locked=Locked, @OldQuantity=Quantity
    FROM dbo.ClinDataPoint WHERE EventId=@EventId AND ItemId = @ItemId;
  -- Add if not found
  IF ( @RowId IS NULL )
    INSERT INTO dbo.ClinDataPoint ( TouchId, EventId, ItemId, Quantity ) VALUES ( @TouchId, @EventId, @ItemId, @Quantity )
  ELSE IF ( @OldQuantity <> @Quantity ) OR ( @OldQuantity IS NULL AND NOT @Quantity IS NULL ) OR ( @Quantity IS NULL AND NOT @OldQuantity IS NULL )
  BEGIN
    -- Need to change
    IF @Locked <> 0
    BEGIN
      RAISERROR( 'Could not save data.  This row is signed.', 16, 1 );
      RETURN -2;
    END;
    -- Set new value
    UPDATE dbo.ClinDataPoint SET TouchId=@TouchId, Quantity=@Quantity, ChangeCount=ChangeCount + 1, ObsDate=GETDATE() 
    WHERE RowId=@RowId;
  END
END
GO

GRANT EXECUTE ON [CRF].[AddClinDataQuantity] TO [FastTrak]
GO