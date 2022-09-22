CREATE TABLE [dbo].[StudCaseLog] (
  [StudCaseLogId] [int] IDENTITY,
  [ChangedAt] [datetime] NULL CONSTRAINT [DF_StudCaseLog_ChangedAt] DEFAULT (getdate()),
  [ChangedBy] [int] NULL CONSTRAINT [DF_StudCaseLog_ChangedBy] DEFAULT (user_id()),
  [StudCaseId] [int] NULL,
  [NewStatusId] [int] NULL,
  [OldStatusId] [int] NULL,
  [NewGroupId] [int] NULL,
  [OldGroupId] [int] NULL,
  [OldHandler] [int] NULL,
  [NewHandler] [int] NULL,
  [OldJournalansvarlig] [int] NULL,
  [NewJournalansvarlig] [int] NULL,
  CONSTRAINT [PK_StudCaseLog] PRIMARY KEY CLUSTERED ([StudCaseLogId])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[StudCaseLog] TO [FastTrak]
GO

ALTER TABLE [dbo].[StudCaseLog]
  ADD CONSTRAINT [FK_StudCaseLog_ChangedBy] FOREIGN KEY ([ChangedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[StudCaseLog]
  ADD CONSTRAINT [FK_StudCaseLog_NewJournalansvarlig] FOREIGN KEY ([NewJournalansvarlig]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[StudCaseLog]
  ADD CONSTRAINT [FK_StudCaseLog_OldJournalansvarlig] FOREIGN KEY ([OldJournalansvarlig]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[StudCaseLog]
  ADD CONSTRAINT [FK_StudCaseLog_StudCaseId] FOREIGN KEY ([StudCaseId]) REFERENCES [dbo].[StudCase] ([StudCaseId]) ON DELETE CASCADE
GO