CREATE TABLE [dbo].[ClinProblem] (
  [ProbId] [int] IDENTITY,
  [PersonId] [int] NOT NULL,
  [ListItem] [int] NOT NULL,
  [ProbType] [char](1) NOT NULL CONSTRAINT [DF_ClinProblem_ProbType] DEFAULT ('A'),
  [ProbSummary] [varchar](max) NULL,
  [ProbSortOrder] [int] NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_ClinProblem_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_ClinProblem_CreatedBy] DEFAULT (user_id()),
  [UpdatedAt] [datetime] NULL,
  [UpdatedBy] [int] NULL,
  [ProbDebut] [datetime] NULL,
  [BatchId] [int] NULL,
  [Priority] [int] NULL,
  [FamilyStatus] [char](1) NULL,
  CONSTRAINT [PK_ClinProblem] PRIMARY KEY CLUSTERED ([ProbId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [I_ClinProblem_ListItem]
  ON [dbo].[ClinProblem] ([ListItem])
  ON [PRIMARY]
GO

CREATE INDEX [I_ClinProblem_PersonId]
  ON [dbo].[ClinProblem] ([PersonId])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_ClinProblem_PersonProb]
  ON [dbo].[ClinProblem] ([PersonId], [ListItem])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_ClinProblem_Update] ON [dbo].[ClinProblem]
AFTER UPDATE AS 
 BEGIN
  INSERT INTO dbo.ClinProblemLog 
    ( PersonId, ProbId, ProbSummary, ProbDebut, ProbType, FamilyStatus )
  SELECT 
    PersonId, ProbId, ProbSummary, ProbDebut, ProbType, FamilyStatus
  FROM deleted;  
END
GO

ALTER TABLE [dbo].[ClinProblem]
  ADD CONSTRAINT [FK_ClinProblem_BatchId] FOREIGN KEY ([BatchId]) REFERENCES [dbo].[ImportBatch] ([BatchId]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ClinProblem]
  ADD CONSTRAINT [FK_ClinProblem_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinProblem] WITH NOCHECK
  ADD CONSTRAINT [FK_ClinProblem_ListItem] FOREIGN KEY ([ListItem]) REFERENCES [dbo].[MetaNomListItem] ([ListItem])
GO

ALTER TABLE [dbo].[ClinProblem] WITH NOCHECK
  ADD CONSTRAINT [FK_ClinProblem_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [dbo].[ClinProblem] WITH NOCHECK
  ADD CONSTRAINT [FK_ClinProblem_ProbType] FOREIGN KEY ([ProbType]) REFERENCES [dbo].[MetaProblemType] ([ProbType])
GO

ALTER TABLE [dbo].[ClinProblem]
  ADD CONSTRAINT [FK_ClinProblem_UpdatedBy] FOREIGN KEY ([UpdatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO