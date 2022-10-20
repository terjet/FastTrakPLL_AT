SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Drug].[AddAdverseReaction] ( 
  @PersonId INT, @TreatId INT, @DRDate DATETIME, @DRFuzzy INT, @ATC VARCHAR(7), @DrugName VARCHAR(256), 
  @DescriptiveText text, @Severity integer, @Relatedness integer, @Resolved integer ) AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO dbo.DrugReaction( DRDate, DRFuzzy, PersonId, ATC, TreatId, DrugName, DescriptiveText, Severity, Relatedness, Resolved  ) 
  VALUES ( @DRDate, @DRFuzzy, @PersonId, @ATC, NULLIF(@TreatId,0), @DrugName, @DescriptiveText, @Severity, @Relatedness, @Resolved  );
  SELECT dr.*, ms.*, mr.*, mo.*  
  FROM dbo.DrugReaction dr 
    JOIN dbo.MetaSeverity ms ON ms.SevId = dr.Severity
    JOIN dbo.MetaRelatedness mr ON mr.RelId = dr.Relatedness
    JOIN dbo.MetaResolution mo ON mo.ResId = dr.Resolved  
    WHERE DRId = SCOPE_IDENTITY();
END;
GO