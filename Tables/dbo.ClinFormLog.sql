CREATE TABLE [dbo].[ClinFormLog] (
  [ClinFormId] [int] NOT NULL,
  [Comment] [varchar](max) NULL,
  [CreatedAt] [datetime] NULL CONSTRAINT [DF_ClinFormLog_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_ClinFormLog_CreatedBy] DEFAULT (user_id()),
  [ClinFormLogId] [int] IDENTITY,
  [FormStatus] [char](1) NULL,
  [FormComplete] [tinyint] NULL,
  [SignedAt] [datetime] NULL,
  [SignedBy] [int] NULL,
  [DeletedAt] [datetime] NULL,
  [DeletedBy] [int] NULL,
  CONSTRAINT [PK_ClinFormLog] PRIMARY KEY CLUSTERED ([ClinFormLogId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [I_ClinFormLog_ClinForm]
  ON [dbo].[ClinFormLog] ([ClinFormId])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[ClinFormLog] TO [FastTrak]
GO

ALTER TABLE [dbo].[ClinFormLog]
  ADD CONSTRAINT [FK_ClinFormLog_ClinFormId] FOREIGN KEY ([ClinFormId]) REFERENCES [dbo].[ClinForm] ([ClinFormId])
GO

ALTER TABLE [dbo].[ClinFormLog]
  ADD CONSTRAINT [FK_ClinFormLog_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinFormLog]
  ADD CONSTRAINT [FK_ClinFormLog_DeletedBy] FOREIGN KEY ([DeletedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinFormLog]
  ADD CONSTRAINT [FK_ClinFormLog_SignedBy] FOREIGN KEY ([SignedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO