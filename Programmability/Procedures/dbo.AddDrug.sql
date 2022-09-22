SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddDrug]( @PersonId INTEGER, 
  @ATC VARCHAR(7), @DrugName VARCHAR(64), @DrugForm VARCHAR(64), @Strength DECIMAL(12, 4), @StrengthUnit VARCHAR(24), 
  @Dose24hCount DECIMAL(12, 4), @StartAt DATETIME, @StartFuzzy INTEGER, @StartReason VARCHAR(64), 
  @DoseCode VARCHAR(24), @RxText VARCHAR(MAX), @TreatType CHAR(1), @BatchId INTEGER = NULL) 
AS
BEGIN
   EXEC dbo.AddDrugTreatment 
     @PersonId, @ATC, @DrugName, @DrugForm, @Strength, @StrengthUnit,
     @Dose24hCount, @StartAt, @StartFuzzy, @StartReason, @DoseCode, @RxText, @TreatType, 'X', @BatchId;
END
GO