CREATE TABLE [dbo].[UserList] (
  [UserId] [int] NOT NULL,
  [PersonId] [int] NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_UserList_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_UserList_CreatedBy] DEFAULT (user_id()),
  [CenterId] [int] NULL,
  [ProfId] [int] NULL,
  [UserName] [sysname] NULL,
  [IsActive] [tinyint] NULL,
  [OldUserId] [int] NULL,
  [ProbListId] [int] NULL CONSTRAINT [DF_UserList_ProbListId] DEFAULT (4),
  [guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_UserList_guid] DEFAULT (newid()),
  [BaseProfId] [int] NULL,
  [FMUserName] [varchar](50) NULL,
  [FMPassword] [varchar](50) MASKED WITH (FUNCTION = 'default()') NULL,
  CONSTRAINT [PK_UserList] PRIMARY KEY CLUSTERED ([UserId]),
  CONSTRAINT [C_UserList_Zero] CHECK ([UserId]<>(0))
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_UserList_FMUserName]
  ON [dbo].[UserList] ([FMUserName])
  WHERE ([FMUserName] IS NOT NULL)
  ON [PRIMARY]
GO

CREATE INDEX [I_UserList_PersonId]
  ON [dbo].[UserList] ([PersonId])
  ON [PRIMARY]
GO

CREATE INDEX [I_UserList_ProfId]
  ON [dbo].[UserList] ([ProfId])
  ON [PRIMARY]
GO

GRANT UPDATE ON [dbo].[UserList] TO [DashboardAgent]
GO

GRANT SELECT ON [dbo].[UserList] TO [FastTrak]
GO

GRANT INSERT ON [dbo].[UserList] TO [superuser]
GO

ALTER TABLE [dbo].[UserList]
  ADD CONSTRAINT [FK_UserList_BaseProfId] FOREIGN KEY ([BaseProfId]) REFERENCES [dbo].[MetaProfession] ([ProfId])
GO

ALTER TABLE [dbo].[UserList]
  ADD CONSTRAINT [FK_UserList_CenterId] FOREIGN KEY ([CenterId]) REFERENCES [dbo].[StudyCenter] ([CenterId])
GO

ALTER TABLE [dbo].[UserList] WITH NOCHECK
  ADD CONSTRAINT [FK_UserList_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [dbo].[UserList]
  ADD CONSTRAINT [FK_UserList_ProfId] FOREIGN KEY ([ProfId]) REFERENCES [dbo].[MetaProfession] ([ProfId])
GO