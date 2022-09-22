CREATE TABLE [dbo].[RoleMember] (
  [RowId] [int] IDENTITY,
  [guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_RoleMember_guid] DEFAULT (newid()),
  [RoleName] [nvarchar](128) NOT NULL,
  [RoleId] [int] NOT NULL,
  [MemberName] [nvarchar](128) NOT NULL,
  [MemberId] [int] NOT NULL,
  [RevokedBy] [int] NULL,
  [RevokedAt] [datetime] NULL,
  [GrantedBy] [int] NOT NULL CONSTRAINT [DF_RoleMember_GrantedBy] DEFAULT (database_principal_id()),
  [GrantedAt] [datetime] NOT NULL CONSTRAINT [DF_RoleMember_GrantedAt] DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([guid])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[RoleMember]
  ADD CONSTRAINT [FK_RoleMember_GrantedBy] FOREIGN KEY ([GrantedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[RoleMember]
  ADD CONSTRAINT [FK_RoleMember_MemberId] FOREIGN KEY ([MemberId]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[RoleMember]
  ADD CONSTRAINT [FK_RoleMember_RevokedBy] FOREIGN KEY ([RevokedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO