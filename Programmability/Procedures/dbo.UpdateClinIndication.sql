SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateClinIndication]( @ProbId INT, @TreatId INT, @Checked BIT ) AS
BEGIN
  UPDATE ClinDrugIndication SET Checked = @Checked WHERE ProbId=@ProbId AND TreatId=@TreatId;
  IF @@ROWCOUNT = 0
    INSERT INTO ClinDrugIndication (ProbId,TreatId,Checked) VALUES(@ProbId,@TreatId,@Checked);
END
GO