SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[SeponerAlt] (@PersonId INT) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @CanModifyDrugTreatment BIT = 1;
  DECLARE @ErrMsg VARCHAR(512);
  DECLARE @TraceMethod VARCHAR(50) = 'eResept.SeponerAlt';
  DECLARE @TraceMessage VARCHAR(MAX);
  SELECT @TraceMessage = 'Enter eResept.SeponerAlt: PersonId=' + CAST(@PersonId AS VARCHAR);
  EXEC Tools.AddTraceMessage @TraceMethod, 0, @TraceMessage;
  EXEC dbo.CanModifyDrugTreatment NULL, @CanModifyDrugTreatment OUTPUT, @ErrMsg OUTPUT;
  IF @CanModifyDrugTreatment = 0
  BEGIN
    RAISERROR (@ErrMsg, 16, 1);
    RETURN -200;
  END;
  UPDATE dbo.DrugTreatment SET StopAt = GETDATE(), StopBy = USER_ID(), StopReason = 'FM aktivert' WHERE PersonId = @PersonId  AND StopAt IS NULL AND FMLibId IS NULL;
  UPDATE dbo.DrugReaction SET DeletedAt = GETDATE(), DeletedBy = USER_ID() WHERE PersonId = @PersonId AND DeletedBy IS NULL AND CaveId IS NULL;
END
GO

GRANT EXECUTE ON [eResept].[SeponerAlt] TO [FMUser]
GO