CREATE TABLE [dbo].[UserLog] (
  [SessId] [int] IDENTITY,
  [StudyId] [int] NOT NULL,
  [CompUser] [varchar](50) NOT NULL,
  [CompName] [nvarchar](128) NULL,
  [CompTime] [datetime] NOT NULL,
  [ServTime] [datetime] NOT NULL CONSTRAINT [DF_UserLog_ServTime] DEFAULT (getdate()),
  [AppVer] [varchar](64) NULL,
  [ClosedAt] [datetime] NULL,
  [Updates] [int] NULL,
  [Inserts] [int] NULL,
  [UserId] [int] NOT NULL CONSTRAINT [DF_UserLog_UserId] DEFAULT (user_id()),
  [ClosedBy] [int] NULL,
  [UserName] [nvarchar](128) NULL CONSTRAINT [DF_UserLog_UserName] DEFAULT (user_name()),
  [DbUser] AS ([UserName]),
  [ServYear] AS (datepart(year,[ServTime])),
  [ServMonth] AS (datepart(month,[ServTime])),
  [ServWeek] AS (datepart(week,[ServTime])),
  [DirtyClose] [bit] NULL,
  [guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_UserLog_guid] DEFAULT (newid()) ROWGUIDCOL,
  [ProfId] [int] NULL,
  [LastPingTime] [datetime] NULL,
  CONSTRAINT [PK_UserLog] PRIMARY KEY CLUSTERED ([SessId])
)
ON [PRIMARY]
GO

CREATE INDEX [I_UserLog_UserId_ClosedAt]
  ON [dbo].[UserLog] ([UserId], [ClosedAt])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserLog]
  ADD CONSTRAINT [FK_UserLog_ClosedBy] FOREIGN KEY ([ClosedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[UserLog]
  ADD CONSTRAINT [FK_UserLog_ProfId] FOREIGN KEY ([ProfId]) REFERENCES [dbo].[MetaProfession] ([ProfId])
GO

ALTER TABLE [dbo].[UserLog]
  ADD CONSTRAINT [FK_UserLog_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId])
GO

ALTER TABLE [dbo].[UserLog] WITH NOCHECK
  ADD CONSTRAINT [FK_UserLog_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[UserList] ([UserId])
GO