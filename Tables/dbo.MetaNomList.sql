CREATE TABLE [dbo].[MetaNomList] (
  [ListId] [int] NOT NULL,
  [ListName] [varchar](32) NOT NULL,
  [ListActive] [int] NOT NULL CONSTRAINT [DF_MetaNomList_ListActive] DEFAULT (1),
  [ListVersion] [int] NOT NULL,
  [LCID] [int] NOT NULL,
  [DxSystem] [int] NULL,
  [OID] [int] NULL,
  [LastUpdate] [datetime] NULL,
  CONSTRAINT [PK_MetaNomList] PRIMARY KEY CLUSTERED ([ListId])
)
ON [PRIMARY]
GO