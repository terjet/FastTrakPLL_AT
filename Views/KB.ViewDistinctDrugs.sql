SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [KB].[ViewDistinctDrugs]
AS
  SELECT DISTINCT PersonId,ATC FROM DrugTreatment WHERE ( ( StopAt IS NULL) OR ( StopAt > getdate() ) )
GO