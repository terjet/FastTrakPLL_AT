CREATE TABLE [CRF].[ClinThreadDataDeleted] (
  [RowId] [int] NOT NULL,
  [EventId] [int] NOT NULL,
  [TouchId] [int] NOT NULL,
  [ItemId] [int] NOT NULL,
  [ThreadId] [int] NOT NULL,
  [ObsDate] [datetime] NOT NULL,
  [Quantity] [decimal](18, 4) NULL,
  [DTVal] [datetime] NULL,
  [EnumVal] [int] NULL,
  [TextVal] [varchar](max) NULL,
  [Locked] [int] NOT NULL,
  [LockedAt] [datetime] NULL,
  [LockedBy] [int] NULL,
  [ChangeCount] [tinyint] NOT NULL,
  PRIMARY KEY CLUSTERED ([RowId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [CRF].[ClinThreadDataDeleted]
  ADD CONSTRAINT [FK_CRF_ClinThreadDataDeleted_EventId] FOREIGN KEY ([EventId]) REFERENCES [dbo].[ClinEvent] ([EventId])
GO

ALTER TABLE [CRF].[ClinThreadDataDeleted]
  ADD CONSTRAINT [FK_CRF_ClinThreadDataDeleted_ItemId] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[MetaItem] ([ItemId])
GO

ALTER TABLE [CRF].[ClinThreadDataDeleted]
  ADD CONSTRAINT [FK_CRF_ClinThreadDataDeleted_LockedBy] FOREIGN KEY ([LockedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [CRF].[ClinThreadDataDeleted]
  ADD CONSTRAINT [FK_CRF_ClinThreadDataDeleted_TouchId] FOREIGN KEY ([TouchId]) REFERENCES [dbo].[ClinTouch] ([TouchId])
GO