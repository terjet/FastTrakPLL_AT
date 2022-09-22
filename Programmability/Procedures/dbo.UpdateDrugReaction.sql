SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateDrugReaction]( @DRId INT,
  @DRDate datetime, @DRFuzzy integer, @DescriptiveText text,
  @Severity integer, @Relatedness integer, @Resolved integer )
AS
BEGIN
  UPDATE DrugReaction SET DRDate=@DRDate, DRFuzzy=@DRFuzzy, DescriptiveText=@DescriptiveText,
    Severity=@Severity, Relatedness=@Relatedness, Resolved=@Resolved 
  WHERE DRId=@DRId;
END
GO

GRANT EXECUTE ON [dbo].[UpdateDrugReaction] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdateDrugReaction] TO [ReadOnly]
GO