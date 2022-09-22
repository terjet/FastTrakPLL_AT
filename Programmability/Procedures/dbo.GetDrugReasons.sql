SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugReasons] @ATC varchar(7),@ReasonType INTEGER
AS
  SET NOCOUNT ON
  SELECT ReasonText FROM DrugReason
  WHERE ATC=@ATC and ReasonType=@ReasonType ORDER BY ReasonText
GO

GRANT EXECUTE ON [dbo].[GetDrugReasons] TO [FastTrak]
GO