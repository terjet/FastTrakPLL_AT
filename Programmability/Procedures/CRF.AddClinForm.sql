SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[AddClinForm]( @SessId INT, @PersonId INT, @FormId INT, @EventTime DateTime ) AS
BEGIN
  DECLARE @StudyId INT;
  DECLARE @EventNum INT;
  DECLARE @EventId INT;
  DECLARE @ClinFormId INT;
  DECLARE @DeletedBy INT;        
  DECLARE @StatusId INT;
  DECLARE @GroupId INT;
  DECLARE @IsNewEvent BIT;

  SET NOCOUNT ON;

  SET @StudyId = dbo.GetStudyId( @SessId )
  SET @EventNum = dbo.FnEventTimeToNum( @EventTime );

  IF @StudyId IS NULL                                
  BEGIN
    RAISERROR( 'Dette er ikke en gyldig brukerøkt (%d), og du kan ikke opprette skjemaet.', 16, 1, @SessId );
    RETURN -1;
  END;
    
  -- Find matching ClinFormId with this FormId in any study, because FormId may be in multiple studies, and we don't want duplicates.

  SELECT @ClinFormId = cf.ClinFormId, @EventId = ce.EventId, @DeletedBy = cf.DeletedBy
  FROM dbo.ClinForm cf 
  JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId 
  WHERE ce.PersonId = @PersonId AND cf.FormId = @FormId AND ce.EventNum = @EventNum;

  -- If there is no form, we need to make sure we have an event.

  IF @ClinFormId IS NULL
  BEGIN
    -- Find group and status (now), create event
    SELECT @StatusId = StatusId, @GroupId = GroupId FROM dbo.StudCase WHERE StudyId = @StudyId AND PersonId = @PersonId;
    EXEC CRF.AddClinEvent @StudyId, @PersonId, @EventNum, @GroupId, @StatusId, @EventId OUTPUT, @IsNewEvent OUTPUT;
    INSERT INTO dbo.ClinForm ( EventId, FormId, CreatedSessId ) VALUES ( @EventId, @FormId, @SessId );
    SET @ClinFormId = SCOPE_IDENTITY();
  END
   -- Reopen form if it was deleted.
   ELSE IF NOT @DeletedBy IS NULL
      UPDATE dbo.ClinForm SET DeletedAt = NULL, DeletedBy = NULL, CreatedBy = USER_ID() WHERE ClinFormId = @ClinFormId;
  SELECT @EventId AS EventId, @ClinFormId AS ClinFormId, @EventNum AS EventNum;
END;
GO

GRANT EXECUTE ON [CRF].[AddClinForm] TO [FastTrak]
GO