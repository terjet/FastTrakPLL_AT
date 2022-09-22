CREATE TABLE [dbo].[MetaDrugForm] (
  [DrugFormId] [int] NOT NULL,
  [StudyId] [int] NOT NULL,
  [FormName] [varchar](32) NOT NULL,
  [AtcPattern] [varchar](32) NOT NULL,
  [InfoHeader] [varchar](64) NOT NULL,
  [InfoMessage] [varchar](max) NOT NULL,
  [ReplacesDrugDosing] [bit] NOT NULL,
  [AddByDefault] [bit] NOT NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_MetaDrugForm_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_MetaDrugForm_CreatedBy] DEFAULT (user_id()),
  [DisabledAt] [datetime] NULL,
  [DisabledBy] [int] NULL,
  PRIMARY KEY CLUSTERED ([DrugFormId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[MetaDrugForm]
  ADD CONSTRAINT [FK_MetaDrugForm_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[MetaDrugForm]
  ADD CONSTRAINT [FK_MetaDrugForm_DisabledBy] FOREIGN KEY ([DisabledBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[MetaDrugForm]
  ADD CONSTRAINT [FK_MetaDrugForm_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId])
GO