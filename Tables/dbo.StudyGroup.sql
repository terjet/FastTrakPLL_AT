CREATE TABLE [dbo].[StudyGroup] (
  [StudyId] [int] NOT NULL,
  [GroupId] [int] NOT NULL,
  [GroupName] [varchar](24) NOT NULL,
  [CenterId] [int] NOT NULL,
  [StudyGroupId] [int] IDENTITY,
  [GroupActive] [int] NULL CONSTRAINT [DF_StudyGroup_GroupActive] DEFAULT (1),
  [BedCount] [int] NULL,
  [DisabledAt] [datetime] NULL,
  [DisabledBy] [int] NULL,
  [guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_StudyGroup_guid] DEFAULT (newid()) ROWGUIDCOL,
  [OrgId] [int] NULL,
  CONSTRAINT [PK_StudyGroup] PRIMARY KEY CLUSTERED ([StudyId], [GroupId])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_StudyGroup]
  ON [dbo].[StudyGroup] ([StudyId], [GroupName], [CenterId])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[StudyGroup] TO [FastTrak]
GO

GRANT INSERT ON [dbo].[StudyGroup] TO [superuser]
GO

ALTER TABLE [dbo].[StudyGroup]
  ADD CONSTRAINT [FK_StudyGroup_CenterId] FOREIGN KEY ([CenterId]) REFERENCES [dbo].[StudyCenter] ([CenterId])
GO

ALTER TABLE [dbo].[StudyGroup]
  ADD CONSTRAINT [FK_StudyGroup_DisabledBy] FOREIGN KEY ([DisabledBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[StudyGroup]
  ADD CONSTRAINT [FK_StudyGroup_OrgId] FOREIGN KEY ([OrgId]) REFERENCES [Comm].[Organization] ([OrgId])
GO

ALTER TABLE [dbo].[StudyGroup] WITH NOCHECK
  ADD CONSTRAINT [FK_StudyGroup_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId]) ON DELETE CASCADE
GO