SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FEST].[GetMatchingDrugs]( @SearchText VARCHAR(32), @Strength FLOAT = NULL ) AS
BEGIN
  SET @SearchText=@SearchText + '%';   
  IF @Strength = 0 SET @Strength = NULL;
  SELECT ATC, DrugNameFormStrength, DrugName, DrugForm, Strength, StrengthUnit, SubstanceName, DoseUnit 
  FROM dbo.PIA 
  WHERE ( ( SubstanceName LIKE @SearchText ) OR ( DrugName LIKE @SearchText ) OR ( ATC LIKE @SearchText) ) 
    AND ( ( @Strength IS NULL ) OR ( @Strength = Strength ) ); 
END
GO

GRANT EXECUTE ON [FEST].[GetMatchingDrugs] TO [FastTrak]
GO