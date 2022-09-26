SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetRoasForms] AS
BEGIN
  SELECT FormId FROM dbo.MetaForm 
  WHERE FormName IN ( 'Addison', 'Autoimmunitet', 'APS1', 'Hypopara', 'OvaryInsufficiency','ROAS_COVID' ); 
END
GO

GRANT EXECUTE ON [ENDO].[GetRoasForms] TO [DataImport]
GO

GRANT EXECUTE ON [ENDO].[GetRoasForms] TO [FastTrak]
GO