CREATE TABLE [dbo].[MetaNomListItem] (
  [ListItem] [int] NOT NULL,
  [ListId] [int] NOT NULL,
  [ItemId] [int] NOT NULL,
  [Popularity] [int] NOT NULL CONSTRAINT [DF_MetaNomListItem_Popularity] DEFAULT (0),
  [LastUpdate] [datetime] NULL,
  [IsActive] [bit] NULL,
  CONSTRAINT [PK_MetaNomListItem] PRIMARY KEY CLUSTERED ([ListItem])
)
ON [PRIMARY]
GO

CREATE INDEX [I_ListItem_ListPopularity]
  ON [dbo].[MetaNomListItem] ([ListId], [Popularity] DESC)
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_NomListItem_ListItem]
  ON [dbo].[MetaNomListItem] ([ListId], [ItemId])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaNomListItem] TO [FastTrak]
GO

ALTER TABLE [dbo].[MetaNomListItem]
  ADD CONSTRAINT [FK_MetaNomListItem_ItemId] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[MetaNomItem] ([ItemId])
GO

ALTER TABLE [dbo].[MetaNomListItem]
  ADD CONSTRAINT [FK_MetaNomListItem_ListId] FOREIGN KEY ([ListId]) REFERENCES [dbo].[MetaNomList] ([ListId])
GO