CREATE TABLE [dbo].[ClinDrugIndication] (
  [IndicationId] [int] IDENTITY,
  [ProbId] [int] NOT NULL,
  [TreatId] [int] NOT NULL,
  [Checked] [bit] NULL CONSTRAINT [DF_ClinDrugIndication_Checked] DEFAULT (1),
  [CreatedAt] [datetime] NULL CONSTRAINT [DF_ClinDrugIndication_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_ClinDrugIndication_CreatedBy] DEFAULT (user_id()),
  CONSTRAINT [PK_ClinDrugIndication] PRIMARY KEY CLUSTERED ([IndicationId])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_ClinDrugIndication_ProbTreat]
  ON [dbo].[ClinDrugIndication] ([ProbId], [TreatId])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ClinDrugIndication]
  ADD CONSTRAINT [FK_ClinDrugIndication_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinDrugIndication]
  ADD CONSTRAINT [FK_ClinDrugIndication_ProbId] FOREIGN KEY ([ProbId]) REFERENCES [dbo].[ClinProblem] ([ProbId])
GO

ALTER TABLE [dbo].[ClinDrugIndication]
  ADD CONSTRAINT [FK_ClinDrugIndication_TreatId] FOREIGN KEY ([TreatId]) REFERENCES [dbo].[DrugTreatment] ([TreatId]) ON DELETE CASCADE
GO