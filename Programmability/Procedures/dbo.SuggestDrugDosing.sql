SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SuggestDrugDosing]( @ATC VARCHAR(7), @DoseCode VARCHAR(24), @TreatType CHAR(1), @PackType CHAR(1) ) AS
BEGIN
  SELECT TOP 10 Dose07, Dose08, Dose13, Dose18, Dose21, Dose23, COUNT(*) AS DoseCount 
  FROM dbo.DrugDosing dd 
  JOIN DrugTreatment dt ON dt.TreatId=dd.DoseId 
  WHERE dt.ATC = @ATC AND dt.TreatType = @TreatType AND dt.PackType = @PackType 
    AND dt.DoseCode = ISNULL( NULLIF( @DoseCode,'' ), dt.DoseCode ) AND dt.StopAt IS NULL
  GROUP BY Dose07, Dose08, Dose13, Dose18, Dose21, Dose23
  HAVING COUNT(*) > 5
  ORDER BY COUNT(*) DESC
END
GO