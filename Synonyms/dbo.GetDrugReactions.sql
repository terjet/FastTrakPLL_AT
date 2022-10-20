CREATE SYNONYM [dbo].[GetDrugReactions] FOR [Drug].[GetAdverseReactions]
GO

GRANT EXECUTE ON [dbo].[GetDrugReactions] TO [DrugEditor]
GO