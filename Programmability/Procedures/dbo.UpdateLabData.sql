SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateLabData]( @ResultId INT, @NumResult FLOAT,
  @DevResult INT = NULL, @TxtResult Text = NULL, @Comment Text = NULL,
  @ArithmeticComp Char(2) = NULL ) AS
BEGIN
  UPDATE LabData SET NumResult=@NumResult, DevResult=@DevResult, TxtResult=@TxtResult,Comment=@Comment,
  ArithmeticComp = @ArithmeticComp WHERE ResultId=@ResultId;
END
GO

DENY EXECUTE ON [dbo].[UpdateLabData] TO [ReadOnly]
GO