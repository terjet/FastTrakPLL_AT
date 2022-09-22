CREATE TABLE [dbo].[ClinThreadData] (
  [RowId] [int] IDENTITY,
  [EventId] [int] NOT NULL,
  [TouchId] [int] NOT NULL,
  [ItemId] [int] NOT NULL,
  [ThreadId] [int] NOT NULL,
  [Quantity] [decimal](18, 4) NULL,
  [DTVal] [datetime] NULL,
  [EnumVal] [int] NULL,
  [TextVal] [varchar](max) NULL,
  [ObsDate] [datetime] NULL CONSTRAINT [DF_ClinThreadData_ObsDate] DEFAULT (getdate()),
  [Locked] [int] NULL CONSTRAINT [DF_ClinThreadData_Locked] DEFAULT (0),
  [LockedAt] [datetime] NULL,
  [LockedBy] [int] NULL,
  [ChangeCount] [tinyint] NULL CONSTRAINT [DF_ClinThreadData_ChangeCount] DEFAULT (0),
  CONSTRAINT [PK_ClinThreadData] PRIMARY KEY CLUSTERED ([RowId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_ClinThread_EventItemThread]
  ON [dbo].[ClinThreadData] ([EventId], [ItemId], [ThreadId])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_ClinThreadData_Delete] ON [dbo].[ClinThreadData]
AFTER DELETE AS 
BEGIN
  INSERT INTO CRF.ClinThreadDataDeleted (RowId, ItemId, ThreadId, EventId, TouchId, ObsDate, Quantity, DTVal, EnumVal, TextVal, ChangeCount, Locked, LockedAt, LockedBy )
  SELECT d.RowId, d.ItemId, d.ThreadId, d.EventId, d.TouchId, d.ObsDate, d.Quantity, d.DTVal, d.EnumVal, d.TextVal, d.ChangeCount, d.Locked, d.LockedAt, d.LockedBy 
  FROM deleted d
END
GO

GRANT SELECT ON [dbo].[ClinThreadData] TO [FastTrak]
GO

ALTER TABLE [dbo].[ClinThreadData]
  ADD CONSTRAINT [FK_ClinThreadData_EventId] FOREIGN KEY ([EventId]) REFERENCES [dbo].[ClinEvent] ([EventId])
GO

ALTER TABLE [dbo].[ClinThreadData]
  ADD CONSTRAINT [FK_ClinThreadData_ItemId] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[MetaItem] ([ItemId])
GO

ALTER TABLE [dbo].[ClinThreadData]
  ADD CONSTRAINT [FK_ClinThreadData_LockedBy] FOREIGN KEY ([LockedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinThreadData]
  ADD CONSTRAINT [FK_ClinThreadData_ThreadId] FOREIGN KEY ([ThreadId]) REFERENCES [dbo].[ClinThread] ([ThreadId]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ClinThreadData]
  ADD CONSTRAINT [FK_ClinThreadData_TouchId] FOREIGN KEY ([TouchId]) REFERENCES [dbo].[ClinTouch] ([TouchId])
GO