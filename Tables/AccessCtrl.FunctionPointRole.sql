CREATE TABLE [AccessCtrl].[FunctionPointRole] (
  [FunctionPointId] [varchar](64) NOT NULL,
  [RoleName] [sysname] NOT NULL,
  [AccessStateId] [int] NOT NULL,
  CONSTRAINT [PK_FunctionPointRole] PRIMARY KEY CLUSTERED ([FunctionPointId], [RoleName])
)
ON [PRIMARY]
GO

ALTER TABLE [AccessCtrl].[FunctionPointRole]
  ADD CONSTRAINT [FK_AccessCtrl_FunctionPointRole_AccessStateId] FOREIGN KEY ([AccessStateId]) REFERENCES [AccessCtrl].[MetaAccessState] ([AccessStateId])
GO

ALTER TABLE [AccessCtrl].[FunctionPointRole]
  ADD CONSTRAINT [FK_AccessCtrl_FunctionPointRole_FunctionPointId] FOREIGN KEY ([FunctionPointId]) REFERENCES [AccessCtrl].[FunctionPoint] ([FunctionPointId])
GO