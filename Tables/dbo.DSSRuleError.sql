CREATE TABLE [dbo].[DSSRuleError] (
  [RowId] [int] IDENTITY,
  [StudyId] [int] NULL,
  [PersonId] [int] NULL,
  [RuleProc] [nvarchar](128) NULL,
  [ErrorNumber] [int] NULL,
  [ErrorSeverity] [int] NULL,
  [ErrorLine] [int] NULL,
  [ErrorMessage] [ntext] NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_DSSRuleError_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_DSSRuleError_CreatedBy] DEFAULT (user_id()),
  PRIMARY KEY CLUSTERED ([RowId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[DSSRuleError] TO [FastTrak]
GO

ALTER TABLE [dbo].[DSSRuleError]
  ADD CONSTRAINT [FK_DSSRuleError_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DSSRuleError]
  ADD CONSTRAINT [FK_DSSRuleError_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [dbo].[DSSRuleError]
  ADD CONSTRAINT [FK_DSSRuleError_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId])
GO