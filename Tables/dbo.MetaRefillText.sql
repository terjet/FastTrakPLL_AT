CREATE TABLE [dbo].[MetaRefillText] (
  [Refills] [int] NOT NULL,
  [RefillText] [varchar](10) NOT NULL,
  CONSTRAINT [PK_MetaRefillText] PRIMARY KEY CLUSTERED ([Refills])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaRefillText] TO [FastTrak]
GO