CREATE TABLE [dbo].[MetaFormPage] (
  [PageId] [int] NOT NULL,
  [FormId] [int] NOT NULL,
  [PageNumber] [int] NOT NULL,
  [PageTitle] [varchar](max) NULL,
  [PageIntroduction] [varchar](max) NULL,
  [LastUpdate] [datetime] NOT NULL,
  CONSTRAINT [PK_MetaFormPage] PRIMARY KEY CLUSTERED ([PageId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [I_MetaFormPage_FormId_PageNumber]
  ON [dbo].[MetaFormPage] ([FormId], [PageNumber])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[MetaFormPage]
  ADD CONSTRAINT [FK_MetaFormPage_FormId] FOREIGN KEY ([FormId]) REFERENCES [dbo].[MetaForm] ([FormId])
GO