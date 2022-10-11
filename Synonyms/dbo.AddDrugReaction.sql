CREATE SYNONYM [dbo].[AddDrugReaction] FOR [Drug].[AddAdverseReaction]
GO

GRANT EXECUTE ON [dbo].[AddDrugReaction] TO [DrugEditor]
GO