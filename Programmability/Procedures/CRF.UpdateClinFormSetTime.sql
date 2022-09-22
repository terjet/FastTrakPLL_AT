SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[UpdateClinFormSetTime]( @ClinFormId INT, @NewEventTime DATETIME ) AS
BEGIN
  DECLARE @NewEventId INT;
  DECLARE @PersonId INT;
  DECLARE @NewEventNum INT;
  DECLARE @OldEventId INT;
  DECLARE @StudyId INT;
  DECLARE @FormId INT;
  DECLARE @DeletedBy INT;
  DECLARE @GroupId INT;
  DECLARE @StatusId INT;
  DECLARE @StudName VARCHAR(40);

  DECLARE @ExistingClinFormId INT;
  DECLARE @ErrMsg VARCHAR(512);
  DECLARE @IsNewEvent BIT;

  SET XACT_ABORT ON;

  BEGIN TRANSACTION;

  BEGIN TRY

    SELECT @StudyId = ce.StudyId, @PersonId = ce.PersonId, @OldEventId = ce.EventId, @GroupId = ce.GroupId, @StatusId = @StatusId, @FormId = cf.FormId, @StudName = s.StudName
    FROM dbo.ClinEvent ce
    JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND cf.ClinFormId = @ClinFormId
    JOIN dbo.Study s ON s.StudyId = ce.StudyId;

    SET @NewEventNum = dbo.FnEventTimeToNum(@NewEventTime);

    -- Make sure we have an event

    IF @GroupId IS NULL SELECT @GroupId = dbo.GetGroupOnDate( @PersonId, @StudName, @NewEventTime );

    EXEC CRF.AddClinEvent @StudyId, @PersonId, @NewEventNum, @GroupId, @StatusId, @NewEventId OUTPUT, @IsNewEvent OUTPUT;

    IF @IsNewEvent = 0 
    BEGIN
      -- Event exists, check for existing form that would conflict with this form
      SELECT @ExistingClinFormId = ClinFormId, @DeletedBy = DeletedBy
      FROM dbo.ClinForm
      WHERE FormId = @FormId
        AND EventId = @NewEventId
        AND ClinFormId <> @ClinFormId;
      IF NOT @ExistingClinFormId IS NULL
      BEGIN
        SET @ErrMsg = 'Skjemaet kan ikke flyttes til ' + dbo.LongTime(@NewEventTime) + '.\nDet finnes allerede et tilsvarende skjema der!';
        IF NOT @DeletedBy IS NULL
          SET @ErrMsg = @ErrMsg + '\nDet andre skjemaet er slettet, så du må evt. angre sletting.';
        RAISERROR (@ErrMsg, 16, 1);      
      END;
    END;

    UPDATE dbo.ClinForm SET EventId = @NewEventId
    WHERE ClinFormId = @ClinFormId;

    -- Try to move the the data connectect to this form.
    EXEC dbo.UpdateClinDataEventId @FormId, @OldEventId, @NewEventId;
    -- Move orphaned variables if there are no more forms on this event.
    IF (SELECT COUNT(*) FROM dbo.ClinForm WHERE EventId = @OldEventId) = 0 
      UPDATE dbo.ClinDataPoint SET EventId = @NewEventId
      WHERE EventId = @OldEventId;
  END TRY
  BEGIN CATCH
    SET @ErrMsg =  CONCAT( 'Flytting av skjema kunne ikke utføres.\n', ERROR_MESSAGE() );
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    RAISERROR ( @ErrMsg, 16, 1 );
    RETURN -1;
  END CATCH;

  IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

END;
GO

GRANT EXECUTE ON [CRF].[UpdateClinFormSetTime] TO [FastTrak]
GO