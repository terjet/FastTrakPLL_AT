SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugTreatDetails]( @TreatId INT ) AS
BEGIN
  SELECT dt.*,a.AtcName as SubstanceName FROM DrugTreatment dt 
  LEFT OUTER JOIN KBAtcIndex a ON a.AtcCode=dt.ATC
  WHERE dt.TreatId=@TreatId
END
GO

GRANT EXECUTE ON [dbo].[GetDrugTreatDetails] TO [FastTrak]
GO