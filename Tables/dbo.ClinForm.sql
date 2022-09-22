CREATE TABLE [dbo].[ClinForm] (
  [ClinFormId] [int] IDENTITY,
  [EventId] [int] NOT NULL,
  [FormId] [int] NOT NULL,
  [FormOwner] [int] NOT NULL CONSTRAINT [DF_ClinForm_FormOwner] DEFAULT (user_id()),
  [FormPriority] [char](1) NOT NULL CONSTRAINT [DF_ClinForm_FormPriority] DEFAULT ('B'),
  [FormDue] [datetime] NULL,
  [Comment] [varchar](max) NULL,
  [MemoHeight] [int] NULL,
  [FormStatus] [char](1) NOT NULL CONSTRAINT [DF_ClinForm_FormStatus] DEFAULT ('E'),
  [FormComplete] [tinyint] NOT NULL CONSTRAINT [DF_ClinForm_FormComplete] DEFAULT (0),
  [CachedText] [varchar](max) NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_ClinForm_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_ClinForm_CreatedBy] DEFAULT (user_id()),
  [SignedAt] [datetime] NULL,
  [SignedBy] [int] NULL,
  [DeletedAt] [datetime] NULL,
  [DeletedBy] [int] NULL,
  [guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ClinForm_guid] DEFAULT (newid()) ROWGUIDCOL,
  [Archived] [bit] NOT NULL CONSTRAINT [DF_ClinForm_Archived] DEFAULT (0),
  [CreatedSessId] [int] NULL,
  [SignedSessId] [int] NULL,
  [LastTouchId] [int] NULL,
  [FormCompleteRequired] [smallint] NULL,
  CONSTRAINT [PK_ClinForm] PRIMARY KEY CLUSTERED ([ClinFormId]),
  CONSTRAINT [C_ClinForm_Timing] CHECK ([SignedAt] IS NULL OR [SignedAt]>[CreatedAt])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_ClinForm_EventFormId]
  ON [dbo].[ClinForm] ([EventId], [FormId])
  ON [PRIMARY]
GO

CREATE INDEX [I_ClinForm_FormId]
  ON [dbo].[ClinForm] ([FormId])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_ClinForm_Update] ON [dbo].[ClinForm]
AFTER UPDATE AS 
BEGIN   
   IF UPDATE(Comment) OR UPDATE (SignedAt) OR UPDATE(DeletedAt)                 
     INSERT INTO dbo.ClinFormLog( ClinFormId, Comment, FormStatus, FormComplete, SignedAt, SignedBy, DeletedAt, DeletedBy )
     SELECT o.ClinFormId, o.Comment, o.FormStatus, o.FormComplete, o.SignedAt, o.SignedBy, o.DeletedAt, o.DeletedBy 
     FROM deleted o;
END
GO

ALTER TABLE [dbo].[ClinForm]
  ADD CONSTRAINT [FK_ClinForm_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinForm]
  ADD CONSTRAINT [FK_ClinForm_CreatedSessId] FOREIGN KEY ([CreatedSessId]) REFERENCES [dbo].[UserLog] ([SessId])
GO

ALTER TABLE [dbo].[ClinForm]
  ADD CONSTRAINT [FK_ClinForm_DeletedBy] FOREIGN KEY ([DeletedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinForm] WITH NOCHECK
  ADD CONSTRAINT [FK_ClinForm_EventId] FOREIGN KEY ([EventId]) REFERENCES [dbo].[ClinEvent] ([EventId])
GO

ALTER TABLE [dbo].[ClinForm] WITH NOCHECK
  ADD CONSTRAINT [FK_ClinForm_FormId] FOREIGN KEY ([FormId]) REFERENCES [dbo].[MetaForm] ([FormId])
GO

ALTER TABLE [dbo].[ClinForm]
  ADD CONSTRAINT [FK_ClinForm_FormOwner] FOREIGN KEY ([FormOwner]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinForm] WITH NOCHECK
  ADD CONSTRAINT [FK_ClinForm_FormStatus] FOREIGN KEY ([FormStatus]) REFERENCES [dbo].[MetaFormStatus] ([FormStatus]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[ClinForm]
  ADD CONSTRAINT [FK_ClinForm_LastTouchId] FOREIGN KEY ([LastTouchId]) REFERENCES [dbo].[ClinTouch] ([TouchId])
GO

ALTER TABLE [dbo].[ClinForm]
  ADD CONSTRAINT [FK_ClinForm_SignedBy] FOREIGN KEY ([SignedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinForm]
  ADD CONSTRAINT [FK_ClinForm_SignedSessId] FOREIGN KEY ([SignedSessId]) REFERENCES [dbo].[UserLog] ([SessId])
GO