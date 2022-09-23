SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[ResetPromDownload]( @PromUid VARCHAR(36), @PersonId INT = NULL ) AS 
BEGIN
  SET NOCOUNT ON;

  -- Find relevant events

  SELECT EventId 
  INTO #ClinEvents
  FROM dbo.ClinForm cf
  JOIN PROM.FormOrder fo ON fo.ClinFormId = cf.ClinFormId
  WHERE fo.PromUid = @PromUid AND ISNULL(@PersonId,fo.PersonId) = fo.PersonId;

  -- Unlock all items on these events

  UPDATE dbo.ClinDataPoint SET LockedAt = NULL, LockedBy = NULL, Locked  = 0 
  WHERE EventId IN (SELECT EventId FROM #ClinEvents )
  
  -- Unlock all forms on these events

  UPDATE dbo.ClinForm SET FormStatus = 'E', FormComplete = 0, SignedAt = NULL, SignedBy = NULL, SignedSessId = NULL
  WHERE EventId IN (SELECT EventId FROM #ClinEvents );
  
  -- Reset download status

  UPDATE PROM.FormOrder SET OrderStatus = 'Waiting', ClinFormId = NULL 
  WHERE PromUid = @PromUid AND PersonId = ISNULL(@PersonId,PersonId);
  
END
GO

GRANT EXECUTE ON [Tools].[ResetPromDownload] TO [Administrator]
GO