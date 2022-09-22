CREATE TABLE [dbo].[MetaThreadType] (
  [V] [int] NOT NULL,
  [DN] [varchar](32) NOT NULL,
  [ThreadNames] [varchar](max) NULL,
  [FixedThreads] [bit] NULL,
  [NewThreadName] [varchar](32) NULL,
  CONSTRAINT [PK_MetaThreadType] PRIMARY KEY CLUSTERED ([V])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaThreadType] TO [FastTrak]
GO