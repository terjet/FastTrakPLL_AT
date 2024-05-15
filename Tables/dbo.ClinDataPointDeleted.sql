CREATE TABLE [dbo].[ClinDataPointDeleted] (
  [RowId] [int] NOT NULL,
  [ItemId] [int] NOT NULL,
  [EventId] [int] NOT NULL,
  [TouchId] [int] NOT NULL,
  [ClinFormId] [int] NOT NULL,
  [ObsDate] [datetime] NOT NULL,
  [Quantity] [decimal](18, 4) NULL,
  [DTVal] [datetime] NULL,
  [EnumVal] [int] NULL,
  [TextVal] [varchar](max) NULL,
  [Locked] [int] NOT NULL,
  [LockedAt] [datetime] NULL,
  [LockedBy] [int] NULL,
  [ChangeCount] [tinyint] NOT NULL,
  [DeletedAt] [datetime] NOT NULL CONSTRAINT [DF_ClinDataPointDeleted_DeletedAt] DEFAULT (getdate()),
  [DeletedBy] [int] NOT NULL CONSTRAINT [DF_ClinDataPointDeleted_DeletedBy] DEFAULT (user_id()),
  [RestoredAt] [datetime] NULL,
  [RestoredBy] [int] NULL,
  [guid] [uniqueidentifier] NOT NULL,
  CONSTRAINT [PK_ClinDataPointDeleted] PRIMARY KEY CLUSTERED ([RowId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[ClinDataPointDeleted] TO [FastTrak]
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [dbo].[ClinDataPointDeleted] TO [public]
GO

ALTER TABLE [dbo].[ClinDataPointDeleted]
  ADD CONSTRAINT [FK_ClinDataPointDeleted_ClinFormId] FOREIGN KEY ([ClinFormId]) REFERENCES [dbo].[ClinForm] ([ClinFormId])
GO

ALTER TABLE [dbo].[ClinDataPointDeleted]
  ADD CONSTRAINT [FK_ClinDataPointDeleted_DeletedBy] FOREIGN KEY ([DeletedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinDataPointDeleted]
  ADD CONSTRAINT [FK_ClinDataPointDeleted_EventId] FOREIGN KEY ([EventId]) REFERENCES [dbo].[ClinEvent] ([EventId])
GO

ALTER TABLE [dbo].[ClinDataPointDeleted]
  ADD CONSTRAINT [FK_ClinDataPointDeleted_ItemId] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[MetaItem] ([ItemId])
GO

ALTER TABLE [dbo].[ClinDataPointDeleted]
  ADD CONSTRAINT [FK_ClinDataPointDeleted_LockedBy] FOREIGN KEY ([LockedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinDataPointDeleted]
  ADD CONSTRAINT [FK_ClinDataPointDeleted_RestoredBy] FOREIGN KEY ([RestoredBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinDataPointDeleted]
  ADD CONSTRAINT [FK_ClinDataPointDeleted_TouchId] FOREIGN KEY ([TouchId]) REFERENCES [dbo].[ClinTouch] ([TouchId])
GO