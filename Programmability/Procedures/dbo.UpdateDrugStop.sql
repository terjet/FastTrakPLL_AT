SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateDrugStop]( @TreatId INTEGER, @StopAt DATETIME, @StopFuzzy INTEGER = 0, @StopReason VARCHAR(64) = NULL, @SaveThisReason INTEGER = 1, @StopAuthorizedByName VARCHAR(30) = NULL ) AS
BEGIN
  DECLARE @ATC VARCHAR(7);
  DECLARE @StartAt DATETIME;
  DECLARE @AlreadyStopped DATETIME;
  DECLARE @PersonId INTEGER;
  DECLARE @CanModifyDrugTreatment BIT;
  DECLARE @ErrMsg VARCHAR(512);

  SET @CanModifyDrugTreatment = 1;

  EXEC dbo.CanModifyDrugTreatment NULL, @CanModifyDrugTreatment OUTPUT, @ErrMsg OUTPUT;
  IF @CanModifyDrugTreatment = 0
  BEGIN
    RAISERROR (@ErrMsg, 16, 1);
    RETURN -200;
  END;

  SELECT @StartAt = StartAt, @AlreadyStopped = StopAt FROM dbo.DrugTreatment WHERE TreatId = @TreatId;
  IF ( @StopAt < @StartAt ) AND CONVERT(INT, GETDATE()) = CONVERT( INT, @StartAt ) SET @StopAt = @StartAt;
  UPDATE dbo.DrugTreatment
	SET StopAt = @StopAt, StopFuzzy = @StopFuzzy, StopReason = @StopReason, StopBy = USER_ID(), StopAuthorizedByName = @StopAuthorizedByName
	WHERE TreatId = @TreatId AND ((StopAt IS NULL) OR (StopAt > @StopAt));
  IF ( @@ROWCOUNT <> 1 ) AND ( @AlreadyStopped IS NULL )
  BEGIN
    SET @ErrMsg = dbo.GetTextItem( 'UpdateDrugStop', 'Failed' );
    RAISERROR( @ErrMsg, 16, 1 );
    RETURN -1;
  END
  ELSE
  BEGIN
    SELECT @PersonId = PersonId	FROM dbo.DrugTreatment WHERE TreatId = @TreatId;
    UPDATE dbo.StudCase SET LastWrite = GETDATE() WHERE PersonId = @PersonId;
	IF ( ISNULL( @StopReason, '' ) <> '' AND @SaveThisReason = 1 )
    BEGIN
      SELECT @ATC = ATC FROM dbo.DrugTreatment WHERE TreatId = @TreatId;
      IF DATALENGTH(@ATC) > 4 EXEC dbo.AddDrugReason @ATC, 2, @StopReason;
    END
  END;
END;
GO