SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[UpdateClinThreadFormData]( @SessId INT, @ClinFormId INT, @FormData XML )
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @TouchId INT;
  DECLARE @EventId INT;
  DECLARE @FormId INT;
  DECLARE @PersonId INT;
  DECLARE @StudyId INT;

  CREATE TABLE #SubForm (FormId INT, ThreadId INT, ThreadName VARCHAR(24), SortOrder INT,
    ThreadTypeId INT, ItemId INT, FormComplete TINYINT, FormCompleteRequired SMALLINT, FormStatus CHAR(1), CachedText VARCHAR(MAX), Deleted BIT); 

   SELECT @EventId = ce.EventId, @FormId = cf.FormId, @StudyId = StudyId, @PersonId = ce.PersonId FROM dbo.ClinForm cf
   JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
   WHERE cf.ClinFormId = @ClinFormId

  -- Extract information on subforms
  INSERT INTO #SubForm
  (ItemId, FormId, ThreadId, ThreadName, SortOrder, ThreadTypeId, FormComplete, FormCompleteRequired, FormStatus, CachedText, Deleted)
  SELECT
    x.r.value('../@ItemId', 'INT'),
    x.r.value('../@DetailFormId', 'INT'),
    x.r.value('@ThreadId', 'INT'),
    x.r.value('@ThreadName', 'VARCHAR(24)'),
    x.r.value('@SortOrder', 'INT'),
    mf.ThreadTypeId,
    x.r.value('@FormComplete', 'TINYINT') AS FormComplete,
    x.r.value('@FormCompleteRequired', 'SMALLINT') AS FormCompleteRequired,
    x.r.value('@FormStatus', 'CHAR(1)') AS FormStatus,
    x.r.value('CachedText[1]', 'VARCHAR(MAX)'),
    x.r.value('@Deleted', 'BIT')
  FROM @FormData.nodes('Subforms/FormList/Form') AS x (r)
  JOIN dbo.MetaForm mf ON mf.FormId = x.r.value('../@DetailFormId', 'INT')

   -- Get a touch identifier to use for this save operation.
   INSERT INTO dbo.ClinTouch( SessId, EventId, FormId ) VALUES ( @SessId, @EventId, @FormId );
   SET @TouchId = SCOPE_IDENTITY();

   -- Merge data into ClinThread table
  MERGE INTO dbo.ClinThread trg
  USING #SubForm src
  ON ( trg.ThreadId = src.ThreadId )
  WHEN
    MATCHED AND
    src.Deleted = 1 THEN
    DELETE
  WHEN
    MATCHED AND
    CHECKSUM(src.ThreadName, @EventId, src.SortOrder ) <>
    CHECKSUM(trg.ThreadName, trg.EventId, trg.SortOrder) THEN
    UPDATE SET 
      ThreadName = src.ThreadName,
      EventId = @EventId,
      SortOrder = src.SortOrder
  WHEN
    NOT MATCHED THEN
    INSERT ( StudyId, PersonId, ThreadName, EventId, SortOrder, ThreadTypeId )
    VALUES ( @StudyId, @PersonId, src.ThreadName, @EventId, src.SortOrder, src.ThreadTypeId );

  -- Fetch ThreadIds for new subforms
  UPDATE #SubForm
    SET ThreadId = ct.ThreadId
  FROM dbo.ClinThread ct
  WHERE ct.StudyId = @StudyId AND ct.PersonId = @PersonId 
    AND #SubForm.ThreadTypeId = ct.ThreadTypeId AND #SubForm.ThreadName = ct.ThreadName 

  -- Merge data into ClinThreadForm table
  MERGE INTO CRF.ClinThreadForm trg 
  USING #SubForm src
  ON src.ThreadId = trg.ThreadId
  WHEN
    MATCHED AND
    CHECKSUM(trg.FormComplete, trg.CachedText, trg.FormStatus) <>
    CHECKSUM(src.FormComplete, src.CachedText, src.FormStatus) THEN
        UPDATE SET 
          trg.FormComplete = src.FormComplete, trg.FormCompleteRequired = src.FormCompleteRequired, trg.CachedText = src.CachedText,
          trg.FormStatus = src.FormStatus
  WHEN 
    NOT MATCHED AND
    src.Deleted IS NULL THEN
    INSERT ( FormId, ThreadId, ClinFormId, ItemId, FormStatus, FormComplete, FormCompleteRequired, CachedText )
    VALUES( src.FormId, src.ThreadId, @ClinFormId, src.ItemId, src.FormStatus, src.FormComplete, src.FormCompleteRequired, src.CachedText );

   -- Merge data into ClinThreadData table
   MERGE INTO dbo.ClinThreadData trg USING 
   (
    SELECT 
      sf.ThreadId, sf.ThreadName,
      x.r.value('@ItemId', 'INT') AS ItemId,
      x.r.value('@EnumVal', 'INT') AS EnumVal,
      x.r.value('@Quantity', 'DECIMAL(18,4)') AS Quantity,
      x.r.value('@DTVal', 'DATE') AS DTVal,
      x.r.value('@TextVal', 'VARCHAR(MAX)') AS TextVal,
      x.r.value('@Locked', 'INT') AS Locked,
      x.r.value('@LockedBy', 'INT') AS LockedBy,
      x.r.value('@LockedAt', 'DATETIME') AS LockedAt,
      x.r.value('@ChangeIncrement', 'INT') AS ChangeIncrement
    FROM @FormData.nodes('Subforms/FormList/Form/ItemList/Item') AS x (r)
    LEFT JOIN #SubForm sf ON sf.ThreadName = x.r.value('../../@ThreadName', 'VARCHAR(24)')
   ) src
   ON ( trg.ThreadId = src.ThreadId AND trg.ItemId = src.ItemId )
   WHEN
     MATCHED AND ( trg.Locked = 0 ) THEN
     UPDATE SET 
       ObsDate = GETDATE(), EnumVal = src.EnumVal, Quantity = src.Quantity, DTVal = src.DTVal, TextVal = src.TextVal, 
       Locked = src.Locked, LockedAt = src.LockedAt, LockedBy = src.LockedBy + USER_ID(),
       TouchId = @TouchId, ChangeCount = ChangeCount + src.ChangeIncrement
   WHEN 
     NOT MATCHED THEN
     INSERT (EventId, TouchId, ItemId, ThreadId, Quantity, EnumVal, DTVal, TextVal, Locked, LockedAt, LockedBy )
     VALUES( @EventId, @TouchId, src.ItemId, src.ThreadId, src.Quantity, src.EnumVal, src.DTVal, src.TextVal, src.Locked, src.LockedAt, src.LockedBy + USER_ID() );

  -- Delete the data points of deleted subforms  
  DELETE ctd
  FROM dbo.ClinThreadData ctd
  JOIN #SubForm sf ON sf.ThreadId = ctd.ThreadId
  WHERE sf.Deleted = 1
  

  -- Return all datapoints for the current event (as they may be changed)
  SELECT ctd.*, ce.EventNum, ce.EventTime, mi.VarName
  FROM dbo.ClinThreadData ctd 
  JOIN dbo.ClinEvent ce ON ce.EventId = ctd.EventId 
  JOIN dbo.MetaItem mi ON mi.ItemId = ctd.ItemId
  WHERE ce.EventId = @EventId;
END;
GO

GRANT EXECUTE ON [CRF].[UpdateClinThreadFormData] TO [FastTrak]
GO