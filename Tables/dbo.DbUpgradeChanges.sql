CREATE TABLE [dbo].[DbUpgradeChanges] (
  [DbVer] [int] NOT NULL,
  [OrderNumber] [int] NOT NULL,
  [ChangeType] [varchar](12) NOT NULL,
  [Details] [varchar](max) NOT NULL,
  CONSTRAINT [PK_DbUpgradeChanges] PRIMARY KEY CLUSTERED ([DbVer], [OrderNumber])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[DbUpgradeChanges]
  ADD CONSTRAINT [FK_DbUpgradeChanges_DbVer] FOREIGN KEY ([DbVer]) REFERENCES [dbo].[DbUpgradeLog] ([DbVer]) ON DELETE CASCADE
GO