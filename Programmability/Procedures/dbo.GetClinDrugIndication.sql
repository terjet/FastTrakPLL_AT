SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetClinDrugIndication]( @TreatId INT )
AS
BEGIN
  SELECT ProbId,Checked FROM ClinDrugIndication WHERE TreatId=@TreatId AND Checked=1;
END
GO

GRANT EXECUTE ON [dbo].[GetClinDrugIndication] TO [FastTrak]
GO