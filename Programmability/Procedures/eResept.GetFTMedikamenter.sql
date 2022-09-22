SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[GetFTMedikamenter] (@PersonId INT) AS
BEGIN
  SELECT dt.TreatId, dt.ATC, dt.DrugName, dt.StartAt, dt.StartReason, dt.StopAt, dt.Strength, dt.StrengthUnit, dt.DrugForm
  FROM dbo.DrugTreatment dt
  WHERE dt.PersonId = @PersonId;
END
GO

GRANT EXECUTE ON [eResept].[GetFTMedikamenter] TO [FastTrak]
GO