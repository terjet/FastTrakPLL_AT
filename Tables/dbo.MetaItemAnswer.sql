CREATE TABLE [dbo].[MetaItemAnswer] (
  [ItemId] [int] NOT NULL,
  [OrderNumber] [int] NOT NULL,
  [Score] [float] NULL,
  [OptionText] [varchar](max) NOT NULL,
  [VerboseText] [varchar](max) NULL,
  [HelpText] [varchar](max) NULL,
  [ShortCode] [varchar](5) NULL,
  [LastUpdate] [datetime] NULL,
  [AnswerId] [int] NOT NULL,
  [ICD10] [varchar](16) NULL,
  [HtmlColor] [varchar](16) NULL,
  [IsDefaultAnswer] [bit] NULL,
  [SCTID] [bigint] NULL,
  CONSTRAINT [PK_MetaItemAnswer] PRIMARY KEY CLUSTERED ([AnswerId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_MetaItemAnswer_ItemId_OrderNumber]
  ON [dbo].[MetaItemAnswer] ([ItemId], [OrderNumber])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[MetaItemAnswer]
  ADD CONSTRAINT [FK_MetaItemAnswer_ItemId] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[MetaItem] ([ItemId])
GO

ALTER TABLE [dbo].[MetaItemAnswer]
  ADD CONSTRAINT [FK_MetaItemAnswer_SCTID] FOREIGN KEY ([SCTID]) REFERENCES [SnomedCT].[Concept] ([SCTID])
GO