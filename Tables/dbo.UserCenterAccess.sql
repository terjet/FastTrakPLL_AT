CREATE TABLE [dbo].[UserCenterAccess] (
  [CenterAccessId] [int] IDENTITY,
  [UserId] [int] NOT NULL,
  [CenterId] [int] NOT NULL,
  [StartAt] [datetime] NOT NULL,
  [StopAt] [datetime] NOT NULL,
  [GrantedBy] [int] NOT NULL CONSTRAINT [DF_UserCenterAccess_GrantedBy] DEFAULT (user_id()),
  [GrantedAt] [datetime] NOT NULL CONSTRAINT [DF_UserCenterAccess_GrantedAt] DEFAULT (getdate()),
  [RevokedBy] [int] NULL,
  [RevokedAt] [datetime] NULL,
  [Comment] [varchar](max) NULL,
  CONSTRAINT [PK_UserCenterAccess] PRIMARY KEY CLUSTERED ([CenterAccessId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_UserCenterAccess_UserId_CenterId_StartAt]
  ON [dbo].[UserCenterAccess] ([UserId], [CenterId], [StartAt])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserCenterAccess]
  ADD CONSTRAINT [FK_UserCenterAccess_GrantedBy] FOREIGN KEY ([GrantedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[UserCenterAccess]
  ADD CONSTRAINT [FK_UserCenterAccess_RevokedBy] FOREIGN KEY ([RevokedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[UserCenterAccess]
  ADD CONSTRAINT [FK_UserCenterAccess_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[UserList] ([UserId])
GO