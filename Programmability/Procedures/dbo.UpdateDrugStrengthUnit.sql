SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateDrugStrengthUnit]( @TreatId INTEGER, @NewStrength decimal(12,4), @NewStrengthUnit VARCHAR(24), @StopReason varchar(64), @ChangeAt DateTime = NULL )
AS
  DECLARE @NewId INT;
BEGIN
  IF @ChangeAt IS NULL SET @ChangeAt = getdate();
  EXEC UpdateDrugStop @TreatId,@ChangeAt,0,@StopReason,0;
  INSERT INTO DrugTreatment
   (PersonId,ATC,DrugName,DrugForm,Strength,Dose24hCount,
    StrengthUnit,StartAt,StartReason,RxText,TreatType,PackType,DoseCode,DoseId)
  SELECT
    PersonId,ATC,DrugName,DrugForm,@NewStrength,Dose24hCount,
    @NewStrengthUnit,@ChangeAt,StartReason,RxText,TreatType,PackType,DoseCode,DoseId
  FROM DrugTreatment WHERE TreatId=@TreatId;
  SET @NewId=SCOPE_IDENTITY();              
  SELECT @NewId AS TreatId;
END
GO