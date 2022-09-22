CREATE TABLE [CRF].[ClinThreadForm] (
  [ClinThreadFormId] [int] IDENTITY,
  [FormId] [int] NOT NULL,
  [ThreadId] [int] NOT NULL,
  [ClinFormId] [int] NOT NULL,
  [ItemId] [int] NOT NULL,
  [FormStatus] [char](1) NOT NULL CONSTRAINT [DF_ClinThreadForm_FormStatus] DEFAULT ('E'),
  [FormComplete] [tinyint] NOT NULL CONSTRAINT [DF_ClinThreadForm_FormComplete] DEFAULT (0),
  [FormCompleteRequired] [smallint] NULL,
  [CachedText] [varchar](max) NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_ClinThreadForm_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_ClinThreadForm_CreatedBy] DEFAULT (user_id()),
  PRIMARY KEY CLUSTERED ([ClinThreadFormId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [CRF].[T_ClinThreadForm_Delete] ON [CRF].[ClinThreadForm]
AFTER DELETE AS 
BEGIN
  INSERT INTO CRF.ClinThreadFormDeleted (ClinThreadFormId, FormId, ThreadId, ClinFormId, ItemId, 
    FormStatus, FormComplete, FormCompleteRequired, CachedText, CreatedAt, CreatedBy)
  SELECT D.ClinThreadFormId, D.FormId, D.ThreadId, D.ClinFormId, D.ItemId,
    D.FormStatus, D.FormComplete, D.FormCompleteRequired, D.CachedText, D.CreatedAt, D.CreatedBy
  FROM DELETED D;
END
GO

ALTER TABLE [CRF].[ClinThreadForm]
  ADD CONSTRAINT [FK_CRF_ClinThreadForm_ClinFormId] FOREIGN KEY ([ClinFormId]) REFERENCES [dbo].[ClinForm] ([ClinFormId])
GO

ALTER TABLE [CRF].[ClinThreadForm]
  ADD CONSTRAINT [FK_CRF_ClinThreadForm_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [CRF].[ClinThreadForm]
  ADD CONSTRAINT [FK_CRF_ClinThreadForm_FormId] FOREIGN KEY ([FormId]) REFERENCES [dbo].[MetaForm] ([FormId])
GO

ALTER TABLE [CRF].[ClinThreadForm]
  ADD CONSTRAINT [FK_CRF_ClinThreadForm_ItemId] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[MetaItem] ([ItemId])
GO

ALTER TABLE [CRF].[ClinThreadForm]
  ADD CONSTRAINT [FK_CRF_ClinThreadForm_ThreadId] FOREIGN KEY ([ThreadId]) REFERENCES [dbo].[ClinThread] ([ThreadId]) ON DELETE CASCADE
GO