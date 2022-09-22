CREATE TABLE [dbo].[PersonDocumentLog] (
  [LogId] [int] IDENTITY,
  [PersonId] [int] NOT NULL,
  [DocumentId] [int] NOT NULL,
  [Content] [varchar](max) NULL,
  [ChangedAt] [datetime] NULL CONSTRAINT [DF_PersonDocumentLog_ChangedAt] DEFAULT (getdate()),
  [ChangedBy] [int] NULL CONSTRAINT [DF_PersonDocumentLog_ChangedBy] DEFAULT (user_id()),
  CONSTRAINT [PK_PersonDocumentLog] PRIMARY KEY CLUSTERED ([LogId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[PersonDocumentLog]
  ADD CONSTRAINT [FK_PersonDocumentLog_ChangedBy] FOREIGN KEY ([ChangedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[PersonDocumentLog]
  ADD CONSTRAINT [FK_PersonDocumentLog_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO