CREATE TABLE [dbo].[MetaRxType] (
  [RxType] [int] NOT NULL,
  [RxTypeName] [varchar](16) NULL,
  CONSTRAINT [PK_MetaRxType] PRIMARY KEY CLUSTERED ([RxType])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaRxType] TO [FastTrak]
GO