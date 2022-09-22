CREATE TABLE [dbo].[PersonLog] (
  [LogId] [int] IDENTITY,
  [PersonId] [int] NOT NULL,
  [DOB] [datetime] NOT NULL,
  [FstName] [varchar](30) NOT NULL,
  [LstName] [varchar](30) NOT NULL,
  [GenderId] [tinyint] NOT NULL,
  [NationalId] [varchar](16) NULL,
  [ChangedAt] [datetime] NOT NULL CONSTRAINT [DF_PersonLog_ChangedAt] DEFAULT (getdate()),
  [ChangedBy] [int] NOT NULL CONSTRAINT [DF_PersonLog_ChangedBy] DEFAULT (user_id()),
  [guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_PersonLog_guid] DEFAULT (newid()),
  [TestCase] [bit] NULL,
  [MidName] [varchar](30) NULL,
  [DeceasedDate] [datetime] NULL,
  [DeceasedInd] [bit] NULL,
  CONSTRAINT [PK_PersonLog] PRIMARY KEY CLUSTERED ([LogId])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[PersonLog] TO [Administrator]
GO

ALTER TABLE [dbo].[PersonLog]
  ADD CONSTRAINT [FK_PersonLog_ChangedBy] FOREIGN KEY ([ChangedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[PersonLog]
  ADD CONSTRAINT [FK_PersonLog_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO