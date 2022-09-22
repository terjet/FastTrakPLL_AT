SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddClinData] ( @TouchId INT, @VarName varchar(24), @Quantity decimal(18,4),
  @DTVal DateTime,@EnumVal int, @TextVal VARCHAR(MAX) )
AS
BEGIN
  DECLARE @OldTouchId INT;
  DECLARE @EventId INT;      
  DECLARE @ItemId INT;    
  DECLARE @RowId INT;
  DECLARE @Locked INT;  
  DECLARE @CmpResult INT;
  DECLARE @ChangeCount INT;
  DECLARE @WhatHappened VARCHAR(64);
         
  /* Find ItemId and EventId */
  
  SELECT @EventId = EventId FROM dbo.ClinTouch WHERE TouchId=@TouchId;
  SELECT @ItemId = ItemId FROM dbo.MetaItem WHERE VarName=@VarName;
                       
  /* Find touch id for existing data */
  
  SELECT @OldTouchId=TouchId,@RowId=RowId,@Locked=Locked,@ChangeCount=ChangeCount
    FROM dbo.ClinDatapoint WHERE EventId=@EventId AND ItemId=@ItemId;

  IF @RowId IS NULL 
  BEGIN
    /* Data does not exist, must create it */
    INSERT INTO dbo.ClinDatapoint (TouchId,ItemId,Quantity,DTVal,EnumVal,TextVal,EventId)
      VALUES (@TouchId,@ItemId,@Quantity,@DTVal,@EnumVal,@TextVal,@EventId)
    SET @RowId = SCOPE_IDENTITY();
    SET @WhatHappened='Data inserted';
  END
  ELSE IF @Locked <> 0
  BEGIN
    RAISERROR( 'Could not save data.  This row is signed.', 16, 1 );
    RETURN -2;
  END
  ELSE 
  BEGIN                                                                
    SET @CmpResult = dbo.SameData( @RowId,@Quantity,@DTVal,@EnumVal,@TextVal );
    IF @CmpResult=-1 
    BEGIN   
      /* The old data was empty, do not log any changes */
      UPDATE dbo.ClinDatapoint SET
        Quantity=@Quantity,DTVal=@DTVal,EnumVal=@EnumVal,TextVal=@TextVal,
        ObsDate=GetDate(),TouchId=@TouchId
      WHERE RowId=@RowId;
      SET @WhatHappened = 'Old data was empty';
    END 
    ELSE IF @CmpResult = 0 
    BEGIN   
      /* Old data was different, update log if different TouchId */
      IF @OldTouchId=@TouchId
        SET @WhatHappened = 'Data changed, Same TouchId'
      ELSE BEGIN  
        SET @ChangeCount = @ChangeCount + 1;
        SET @WhatHappened = 'Data changed, Updated ClinLog with trigger';
      END;
      /* Increment change count and save data*/
      UPDATE dbo.ClinDatapoint SET
        Quantity=@Quantity,DTVal=@DTVal,EnumVal=@EnumVal,TextVal=@TextVal,
        ObsDate=GetDate(),TouchId=@TouchId,ChangeCount=@ChangeCount
      WHERE RowId=@RowId;
    END
    ELSE IF @CmpResult = 1
      SET @WhatHappened = 'Data was unchanged, not saved.'
    ELSE
      SET @WhatHappened = 'Invalid compare result, not saved';
  END;
  SELECT @RowId AS RowId,0 AS Locked,@WhatHappened AS MsgResult;
END
GO

GRANT EXECUTE ON [dbo].[AddClinData] TO [FastTrak]
GO