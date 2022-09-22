CREATE TABLE [dbo].[DrugTemplate] (
  [FriendlyName] [varchar](64) NOT NULL,
  [ATC] [varchar](7) NOT NULL,
  [DrugName] [varchar](64) NOT NULL,
  [DrugForm] [varchar](64) NOT NULL,
  [Strength] [decimal](12, 4) NULL,
  [StrengthUnit] [varchar](24) NULL,
  [DoseCode] [varchar](24) NOT NULL,
  [StartReason] [varchar](64) NOT NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_DrugTemplate_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_DrugTemplate_CreatedBy] DEFAULT (user_id()),
  [UpdatedBy] [int] NULL,
  [UpdatedAt] [datetime] NULL,
  [TemplateId] [int] IDENTITY,
  [DoseUnit] [varchar](24) NULL,
  CONSTRAINT [PK_DrugTemplate] PRIMARY KEY CLUSTERED ([FriendlyName])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_DrugTemplate_ATC]
  ON [dbo].[DrugTemplate] ([ATC])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[DrugTemplate] TO [FastTrak]
GO

ALTER TABLE [dbo].[DrugTemplate]
  ADD CONSTRAINT [FK_DrugTemplate_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugTemplate]
  ADD CONSTRAINT [FK_DrugTemplate_UpdatedBy] FOREIGN KEY ([UpdatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO