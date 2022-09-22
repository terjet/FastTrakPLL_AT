SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetRxPackOptionsByName]( @DrugName VARCHAR(64), @Strength FLOAT, @DrugForm varchar(32) )
AS
BEGIN
   SELECT DISTINCT PackSize,PackSizeUnit,PackName FROM PIA
   WHERE DrugName=@DrugName AND ISNULL(Strength,0)=ISNULL(@Strength,0) AND ISNULL(DrugForm,'')=ISNULL(@DrugForm,'') 
   ORDER BY PackSize
END
GO

GRANT EXECUTE ON [dbo].[GetRxPackOptionsByName] TO [FastTrak]
GO