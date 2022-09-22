SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddDrugReason] @ATC varchar(7), @ReasonType INTEGER, @ReasonText varchar(64)
AS
IF NOT EXISTS(
  SELECT ATC FROM DrugReason
  WHERE ATC=@ATC AND ReasonType=@ReasonType AND ReasonText=@ReasonText )
BEGIN
  INSERT INTO DrugReason (ATC,ReasonType,ReasonText)
  VALUES(@ATC,@ReasonType,@ReasonText)
END
GO

GRANT EXECUTE ON [dbo].[AddDrugReason] TO [FastTrak]
GO