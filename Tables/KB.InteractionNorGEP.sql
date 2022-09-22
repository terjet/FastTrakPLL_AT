CREATE TABLE [KB].[InteractionNorGEP] (
  [Id] [int] NOT NULL,
  [NgId] [int] NOT NULL,
  [IntId] [int] NOT NULL,
  [AlertClass] AS ('DRUID#'+CONVERT([varchar],[IntId],(0))),
  CONSTRAINT [PK_InteractionNorGEP] PRIMARY KEY CLUSTERED ([Id])
)
ON [PRIMARY]
GO

GRANT SELECT ON [KB].[InteractionNorGEP] TO [FastTrak]
GO