SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddDrugTreatment]( @PersonId INTEGER, 
  @ATC VARCHAR(7), @DrugName VARCHAR(64), @DrugForm VARCHAR(64), @Strength DECIMAL(12, 4), @StrengthUnit VARCHAR(24), 
  @Dose24hCount DECIMAL(12, 4), @StartAt DATETIME, @StartFuzzy INTEGER, @StartReason VARCHAR(64), 
  @DoseCode VARCHAR(24), @RxText VARCHAR(MAX), @TreatType CHAR(1), @PackType CHAR(1), @BatchId INTEGER = NULL) AS
BEGIN
  DECLARE @TreatId INTEGER;
  DECLARE @MaxSeverity INTEGER;
  DECLARE @CanModifyDrugTreatment BIT;
  DECLARE @ErrMsg VARCHAR(512);

  SET NOCOUNT ON;

  SET @CanModifyDrugTreatment = 1;

  /* Check if user is allowed to modify drug treatment */

  EXEC dbo.CanModifyDrugTreatment NULL, @CanModifyDrugTreatment OUTPUT, @ErrMsg OUTPUT;
  
  IF @CanModifyDrugTreatment = 0
  BEGIN
    SELECT 0 AS TreatId;
    RAISERROR (@ErrMsg, 16, 1);
    RETURN -200;
  END;

  /* Make sure that this drug is not marked as contraindicated */

  IF dbo.AllowDrug(@PersonId, @ATC) = 0
  BEGIN
    RAISERROR ('Du kan ikke ordinere %s %s pga. tidligere bivirkninger av tilsvarende preparat!', 16, 1, @ATC, @DrugName);
    RETURN -1;
  END;

  /* Add drug treatment */

  INSERT INTO dbo.DrugTreatment (PersonId, ATC, DrugName, DrugForm, Strength, StrengthUnit, Dose24hCount, StartAt, StartFuzzy, StartReason, DoseCode, TreatType, PackType, RxText, BatchId)
    VALUES (@PersonId, @ATC, @DrugName, @DrugForm, @Strength, @StrengthUnit, @Dose24hCount, @StartAt, @StartFuzzy, @StartReason, @DoseCode, @TreatType, @PackType, @RxText, @BatchId);
  SET @TreatId = SCOPE_IDENTITY();

  /* Update secondary data */

  IF DATALENGTH(@StartReason) > 2 EXEC dbo.AddDrugReason @ATC, 1, @StartReason;
  UPDATE dbo.StudCase SET LastWrite = GETDATE() WHERE PersonId = @PersonId;

  SELECT @TreatId AS TreatId;
  RETURN @TreatId;
END
GO

GRANT EXECUTE ON [dbo].[AddDrugTreatment] TO [FastTrak]
GO