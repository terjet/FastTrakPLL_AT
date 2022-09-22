CREATE TABLE [dbo].[ImportContext] (
  [ContextId] [int] IDENTITY,
  [StudyId] [int] NOT NULL,
  [ContextName] [varchar](64) NOT NULL,
  [LastUpdate] [datetime] NULL,
  CONSTRAINT [PK_ImportContext] PRIMARY KEY CLUSTERED ([ContextId])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_ImportContext_ContextName]
  ON [dbo].[ImportContext] ([StudyId], [ContextName])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[ImportContext] TO [FastTrak]
GO

ALTER TABLE [dbo].[ImportContext]
  ADD CONSTRAINT [FK_ImportContext_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId])
GO