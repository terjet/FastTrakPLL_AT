SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateDrugTreatmentWeekDetails]( @TreatId INTEGER,
 @DoseHour INTEGER,
 @DoseMon DECIMAL(8,2), @DoseTue DECIMAL(8,2), @DoseWed DECIMAL(8,2),
  @DoseThu DECIMAL(8,2), @DoseFri DECIMAL(8,2), @DoseSat DECIMAL(8,2),
  @DoseSun DECIMAL(8,2), @ChangedAt DateTime = NULL )
AS
BEGIN
  DECLARE @CanModifyDrugTreatment BIT;
  DECLARE @ErrMsg VARCHAR(512);
  DECLARE @Dose24hCount DECIMAL(12,4);
  DECLARE @CalcDose DECIMAL(12,4);
  DECLARE @DoseId INTEGER;
  DECLARE @MsgText VARCHAR(255);
  DECLARE @PackType CHAR(1);

  SET @CanModifyDrugTreatment = 1;

  EXEC dbo.CanModifyDrugTreatment  null, @CanModifyDrugTreatment OUTPUT, @ErrMsg OUTPUT;
  IF  @CanModifyDrugTreatment = 0
  BEGIN
    RAISERROR( @ErrMsg, 16, 1 );
    RETURN -200;
  END;

  SELECT @PackType = PackType FROM dbo.DrugTreatment WHERE TreatId=@TreatId;
  UPDATE dbo.DrugTreatment SET TreatType='U' WHERE TreatId=@TreatId;
  IF @ChangedAt IS NULL SET @ChangedAt=GetDate();
  /* Make sure the existing dose is equivalent to what we are adding here */
  SET @CalcDose=(@DoseMon+@DoseTue+@DoseWed+@DoseThu+@DoseFri+@DoseSat+@DoseSun)/7;
  /* Stop all earlier dosing schemes, regardless of type */
  EXEC dbo.DisableDrugDosingSchemes @TreatId,@ChangedAt;
  /* Add a new dosing scheme to DrugDosing */
  INSERT INTO dbo.DrugDosing (TreatId,PackType,ValidFrom,DoseHour,
    DoseMon,DoseTue,DoseWed,DoseThu,DoseFri,DoseSat,DoseSun,TreatType)
    VALUES (@TreatId,'M',@ChangedAt,@DoseHour,
      @DoseMon,@DoseTue,@DoseWed,@DoseThu,@DoseFri,@DoseSat,@DoseSun,'U');
  SET @DoseId=SCOPE_IDENTITY();
  UPDATE dbo.DrugTreatment SET DoseId=@DoseId WHERE TreatId=@TreatId;
  SET @MsgText='OK';
  SELECT ISNULL(@DoseId,-1),@MsgText;
END
GO

GRANT EXECUTE ON [dbo].[UpdateDrugTreatmentWeekDetails] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdateDrugTreatmentWeekDetails] TO [ReadOnly]
GO