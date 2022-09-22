CREATE TABLE [AccessCtrl].[UserCaseBlock] (
  [UserCaseBlockId] [int] IDENTITY,
  [PersonId] [int] NOT NULL,
  [UserId] [int] NOT NULL,
  [BlockedAt] [datetime] NOT NULL CONSTRAINT [DF_UserCaseBlock_BlockedAt] DEFAULT (getdate()),
  [BlockedBy] [int] NOT NULL CONSTRAINT [DF_UserCaseBlock_BlockedBy] DEFAULT (user_id()),
  [BlockReason] [varchar](max) NOT NULL,
  [AllowedAt] [datetime] NULL,
  [AllowedBy] [int] NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_UserCaseBlock_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_UserCaseBlock_CreatedBy] DEFAULT (user_id()),
  CONSTRAINT [PK_UserCaseAccessId] PRIMARY KEY CLUSTERED ([UserCaseBlockId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [AccessCtrl].[UserCaseBlock]
  ADD CONSTRAINT [FK_AccessCtrl_UserCaseBlock_AllowedBy] FOREIGN KEY ([AllowedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [AccessCtrl].[UserCaseBlock]
  ADD CONSTRAINT [FK_AccessCtrl_UserCaseBlock_BlockedBy] FOREIGN KEY ([BlockedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [AccessCtrl].[UserCaseBlock]
  ADD CONSTRAINT [FK_AccessCtrl_UserCaseBlock_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [AccessCtrl].[UserCaseBlock]
  ADD CONSTRAINT [FK_AccessCtrl_UserCaseBlock_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [AccessCtrl].[UserCaseBlock]
  ADD CONSTRAINT [FK_AccessCtrl_UserCaseBlock_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[UserList] ([UserId])
GO