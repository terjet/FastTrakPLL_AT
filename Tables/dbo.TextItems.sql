CREATE TABLE [dbo].[TextItems] (
  [ScopeName] [varchar](24) NOT NULL,
  [KeyName] [varchar](64) NOT NULL,
  [TextValue] [varchar](512) NULL,
  [TextId] [int] NOT NULL,
  [ChkSum] [int] NOT NULL CONSTRAINT [DF_TextItems_ChkSum] DEFAULT (0),
  CONSTRAINT [PK_TextItems] PRIMARY KEY CLUSTERED ([TextId])
)
ON [PRIMARY]
GO