CREATE TABLE [dbo].[MetaItemType] (
  [ItemType] [int] NOT NULL,
  [Description] [varchar](32) NOT NULL,
  [LoincScale] [varchar](4) NULL,
  [Active] [bit] NOT NULL,
  [HasData] [bit] NOT NULL,
  CONSTRAINT [PK_MetaItemType] PRIMARY KEY CLUSTERED ([ItemType])
)
ON [PRIMARY]
GO