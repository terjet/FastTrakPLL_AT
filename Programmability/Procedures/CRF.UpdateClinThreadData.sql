SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[UpdateClinThreadData] ( @RowId INT, @TouchId INT, @Quantity decimal(18,4),@DTVal DateTime, @EnumVal int, @TextVal VARCHAR(MAX) )
AS
BEGIN
  DECLARE @Locked INT;
  DECLARE @ItemId INT;
  SELECT @Locked = Locked, @ItemId = ItemId FROM ClinThreadData WHERE RowId=@RowId;
  IF @Locked = 1
  BEGIN
    RAISERROR( 'Threaded datapoint with RowId=%d and ItemId=%d is locked.',16,1,@RowId,@ItemId ) 
    RETURN -1;
  END
  UPDATE ClinThreadData SET
    Quantity=@Quantity,DTVal=@DTVal,EnumVal=@EnumVal,TextVal=@TextVal,
    ObsDate=GetDate(),TouchId=@TouchId,ChangeCount=ChangeCount+1
  WHERE ( RowId=@RowId ) AND ( Locked = 0 )
  AND
    ( 
      ( ISNULL(Quantity,-1) <> ISNULL(@Quantity,-1) ) OR 
      ( ISNULL(DTVal,'1899-12-30') <> ISNULL(@DTVal,'1899-12-30' ) ) OR 
      ( ISNULL(EnumVal,-1) <> ISNULL(@EnumVal,-1 ) ) OR 
      ( ISNULL(TextVal,'') <> ISNULL(@TextVal,'') )
    )
END
GO

GRANT EXECUTE ON [CRF].[UpdateClinThreadData] TO [FastTrak]
GO