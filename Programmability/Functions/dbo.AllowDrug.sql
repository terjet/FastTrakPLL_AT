SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[AllowDrug]( @PersonId INT, @ATC VARCHAR(7) ) RETURNS INT AS
BEGIN
  DECLARE @AllowIt INT;
  SET @AllowIt=1;
  DECLARE @MaxRisk INT;
  SELECT @MaxRisk = ISNULL(MAX(RiskScore),0) FROM DrugReaction
    WHERE CHARINDEX(ATC,@ATC) = 1 AND PersonId=@PersonId AND ( Relatedness>1 ) AND ( DeletedAt IS NULL );
  IF @MaxRisk >= 12 SET @AllowIt=0;
  RETURN @AllowIt;
END
GO

GRANT EXECUTE ON [dbo].[AllowDrug] TO [FastTrak]
GO