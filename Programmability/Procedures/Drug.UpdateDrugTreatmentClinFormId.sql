SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Drug].[UpdateDrugTreatmentClinFormId]( @TreatId INT, @ClinFormId INT ) AS
BEGIN  
  SET NOCOUNT ON;
  UPDATE dbo.DrugTreatment SET ClinFormId = @ClinFormId WHERE TreatId = @TreatId;
END;
GO

GRANT EXECUTE ON [Drug].[UpdateDrugTreatmentClinFormId] TO [DrugEditor]
GO