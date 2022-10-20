CREATE TABLE [dbo].[DrugReactionLog] (
  [LogId] [int] IDENTITY,
  [DRId] [int] NOT NULL,
  [DRDate] [datetime] NULL,
  [DRFuzzy] [int] NULL,
  [DescriptiveText] [varchar](1024) NULL,
  [Severity] [tinyint] NOT NULL,
  [Relatedness] [tinyint] NOT NULL,
  [Resolved] [tinyint] NULL,
  [ChangedAt] [datetime] NULL,
  [ChangedBy] [int] NULL,
  [DeletedAt] [datetime] NULL,
  [DeletedBy] [int] NULL,
  CONSTRAINT [PK__DrugReactionLog__6497E884] PRIMARY KEY CLUSTERED ([LogId])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[DrugReactionLog] TO [FastTrak]
GO

ALTER TABLE [dbo].[DrugReactionLog]
  ADD CONSTRAINT [FK_DrugReactionLog_ChangedBy] FOREIGN KEY ([ChangedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugReactionLog]
  ADD CONSTRAINT [FK_DrugReactionLog_DeletedBy] FOREIGN KEY ([DeletedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugReactionLog]
  ADD CONSTRAINT [FK_DrugReactionLog_DRId] FOREIGN KEY ([DRId]) REFERENCES [dbo].[DrugReaction] ([DRId]) ON DELETE CASCADE
GO