SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[AddClinThread]( @ClinFormId INT, @ThreadName VARCHAR(24), @EventId INT = NULL ) AS
BEGIN
  DECLARE @ThreadTypeId INT;
  DECLARE @StudyId INT;
  DECLARE @PersonId INT;                                                                                                           
  DECLARE @ThreadId INT;

  -- Find StudyId, PersonId, ThreadTypeId based on Thread name and ClinFormId.

  SELECT
    @ThreadTypeId = mf.ThreadTypeId,
    @PersonId = ce.PersonId,
    @StudyId = ce.StudyId
  FROM dbo.MetaForm mf
  JOIN dbo.ClinForm cf
    ON cf.FormId = mf.FormId
  JOIN dbo.ClinEvent ce
    ON ce.EventId = cf.EventId
  WHERE cf.ClinFormId = @ClinFormId;  

  -- Find existing ThreadId based on StudyId, PersonId, EventId, ThreadTypeId AND ThreadName

  SELECT
    @ThreadId = ThreadId
  FROM dbo.ClinThread
  WHERE StudyId = @StudyId
  AND PersonId = @PersonId
  AND ThreadTypeId = @ThreadTypeId
  AND ThreadName = @ThreadName
  AND ( EventId = @EventId AND @EventId IS NOT NULL );
  IF @ThreadId IS NULL                                                                                                            
  BEGIN
    INSERT INTO dbo.ClinThread ( StudyId, PersonId, ThreadName, ThreadTypeId, EventId )
      VALUES ( @StudyId, @PersonId, @ThreadName, @ThreadTypeId, @EventId );
    SET @ThreadId = SCOPE_IDENTITY();
  END;
  SELECT @ThreadId AS ThreadId, @ThreadName AS ThreadName;
END;
GO

GRANT EXECUTE ON [CRF].[AddClinThread] TO [FastTrak]
GO