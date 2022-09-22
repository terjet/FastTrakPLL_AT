CREATE TABLE [dbo].[DrugDosing] (
  [DoseId] [int] IDENTITY,
  [TreatId] [int] NOT NULL,
  [TreatType] [char](1) NOT NULL,
  [PackType] [char](1) NOT NULL,
  [ValidFrom] [datetime] NOT NULL,
  [ValidUntil] [datetime] NULL,
  [Dose07] [decimal](8, 2) NOT NULL CONSTRAINT [DF_DrugDosing_Dose07] DEFAULT (0),
  [Dose08] [decimal](8, 2) NOT NULL CONSTRAINT [DF_DrugDosing_Dose08] DEFAULT (0),
  [Dose18] [decimal](8, 2) NOT NULL CONSTRAINT [DF_DrugDosing_Dose18] DEFAULT (0),
  [Dose13] [decimal](8, 2) NOT NULL CONSTRAINT [DF_DrugDosing_Dose13] DEFAULT (0),
  [Dose21] [decimal](8, 2) NOT NULL CONSTRAINT [DF_DrugDosing_Dose21] DEFAULT (0),
  [Dose23] [decimal](8, 2) NOT NULL CONSTRAINT [DF_DrugDosing_Dose23] DEFAULT (0),
  [DoseMon] [decimal](8, 2) NOT NULL CONSTRAINT [DF_DrugDosing_DoseMon] DEFAULT (0),
  [DoseTue] [decimal](8, 2) NOT NULL CONSTRAINT [DF_DrugDosing_DoseTue] DEFAULT (0),
  [DoseWed] [decimal](8, 2) NOT NULL CONSTRAINT [DF_DrugDosing_DoseWed] DEFAULT (0),
  [DoseThu] [decimal](8, 2) NOT NULL CONSTRAINT [DF_DrugDosing_DoseThu] DEFAULT (0),
  [DoseFri] [decimal](8, 2) NOT NULL CONSTRAINT [DF_DrugDosing_DoseFri] DEFAULT (0),
  [DoseSat] [decimal](8, 2) NOT NULL CONSTRAINT [DF_DrugDosing_DoseSat] DEFAULT (0),
  [DoseSun] [decimal](8, 2) NOT NULL CONSTRAINT [DF_DrugDosing_DoseSun] DEFAULT (0),
  [DoseHour] [tinyint] NULL,
  [DoseSum] AS ((((([Dose07]+[Dose08])+[Dose13])+[Dose18])+[Dose21])+[Dose23]),
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_DrugDosing_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_DrugDosing_CreatedBy] DEFAULT (user_id()),
  CONSTRAINT [PK_DrugDosing] PRIMARY KEY CLUSTERED ([DoseId]),
  CONSTRAINT [C_DrugDosing_HourCheck] CHECK ([DoseHour] IS NULL OR ([DoseHour]<(24) OR [DoseHour]>=(0)))
)
ON [PRIMARY]
GO

CREATE INDEX [I_DrugDosing_TreatId]
  ON [dbo].[DrugDosing] ([DoseId])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[DrugDosing] TO [FastTrak]
GO

ALTER TABLE [dbo].[DrugDosing]
  ADD CONSTRAINT [FK_DrugDosing_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugDosing] WITH NOCHECK
  ADD CONSTRAINT [FK_DrugDosing_PackType] FOREIGN KEY ([PackType]) REFERENCES [dbo].[MetaPackType] ([PackType])
GO

ALTER TABLE [dbo].[DrugDosing] WITH NOCHECK
  ADD CONSTRAINT [FK_DrugDosing_TreatId] FOREIGN KEY ([TreatId]) REFERENCES [dbo].[DrugTreatment] ([TreatId])
GO

ALTER TABLE [dbo].[DrugDosing] WITH NOCHECK
  ADD CONSTRAINT [FK_DrugDosing_TreatType] FOREIGN KEY ([TreatType]) REFERENCES [dbo].[MetaTreatType] ([TreatType])
GO