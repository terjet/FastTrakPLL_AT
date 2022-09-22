SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetRxPackOptions]( @ATC VARCHAR(7), @Strength FLOAT, @DrugForm varchar(32) )
AS
BEGIN
   SELECT DISTINCT PackSize,PackSizeUnit,PackName FROM PIA
   WHERE ATC=@ATC AND ISNULL(Strength,0)=ISNULL(@Strength,0) AND DrugForm=@DrugForm ORDER BY PackSize
END
GO

GRANT EXECUTE ON [dbo].[GetRxPackOptions] TO [FastTrak]
GO