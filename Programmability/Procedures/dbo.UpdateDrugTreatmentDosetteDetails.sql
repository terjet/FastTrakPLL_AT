SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateDrugTreatmentDosetteDetails]( 
  @TreatId INTEGER, 
  @Dose08 DECIMAL(8,2), @Dose13 DECIMAL(8,2),
  @Dose18 DECIMAL(8,2), @Dose21 DECIMAL(8,2),  @ChangedAt DateTime = NULL ) AS 
BEGIN
  EXEC Drug.UpdateDrugTreatmentDosetteDetails @TreatId, 0, @Dose08, @Dose13, @Dose18, @Dose21, 0, @ChangedAt;
END;
GO

DENY EXECUTE ON [dbo].[UpdateDrugTreatmentDosetteDetails] TO [ReadOnly]
GO