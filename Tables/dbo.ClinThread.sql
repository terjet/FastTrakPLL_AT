CREATE TABLE [dbo].[ClinThread] (
  [ThreadId] [int] IDENTITY,
  [StudyId] [int] NOT NULL,
  [PersonId] [int] NOT NULL,
  [ThreadName] [varchar](24) NULL,
  [ThreadTypeId] [int] NOT NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_ClinThread_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_ClinThread_CreatedBy] DEFAULT (user_id()),
  [EventId] [int] NULL,
  [SortOrder] [int] NULL,
  CONSTRAINT [PK_ClinThread] PRIMARY KEY CLUSTERED ([ThreadId])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_ClinThread_StudyPersonTypeNameEventId]
  ON [dbo].[ClinThread] ([StudyId], [PersonId], [ThreadTypeId], [ThreadName], [EventId])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_ClinThread_Delete] ON [dbo].[ClinThread]
AFTER DELETE AS 
BEGIN
  INSERT INTO CRF.ClinThreadDeleted (ThreadId, StudyId, PersonId, ThreadName, ThreadTypeId, CreatedAt, CreatedBy, EventId, SortOrder)
  SELECT D.ThreadId, D.StudyId, D.PersonId, D.ThreadName, D.ThreadTypeId, D.CreatedAt, D.CreatedBy, D.EventId, D.SortOrder
  FROM DELETED D
END
GO

ALTER TABLE [dbo].[ClinThread]
  ADD CONSTRAINT [FK_ClinThread_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinThread]
  ADD CONSTRAINT [FK_ClinThread_EventId] FOREIGN KEY ([EventId]) REFERENCES [dbo].[ClinEvent] ([EventId])
GO

ALTER TABLE [dbo].[ClinThread]
  ADD CONSTRAINT [FK_ClinThread_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [dbo].[ClinThread]
  ADD CONSTRAINT [FK_ClinThread_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId])
GO

ALTER TABLE [dbo].[ClinThread]
  ADD CONSTRAINT [FK_ClinThread_ThreadTypeId] FOREIGN KEY ([ThreadTypeId]) REFERENCES [dbo].[MetaThreadType] ([V])
GO