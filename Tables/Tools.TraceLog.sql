CREATE TABLE [Tools].[TraceLog] (
  [TrcId] [int] IDENTITY,
  [TrcLevel] [tinyint] NOT NULL,
  [Sender] [varchar](64) NOT NULL,
  [Content] [varchar](max) NOT NULL,
  [UserName] [sysname] NOT NULL CONSTRAINT [DF_TraceLog_UserName] DEFAULT (user_name()),
  [HostName] [sysname] NOT NULL CONSTRAINT [DF_TraceLog_HostName] DEFAULT (host_name()),
  [CreatedAt] [datetime2] NOT NULL CONSTRAINT [DF_TraceLog_CreatedAt] DEFAULT (sysdatetime()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_TraceLog_CreatedBy] DEFAULT (user_id()),
  PRIMARY KEY CLUSTERED ([TrcId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Tools].[TraceLog]
  ADD CONSTRAINT [FK_Tools_TraceLog_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO