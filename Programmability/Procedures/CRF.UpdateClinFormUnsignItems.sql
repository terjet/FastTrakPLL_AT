SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[UpdateClinFormUnsignItems]( @ClinFormId INT )
AS
BEGIN
  DECLARE @EventId INT; 
  DECLARE @FormId INT;
  SELECT @EventId = EventId, @FormId=FormId FROM dbo.ClinForm WHERE ClinFormId=@ClinFormId;
  -- Find items on this form, but not on other signed forms  
  SELECT ItemId INTO #itemList 
  FROM dbo.MetaFormItem WHERE FormId=@FormId
  EXCEPT
    SELECT ItemId FROM dbo.MetaFormItem mfi
    JOIN dbo.ClinForm cf ON cf.FormId=mfi.FormId
    WHERE cf.EventId = @EventId AND cf.FormStatus='L'
    AND cf.ClinFormId <> @ClinFormId;          
  -- Unsign regular items
  UPDATE dbo.ClinDatapoint SET Locked=0, LockedAt=NULL, LockedBy=NULL
  WHERE EventId = @EventId AND Locked<>0 AND ItemId IN ( SELECT ItemId FROM #itemList );
  -- Unsign threaded items
  UPDATE dbo.ClinThreadData SET Locked=0, LockedAt=NULL,LockedBy=NULL
  WHERE EventId=@EventId AND Locked<>0 AND ItemId IN (SELECT ItemId from #itemList);
END
GO

GRANT EXECUTE ON [CRF].[UpdateClinFormUnsignItems] TO [FastTrak]
GO

DENY EXECUTE ON [CRF].[UpdateClinFormUnsignItems] TO [ReadOnly]
GO