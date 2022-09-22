SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateDrugStrength]( @TreatId INTEGER, @NewStrength DECIMAL(12,4),@StopReason VARCHAR(64), @ChangeAt DateTime = NULL )
AS
BEGIN
  DECLARE @NewId INTEGER;
  DECLARE @CanModifyDrugTreatment BIT;
  DECLARE @ErrMsg VARCHAR(512);

  SET @CanModifyDrugTreatment = 1;

  EXEC dbo.CanModifyDrugTreatment  null, @CanModifyDrugTreatment OUTPUT, @ErrMsg OUTPUT;
  IF  @CanModifyDrugTreatment = 0
  BEGIN
    RAISERROR( @ErrMsg, 16, 1 );
    RETURN -200;
  END;

  IF @ChangeAt IS NULL SET @ChangeAt = getdate();
  EXEC dbo.UpdateDrugStop @TreatId,@ChangeAt,0,@StopReason,0;
  INSERT INTO dbo.DrugTreatment
   (PersonId,ATC,DrugName,DrugForm,Strength,Dose24hCount,
    StrengthUnit,StartAt,StartReason,RxText,TreatType,PackType,DoseCode,DoseId)
  SELECT
    PersonId,ATC,DrugName,DrugForm,@NewStrength,Dose24hCount,
    StrengthUnit,@ChangeAt,StartReason,RxText,TreatType,PackType,DoseCode,DoseId
  FROM dbo.DrugTreatment WHERE TreatId=@TreatId;
  SET @NewId=SCOPE_IDENTITY();              
  SELECT @NewId AS TreatId;
END
GO