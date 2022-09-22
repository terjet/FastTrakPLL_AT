SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[DeleteClinFormItems]( @ClinFormId INT ) AS
BEGIN
  DECLARE @PersonId INT;  
  DECLARE @EventId INT;
  DECLARE @FormId INT;
  SET XACT_ABORT ON;
  BEGIN TRANSACTION DeleteItems;
  -- Find person and event number for this form
  SELECT @EventId = ce.EventId, @PersonId = ce.PersonId, @FormId = cf.FormId
  FROM   dbo.ClinEvent ce
  JOIN   dbo.ClinForm cf ON cf.EventId = ce.EventId
  WHERE  ClinFormId = @ClinFormId;
  -- Find items unique to this form
  SELECT ItemId INTO #tempItems 
    FROM dbo.MetaFormItem WHERE FormId = @FormId
  EXCEPT
    SELECT mfi.ItemId 
      FROM dbo.ClinEvent ce 
      JOIN dbo.ClinForm cf ON ( cf.EventId = ce.EventId ) AND ( cf.DeletedAt IS NULL )
      JOIN dbo.MetaFormItem mfi ON mfi.FormId = cf.FormId AND ISNULL(mfi.ReadOnly,0) = 0 
    WHERE  ( ce.EventId=@EventId ) AND ( cf.ClinFormId <> @ClinFormId );
  -- Insert datapoints into deleted table
  INSERT INTO dbo.ClinDatapointDeleted ( RowId,ItemId,EventId,TouchId,ClinFormId,ObsDate,Quantity,DTVal,EnumVal,TextVal,ChangeCount,Locked,LockedAt,LockedBy,guid )
  SELECT RowId,ItemId,EventId,TouchId,@ClinFormId,ObsDate,Quantity,DTVal,EnumVal,TextVal,ChangeCount,Locked,LockedAt,LockedBy,guid 
  FROM dbo.ClinDatapoint WHERE EventId=@EventId AND ItemId IN (SELECT ItemId FROM #tempItems);
  --- Delete datapoints
  DELETE FROM dbo.ClinDatapoint WHERE EventId=@EventId AND ItemId IN (SELECT ItemId FROM #tempItems);
  COMMIT TRANSACTION DeleteItems;
END
GO