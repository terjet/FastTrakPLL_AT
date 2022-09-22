CREATE TABLE [dbo].[PopulationLog] (
  [LogId] [int] IDENTITY,
  [StudyId] [int] NULL,
  [ProcId] [int] NULL,
  [ProcDesc] [varchar](64) NULL,
  [MsElapsed] [decimal](9, 2) NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_PopulationLog_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_PopulationLog_CreatedBy] DEFAULT (user_id()),
  CONSTRAINT [PK_PopulationLog] PRIMARY KEY CLUSTERED ([LogId])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[PopulationLog]
  ADD CONSTRAINT [FK_PopulationLog_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[PopulationLog]
  ADD CONSTRAINT [FK_PopulationLog_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId])
GO