SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddDrugByNewStrength]( @TreatId INTEGER, @NewStrength DECIMAL(12,4),@StopReason VARCHAR(64) )
AS
BEGIN
  DECLARE @NewId INTEGER;
  DECLARE @CanModifyDrugTreatment BIT;
  DECLARE @ErrMsg VARCHAR(512);
  DECLARE @ChangeAt DateTime;

  SET @CanModifyDrugTreatment = 1;

  EXEC dbo.CanModifyDrugTreatment  null, @CanModifyDrugTreatment OUTPUT, @ErrMsg OUTPUT;
  IF  @CanModifyDrugTreatment = 0
  BEGIN
    RAISERROR( @ErrMsg, 16, 1 );
    RETURN -200;
  END;

  SET @ChangeAt = getdate();
  INSERT INTO dbo.DrugTreatment
   (PersonId,ATC,DrugName,DrugForm,Strength,Dose24hCount,
    StrengthUnit,StartAt,StartReason,RxText,TreatType,PackType,DoseCode,DoseId)
  SELECT
    PersonId,ATC,DrugName,DrugForm,@NewStrength,Dose24hCount,
    StrengthUnit,@ChangeAt,StartReason,RxText,TreatType,PackType,DoseCode,DoseId
  FROM dbo.DrugTreatment WHERE TreatId=@TreatId;
  SET @NewId=SCOPE_IDENTITY();
  IF @@ERROR <> 0 RETURN -ABS(@@ERROR);
  EXEC dbo.UpdateDrugStop @TreatId,@ChangeAt,0,@StopReason,0;
  RETURN @NewId;
END
GO