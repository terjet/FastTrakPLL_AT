CREATE TABLE [dbo].[DrugPrescription] (
  [PrescId] [int] IDENTITY,
  [TreatId] [int] NOT NULL,
  [CodeId] [int] NULL,
  [PackName] [varchar](64) NULL,
  [PackSize] [float] NULL,
  [PackSizeUnit] [varchar](24) NULL,
  [PackCount] [int] NULL,
  [Refills] [int] NULL,
  [RxText] [varchar](max) NULL,
  [RxType] [int] NULL,
  [RxPrint] [int] NULL,
  [CreatedAt] [datetime] NULL CONSTRAINT [DF_DrugPrescription_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_DrugPrescription_CreatedBy] DEFAULT (user_id()),
  [DeletedAt] [datetime] NULL,
  [PrintedAt] [datetime] NULL,
  [PrintedBy] [int] NULL,
  [ProbCode] [varchar](8) NULL,
  [DeletedBy] [int] NULL,
  [PrescribedAt] AS ([CreatedAt]),
  [PrescribedBy] AS ([CreatedBy]),
  CONSTRAINT [PK_DrugPrescription] PRIMARY KEY CLUSTERED ([PrescId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[DrugPrescription] WITH NOCHECK
  ADD CONSTRAINT [FK_DrugPrescription_CodeId] FOREIGN KEY ([CodeId]) REFERENCES [dbo].[MetaReimbursementCode] ([CodeId])
GO

ALTER TABLE [dbo].[DrugPrescription]
  ADD CONSTRAINT [FK_DrugPrescription_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugPrescription]
  ADD CONSTRAINT [FK_DrugPrescription_DeletedBy] FOREIGN KEY ([DeletedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugPrescription]
  ADD CONSTRAINT [FK_DrugPrescription_PrintedBy] FOREIGN KEY ([PrintedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugPrescription] WITH NOCHECK
  ADD CONSTRAINT [FK_DrugPrescription_RxType] FOREIGN KEY ([RxType]) REFERENCES [dbo].[MetaRxType] ([RxType])
GO

ALTER TABLE [dbo].[DrugPrescription]
  ADD CONSTRAINT [FK_DrugPrescription_TreatId] FOREIGN KEY ([TreatId]) REFERENCES [dbo].[DrugTreatment] ([TreatId])
GO