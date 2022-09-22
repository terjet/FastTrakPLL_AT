SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateDrugTreatmentMultidoseDetails]( @TreatId INTEGER,
 @Dose07 DECIMAL(8,2), @Dose08 DECIMAL(8,2), @Dose13 DECIMAL(8,2),
 @Dose18 DECIMAL(8,2), @Dose21 DECIMAL(8,2), @Dose23 DECIMAL(8,2),
 @ChangedAt DateTime = NULL )
AS
BEGIN
  DECLARE @CanModifyDrugTreatment BIT;
  DECLARE @ErrMsg VARCHAR(512);
  DECLARE @Dose24hCount DECIMAL(12,4);
  DECLARE @CalcDose DECIMAL(12,4);
  DECLARE @DoseId INTEGER;
  DECLARE @MsgText VARCHAR(255);
  DECLARE @TreatType CHAR(1);
  DECLARE @PackType CHAR(1);

  SET @CanModifyDrugTreatment = 1;

  EXEC dbo.CanModifyDrugTreatment  null, @CanModifyDrugTreatment OUTPUT, @ErrMsg OUTPUT;
  IF  @CanModifyDrugTreatment = 0
  BEGIN
    RAISERROR( @ErrMsg, 16, 1 );
    RETURN -200;
  END;

  SELECT @TreatType=TreatType,@PackType=PackType FROM dbo.DrugTreatment WHERE TreatId=@TreatId;
  IF @ChangedAt IS NULL SET @ChangedAt=GetDate();
  SET @DoseId = NULL;
  SELECT @Dose24hCount = Dose24hCount FROM dbo.DrugTreatment
    WHERE ( TreatId=@TreatId ) AND (StopAt IS NULL ) AND ( TreatType = @TreatType );
  IF @Dose24hCount IS NULL
    SET @MsgText = 'Treatment does not exists, is not active, or of the wrong type.'
  ELSE 
  BEGIN
    /* Calculate the dose based on given information */
    IF @Dose24hCount=0 
      SET @CalcDose = 0
    ELSE
      SET @CalcDose=@Dose07+@Dose08+@Dose13+@Dose18+@Dose21+@Dose23;
    /* Make sure the existing dose is equivalent to what we are adding here */
    IF ( @CalcDose<>@Dose24hCount )
      SET @MsgText = 'Daily dose mismatch.  Could not set dose details.'
    ELSE 
    BEGIN
      /* Stop all earlier dosing schemes, regardless of type */
      EXEC dbo.DisableDrugDosingSchemes @TreatId,@ChangedAt;
      /* Add a new dosing scheme to DrugDosing */
      INSERT INTO dbo.DrugDosing (TreatId,PackType,ValidFrom,Dose07,Dose08,Dose13,Dose18,Dose21,Dose23,
        DoseMon,DoseTue,DoseWed,DoseThu,DoseFri,DoseSat,DoseSun,TreatType)
        VALUES (@TreatId,@PackType,@ChangedAt,@Dose07,@Dose08,@Dose13,@Dose18,@Dose21,@Dose23,
          @CalcDose,@CalcDose,@CalcDose,@CalcDose,@CalcDose,@CalcDose,@CalcDose,@TreatType);
      SET @DoseId=SCOPE_IDENTITY();
      UPDATE dbo.DrugTreatment SET DoseId=@DoseId WHERE TreatId=@TreatId;
      SET @MsgText='OK';
    END;
  END;
  IF @DoseId IS NULL 
  BEGIN
    RAISERROR( @MsgText, 16, 1 );
    RETURN -1;
  END;
  SELECT @DoseId AS DoseId, @MsgText AS MsgText;
END
GO

GRANT EXECUTE ON [dbo].[UpdateDrugTreatmentMultidoseDetails] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdateDrugTreatmentMultidoseDetails] TO [ReadOnly]
GO