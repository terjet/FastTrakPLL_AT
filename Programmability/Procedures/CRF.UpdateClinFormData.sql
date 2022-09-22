SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[UpdateClinFormData]( @SessId INT, @ClinFormId INT, @FormData XML ) AS
BEGIN
   SET NOCOUNT ON;

   DECLARE @TouchId INT;
   DECLARE @EventId INT;
   DECLARE @FormId INT;
   DECLARE @SignedBy INT;
   DECLARE @SignedByPerson VARCHAR(128);

   -- Retrieve some more details about this form that we will need later on.

   SELECT @EventId = cf.EventId, @FormId = cf.FormId, 
    @SignedBy = cf.SignedBy,
    @SignedByPerson = ISNULL( p.FullName, USER_NAME( cf.SignedBy ) )
   FROM dbo.ClinForm cf
   LEFT JOIN dbo.UserList ul ON ul.UserId = cf.SignedBy
   LEFT JOIN dbo.Person p ON p.PersonId = ul.PersonId
   WHERE cf.ClinFormId = @ClinFormId;

   -- Make sure we are not trying to update a form that is already signed.

   IF NOT @SignedBy IS NULL
   BEGIN
      RAISERROR ( 'En annen bruker (%s) har signert dette skjemaet.\nDu kan ikke redigere skjemaet uten at det gjenåpnes.', 16, 1, @SignedByPerson );
      RETURN -1;
   END;

   -- Get a touch identifier to use for this save operation.

   INSERT INTO dbo.ClinTouch( SessId, EventId, FormId ) VALUES ( @SessId, @EventId, @FormId );
   SET @TouchId = SCOPE_IDENTITY();

   -- Merge data into ClinForm table

   MERGE INTO dbo.ClinForm trg USING 
   (
    SELECT 
      x.r.value('@FormComplete', 'TINYINT') AS FormComplete,
      x.r.value('@FormCompleteRequired', 'SMALLINT') AS FormCompleteRequired,
      x.r.value('@FormStatus', 'CHAR(1)') AS FormStatus,
      x.r.value('@SignedBy', 'INT') AS SignedBy,
      x.r.value('@SignedAt', 'DATETIME') AS SignedAt,
      x.r.value('Comment[1]', 'VARCHAR(MAX)') AS Comment,
      x.r.value('CachedText[1]', 'VARCHAR(MAX)') AS CachedText
    FROM @FormData.nodes('/Form') AS x (r)
   ) src
   ON trg.ClinFormId = @ClinFormId
   WHEN MATCHED AND 
     CHECKSUM( trg.Comment, trg.FormComplete, trg.CachedText, trg.FormStatus, trg.SignedAt ) <> 
     CHECKSUM( src.Comment, src.FormComplete, src.CachedText, src.FormStatus, src.SignedAt ) THEN
     UPDATE SET 
       trg.Comment = src.Comment, trg.FormComplete = src.FormComplete, trg.FormCompleteRequired = src.FormCompleteRequired, trg.CachedText = src.CachedText, 
       trg.FormStatus = src.FormStatus, trg.SignedAt = src.SignedAt, trg.SignedBy = src.SignedBy + USER_ID();

   -- Merge data into ClinDataPoint table

   MERGE INTO dbo.ClinDataPoint trg USING 
   (
    SELECT 
      x.r.value('@ItemId', 'INT') AS ItemId,
      x.r.value('@EnumVal', 'INT') AS EnumVal,
      x.r.value('@Quantity', 'DECIMAL(18,4)') AS Quantity,
      x.r.value('@DTVal', 'DATE') AS DTVal,
      x.r.value('@TextVal', 'VARCHAR(MAX)') AS TextVal,
      x.r.value('@Locked', 'INT') AS Locked,
      x.r.value('@LockedBy', 'INT') AS LockedBy,
      x.r.value('@LockedAt', 'DATETIME') AS LockedAt,
      x.r.value('@ChangeIncrement', 'INT') AS ChangeIncrement
    FROM @FormData.nodes('/Form/ItemList/Item') AS x (r)
   ) src
   ON ( trg.EventId = @EventId AND trg.ItemId = src.ItemId )
   WHEN 
     MATCHED AND ( trg.Locked = 0 ) THEN
     UPDATE SET 
       ObsDate = GETDATE(), EnumVal = src.EnumVal, Quantity = src.Quantity, DTVal=src.DTVal, TextVal=src.TextVal, 
       Locked = src.Locked, LockedAt = src.LockedAt, LockedBy = src.LockedBy + USER_ID(),
       TouchId = @TouchId, ChangeCount = ChangeCount + src.ChangeIncrement
   WHEN 
     NOT MATCHED THEN
     INSERT (EventId, TouchId, ItemId, Quantity, EnumVal, DTVal, TextVal, Locked, LockedAt, LockedBy )
     VALUES( @EventId, @TouchId, src.ItemId, src.Quantity, src.EnumVal, src.DTVal, src.TextVal, src.Locked, src.LockedAt, src.LockedBy + USER_ID() );

  -- Update the LastTouchId for this form only if the merge affected the datapoints

  IF @@ROWCOUNT  > 0
    UPDATE dbo.ClinForm SET LastTouchId = @TouchId WHERE ClinFormId = @ClinFormId;

  -- Return all datapoints for the current event (as they may be changed)

  SELECT cdp.*, ce.EventNum, ce.EventTime, mi.VarName
  FROM dbo.ClinDataPoint cdp 
  JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId 
  JOIN dbo.MetaItem mi ON mi.ItemId = cdp.ItemId
  WHERE ce.EventId = @EventId;

END;
GO

GRANT EXECUTE ON [CRF].[UpdateClinFormData] TO [FastTrak]
GO