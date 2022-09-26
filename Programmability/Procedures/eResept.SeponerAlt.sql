SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[SeponerAlt]( @PersonId INT ) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @CanModifyDrugTreatment BIT = 1;
  DECLARE @ErrMsg VARCHAR(512);
  DECLARE @TraceMethod VARCHAR(50) = 'eResept.SeponerAlt';
  DECLARE @TraceMessage VARCHAR(512);
  SELECT @TraceMessage = CONCAT( 'Enter eResept.SeponerAlt: PersonId = ', @PersonId );
  EXEC Tools.AddTraceMessage @TraceMethod, 0, @TraceMessage;
  EXEC dbo.CanModifyDrugTreatment NULL, @CanModifyDrugTreatment OUTPUT, @ErrMsg OUTPUT;
  IF @CanModifyDrugTreatment = 0
  BEGIN
    RAISERROR (@ErrMsg, 16, 1);
    RETURN -200;
  END;
  -- All non-FM drugs are stopped, unless they are already stopped.
  UPDATE dbo.DrugTreatment 
    SET 
      StopAt = GETDATE(), StopBy = USER_ID(), 
      StopReason = 'FM aktivert', Seponeringskladd = 0, Forskrivningskladd = 0
    WHERE ( PersonId = @PersonId ) 
      AND ( StopAt IS NULL OR StopAt > GETDATE() OR Forskrivningskladd = 1 OR Seponeringskladd = 1 ) 
      AND ( FMLibId IS NULL );
  -- Remove all drug reactions from the view by setting them to Deleted.
  UPDATE dbo.DrugReaction SET DeletedAt = GETDATE(), DeletedBy = USER_ID() 
    WHERE PersonId = @PersonId AND DeletedBy IS NULL AND CaveId IS NULL;
END
GO

GRANT EXECUTE ON [eResept].[SeponerAlt] TO [FMUser]
GO