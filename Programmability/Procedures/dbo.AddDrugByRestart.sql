SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddDrugByRestart]( @TreatId INTEGER, @StartAt DateTime = NULL ) AS
BEGIN
  SET NOCOUNT ON;                                                          
  DECLARE @NewId INT;
  DECLARE @PersonId INT;
  DECLARE @ATC VARCHAR(7);
  IF @StartAt IS NULL SET @StartAt = GETDATE();
  IF ( SELECT PauseStatus FROM dbo.DrugTreatment WHERE TreatId = @TreatId ) = 1
  BEGIN
    EXEC @NewId = dbo.UpdateDrugPause @TreatId, 0;
  END
  ELSE BEGIN   
    SELECT @ATC = ATC, @Personid = PersonId FROM dbo.DrugTreatment WHERE TreatId = @TreatId;
    IF dbo.AllowDrug( @PersonId, @ATC ) = 0
    BEGIN
      RAISERROR( 'Medisinen kan ikke ordineres pga. tidligere bivirkninger.', 16, 1 );
      RETURN -1;
    END   
    ELSE 
    BEGIN
      INSERT INTO dbo.DrugTreatment
        ( PersonId, ATC, DrugName, DrugForm, Strength, StrengthUnit,
          Dose24hCount, StartAt, StartFuzzy, StartReason, DoseCode, RxText, TreatType, PackType, DoseId )
        SELECT PersonId, ATC, DrugName, DrugForm, Strength, StrengthUnit,
          Dose24hCount, @StartAt, StartFuzzy, StartReason, DoseCode, RxText, TreatType, PackType, DoseId
        FROM dbo.DrugTreatment WHERE ( TreatId = @TreatId ) AND ( NOT StopAt IS NULL );
      UPDATE dbo.StudCase SET LastWrite = GETDATE() WHERE PersonId = @PersonId;
      SET @NewId = SCOPE_IDENTITY();
    END;
  END;
  SELECT @NewId AS TreatId;
  RETURN @NewId; -- Deprecated
END
GO

GRANT EXECUTE ON [dbo].[AddDrugByRestart] TO [FastTrak]
GO