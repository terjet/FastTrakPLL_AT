CREATE TABLE [AccessCtrl].[FunctionPointProfession] (
  [FunctionPointId] [varchar](64) NOT NULL,
  [ProfType] [varchar](3) NOT NULL,
  [AccessStateId] [int] NOT NULL,
  CONSTRAINT [PK_FunctionPointProfession] PRIMARY KEY CLUSTERED ([FunctionPointId], [ProfType])
)
ON [PRIMARY]
GO

ALTER TABLE [AccessCtrl].[FunctionPointProfession]
  ADD CONSTRAINT [FK_AccessCtrl_FunctionPointProfession_AccessStateId] FOREIGN KEY ([AccessStateId]) REFERENCES [AccessCtrl].[MetaAccessState] ([AccessStateId])
GO

ALTER TABLE [AccessCtrl].[FunctionPointProfession]
  ADD CONSTRAINT [FK_AccessCtrl_FunctionPointProfession_FunctionPointId] FOREIGN KEY ([FunctionPointId]) REFERENCES [AccessCtrl].[FunctionPoint] ([FunctionPointId])
GO

ALTER TABLE [AccessCtrl].[FunctionPointProfession]
  ADD CONSTRAINT [FK_AccessCtrl_FunctionPointProfession_ProfType] FOREIGN KEY ([ProfType]) REFERENCES [dbo].[MetaProfession] ([ProfType])
GO