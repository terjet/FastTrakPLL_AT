CREATE TABLE [dbo].[ClinProblemLog] (
  [ProbLogId] [int] IDENTITY,
  [PersonId] [int] NOT NULL,
  [ProbId] [int] NOT NULL,
  [ProbSummary] [varchar](max) NULL,
  [ProbDebut] [datetime] NULL,
  [ProbType] [char](1) NOT NULL,
  [FamilyStatus] [char](1) NULL,
  [ChangedAt] [datetime] NOT NULL CONSTRAINT [DF_ClinProblemLog_ChangedAt] DEFAULT (getdate()),
  [ChangedBy] [int] NOT NULL CONSTRAINT [DF_ClinProblemLog_ChangedBy] DEFAULT (user_id()),
  PRIMARY KEY CLUSTERED ([ProbLogId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ClinProblemLog]
  ADD CONSTRAINT [FK_ClinProblemLog_ChangedBy] FOREIGN KEY ([ChangedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinProblemLog]
  ADD CONSTRAINT [FK_ClinProblemLog_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [dbo].[ClinProblemLog]
  ADD CONSTRAINT [FK_ClinProblemLog_ProbId] FOREIGN KEY ([ProbId]) REFERENCES [dbo].[ClinProblem] ([ProbId]) ON DELETE CASCADE
GO