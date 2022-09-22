SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[AddClinDatapoint] ( 
  @TouchId INT, @EventId INT, @ItemId INT, @Quantity decimal(18,4),
  @DTVal DateTime, @EnumVal int, @TextVal VARCHAR(MAX), @Locked INT )
AS
BEGIN
  DECLARE @RowId INT;
  DECLARE @ChangeCount INT;
  DECLARE @OldLocked INT;  
  DECLARE @OldChangeCount INT;
  DECLARE @OldQuantity DECIMAL(18,4);
  DECLARE @OldEnumVal INT;
  DECLARE @OldTextVal VARCHAR(MAX);
  DECLARE @OldDTVal DateTime;    
  
  -- Find the row and load data
  SELECT 
    @RowId=RowId, @OldLocked=Locked, @OldChangeCount=ChangeCount, @OldQuantity=Quantity, 
    @OldEnumVal=EnumVal, @OldDTVal=DTVal, @OldTextVal=TextVal 
    FROM dbo.ClinDatapoint WHERE EventId=@EventId AND ItemId=@ItemId;
  
  IF @RowId IS NULL 
  BEGIN          
    -- Have to create it
    INSERT INTO dbo.ClinDatapoint (TouchId,ItemId,Quantity,DTVal,EnumVal,TextVal,EventId,Locked)
      VALUES (@TouchId,@ItemId,@Quantity,@DTVal,@EnumVal,@TextVal,@EventId,@Locked);
    SET @RowId = SCOPE_IDENTITY();
  END
  ELSE IF @OldLocked > 0
  BEGIN
    RAISERROR( 'Could not save data.  This row is already locked for updates.', 16, 1 );
    RETURN -2;
  END
  ELSE 
  BEGIN                   
    SET @ChangeCount = @OldChangeCount;
    -- Increase update counter if necessary
    IF ( @Quantity <> @OldQuantity ) OR ( @DTVal <> @OldDTVal ) OR ( @EnumVal <> @OldEnumVal ) OR ( @TextVal <> @OldTextVal )
      OR ( @Quantity IS NULL AND NOT @OldQuantity IS NULL ) OR ( @OldQuantity IS NULL AND NOT @Quantity IS NULL )
      OR ( @EnumVal IS NULL AND NOT @OldEnumVal IS NULL ) OR ( @OldEnumVal IS NULL AND NOT @EnumVal IS NULL )
      OR ( @DTVal IS NULL AND NOT @OldDTVal IS NULL ) OR ( @OldDTVal IS NULL AND NOT @DTVal IS NULL )
      OR ( @TextVal IS NULL AND NOT @OldTextVal IS NULL ) OR ( @OldTextVal IS NULL AND NOT @TextVal IS NULL )
        SET @ChangeCount = @ChangeCount + 1;
    IF ( @ChangeCount <> @OldChangeCount )
    BEGIN
      -- Update if changed, trigger will do the logging                                                           
      UPDATE dbo.ClinDatapoint SET 
        Quantity=@Quantity, DTVal=@DTVal, EnumVal=@EnumVal, TextVal=@TextVal,
        ObsDate=GetDate(), TouchId=@TouchId, ChangeCount=@ChangeCount
      WHERE RowId=@RowId;
    END; 
    IF ( @Locked <> @OldLocked ) UPDATE dbo.ClinDatapoint SET Locked=@Locked WHERE RowId=@RowId;
  END;
  SELECT RowId,Locked,ChangeCount FROM dbo.ClinDatapoint WHERE RowId=@RowId;
END
GO