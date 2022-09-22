SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[AddClinThreadData]( @TouchId INT, @ThreadId INT, @ItemId INT, @Quantity decimal(18,4), @DTVal DateTime, @EnumVal int, @TextVal VARCHAR(MAX) ) AS
BEGIN
  DECLARE @EventId INT;
  DECLARE @RowId INT;
  DECLARE @Locked INT;
  DECLARE @MsgResult VARCHAR(32);  
  SET NOCOUNT ON;
  -- Make sure the TouchId is valid, matches an open session, and find the matching EventId
  SELECT @EventId=EventId FROM dbo.ClinTouch t 
    JOIN dbo.UserLog u on (u.SessId=t.SessId ) AND ( u.ClosedAt IS NULL ) AND (u.UserId=USER_ID())
    WHERE (t.TouchId=@TouchId) AND (t.CreatedBy=USER_ID());
  IF @EventId IS NULL
  BEGIN
    RAISERROR( 'Invalid SessId, UserId or TouchId.', 16, 1 );
    RETURN -1;
  END
  ELSE 
  BEGIN  
    -- Find row to update
    SELECT @RowId=RowId, @Locked=Locked FROM dbo.ClinThreadData WHERE EventId=@EventId AND ItemId=@ItemId AND ThreadId=@ThreadId;          
    IF @RowId IS NULL
    BEGIN
      INSERT INTO dbo.ClinThreadData (TouchId,ItemId,ThreadId,Quantity,DTVal,EnumVal,TextVal,EventId)
        VALUES (@TouchId,@ItemId,@ThreadId,@Quantity,@DTVal,@EnumVal,@TextVal,@EventId)
      SET @RowId = SCOPE_IDENTITY();
      SET @MsgResult = 'Data inserted';
    END;
   -- Make sure it is unlocked
    ELSE IF @Locked = 0
    BEGIN
      UPDATE dbo.ClinThreadData SET TouchId=@TouchId, Quantity=@Quantity, DTVal=@DTVal, EnumVal=@EnumVal, TextVal=@TextVal
      WHERE RowId=@RowId;      
      SET @MsgResult = 'Data updated';
    END  
    ELSE
    BEGIN
      RAISERROR( 'Variable %d is already locked', 16, 1, @ItemId );
      RETURN -2;
    END;                                               
  END;
  SELECT @RowId AS RowId,0 AS Locked,@MsgResult AS MsgResult;
END
GO

GRANT EXECUTE ON [CRF].[AddClinThreadData] TO [FastTrak]
GO