CREATE TABLE [CRF].[ClinThreadFormDeleted] (
  [ClinThreadFormId] [int] NOT NULL,
  [FormId] [int] NOT NULL,
  [ThreadId] [int] NOT NULL,
  [ClinFormId] [int] NOT NULL,
  [ItemId] [int] NOT NULL,
  [FormStatus] [char](1) NOT NULL,
  [FormComplete] [tinyint] NOT NULL,
  [FormCompleteRequired] [smallint] NULL,
  [CachedText] [varchar](max) NULL,
  [CreatedAt] [datetime] NOT NULL,
  [CreatedBy] [int] NOT NULL,
  PRIMARY KEY CLUSTERED ([ClinThreadFormId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [CRF].[ClinThreadFormDeleted]
  ADD CONSTRAINT [FK_CRF_ClinThreadFormDeleted_ClinFormId] FOREIGN KEY ([ClinFormId]) REFERENCES [dbo].[ClinForm] ([ClinFormId])
GO

ALTER TABLE [CRF].[ClinThreadFormDeleted]
  ADD CONSTRAINT [FK_CRF_ClinThreadFormDeleted_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [CRF].[ClinThreadFormDeleted]
  ADD CONSTRAINT [FK_CRF_ClinThreadFormDeleted_FormId] FOREIGN KEY ([FormId]) REFERENCES [dbo].[MetaForm] ([FormId])
GO

ALTER TABLE [CRF].[ClinThreadFormDeleted]
  ADD CONSTRAINT [FK_CRF_ClinThreadFormDeleted_ItemId] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[MetaItem] ([ItemId])
GO