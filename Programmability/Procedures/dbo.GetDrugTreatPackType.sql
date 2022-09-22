SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugTreatPackType]( @ATC VARCHAR(7), @DoseCode VARCHAR(24) = NULL )
AS
BEGIN
  IF @DoseCode = '' SET @DoseCode = NULL;
  SELECT TreatType,PackType,count(*) As ComboCount FROM DrugTreatment
  WHERE ( ATC=@ATC ) AND ( DoseCode=@DoseCode OR @DoseCode IS NULL ) AND ( StopAt IS NULL ) 
  GROUP BY TreatType,PackType ORDER BY Count(*) DESC
END
GO

GRANT EXECUTE ON [dbo].[GetDrugTreatPackType] TO [FastTrak]
GO