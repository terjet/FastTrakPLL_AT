SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddOrUpdateLabResult]( @PersonId INT, @LabDate DateTime, @InvestigationId VARCHAR(16), @LabName varchar(40), 
  @NumResult FLOAT, @DevResult INT = NULL, @TxtResult VARCHAR(MAX) = null, @Comment VARCHAR(MAX) = null,
  @ArithmeticComp Char(2) = NULL, @UnitStr varchar(24) = NULL, @BatchId INTEGER = NULL, @RefInterval VARCHAR(MAX) = NULL ) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @ResultId INT;
  DECLARE @LabCodeId INT;
  -- Make sure that we have an existing LabCode, add if this combination of LabName and UnitStr is missing.
  SELECT @LabCodeId = LabCodeId FROM dbo.LabCode WHERE LabName = @LabName AND UnitStr = ISNULL(@UnitStr,''); 
  IF @LabCodeId IS NULL 
  BEGIN
    INSERT INTO dbo.LabCode ( LabName, UnitStr ) VALUES( @LabName, ISNULL( @UnitStr, '' ) );
	SELECT @LabCodeId = SCOPE_IDENTITY();
  END;
  -- Search for existing result to overwrite.
  SELECT @ResultId = ResultId FROM dbo.LabData 
    WHERE PersonId = @PersonId AND LabDate = @LabDate AND InvestigationId = @InvestigationId;
  -- No match on InvestigationId, check instead for match on LabCodeId.
  IF @ResultId IS NULL
    SELECT @ResultId = ResultId FROM dbo.LabData 
	WHERE PersonId = @PersonId AND LabDate = @LabDate AND LabCodeId= @LabCodeId;
  -- Update result if it exists, including a potentially changed unit otherwise just insert.
  IF NOT @ResultId IS NULL
    UPDATE dbo.LabData SET 
	  LabCodeId = @LabCodeId, NumResult = @NumResult, DevResult = @DevResult, TxtResult = @TxtResult, Comment = @Comment,
      InvestigationId = @InvestigationId, ArithmeticComp = @ArithmeticComp, UnitStr = @UnitStr, BatchId = @BatchId, RefInterval = @RefInterval
	WHERE ResultId=@ResultId;
  ELSE 
    INSERT INTO dbo.LabData
	  (  PersonId, LabDate, LabCodeId, OrigCodeId, InvestigationId,  NumResult,  DevResult,  TxtResult,  Comment,  ArithmeticComp,  UnitStr,  BatchId,  RefInterval )
    VALUES
      ( @PersonId,@LabDate,@LabCodeId,@LabCodeId, @InvestigationId, @NumResult, @DevResult, @TxtResult, @Comment, @ArithmeticComp, @UnitStr, @BatchId, @RefInterval );
END
GO

GRANT EXECUTE ON [dbo].[AddOrUpdateLabResult] TO [FastTrak]
GO