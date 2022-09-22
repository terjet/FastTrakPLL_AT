CREATE TABLE [dbo].[ClinTouch] (
  [TouchId] [int] IDENTITY,
  [EventId] [int] NOT NULL,
  [SessId] [int] NOT NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_ClinTouch_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_ClinTouch_CreatedBy] DEFAULT (user_id()),
  [FormId] [int] NULL,
  [guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ClinTouch_guid] DEFAULT (newid()) ROWGUIDCOL,
  CONSTRAINT [PK_ClinTouch] PRIMARY KEY CLUSTERED ([TouchId])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[ClinTouch] TO [FastTrak]
GO

GRANT INSERT ON [dbo].[ClinTouch] TO [superuser]
GO

ALTER TABLE [dbo].[ClinTouch]
  ADD CONSTRAINT [FK_ClinTouch_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinTouch]
  ADD CONSTRAINT [FK_ClinTouch_EventId] FOREIGN KEY ([EventId]) REFERENCES [dbo].[ClinEvent] ([EventId])
GO

ALTER TABLE [dbo].[ClinTouch]
  ADD CONSTRAINT [FK_ClinTouch_FormId] FOREIGN KEY ([FormId]) REFERENCES [dbo].[MetaForm] ([FormId])
GO

ALTER TABLE [dbo].[ClinTouch]
  ADD CONSTRAINT [FK_ClinTouch_SessId] FOREIGN KEY ([SessId]) REFERENCES [dbo].[UserLog] ([SessId])
GO