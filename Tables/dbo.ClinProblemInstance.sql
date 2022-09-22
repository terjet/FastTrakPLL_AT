CREATE TABLE [dbo].[ClinProblemInstance] (
  [ProbInstId] [int] IDENTITY,
  [ProbId] [int] NULL,
  [ProbDate] [datetime] NULL,
  [ProbType] [char](1) NULL,
  CONSTRAINT [PK_ClinProblemInstance] PRIMARY KEY CLUSTERED ([ProbInstId])
)
ON [PRIMARY]
GO

CREATE INDEX [I_ClinProblemInstance_ProbId]
  ON [dbo].[ClinProblemInstance] ([ProbId])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ClinProblemInstance]
  ADD CONSTRAINT [FK_ClinProblemInstance_ProbId] FOREIGN KEY ([ProbId]) REFERENCES [dbo].[ClinProblem] ([ProbId]) ON DELETE CASCADE
GO