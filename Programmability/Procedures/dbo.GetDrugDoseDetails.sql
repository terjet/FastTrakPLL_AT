SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugDoseDetails]( @TreatId INT ) AS
BEGIN
  SELECT dd.* FROM DrugDosing dd JOIN DrugTreatment dt ON dt.DoseId=dd.DoseId AND dt.TreatId=@TreatId
END
GO

GRANT EXECUTE ON [dbo].[GetDrugDoseDetails] TO [FastTrak]
GO