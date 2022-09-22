CREATE TABLE [dbo].[DbUpgradeLog] (
  [DbVer] [int] NOT NULL,
  [DbUpgradeStart] [datetime] NOT NULL,
  [DbUpgradeEnd] [datetime] NULL,
  [UpgradedBy] [int] NOT NULL CONSTRAINT [DF_DbUpgradeLog_UpgradedBy] DEFAULT (user_id()),
  CONSTRAINT [PK_DbUpgradeLog] PRIMARY KEY CLUSTERED ([DbVer])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[DbUpgradeLog]
  ADD CONSTRAINT [FK_DbUpgradeLog_UpgradedBy] FOREIGN KEY ([UpgradedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO