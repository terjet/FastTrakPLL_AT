CREATE TABLE [dbo].[PersonAbstraction] (
  [RowId] [int] IDENTITY,
  [PersonId] [int] NULL,
  [Weight] [decimal](6, 1) NULL,
  [Height] [decimal](6, 1) NULL,
  [BMI] [float] NULL,
  [MustScore] [int] NULL,
  CONSTRAINT [PK_PersonAbstraction] PRIMARY KEY CLUSTERED ([RowId])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[PersonAbstraction] WITH NOCHECK
  ADD CONSTRAINT [FK_PersonAbstraction_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO