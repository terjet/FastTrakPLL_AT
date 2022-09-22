SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetFavoriteDrugs] AS
BEGIN
  SELECT TemplateId, 
    DrugName  + ' ' + DrugForm + ' ' + ISNULL(dbo.GetShortNumber( Strength ),'') + ' ' + ISNULL(StrengthUnit,''),
    '' AS DummyField,StartReason FROM DrugTemplate  
END
GO

GRANT EXECUTE ON [dbo].[GetFavoriteDrugs] TO [FastTrak]
GO