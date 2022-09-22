CREATE TABLE [dbo].[DrugPause] (
  [PauseId] [int] IDENTITY,
  [TreatId] [int] NOT NULL,
  [PausedAt] [datetime] NOT NULL,
  [PauseReason] [varchar](64) NULL,
  [RestartAt] [datetime] NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_DrugPause_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_DrugPause_CreatedBy] DEFAULT (user_id()),
  [PausedBy] [int] NULL CONSTRAINT [DF_DrugPause_PausedBy] DEFAULT (user_id()),
  [RestartBy] [int] NULL,
  [PauseDuration] AS (CONVERT([float],[RestartAt]-[PausedAt],(0))),
  [PauseAuthorizedByName] [varchar](30) NULL,
  CONSTRAINT [PK_DrugPause] PRIMARY KEY CLUSTERED ([PauseId]),
  CONSTRAINT [C_DrugPause_Timing] CHECK ([RestartAt] IS NULL OR [RestartAt]>[PausedAt])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_DrugPause_TreatId]
  ON [dbo].[DrugPause] ([TreatId])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[DrugPause]
  ADD CONSTRAINT [FK_DrugPause_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugPause]
  ADD CONSTRAINT [FK_DrugPause_PausedBy] FOREIGN KEY ([PausedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugPause]
  ADD CONSTRAINT [FK_DrugPause_RestartBy] FOREIGN KEY ([RestartBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugPause]
  ADD CONSTRAINT [FK_DrugPause_TreatId] FOREIGN KEY ([TreatId]) REFERENCES [dbo].[DrugTreatment] ([TreatId])
GO