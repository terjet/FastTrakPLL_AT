CREATE TABLE [dbo].[ClinDataPoint] (
  [RowId] [int] IDENTITY,
  [ObsDate] [datetime] NOT NULL CONSTRAINT [DF_ClinDataPoint_ObsDate] DEFAULT (getdate()),
  [Quantity] [decimal](18, 4) NULL,
  [DTVal] [datetime] NULL,
  [EnumVal] [int] NULL,
  [TextVal] [varchar](max) NULL,
  [Locked] [int] NOT NULL CONSTRAINT [DF_ClinDataPoint_Locked] DEFAULT (0),
  [LockedAt] [datetime] NULL,
  [LockedBy] [int] NULL,
  [EventId] [int] NOT NULL,
  [TouchId] [int] NOT NULL,
  [ChangeCount] [tinyint] NOT NULL CONSTRAINT [DF_ClinDataPoint_ChangeCount] DEFAULT (0),
  [ItemId] [int] NOT NULL,
  [guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ClinDataPoint_guid] DEFAULT (newid()) ROWGUIDCOL,
  CONSTRAINT [PK_ClinData] PRIMARY KEY CLUSTERED ([RowId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [I_ClinData_Locked]
  ON [dbo].[ClinDataPoint] ([Locked])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_ClinDatapoint_EventItem]
  ON [dbo].[ClinDataPoint] ([EventId], [ItemId])
  ON [PRIMARY]
GO

CREATE INDEX [I_ClinDataPoint_ItemId]
  ON [dbo].[ClinDataPoint] ([ItemId])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_ClinDataPoint_Update] ON [dbo].[ClinDataPoint]
AFTER UPDATE AS 
BEGIN
   IF UPDATE(Quantity) OR UPDATE(DTVal) OR UPDATE(EnumVal) OR UPDATE (TextVal)
     INSERT INTO dbo.ClinDataPointLog( RowId, TouchId, ObsDate, Quantity, DTVal, EnumVal, TextVal )
       SELECT o.RowId, o.TouchId, o.ObsDate, o.Quantity, o.DTVal, o.EnumVal, o.TextVal 
       FROM deleted o
     JOIN inserted i ON i.RowId = o.RowId
     WHERE  
       ISNULL( i.Quantity, -123456789 ) <> ISNULL( o.Quantity, -123456789 ) OR
       ISNULL( i.EnumVal, -1 ) <> ISNULL( o.EnumVal, -1 ) OR
       ISNULL( i.DTVal, -1 ) <> ISNULL( o.DTVal, -1 ) OR
       ISNULL( i.TextVal, '' ) <> ISNULL( o.TextVal, '' );
END
GO

GRANT SELECT ON [dbo].[ClinDataPoint] TO [FastTrak]
GO

ALTER TABLE [dbo].[ClinDataPoint]
  ADD CONSTRAINT [FK_ClinDataPoint_EventId] FOREIGN KEY ([EventId]) REFERENCES [dbo].[ClinEvent] ([EventId])
GO

ALTER TABLE [dbo].[ClinDataPoint]
  ADD CONSTRAINT [FK_ClinDataPoint_ItemId] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[MetaItem] ([ItemId])
GO

ALTER TABLE [dbo].[ClinDataPoint]
  ADD CONSTRAINT [FK_ClinDataPoint_LockedBy] FOREIGN KEY ([LockedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinDataPoint]
  ADD CONSTRAINT [FK_ClinDataPoint_TouchId] FOREIGN KEY ([TouchId]) REFERENCES [dbo].[ClinTouch] ([TouchId])
GO