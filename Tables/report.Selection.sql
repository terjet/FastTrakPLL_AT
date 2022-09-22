CREATE TABLE [report].[Selection] (
  [SelId] [int] IDENTITY,
  [StudyId] [int] NOT NULL,
  [SelTitle] [varchar](80) NOT NULL,
  [SelDescription] [varchar](max) NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_Selection_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_Selection_CreatedBy] DEFAULT (user_id()),
  CONSTRAINT [PK_ReportSelection] PRIMARY KEY CLUSTERED ([SelId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_ReportSelection_StudyTitle]
  ON [report].[Selection] ([StudyId], [CreatedBy], [SelTitle])
  ON [PRIMARY]
GO

ALTER TABLE [report].[Selection]
  ADD CONSTRAINT [FK_report_Selection_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [report].[Selection]
  ADD CONSTRAINT [FK_report_Selection_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId])
GO