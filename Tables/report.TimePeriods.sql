CREATE TABLE [report].[TimePeriods] (
  [RowId] [int] IDENTITY,
  [StartTime] [datetime] NOT NULL,
  [EndTime] [datetime] NOT NULL,
  [PeriodType] [char](8) NOT NULL,
  [StartYear] AS (datepart(year,[StartTime])),
  CONSTRAINT [PK_Report_TimePeriods] PRIMARY KEY CLUSTERED ([RowId])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_Report_TimePeriods_StartTime_EndTime]
  ON [report].[TimePeriods] ([StartTime], [EndTime])
  ON [PRIMARY]
GO