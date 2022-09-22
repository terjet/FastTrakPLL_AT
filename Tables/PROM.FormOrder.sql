CREATE TABLE [PROM].[FormOrder] (
  [RowId] [int] IDENTITY,
  [PersonId] [int] NOT NULL,
  [FormId] [int] NOT NULL,
  [FormOrderId] [varchar](36) NOT NULL,
  [ExpiryDate] [datetime] NULL,
  [LoginUrl] [varchar](255) NULL,
  [OTP] [varchar](16) NULL,
  [OrderStatus] [varchar](16) NULL,
  [ClinFormId] [int] NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_FormOrder_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_FormOrder_CreatedBy] DEFAULT (user_id()),
  [PromUid] [varchar](36) NULL,
  [NotificationChannel] [varchar](32) NULL,
  CONSTRAINT [PK_PROM_FormOrder] PRIMARY KEY CLUSTERED ([RowId])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_PROM_FormOrder_ClinFormId]
  ON [PROM].[FormOrder] ([ClinFormId])
  WHERE ([ClinFormId] IS NOT NULL)
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_PROM_FormOrder_FormOrderId]
  ON [PROM].[FormOrder] ([FormOrderId])
  ON [PRIMARY]
GO

ALTER TABLE [PROM].[FormOrder]
  ADD CONSTRAINT [FK_PROM_FormOrder_ClinFormId] FOREIGN KEY ([ClinFormId]) REFERENCES [dbo].[ClinForm] ([ClinFormId])
GO

ALTER TABLE [PROM].[FormOrder]
  ADD CONSTRAINT [FK_PROM_FormOrder_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [PROM].[FormOrder]
  ADD CONSTRAINT [FK_PROM_FormOrder_FormId] FOREIGN KEY ([FormId]) REFERENCES [dbo].[MetaForm] ([FormId])
GO

ALTER TABLE [PROM].[FormOrder]
  ADD CONSTRAINT [FK_PROM_FormOrder_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO