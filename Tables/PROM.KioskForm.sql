CREATE TABLE [PROM].[KioskForm] (
  [RowId] [int] IDENTITY,
  [FormOrderId] [varchar](36) NULL,
  [ClinFormId] [int] NOT NULL,
  [FormTag] [varchar](8) NOT NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_KioskForm_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_KioskForm_CreatedBy] DEFAULT (user_id()),
  PRIMARY KEY CLUSTERED ([RowId])
)
ON [PRIMARY]
GO

ALTER TABLE [PROM].[KioskForm]
  ADD CONSTRAINT [FK_PROM_KioskForm_ClinFormId] FOREIGN KEY ([ClinFormId]) REFERENCES [dbo].[ClinForm] ([ClinFormId]) ON DELETE CASCADE
GO

ALTER TABLE [PROM].[KioskForm]
  ADD CONSTRAINT [FK_PROM_KioskForm_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO