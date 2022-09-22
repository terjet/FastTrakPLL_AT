CREATE TABLE [dbo].[MetaReasonType] (
  [ReasonType] [int] NOT NULL,
  [ReasonText] [varchar](32) NOT NULL,
  CONSTRAINT [PK_MetaReasonType] PRIMARY KEY CLUSTERED ([ReasonType])
)
ON [PRIMARY]
GO