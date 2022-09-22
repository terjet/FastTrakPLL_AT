SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UndeleteClinForm]( @ClinFormId INT )
AS
BEGIN
  DECLARE @EventId INT;
  DECLARE @FormId INT;
  -- Find EventId and FormId t
  SELECT @EventId = EventId, @FormId=FormId FROM dbo.ClinForm WHERE ClinFormId=@ClinFormId;
  -- Add back into ClinForm table
  UPDATE dbo.ClinForm SET DeletedAt = NULL, DeletedBy = NULL WHERE ClinFormId=@ClinFormId;
  -- Move the datapoints
  INSERT INTO dbo.ClinDataPoint (ItemId,EventId,TouchId,ObsDate,Quantity,DTVal,EnumVal,TextVal,ChangeCount,Locked,LockedAt,LockedBy,guid)
    SELECT ItemId,EventId,TouchId,ObsDate,Quantity,DTVal,EnumVal,TextVal,ChangeCount,Locked,LockedAt,LockedBy,guid
    FROM dbo.ClinDataPointDeleted WHERE ( ClinFormId = @ClinFormId ) AND ( RestoredAt IS NULL );
  -- Mark datapoints as restored
  UPDATE dbo.ClinDataPointDeleted SET RestoredAt = GETDATE(), RestoredBy = USER_ID() WHERE ClinFormId=@ClinFormId AND RestoredAt IS NULL;
END;
GO

GRANT EXECUTE ON [dbo].[UndeleteClinForm] TO [FastTrak]
GO