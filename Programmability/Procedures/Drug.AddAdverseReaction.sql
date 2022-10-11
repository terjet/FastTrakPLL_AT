SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Drug].[AddAdverseReaction] ( 
  @PersonId INT, @TreatId INT, @DRDate DATETIME, @DRFuzzy INT, @ATC VARCHAR(7), @DrugName VARCHAR(256), 
  @DescriptiveText text, @Severity integer, @Relatedness integer, @Resolved integer ) AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO dbo.DrugReaction( DRDate, DRFuzzy, PersonId, ATC, TreatId, DrugName, DescriptiveText, Severity, Relatedness, Resolved  )
  OUTPUT inserted.*
  VALUES
   (@DRDate, @DRFuzzy, @PersonId, @ATC, @TreatId, @DrugName, @DescriptiveText, @Severity, @Relatedness, @Resolved  );
END;
GO

GRANT EXECUTE ON [Drug].[AddAdverseReaction] TO [FastTrak]
GO