CREATE TABLE [dbo].[StudyStatus] (
  [StudyId] [int] NOT NULL,
  [StatusId] [int] NOT NULL,
  [StatusText] [varchar](64) NOT NULL,
  [StatusActive] [int] NOT NULL,
  [DisabledAt] [datetime] NULL,
  [DisabledBy] [int] NULL,
  [LongTerm] [bit] NULL,
  CONSTRAINT [PK_StudyStatus] PRIMARY KEY CLUSTERED ([StudyId], [StatusId])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[StudyStatus] TO [FastTrak]
GO

ALTER TABLE [dbo].[StudyStatus]
  ADD CONSTRAINT [FK_StudyStatus_DisabledBy] FOREIGN KEY ([DisabledBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[StudyStatus]
  ADD CONSTRAINT [FK_StudyStatus_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId])
GO