SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddDrugReaction] ( @PersonId integer, @TreatId integer,
  @DRDate datetime, @DRFuzzy integer, @ATC varchar(7), @DrugName varchar(64), 
  @DescriptiveText text,
  @Severity integer, @Relatedness integer, @Resolved integer )
AS
BEGIN
  INSERT INTO DrugReaction( DRDate, DRFuzzy, PersonId, ATC, DrugName, DescriptiveText, Severity, Relatedness, Resolved  )
  VALUES
   (@DRDate, @DRFuzzy, @PersonId, @ATC, @DrugName, @DescriptiveText, @Severity, @Relatedness, @Resolved  );
  SELECT  SCOPE_IDENTITY() AS DRId;
END;
GO

GRANT EXECUTE ON [dbo].[AddDrugReaction] TO [FastTrak]
GO