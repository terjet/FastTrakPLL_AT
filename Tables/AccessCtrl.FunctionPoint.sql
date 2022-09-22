CREATE TABLE [AccessCtrl].[FunctionPoint] (
  [FunctionPointId] [varchar](64) NOT NULL,
  [DefaultAccessState] [int] NOT NULL,
  CONSTRAINT [PK_FunctionPoint] PRIMARY KEY CLUSTERED ([FunctionPointId])
)
ON [PRIMARY]
GO

ALTER TABLE [AccessCtrl].[FunctionPoint]
  ADD CONSTRAINT [FK_AccessCtrl_FunctionPoint_DefaultAccessState] FOREIGN KEY ([DefaultAccessState]) REFERENCES [AccessCtrl].[MetaAccessState] ([AccessStateId])
GO