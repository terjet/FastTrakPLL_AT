SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ViewDrugList] (ATC, DrugName, DrugForm, Strength, StrengthUnit, SubstanceName,DrugNameFormStrength) 
AS
SELECT
  ATC,DrugName,DrugForm,Strength,StrengthUnit,SubstanceName,DrugNameFormStrength
FROM dbo.PIA
GO

GRANT SELECT ON [dbo].[ViewDrugList] TO [FastTrak]
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [dbo].[ViewDrugList] TO [public]
GO