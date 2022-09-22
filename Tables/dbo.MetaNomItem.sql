CREATE TABLE [dbo].[MetaNomItem] (
  [ItemId] [int] NOT NULL,
  [ItemCode] [varchar](8) NOT NULL,
  [ItemName] [varchar](max) NULL,
  [LastUpdate] [datetime] NULL,
  CONSTRAINT [PK_MetaNomItem] PRIMARY KEY CLUSTERED ([ItemId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [I_MetaNomItem_ItemCode]
  ON [dbo].[MetaNomItem] ([ItemCode])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaNomItem] TO [FastTrak]
GO