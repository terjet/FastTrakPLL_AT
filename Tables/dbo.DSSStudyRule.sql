CREATE TABLE [dbo].[DSSStudyRule] (
  [StudyRuleId] [int] NOT NULL,
  [StudyName] [varchar](40) NULL,
  [RuleActive] [int] NULL,
  [RuleId] [int] NULL,
  [LastUpdate] [datetime] NULL,
  [ChkSum] [int] NOT NULL CONSTRAINT [DF_DSSStudyRule_ChkSum] DEFAULT (0),
  CONSTRAINT [PK_DSSStudyRule] PRIMARY KEY CLUSTERED ([StudyRuleId])
)
ON [PRIMARY]
GO