CREATE TABLE [PROM].[FormMapping] (
  [PromId] [int] NOT NULL,
  [PromUid] [varchar](36) NOT NULL,
  [FormId] [int] NOT NULL,
  [ExpireDays] [int] NOT NULL CONSTRAINT [DF_FormMapping_ExpireDays] DEFAULT (14),
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_FormMapping_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_FormMapping_CreatedBy] DEFAULT (user_id()),
  [ValidFrom] [datetime] NOT NULL CONSTRAINT [DF_FormMapping_ValidFrom] DEFAULT (getdate()),
  [ValidUntil] [datetime] NOT NULL CONSTRAINT [DF_FormMapping_ValidUntil] DEFAULT (getdate()),
  CONSTRAINT [PK_PROM_FormMapping] PRIMARY KEY CLUSTERED ([PromId])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_PROM_PromUid]
  ON [PROM].[FormMapping] ([PromUid])
  ON [PRIMARY]
GO

ALTER TABLE [PROM].[FormMapping]
  ADD CONSTRAINT [FK_PROM_FormMapping_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [PROM].[FormMapping]
  ADD CONSTRAINT [FK_PROM_FormMapping_FormId] FOREIGN KEY ([FormId]) REFERENCES [dbo].[MetaForm] ([FormId])
GO