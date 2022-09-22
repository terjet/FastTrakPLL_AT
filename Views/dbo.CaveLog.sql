SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[CaveLog] AS SELECT PersonId, Content, ChangedAt AS CreatedAt, ChangedBy AS CreatedBy 
FROM dbo.PersonDocumentLog WHERE DocumentId=50001
GO

GRANT SELECT ON [dbo].[CaveLog] TO [FastTrak]
GO