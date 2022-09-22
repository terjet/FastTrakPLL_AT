CREATE TABLE [dbo].[DSSRuleExecute] (
  [RunId] [bigint] IDENTITY,
  [PersonId] [int] NOT NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_DSSRuleExecute_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_DSSRuleExecute_CreatedBy] DEFAULT (user_id()),
  [StudyRuleId] [int] NOT NULL,
  [MsElapsed] [int] NULL,
  CONSTRAINT [PK_DSSRuleExecute] PRIMARY KEY CLUSTERED ([RunId])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[DSSRuleExecute] TO [FastTrak]
GO

ALTER TABLE [dbo].[DSSRuleExecute]
  ADD CONSTRAINT [FK_DSSRuleExecute_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DSSRuleExecute]
  ADD CONSTRAINT [FK_DSSRuleExecute_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO