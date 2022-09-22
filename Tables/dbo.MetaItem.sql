CREATE TABLE [dbo].[MetaItem] (
  [ItemId] [int] NOT NULL,
  [VarName] [varchar](64) NOT NULL,
  [ItemType] [int] NOT NULL,
  [CreatedAt] [datetime] NULL CONSTRAINT [DF_MetaItem_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_MetaItem_CreatedBy] DEFAULT (user_id()),
  [MarkForExport] [int] NULL,
  [UnitStr] [varchar](16) NULL,
  [MinNormal] [decimal](12, 2) NULL,
  [MaxNormal] [decimal](12, 2) NULL,
  [ThreadTypeId] [int] NULL,
  [LastUpdate] [datetime] NULL,
  [LabName] [varchar](40) NULL,
  [Multiline] [bit] NULL,
  [LabClassId] [int] NULL,
  [ProcId] [int] NULL,
  [SCTID] [bigint] NULL,
  [ValidationPattern] [varchar](64) NULL,
  CONSTRAINT [PK_MetaItem] PRIMARY KEY CLUSTERED ([ItemId])
)
ON [PRIMARY]
GO

CREATE INDEX [I_MetaItem_VarName]
  ON [dbo].[MetaItem] ([VarName])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaItem] TO [FastTrak]
GO

ALTER TABLE [dbo].[MetaItem]
  ADD CONSTRAINT [FK_MetaItem_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[MetaItem]
  ADD CONSTRAINT [FK_MetaItem_ItemType] FOREIGN KEY ([ItemType]) REFERENCES [dbo].[MetaItemType] ([ItemType])
GO

ALTER TABLE [dbo].[MetaItem]
  ADD CONSTRAINT [FK_MetaItem_LabClassId] FOREIGN KEY ([LabClassId]) REFERENCES [dbo].[LabClass] ([LabClassId])
GO

ALTER TABLE [dbo].[MetaItem]
  ADD CONSTRAINT [FK_MetaItem_ProcId] FOREIGN KEY ([ProcId]) REFERENCES [dbo].[DbProcList] ([ProcId])
GO

ALTER TABLE [dbo].[MetaItem]
  ADD CONSTRAINT [FK_MetaItem_SCTID] FOREIGN KEY ([SCTID]) REFERENCES [SnomedCT].[Concept] ([SCTID])
GO

ALTER TABLE [dbo].[MetaItem]
  ADD CONSTRAINT [FK_MetaItem_ThreadTypeId] FOREIGN KEY ([ThreadTypeId]) REFERENCES [dbo].[MetaThreadType] ([V])
GO