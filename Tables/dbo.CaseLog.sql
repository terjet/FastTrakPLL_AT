CREATE TABLE [dbo].[CaseLog] (
  [LogId] [int] IDENTITY,
  [PersonId] [int] NOT NULL,
  [LogText] [varchar](255) NOT NULL,
  [LogType] [varchar](8) NOT NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_CaseLog_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_CaseLog_CreatedBy] DEFAULT (user_id()),
  CONSTRAINT [PK_CaseLog] PRIMARY KEY CLUSTERED ([LogId])
)
ON [PRIMARY]
GO

CREATE INDEX [I_CaseLog_CreatedAt]
  ON [dbo].[CaseLog] ([CreatedAt])
  ON [PRIMARY]
GO

CREATE INDEX [I_CaseLog_CreatedBy]
  ON [dbo].[CaseLog] ([CreatedBy])
  ON [PRIMARY]
GO

CREATE INDEX [I_CaseLog_LogType]
  ON [dbo].[CaseLog] ([LogType])
  ON [PRIMARY]
GO

CREATE INDEX [I_CaseLog_PersonId]
  ON [dbo].[CaseLog] ([PersonId])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[CaseLog] TO [FastTrak]
GO

ALTER TABLE [dbo].[CaseLog]
  ADD CONSTRAINT [FK_CaseLog_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[CaseLog]
  ADD CONSTRAINT [FK_CaseLog_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId]) ON DELETE CASCADE
GO