SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetDrugUse]( @PersonId INT, @ATC varchar(7), @CalcAt DateTime ) RETURNS INT
AS
BEGIN
  -- Returns 0 if never used, 1 if ongoing, 2 if stopped.
  DECLARE @RetVal INT;
  DECLARE @TreatId INT;
  SELECT @TreatId=MAX(TreatId) FROM DrugTreatment
    WHERE ( PersonId=@PersonId ) AND (ATC LIKE @ATC) AND ( StartAt <= @CalcAt );
  IF @TreatId IS NULL
    SET @RetVal = 0
  ELSE
  BEGIN
    SELECT @TreatId=MAX(TreatId) FROM DrugTreatment WHERE ( PersonId=@PersonId )
      AND ( StartAt <= @CalcAt ) AND ( StopAt IS NULL OR StopAt > @CalcAt ) AND ( ATC LIKE @ATC );
     IF NOT @TreatId IS NULL
       SET @RetVal = 1
     ELSE
       SET @RetVal = 2;
  END;
  RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[GetDrugUse] TO [FastTrak]
GO