CREATE TABLE [dbo].[DrugTreatment] (
  [TreatId] [int] IDENTITY,
  [PersonId] [int] NOT NULL,
  [ATC] [varchar](7) NULL,
  [ATCVersion] [int] NULL CONSTRAINT [DF_DrugTreatment_ATCVersion] DEFAULT (0),
  [DrugName] [varchar](128) NOT NULL,
  [DrugForm] [varchar](64) NULL,
  [TreatType] [char](1) NOT NULL CONSTRAINT [DF_DrugTreatment_TreatType] DEFAULT ('X'),
  [PackType] [char](1) NOT NULL CONSTRAINT [DF_DrugTreatment_PackType] DEFAULT ('X'),
  [TreatPackType] AS ([TreatType]+[PackType]),
  [Strength] [decimal](12, 4) NULL,
  [StrengthUnit] [varchar](24) NULL,
  [Dose24hCount] [decimal](12, 4) NULL,
  [Dose24hDD] AS ([Strength]*[Dose24hCount]),
  [StartAt] [datetime] NOT NULL,
  [StartFuzzy] [int] NULL,
  [StartReason] [varchar](64) NULL,
  [RxText] [varchar](max) NULL,
  [StopAt] [datetime] NULL,
  [StopFuzzy] [int] NULL,
  [StopReason] [varchar](64) NULL,
  [DoseCode] [varchar](32) NULL,
  [PauseStatus] [int] NULL CONSTRAINT [DF_DrugTreatment_PauseStatus] DEFAULT (0),
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_DrugTreatment_CreatedAt] DEFAULT (getdate()),
  [DoseId] [int] NULL,
  [StartedBy] [int] NULL CONSTRAINT [DF_DrugTreatment_StartedBy] DEFAULT (user_id()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_DrugTreatment_CreatedBy] DEFAULT (user_id()),
  [StopBy] [int] NULL,
  [BatchId] [int] NULL,
  [SignedBy] [int] NULL,
  [SignedAt] [datetime] NULL,
  [StopAuthorizedByName] [varchar](30) NULL,
  [ClinFormId] [int] NULL,
  [DoseUnit] [varchar](24) NULL,
  [FMLibId] [varchar](40) NULL,
  [Forskrivningskladd] [bit] NOT NULL CONSTRAINT [DF_DrugTreatment_Forskrivningskladd] DEFAULT (0),
  [FMUpdated] [bit] NULL,
  [InteraksjonsNiva] [int] NULL,
  [InteraksjonsKommentar] [varchar](max) NULL,
  [DobbeltForskrivningsvarsel] [varchar](max) NULL,
  [CaveIdList] [varchar](max) NULL,
  [CAVE] [varchar](max) NULL,
  [SeponertAv] [varchar](max) NULL,
  [Seponeringsgrunn] [varchar](max) NULL,
  [Seponeringskladd] [bit] NOT NULL CONSTRAINT [DF_DrugTreatment_Seponeringskladd] DEFAULT (0),
  [RegistrertAv] [varchar](max) NULL,
  [VarselSlvTypeV] [int] NULL,
  [VarselSlvTypeDN] [varchar](50) NULL,
  [VarselSlvOverskrift] [varchar](100) NULL,
  [VarselSlvTekst] [varchar](max) NULL,
  CONSTRAINT [PK_DrugTreatment] PRIMARY KEY CLUSTERED ([TreatId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [I_DrugTreatment_ClinFormId]
  ON [dbo].[DrugTreatment] ([ClinFormId])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_DrugTreatment_ATC]
  ON [dbo].[DrugTreatment] ([ATC])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_DrugTreatment_PersonId]
  ON [dbo].[DrugTreatment] ([PersonId])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[DrugTreatment] TO [FastTrak]
GO

ALTER TABLE [dbo].[DrugTreatment]
  ADD CONSTRAINT [FK_DrugTreatment_BatchId] FOREIGN KEY ([BatchId]) REFERENCES [dbo].[ImportBatch] ([BatchId]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[DrugTreatment]
  ADD CONSTRAINT [FK_DrugTreatment_ClinFormId] FOREIGN KEY ([ClinFormId]) REFERENCES [dbo].[ClinForm] ([ClinFormId])
GO

ALTER TABLE [dbo].[DrugTreatment]
  ADD CONSTRAINT [FK_DrugTreatment_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugTreatment] WITH NOCHECK
  ADD CONSTRAINT [FK_DrugTreatment_PackType] FOREIGN KEY ([PackType]) REFERENCES [dbo].[MetaPackType] ([PackType]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[DrugTreatment] WITH NOCHECK
  ADD CONSTRAINT [FK_DrugTreatment_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [dbo].[DrugTreatment]
  ADD CONSTRAINT [FK_DrugTreatment_SignedBy] FOREIGN KEY ([SignedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugTreatment]
  ADD CONSTRAINT [FK_DrugTreatment_StartedBy] FOREIGN KEY ([StartedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugTreatment]
  ADD CONSTRAINT [FK_DrugTreatment_StopBy] FOREIGN KEY ([StopBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugTreatment] WITH NOCHECK
  ADD CONSTRAINT [FK_DrugTreatment_TreatType] FOREIGN KEY ([TreatType]) REFERENCES [dbo].[MetaTreatType] ([TreatType]) ON UPDATE CASCADE
GO