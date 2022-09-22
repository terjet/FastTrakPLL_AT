CREATE TABLE [dbo].[StudyUser] (
  [StudyId] [int] NOT NULL,
  [UserId] [int] NOT NULL,
  [GroupId] [int] NULL,
  [ShowMyGroup] [bit] NULL,
  [CaseList] [int] NULL,
  CONSTRAINT [PK_StudyUser] PRIMARY KEY CLUSTERED ([StudyId], [UserId])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[StudyUser]
  ADD CONSTRAINT [FK_StudyUser_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId])
GO

ALTER TABLE [dbo].[StudyUser]
  ADD CONSTRAINT [FK_StudyUser_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[UserList] ([UserId])
GO