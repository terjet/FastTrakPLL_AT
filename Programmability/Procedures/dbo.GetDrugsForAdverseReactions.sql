SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugsForAdverseReactions]( @PersonId INT ) AS
BEGIN
  SELECT DISTINCT ATC, DrugName, DrugForm, NULL AS StartReason, NULL AS DoseCode,NULL AS StrengthUnit, NULL AS Strength 
  FROM dbo.DrugTreatment 
  WHERE PersonId=@PersonId AND DATALENGTH(ATC)>2 
  ORDER BY DrugName;
END
GO