CREATE TABLE [AccessCtrl].[MetaAccessState] (
  [AccessStateId] [int] IDENTITY,
  [AccessStateDescription] [varchar](24) NOT NULL,
  CONSTRAINT [PK_MetaAccessState] PRIMARY KEY CLUSTERED ([AccessStateId])
)
ON [PRIMARY]
GO