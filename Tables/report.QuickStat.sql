CREATE TABLE [report].[QuickStat] (
  [RowId] [int] IDENTITY,
  [StudyId] [int] NULL,
  [ProcId] [int] NULL,
  [Title] [varchar](80) NULL,
  [DataElements] [varchar](max) NULL,
  [Comment] [varchar](max) NULL,
  CONSTRAINT [PK_ReportQuickStat] PRIMARY KEY CLUSTERED ([RowId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_Report_StudyTitle]
  ON [report].[QuickStat] ([StudyId], [Title])
  ON [PRIMARY]
GO

ALTER TABLE [report].[QuickStat]
  ADD CONSTRAINT [FK_report_QuickStat_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId])
GO