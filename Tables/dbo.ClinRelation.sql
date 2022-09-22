CREATE TABLE [dbo].[ClinRelation] (
  [ClinRelId] [int] IDENTITY,
  [PersonId] [int] NULL,
  [UserId] [int] NULL,
  [RelId] [int] NULL,
  [CreatedAt] [datetime] NULL CONSTRAINT [DF_ClinRelation_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_ClinRelation_CreatedBy] DEFAULT (user_id()),
  [ExpiresAt] [datetime] NULL,
  CONSTRAINT [PK_ClinRelation] PRIMARY KEY CLUSTERED ([ClinRelId])
)
ON [PRIMARY]
GO

CREATE INDEX [I_ClinRelation_PersonId]
  ON [dbo].[ClinRelation] ([PersonId])
  ON [PRIMARY]
GO

CREATE INDEX [I_ClinRelation_UserId]
  ON [dbo].[ClinRelation] ([UserId])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_ClinRelation_UserIdPersonId]
  ON [dbo].[ClinRelation] ([PersonId], [UserId])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[ClinRelation] TO [FastTrak]
GO

ALTER TABLE [dbo].[ClinRelation]
  ADD CONSTRAINT [FK_ClinRelation_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinRelation]
  ADD CONSTRAINT [FK_ClinRelation_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ClinRelation] WITH NOCHECK
  ADD CONSTRAINT [FK_ClinRelation_RelId] FOREIGN KEY ([RelId]) REFERENCES [dbo].[MetaRelation] ([RelId])
GO

ALTER TABLE [dbo].[ClinRelation]
  ADD CONSTRAINT [FK_ClinRelation_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[UserList] ([UserId])
GO