SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Drug].[GetCustomDrugForms]( @StudyId INT ) AS
BEGIN
  SELECT 
     DrugFormId, StudyId, FormName, AtcPattern, ReplacesDrugDosing, AddByDefault,
	 InfoHeader, InfoMessage
  FROM dbo.MetaDrugForm
  WHERE StudyId = @StudyId AND DisabledAt IS NULL;
END
GO