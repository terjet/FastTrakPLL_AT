CREATE TABLE [CRF].[ClinThreadDeleted] (
  [ThreadId] [int] NOT NULL,
  [StudyId] [int] NOT NULL,
  [PersonId] [int] NOT NULL,
  [ThreadName] [varchar](24) NULL,
  [ThreadTypeId] [int] NOT NULL,
  [CreatedAt] [datetime] NOT NULL,
  [CreatedBy] [int] NOT NULL,
  [EventId] [int] NULL,
  [SortOrder] [int] NULL,
  [DeletedAt] [datetime] NOT NULL CONSTRAINT [DF_ClinThreadDeleted_DeletedAt] DEFAULT (getdate()),
  [DeletedBy] [int] NOT NULL CONSTRAINT [DF_ClinThreadDeleted_DeletedBy] DEFAULT (user_id()),
  PRIMARY KEY CLUSTERED ([ThreadId])
)
ON [PRIMARY]
GO

ALTER TABLE [CRF].[ClinThreadDeleted]
  ADD CONSTRAINT [FK_CRF_ClinThreadDeleted_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [CRF].[ClinThreadDeleted]
  ADD CONSTRAINT [FK_CRF_ClinThreadDeleted_DeletedBy] FOREIGN KEY ([DeletedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [CRF].[ClinThreadDeleted]
  ADD CONSTRAINT [FK_CRF_ClinThreadDeleted_EventId] FOREIGN KEY ([EventId]) REFERENCES [dbo].[ClinEvent] ([EventId])
GO

ALTER TABLE [CRF].[ClinThreadDeleted]
  ADD CONSTRAINT [FK_CRF_ClinThreadDeleted_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [CRF].[ClinThreadDeleted]
  ADD CONSTRAINT [FK_CRF_ClinThreadDeleted_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId])
GO

ALTER TABLE [CRF].[ClinThreadDeleted]
  ADD CONSTRAINT [FK_CRF_ClinThreadDeleted_ThreadTypeId] FOREIGN KEY ([ThreadTypeId]) REFERENCES [dbo].[MetaThreadType] ([V])
GO