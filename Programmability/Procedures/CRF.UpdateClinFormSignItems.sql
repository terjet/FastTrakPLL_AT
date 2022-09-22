SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[UpdateClinFormSignItems]( @ClinFormId INT )
AS
BEGIN
  DECLARE @EventId INT;
  DECLARE @FormId INT;
  SELECT @EventId = EventId, @FormId=FormId FROM dbo.ClinForm WHERE ClinFormId=@ClinFormId;
  SELECT ItemId INTO #itemList FROM dbo.MetaFormItem WHERE FormId=@FormId;
  -- Sign regular items
  UPDATE dbo.ClinDatapoint SET LockedAt=GETDATE(),LockedBy=USER_ID(),Locked=1
  WHERE EventId=@EventId AND LockedBy IS NULL AND ItemId IN (SELECT ItemId FROM #itemList );
  -- Sign threaded items
  UPDATE dbo.ClinThreadData SET LockedAt=GETDATE(),LockedBy=USER_ID(),Locked=1
  WHERE EventId=@EventId AND LockedBy IS NULL AND ItemId IN (SELECT ItemId from #itemList);
END
GO