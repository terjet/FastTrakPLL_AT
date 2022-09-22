CREATE TABLE [dbo].[ClinDataPointLog] (
  [LogId] [int] IDENTITY,
  [RowId] [int] NOT NULL,
  [TouchId] [int] NOT NULL,
  [ObsDate] [datetime] NOT NULL,
  [Quantity] [decimal](18, 4) NULL,
  [DTVal] [datetime] NULL,
  [EnumVal] [int] NULL,
  [TextVal] [varchar](max) NULL,
  [ChangedAt] [datetime] NOT NULL CONSTRAINT [DF_ClinDataPointLog_ChangedAt] DEFAULT (getdate()),
  [ChangedBy] [int] NOT NULL CONSTRAINT [DF_ClinDataPointLog_ChangedBy] DEFAULT (user_id()),
  CONSTRAINT [PK_ClinLog] PRIMARY KEY CLUSTERED ([LogId]),
  CONSTRAINT [C_ClinLog_Timing] CHECK ([ChangedAt]>=[ObsDate])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ClinDataPointLog]
  ADD CONSTRAINT [FK_ClinDataPointLog_ChangedBy] FOREIGN KEY ([ChangedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinDataPointLog]
  ADD CONSTRAINT [FK_ClinDataPointLog_RowId] FOREIGN KEY ([RowId]) REFERENCES [dbo].[ClinDataPoint] ([RowId]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ClinDataPointLog]
  ADD CONSTRAINT [FK_ClinDataPointLog_TouchId] FOREIGN KEY ([TouchId]) REFERENCES [dbo].[ClinTouch] ([TouchId])
GO