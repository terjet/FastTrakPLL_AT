CREATE TABLE [dbo].[MetaReimbursementCode] (
  [CodeId] [int] NOT NULL,
  [CodeText] [varchar](6) NOT NULL,
  [CodeHeader] [varchar](64) NOT NULL,
  [OID7427] [int] NULL,
  CONSTRAINT [PK_MetaReimbursementCode] PRIMARY KEY CLUSTERED ([CodeId])
)
ON [PRIMARY]
GO