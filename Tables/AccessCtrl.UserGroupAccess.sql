CREATE TABLE [AccessCtrl].[UserGroupAccess] (
  [UserGroupAccessId] [int] IDENTITY,
  [UserId] [int] NOT NULL,
  [GroupId] [int] NOT NULL,
  [StartAt] [datetime] NOT NULL,
  [StopAt] [datetime] NULL,
  [GrantedBy] [int] NOT NULL CONSTRAINT [DF_UserGroupAccess_GrantedBy] DEFAULT (user_id()),
  [GrantedAt] [datetime] NOT NULL CONSTRAINT [DF_UserGroupAccess_GrantedAt] DEFAULT (getdate()),
  [RevokedBy] [int] NULL,
  [RevokedAt] [datetime] NULL,
  [Comment] [varchar](max) NULL,
  CONSTRAINT [PK_UserGroupAccessId] PRIMARY KEY CLUSTERED ([UserGroupAccessId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [AccessCtrl].[UserGroupAccess]
  ADD CONSTRAINT [FK_AccessCtrl_UserGroupAccess_GrantedBy] FOREIGN KEY ([GrantedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [AccessCtrl].[UserGroupAccess]
  ADD CONSTRAINT [FK_AccessCtrl_UserGroupAccess_RevokedBy] FOREIGN KEY ([RevokedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [AccessCtrl].[UserGroupAccess]
  ADD CONSTRAINT [FK_AccessCtrl_UserGroupAccess_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[UserList] ([UserId])
GO